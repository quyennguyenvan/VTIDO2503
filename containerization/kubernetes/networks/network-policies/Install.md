install 
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico-typha.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico-policy-only.yaml

-> only network policy no require for eBPF or BPFFS -> approach for docker-desktop only 

k8s if support eBPF or BPFFS then install this one
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml
