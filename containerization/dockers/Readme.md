###basic architecture of docker enginee

3 layers

Low layer:
**RUNTIME** 
-> Containerd
    high-level runtime, relationship 1 - n with runc(s)
    it will work with container via runc
    Docker Enginee use containerd to abstract actions with container
-> RunC: 
    low-level runtime, relationship 1 - 1 with each of container
    execution container, follow OCI standard - Open Container Initiative

Midle Layer
**Engine/Daemon**
-> **Remote API**: allow interactive Docker from remote host like CLI or RestfulAPI.
-> **Networking**: allow process the network between containers or container with external environment....
-> **Volumes(Storage)**: manage about storage(bind, mount volumn, share data between containers or host)
-> **Image management**: manage the image(pull, push from locall or remote registry container image like dockerhub, jfog, nexus)


###DOCKERFILE NOTE

use case for entrypoint and cmd 

CMD when you want overwrite
ENTRYPOINT when you specified an application like python/java...
CMD + ENTRYPOINT when you want setup default application with path and allow more args