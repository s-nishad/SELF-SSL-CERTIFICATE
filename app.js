const express = require('express');
const https = require('https');
const fs = require('fs');
const path = require('path');

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.get('/', (req, res) => {
  res.render('index', { title: 'Home', description: 'This is the home template' });
});

const PORT = 443;

const options = {
  key: fs.readFileSync(path.join(__dirname, 'certificates/localhost.key')),
  cert: fs.readFileSync(path.join(__dirname, 'certificates/localhost.crt'))
};

// Start the HTTPS server
https.createServer(options, app).listen(PORT, () => {
  console.log(`Server is running on https://localhost:${PORT}`);
});
