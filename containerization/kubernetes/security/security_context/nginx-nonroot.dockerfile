FROM nginx:stable 

RUN addgroup --system --gid 3000 nginxgroup 
RUN adduser --system --uid 1001 --gid 3000 nginxuser

RUN mkdir -p /var/cache/nginx/client_temp
RUN chown -R 1001:1001 /var/cache/nginx/ /var/run/ /var/log/nginx 

USER 1001

#run nginx 
CMD [ "nginx", "-g", "daemon off;" ]