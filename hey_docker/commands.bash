kubectl get pods -o go-template='{{range .items}}{{.metadata.name}}{{end}}'

kubectl get services/meu-primeiro-deployment -o go-template='{{(index .spec.ports 0).nodePort}}'

#fazer um novo deployment e um novo serviço

kubectl create deployment meu-primeiro-deployment --image=gcr.io/google-samples/kubernetes-bootcamp:v1

kubectl get deployments

kubectl expose deployment/meu-primeiro-deployment --type="NodePort" --port 8080

kubectl get services

kubectl get pods -l app=meu-primeiro-deployment

kubectl get services -l app=meu-primeiro-deployment

kubectl get pods -o go-template --template "{{range .items}}{{.metadata.name}}{{end}}"

kubectl label pod $POD_NAME versao=v1

kubectl delete service -l app=meu-primeiro-deployment

kubectl get service meu-primeiro-deployment -o go-template --template "{{(index .spec.ports 0)}}"

kubectl set image deployments/meu-primeiro-deployment kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2

kubectl set image deployments/meu-primeiro-deployment kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v10