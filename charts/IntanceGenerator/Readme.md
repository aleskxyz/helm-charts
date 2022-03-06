# Instance Generator for helm objects
With help of this helm chart you can generate different instances of same object in your helm chart with the specified attributes.
## User Guide
Install the chart as a subchart of your existing chart:
```bash
cd charts
git clone https://github.com/aleskxyz/InstanceGenerator.git
```
Define the instances in the parent values.yaml file:
```yaml
favorite:
  drink: coffee
  food: pizza

instances:
  alis:
    favorite:
      drink: tea
      desert: icecream
  bob:
    favorite:
      drink: wine

# You can change the default keyword "instances" by setting this variable:
#InstanceGenerator:
#  key: instances
```
Wrap the traget template files content with these lines:
```yaml
{{- range $instanceName, $instanceValues := include "InstanceGenerator.Generator" $ | fromYaml -}}
{{- $_ := merge $instanceValues (omit $ "Values") -}}

# Target tempalte files content

{{- end -}}
```
For example:
```yaml
{{- range $instanceName, $instanceValues := include "InstanceGenerator.Generator" $ | fromYaml -}}
{{- $_ := merge $instanceValues (omit $ "Values") -}}

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $instanceName }}-favorite
data:
  {{- range $key, $val := .Values.favorite }}
  {{ $key }}: {{ $val }}
  {{- end }}
---

{{- end -}}
```
Result:
```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: alis-favorite
data:
  desert: icecream
  drink: tea
  food: pizza
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: bob-favorite
data:
  drink: wine
  food: pizza
  ```
## Note
As you can see above, you don't need to modify variables for the existing template files.
You should pass `.` instead of `$` to named templates if you want to have uniq result for each of the instances.
 
