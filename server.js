var express = require('express'),
    https = require('https'),
    http = require('http'),
    fs = require('fs'),
    public = require('public-ip');

var app = express();

app.use('/', express.static(__dirname + '/'));

app.get('/', function(req, res) {
	res.sendFile(__dirname + '/index.html');
});

app.get('/ip', function(req, res) {
	var reqip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
	if (reqip == '::ffff:127.0.0.1') {
		console.log('localhost : ' + reqip + '\n');
		res.send('127.0.0.1');
	} else if (reqip.match(/::ffff:192.168.0./)) {
		console.log('LAN : ' + reqip + ' : ' + '192.168.0.49' + '\n');
		res.send('192.168.0.49');
	} else {
		public.v4().then(function(extip) {
			console.log('WAN : ' + reqip + ' : ' + extip + '\n');
			res.send(extip);
		}, function(error) {
			console.log('WAN : ' + reqip + ' : ' + 'ERROR' + '\n');
			res.send('ERROR');
		});
	}
});

var options = {
	key: fs.readFileSync('encryption/key.pem'),
	ca: fs.readFileSync('encryption/csr.pem'),
	cert: fs.readFileSync('encryption/cert.pem')
};

var http = require('http');
var https = require('https');

http.createServer(app).listen(20080);
https.createServer(options, app).listen(20443);

console.log('Server started');
