{{- define "InstanceGenerator.Generator" -}}
{{ $defaultValues := omit .Values .Values.InstanceGenerator.key }}
{{ range $instanceName, $instanceValues := get .Values .Values.InstanceGenerator.key }}
{{ $Values := mergeOverwrite (deepCopy $defaultValues) $instanceValues }}
{{ $instanceName }}:
  Values: {{ $Values | toYaml | nindent 4 }}
{{ end }}
{{- end }}
