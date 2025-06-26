docker storage

to create the volume  - which managed by DockerD

```docker volume create datastorage```
```docker run -d -v datastorage:/app/data alpine sleep 3600```


to  using bind mount ( data from current host storage)

`docker run -d -v $(pwd)\docker-storages:/appdata alpine 3600`


to using tmpfs please run

`docker run -d --tmpfs /cache:rw,size=64m alpine sleep 3000 `

    
please access to the docker to see what the happend.