from flask import Flask,request, url_for, redirect, render_template
import pickle
import numpy as np
import joblib

app = Flask(__name__)

clf=pickle.load(open('finalized_model.sav','rb'))


@app.route('/')
def hello_world():
    return render_template("index.html")


@app.route('/detect',methods=['POST','GET'])
def predict():
    int_features=[int(x) for x in request.form.values()]
    final=[np.array(int_features)]
    print(int_features)
    print(final)
    prediction=clf.predict(final)

    print(np.exp(prediction))
    return render_template('index.html', pred=np.exp(prediction))



if __name__ == '__main__':
    app.run(debug=True)
    app.run(host="0.0.0.0", port="33")

