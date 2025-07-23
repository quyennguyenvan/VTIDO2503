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


###NETWORK
| Criteria                                | `bridge`                                        | `host`                                   | `overlay`                               | `ipvlan`                                | `none`                            |
| --------------------------------------- | ----------------------------------------------- | ---------------------------------------- | --------------------------------------- | --------------------------------------- | --------------------------------- |
| **Description**                         | Internal network between containers on one host | Container shares network stack with host | Distributed network across Docker hosts | Container gets IP from physical network | No network assigned to container  |
| **Inter-host communication**            | ❌ No                                            | ❌ No                                     | ✅ Yes                                   | ✅ Yes (requires configuration)          | ❌ No                              |
| **Communication with host**             | ✅ NAT via `docker0`                             | ✅ Direct                                 | ✅ NAT or direct (configurable)          | ✅ Direct                                | ❌ No                              |
| **Communication with other containers** | ✅ Within the same bridge network                | ✅ (via host IP)                          | ✅ Within the same overlay network       | ✅ If same subnet + routing              | ❌ No                              |
| **Requires Docker Swarm**               | ❌ No                                            | ❌ No                                     | ✅ Yes                                   | ❌ No                                    | ❌ No                              |
| **Requires advanced network config**    | ❌ No                                            | ❌ No                                     | ✅ Yes (Swarm init)                      | ✅ Yes (subnet, gateway, interface)      | ❌ No                              |
| **Network performance**                 | Average (NAT)                                   | High (native)                            | Average (due to overlay + encryption)   | High (native, no NAT)                   | Not applicable                    |
| **Ease of use**                         | ✅ Easy                                          | ✅ Easy                                   | ⚠️ Moderate                              | ❌ Difficult                             | ✅ Easy                            |
| **Custom IP addressing**                | ✅ Possible                                      | ❌ Not supported                          | ✅ Possible                              | ✅ Strong (uses real IPs)                | ✅ (if custom configured)          |
| **Common use cases**                    | Local development, CI                           | High-performance, game servers           | Swarm, distributed microservices        | Enterprise LAN network management       | When a container needs no network |
