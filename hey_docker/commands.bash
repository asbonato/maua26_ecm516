kubectl get pods -o go-template='{{range .items}}{{.metadata.name}}{{end}}'

kubectl get services/meu-primeiro-deployment -o go-template='{{(index .spec.ports 0).nodePort}}'

#fazer um novo deployment e um novo serviço

kubectl create deployment meu-primeiro-deployment --image=gcr.io/google-samples/kubernetes-bootcamp:v1

kubectl get deployments

kubectl expose deployment/meu-primeiro-deployment --type="NodePort" --port 8080

kubectl get services