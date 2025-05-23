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