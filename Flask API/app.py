from flask import Flask,request,jsonify
import pickle, sklearn
import numpy as np

model = pickle.load(open('model.pkl','rb'))

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello Rishabh"

@app.route('/predict',methods=['GET'])
def predict():
    age = request.args['age']
    systolicBP = request.args['systolicBP']
    diastolicBP = request.args['diastolicBP']
    bloodSugar = request.args['bloodSugar']
    bodyTemp = request.args['bodyTemp']
    heartRate = request.args['heartRate']

    inputQuery = np.array([age,systolicBP,diastolicBP,bloodSugar,bodyTemp,heartRate])
    queryReshaped = inputQuery.reshape(1,-1)
    result = model.predict(queryReshaped)

    return jsonify({"RiskLevel": str(result)})

if __name__ == '__main__':
    app.run(debug=True)