from flask import Flask, request, jsonify

app = Flask(__name__)

data_storage = []

@app.route('/send_data', methods=['POST'])
def send_data():
    global data_storage
    data_storage = request.get_data()
    return "Data stored successfully", 200

@app.route('/get_data', methods=['GET'])
def get_data():
    return data_storage, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
