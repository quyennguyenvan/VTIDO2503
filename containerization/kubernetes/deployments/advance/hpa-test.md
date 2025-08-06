kubectl run -it --rm load-generator --image=busybox -- /bin/sh

Inside the pod
while true; do wget -q -O- http://nginx-service; done