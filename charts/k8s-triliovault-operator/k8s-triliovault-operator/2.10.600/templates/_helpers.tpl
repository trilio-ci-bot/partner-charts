{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-triliovault-operator.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "k8s-triliovault-operator.appName" -}}
{{- printf "%s" .Chart.Name -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "k8s-triliovault-operator.fullname" -}}
{{- printf "%s" .Chart.Name -}}
{{- end -}}

{{/*
Return the proper TrilioVault Operator image name
*/}}
{{- define "k8s-triliovault-operator.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Validation of the secret of CA bundle if provided
*/}}
{{- define "k8s-triliovault-operator.caBundleValidation" -}}
{{- if .Values.proxySettings.CA_BUNDLE_CONFIGMAP }}
{{- if not (lookup "v1" "ConfigMap" .Release.Namespace .Values.proxySettings.CA_BUNDLE_CONFIGMAP) }}
   {{ fail "Proxy CA bundle proxy is not present in the release namespace" }}
{{- else }}
    {{- $caMap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.proxySettings.CA_BUNDLE_CONFIGMAP).data }}
        {{- if not (get $caMap "ca-bundle.crt") }}
            {{ fail "Proxy CA certificate file key should be ca-bundle.crt" }}
        {{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Validation for the ingress tlsSecret, should exists if provided
*/}}

{{- define "k8s-triliovault-operator.tlsSecretValidation" }}
{{- if .Values.installTVK.ingressConfig.tlsSecretName -}}
{{- if not (lookup "v1" "Secret" .Release.Namespace .Values.installTVK.ingressConfig.tlsSecretName ) -}}
    {{ fail "Ingress tls secret is not present in the release namespace" }}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "k8s-triliovault-operator.preFlightValidation" }}
{{- if not .Values.preflight.storageClass }}
    {{ fail "Provide the name of storage class as you have enabled the preflight" }}
{{- else }}
    {{- if not (lookup "storage.k8s.io/v1" "StorageClass" "" .Values.preflight.storageClass) }}
        {{ fail "Storage class provided is not present in the cluster" }}
    {{- end }}
{{- end }}
{{- end }}

{{- define "k8s-triliovault-operator.priorityClassValidator" }}
{{- if .Values.priorityClassName -}}
{{- if not (lookup "scheduling.k8s.io/v1" "PriorityClass" "" .Values.priorityClassName) }}
     {{ fail "Priority class provided is not present in the cluster" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create unified labels for k8s-triliovault-operator components
*/}}
{{- define "k8s-triliovault-operator.labels" -}}
app.kubernetes.io/part-of: k8s-triliovault-operator
app.kubernetes.io/managed-by: k8s-triliovault-operator
app.kubernetes.io/name: k8s-triliovault-operator
{{- end -}}

{{/*
Return k8s-triliovault-operator repository name based on source
*/}}
{{- define "k8s-triliovault-operator.k8s-triliovault-operator.repository" -}}
    {{- if eq .Values.images "aws-marketplace-byol" -}}
        {{- printf "%s" "tvk-operator-byol" -}}
    {{- else -}}
        {{- printf "%s" "k8s-triliovault-operator" -}}
    {{- end -}}
{{- end -}}

{{/*
Return operator-webhook-init repository name based on source
*/}}
{{- define "k8s-triliovault-operator.operator-webhook-init.repository" -}}
    {{- if eq .Values.images "aws-marketplace-byol" -}}
        {{- printf "%s" "operator-webhook-init-byol" -}}
    {{- else -}}
        {{- printf "%s" "operator-webhook-init" -}}
    {{- end -}}
{{- end -}}

{{/*
Return preflight repository name based on source
*/}}
{{- define "k8s-triliovault-operator.preflight.repository" -}}
    {{- if eq .Values.images "aws-marketplace-byol" -}}
        {{- printf "%s" "preflight-byol" -}}
    {{- else -}}
        {{- printf "%s" "preflight" -}}
    {{- end -}}
{{- end -}}

{{- define "k8s-triliovault-operator.serviceAccountName" -}}
    {{- if eq .Values.svcAccountName "" -}}
        {{- printf "%s" "k8s-triliovault-operator-service-account" -}}
    {{- else -}}
        {{- printf "%s" .Values.svcAccountName -}}
    {{- end -}}
{{- end -}}

{{- define "k8s-triliovault-operator.preflightServiceAccountName" -}}
    {{- if eq .Values.svcAccountName "" -}}
        {{- printf "%s" "k8s-triliovault-operator-preflight-service-account" -}}
    {{- else -}}
        {{- printf "%s" .Values.svcAccountName -}}
    {{- end -}}
{{- end -}}