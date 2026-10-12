{{- define "site.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "site.selector" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{/* ConfigMap keys cannot contain "/": site/privacy/index.html → privacy__index.html */}}
{{- define "site.key" -}}
{{- trimPrefix "site/" . | replace "/" "__" -}}
{{- end -}}
