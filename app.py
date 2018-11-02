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
        similar_words = word_vectors.most_similar(word)
        results = [item[0] for item in similar_words]
        results.insert(0, word)
        resp_json = { 'word': word, 'results': results,'details': similar_words }
        resp = make_response(json.dumps(resp_json))
        return resp
    except:
        abort(404)
    
if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
