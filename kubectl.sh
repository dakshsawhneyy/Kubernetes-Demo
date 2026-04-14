🔹 1. Cluster Basics
kubectl version --client
kubectl cluster-info
kubectl get nodes

🔹 2. Pods
kubectl run nginx --image=nginx
kubectl get pods
kubectl describe pod nginx
kubectl delete pod nginx

🔹 3. Deployments
kubectl create deployment myapp --image=nginx
kubectl get deployments
kubectl describe deployment myapp

🔹 4. Scaling
kubectl scale deployment myapp --replicas=3
kubectl get pods
kubectl get deployment myapp

--- Reduce:
kubectl scale deployment myapp --replicas=1

🔹 5. Logs & Debugging
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- /bin/sh

--- Example: kubectl logs nginx
kubectl exec -it nginx -- /bin/sh

🔹 6. Rolling Updates
kubectl set image deployment/myapp nginx=nginx:latest
kubectl rollout status deployment/myapp
kubectl get pods

🔹 7. Rollback
kubectl rollout undo deployment/myapp
kubectl rollout history deployment/myapp
kubectl rollout history deployment/myapp --revision=1

🔹 8. Services
kubectl expose deployment myapp --type=NodePort --port=80
kubectl get svc

🔹 9. YAML Apply
kubectl apply -f deployment.yaml
kubectl get deployments

🔹 10. Autoscaling (Concept)
kubectl autoscale deployment myapp --cpu-percent=50 --min=1 --max=5
