from flask import Flask,request,jsonify
import pickle
import numpy as np

model = pickle.load(open('model.pkl','rb'))

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello Rishabh"

@app.route('/predict',methods=['POST'])
def predict():
    age = request.form.get('age')
    systolicBP = request.form.get('systolicBP')
    diastolicBP = request.form.get('diastolicBP')
    bloodSugar = request.form.get('bloodSugar')
    bodyTemp = request.form.get('bodyTemp')
    heartRate = request.form.get('heartRate')

    inputQuery = np.array([age,systolicBP,diastolicBP,bloodSugar,bodyTemp,heartRate])
    result = model.predict(inputQuery)

    return jsonify({"Health Risk": str(result)})

if __name__ == '__main__':
    app.run(debug=True)