var express = require('express'),
	path = require('path'),
	https = require('https'),
	http = require('http'),
	fs = require('fs'),
	public = require('public-ip');

var app = express();

// if (/*app.get('env') === 'development'*/ true) {
// 	var livereload = require('easy-livereload');
// 	var file_type_map = {
// 		html: 'html',
// 		jade: 'html',
// 		styl: 'css',
// 		scss: 'css',
// 		sass: 'css',
// 		less: 'css'
// 	};

// 	// store the generated regex of the object keys
// 	var file_type_regex = new RegExp('\\.(' + Object.keys(file_type_map).join('|') + ')$');

// 	app.use(livereload({
// 		watchDirs: [
// 			__dirname,
// 			path.join(__dirname, 'gui'),
// 			path.join(__dirname, 'gui/js'),
// 			path.join(__dirname, 'gui/css')
// 		],
// 		checkFunc: function(file) {
// 			console.log(file);
// 			return /\.(css|js|html)$/.test(file);
// 		},
// 		renameFunc: function(file) {
// 			console.log(file);
// 			return file;
// 		},
// 		port: process.env.LIVERELOAD_PORT || 35729
// 	}));
// }

app.use('/', express.static(__dirname + '/'));

['/', '/home', '/main', '/gui'].forEach(function(e) {
	app.use(e, express.static(__dirname + '/gui'));
	app.get(e, function(req, res) {
		res.sendFile(__dirname + '/gui/index.html');
	});
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



var http = require('http');
http.createServer(app).listen(18110);

// var https = require('https');
// var options = {
// 	key: fs.readFileSync('encryption/key.pem'),
// 	ca: fs.readFileSync('encryption/csr.pem'),
// 	cert: fs.readFileSync('encryption/cert.pem')
// };
// https.createServer(options, app).listen(20443);

console.log('Server started');