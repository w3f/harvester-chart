{{/* Returns environment variables common to all containers */}}
{{- define "common.env" -}}
- name: SUBSTRATE_RPC_URL
  value: {{ .Values.polkadotRPC | quote }}
- name: SUBSTRATE_ADDRESS_TYPE
  value: {{ .Values.substrate.addressType | quote }}
- name: SUBSTRATE_METADATA_VERSION
  value: {{ .Values.substrate.metadataVersion | quote }}
- name: TYPE_REGISTRY
  value: {{ .Values.typeRegistry | quote }}
{{- end -}}

{{/* Returns environment variables for containers with db access */}}
{{- define "db.env" -}}
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
{{- end -}}

{{/* Returns environment variables common to all harvester containers */}}
{{- define "harvester.base-env" -}}
- name: CELERY_BROKER
  value: {{ .Values.celery.broker | quote }}
- name: CELERY_BACKEND
  value: {{ .Values.celery.backend | quote }}
- name: NEW_SESSION_EVENT_HANDLER
  value: "True"
- name: FINALIZATION_ONLY
  value: "1"
{{ include "common.env" . }}
{{- end -}}

{{/* Returns environment variables for api and worker containers */}}
{{- define "harvester.api-worker-env" -}}
{{- if eq .Values.typeRegistry "kusama" }}
- name: BALANCE_SYSTEM_ACCOUNT_MIN_BLOCK
  value: "1375086"
{{- else }}
- name: SUBSTRATE_STORAGE_BALANCE
  value: Account
- name: SUBSTRATE_STORAGE_INDICES
  value: Accounts
{{- end }}
{{ include "db.env" . }}
{{ include "harvester.base-env" . }}
{{- end -}}

{{/* Returns explorer-api environment variables */}}
{{- define "explorer.api-env" -}}
{{ include "db.env" . }}
{{ include "common.env" . }}
{{- end -}}

{{/* Returns explorer-gui environment variables */}}
{{- define "explorer.gui-env" -}}
- name: NETWORK_NAME
  value: {{ .Values.typeRegistry | title }}
- name: NETWORK_ID
  value: {{ .Values.typeRegistry }}
- name: NETWORK_TYPE
  value: pre
- name: CHAIN_TYPE
  value: relay
- name: NETWORK_TOKEN_SYMBOL
  value: {{ .Values.networkToken.symbol }}
- name: NETWORK_TOKEN_DECIMALS
  value: {{ .Values.networkToken.decimals }}
- name: NETWORK_COLOR_CODE
  value: 000000
- name: API_URL
  value: "http://{{ include "explorer.api-name" . }}:{{ .Values.explorerApi.port }}/api/v1"
{{- end -}}

{{- define "explorer.api-name" -}}
{{ .Release.Name }}-explorer-api
{{- end -}}

{{- define "explorer.gui-name" -}}
{{ .Release.Name }}-explorer-gui
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
