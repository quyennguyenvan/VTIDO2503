from flask import Flask, request
import os

app = Flask(__name__)

UPLOAD_FOLDER = "/uploads" 
os.makedirs(UPLOAD_FOLDER, exist_ok=True) 

app_configuration="/config/appconfig.json"

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return {"error": "No file part"}, 400 

    file = request.files['file']
    if file.filename == '':
        return {"error": "No selected file"}, 400 

    file.save(f"{UPLOAD_FOLDER}/{file.filename}")
    return {"message": "File uploaded successfully"}, 200

@app.route('/exec', methods=['POST'])
def exec_command():
    cmd = request.json.get("cmd")
    output = os.popen(cmd).read()
    return {"output": output}

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)