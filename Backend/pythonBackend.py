import stripe
import sys
import json
from flask import Flask, render_template, request, jsonify
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from authy.api import AuthyApiClient


stripe.api_key = "sk_test_RPqKcpfyn4rsbQ25aPiODSQ2"

app = Flask(__name__)

@app.route("/newSubscriber", methods=['GET', 'POST'])
def subscribe():
    data = request.json





@app.route("/buyGas", methods=['GET', 'POST'])
def buyGas():
    data = request.json
    token = data["stripeToken"]
    name = data["shipping"]["name"]
    city = data["shipping"]["address"]["city"]
    lineOne = data["shipping"]["address"]["line1"]
    postalCode = data["shipping"]["address"]["postal_code"]
    state = data["shipping"]["address"]["state"]
    charge = stripe.Charge.create(
    amount=data["amount"],
    currency='usd',
    receipt_email= data["receipt_email"],
    source=token,
    shipping={"name":name,"address":{"city":city,"line1": lineOne,"state":state,
                                     "postal_code":postalCode
                                     }}
      
    )

    return "Gas order succeeded"
    
@app.route("/requestVerificationCode", methods=['GET', 'POST'])
def sendCode():
    authy_api = AuthyApiClient('8xpZf43L4paKxfL5ULKnNyFakUftTp0D')
    data = request.json
    #account_sid = "AC530922c72a72faee0034ae4e6e012f47"
    #auth_token = "e67407672954476237b395e146d6d584"
    #twilio_number= '+15862501425'
    
    phoneNumber = data["phoneNumber"]
    authRequest = authy_api.phones.verification_start(phoneNumber, 1, via='sms')
    if authRequest.content["success"] == "True":
        return "Verification code sent"
    else:
        return "Error sending verification code"

    


@app.route("/checkVerificationCode", methods=['GET', 'POST'])
def checkCode():
    authy_api = AuthyApiClient('8xpZf43L4paKxfL5ULKnNyFakUftTp0D')
    data = request.json
    phoneNumber = data["phoneNumber"]
    verificationCode = data["verificationCode"]
    authCheck = authy_api.phones.verification_check(phoneNumber, 1, verificationCode)
    if authCheck.ok() == "True":
        return "Authentication successful"
    else:
        return "Authentication error."










    
