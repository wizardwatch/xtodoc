import flask
@app.route('/')
def root():
  with open('index.html') as file:
    page = file.read()
  return page
