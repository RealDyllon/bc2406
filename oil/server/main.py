import pickle
from flask import Flask, request, jsonify
from flask_socketio import SocketIO, send, emit
import os
import numpy as np
import time

from utils import get_simulated_rows

print("Current Working Directory:", os.getcwd())

# Load the pickled model from "../models/dataset_7_ensemble_model.pkl"
# oil/models/dataset_7_ensemble_model.pkl
with open("../models/dataset_7_ensemble_model.pkl", 'rb') as f:
    model = pickle.load(f)

# Create the Flask app
app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

csv_row_generator = get_simulated_rows()

@socketio.on('hello')
def hello(json):
    print("Client connected")
    emit('hello', {"data": "Hello World!"})


# emit time every second
@socketio.on("time")
def handle_time(json):
    while True:
        current_time = time.strftime('%H:%M:%S')
        emit('time', {'time': current_time})
        socketio.sleep(1)

import time

@socketio.on("simulate_7")
def simulate_7(json):
    print("Simulate 7")
    while True:
        row = next(csv_row_generator)
        emit('simulate_7', row)
        socketio.sleep(1)


# Define the prediction endpoint
@app.route('/predict/7', methods=['POST'])
def predict_7():
    # Get the request data
    data = request.get_json()
    print(data["xVals"])

    # sample input data = 
    # sample_data = np.array(
    #     [[ 1.60055373, -4.12519932, -2.54230005, -2.72404032, -3.67845804, -1.33102115, 0.0 ]]
    # )

    x_vals = np.array(data["xVals"])

    # Make a prediction using the loaded model
    prediction = model.predict(x_vals)

    # Return the prediction as a JSON response
    return jsonify({'prediction': prediction.tolist()})

if __name__ == '__main__':
    socketio.run(app, port=5033, debug=True)
