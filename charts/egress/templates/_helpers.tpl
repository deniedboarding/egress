{{- define "name" -}}
{{- .Release.Name -}}
{{- end }}

{{/*
Labels that should be applied to ALL resources.
*/}}
{{- define "egress.labels" -}}
{{- if .Release.Service -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}
{{- if .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ .Chart.Name | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- if and .Chart.Name .Chart.Version }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end -}}

{{- define "egress.service-entry" }}
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata:
  name: {{ .name }}
  labels:
{{ if .Values.ambient }}
    istio.io/use-waypoint: {{ .Values.gateway.name }}
{{ end }}
    {{- include "egress.labels" . | nindent 4}}
spec:
{{ with .hosts }}
  hosts: {{ toYaml . | nindent 2 }}
{{ end }}
  ports:
  - number: {{ .Values.port }}
    name: {{ .Values.protocol }}
    protocol: {{ .Values.protocol | upper }}
{{ if and .Values.tlsOrigination (eq .Values.protocol "tls") }}
  - name: http-port-for-tls-origination
    number: 80
    protocol: HTTP
{{ end }}
  resolution: {{ .Values.resolution }}
  location: MESH_EXTERNAL
{{- end -}}

{{- define "egress.string-match" }}
{{ if hasPrefix "*" . }}
regex: {{ . | replace "." "\\." | replace "*" ".*" | quote }}
{{- else -}}
exact: {{ . | quote }}
{{- end -}}
{{- end -}}