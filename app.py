import json
import os
from flask import Flask, request, make_response, abort
from gensim.models import KeyedVectors

app = Flask(__name__)

model = KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin.gz', binary=True, limit=500000)
word_vectors = model.wv
print('Loaded')

@app.route('/s')
def similar():
    try:
        word = request.args.get('w')
        resp_json = { 'word': word, 'results': word_vectors.most_similar(word) }
        resp = make_response(json.dumps(resp_json))
        return resp
    except:
        abort(404)
    
if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
