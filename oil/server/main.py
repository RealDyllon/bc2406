import pickle
from flask import Flask, request, jsonify
import os
import numpy as np

print("Current Working Directory:", os.getcwd())

# Load the pickled model from "../models/dataset_7_ensemble_model.pkl"
# oil/models/dataset_7_ensemble_model.pkl
with open("./oil/models/dataset_7_ensemble_model.pkl", 'rb') as f:
    model = pickle.load(f)

# Create the Flask app
app = Flask(__name__)

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
    app.run(port=5033, debug=True)
