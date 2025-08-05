**Setup Calico**
1. kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/calico.yaml
2. kubectl get pods -n kube-system | grep calico
3. kubectl apply -f  https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/calico-policy-only.yaml