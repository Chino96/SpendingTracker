import json
from flask import Flask, jsonify
from Email_Parser import fetch_email
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)


class GenericEmailEndpoint(Resource):
	def get(self, key):
		if key == 'API_KEY':
			try:
				return jsonify({'Transaction Data': json.loads(fetch_email())})
			except:
				return jsonify({'Transaction Data': json.loads('{\"data\": \"TRANSACTION DOES NOT EXSIST\"}')})
		else:
			return 'INVALID API KEY'


class SpecifiedEmailEndpoint(Resource):
	def get(self, id, key):
		if key == 'API_KEY':
			try:
				return jsonify({'Transaction Data': json.loads(fetch_email(month=str(id)))})
			except:
				return jsonify({'Transaction Data': json.loads('{\"data\": \"TRANSACTION DOES NOT EXSIST\"}')})
		else:
			return 'INVALID API KEY'


api.add_resource(SpecifiedEmailEndpoint, '/month/<id>/<key>')
api.add_resource(GenericEmailEndpoint, '/email/<key>')

if __name__ == '__main__':
	app.run(host='0.0.0.0', port=80, debug=True)
