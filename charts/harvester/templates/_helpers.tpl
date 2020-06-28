{{/* Returns environment variables common to all harvester containers */}}
{{- define "harvester.base-env" -}}
- name: CELERY_BROKER
  value: {{ .Values.celery.broker | quote }}
- name: CELERY_BACKEND
  value: {{ .Values.celery.backend | quote }}
- name: SUBSTRATE_RPC_URL
  value: {{ .Values.polkadotRPC | quote }}
- name: SUBSTRATE_ADDRESS_TYPE
  value: {{ .Values.substrate.addressType | quote }}
- name: SUBSTRATE_METADATA_VERSION
  value: {{ .Values.substrate.metadataVersion | quote }}
- name: TYPE_REGISTRY
  value: {{ .Values.typeRegistry | quote }}
- name: NEW_SESSION_EVENT_HANDLER
  value: "True"
- name: FINALIZATION_ONLY
  value: "1"
{{- end -}}

{{/* Returns environment variables for api and worker containers */}}
{{- define "harvester.api-worker-env" -}}
- name: DB_HOST
  value: {{ .Values.db.host | quote }}
- name: DB_PORT
  value: {{ .Values.db.port | quote }}
- name: DB_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}
      key: db-user
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}
      key: db-password
- name: DB_NAME
  value: {{ .Values.db.name | quote }}
{{- if eq .Values.typeRegistry "kusama" }}
- name: BALANCE_SYSTEM_ACCOUNT_MIN_BLOCK
  value: "1375086"
{{- else }}
- name: SUBSTRATE_STORAGE_BALANCE
  value: Account
- name: SUBSTRATE_STORAGE_INDICES
  value: Accounts
{{- end }}
{{ include "harvester.base-env" . }}
{{- end -}}

{{- define "harvester.api-name" -}}
{{ .Release.Name }}-api
{{- end -}}

{{- define "harvester.worker-name" -}}
{{ .Release.Name }}-worker
{{- end -}}

{{- define "harvester.beat-name" -}}
{{ .Release.Name }}-beat
{{- end -}}

{{- define "harvester.worker-cronjob-name" -}}
{{ .Release.Name }}-worker-start
{{- end -}}
