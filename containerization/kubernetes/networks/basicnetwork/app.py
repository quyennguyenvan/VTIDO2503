
from flask import Flask, jsonify
import socket
 
import os 
app = Flask(__name__)


@app.route('/health', methods=['GET'])
def health_check():
    hostname=socket.gethostname()
    return jsonify(
        status="Healthy",
        hostname=hostname   
    ), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
