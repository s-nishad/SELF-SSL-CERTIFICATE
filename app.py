from flask import Flask, render_template

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html', title='Home', description='This is home template')


if __name__ == '__main__':
    app.run(ssl_context=('certificates/localhost.crt', 'certificates/localhost.key'), port=443, debug=True)
    # app.run(ssl_context=('certificate_generate/MyServer.crt', 'certificate_generate/MyServer.key'), port=443, debug=True)
