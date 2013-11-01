//
// Put some description here
//
var fs = require('fs');
var util = require('util');
var path = require('path');
var mustache = require('mustache');
var express = require('express');
var mongoose = require('mongoose');
var db = mongoose.createConnection('127.0.0.1', 'test');
var costPerCup = 0.15;
var server = express();

var mail_from = "kaffeekiosk-noreply@domain.com";
var nodemailer = require('nodemailer');
nodemailer.SMTP = {
  host: 'localhost'
};

server.use(express.bodyParser());
server.use('/', express.static('./public/'));


// Models definitions

var Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var userSchema = mongoose.Schema({
	name: {
		type: String,
		default: '',
		index: true
	},
	email: {
		type: String,
		default: ''
	},
	img: {
		type: String,
		default: 'user.jpg'
	},
	balance: {
		type: Number,
		default: 0
	},
	totalCups: {
		type: Number,
		default: 0
	}
});
var User = db.model('User', userSchema);

var cupSchema = mongoose.Schema({
	userId: {
		type: mongoose.Schema.Types.ObjectId,
		index: true
	},
	price: {
		type: Number,
		default: 0
	},
	date: {
		type: Date
	}
});
var Cup = db.model('Cup', cupSchema);


// Routing / methods implementation for admin area

server.all('/admin', function(req, res) {
	var action = req.param('submit');
	console.log(action);
	if (action == 'create') {
		User.create({}, function(err, small) {
			if (err) return handleError(err);
			renderIndex(req, res);
		})
	} else if (action == 'update') {
		User.findOneAndUpdate({
			_id: req.param('id')
		}, {
			name: req.param('name'),
			email: req.param('email'),
			balance: req.param('balance')
		},
			null, function(err) {
			if (err) return handleError(error);
			renderIndex(req, res);
		});
	} else if (action == 'delete') {
		var _id = req.param('id');
		User.remove({
			_id: _id
		}, function(err) {
			if (err) return handleError(err);
			renderIndex(req, res);
		});
	} else {
		renderIndex(req, res);
	}
});

server.all('/admin/edit/:id', function(req, res) {
	var action = req.param('submit');
	if (action == 'save') {
		var serverPath = path.join('public', 'img', imgFromName(req.param('id')));
		if (req.files.userPhoto.length > 0) {
			User.findOneAndUpdate({
				_id: req.param('id')
			}, {
				name: req.param('name'),
				email: req.param('email'),
				balance: req.param('balance'),
				img: imgFromName(req.param('id'))
			}, null, function(err) {
				var fromPath = req.files.userPhoto.path;
				var toPath = path.join(__dirname, serverPath);
				require('fs').rename(
					fromPath,
					toPath, function(error) {
					if (error) return handleError(error);
					renderIndex(req, res);
				});
			});
		} else {
			User.findOneAndUpdate({
				_id: req.param('id')
			}, {
				name: req.param('name'),
				email: req.param('email'),
				balance: req.param('balance'),
				img: imgFromName(req.param('id'))
			}, null, function(err) {
				renderIndex(req, res);
			});
		}
	} else {
		renderUser(req, res);
	}
});

// Routing / methods implementation for RESTful API

server.get('/api/users', function(req, res) {
	var filter = req.param('filter');
	var query = User.find({});
	if (filter == 1) {
		query.sort({
			'balance': 1
		});
	} else if (filter == 2) {
		query.sort({
			'totalCups': -1
		});
	} else {
		query.sort({
			'name': 1
		});
	}
	query.exec(function(err, data) {
		if (err)
			res.json(500, {
				error: 'error'
			});
		res.json(200, data);
	});
});

server.get('/api/users/:id', function(req, res) {
	User.findOne({
		'_id': req.param('id')
	}, function(err, data) {
		if (err) {
			res.json(404, {});
		} else {
			res.json(200, data);
		}
	});
});

server.post('/api/users', function(req, res) {
    User.create({
        name: req.param('name'),
        email: req.param('email')
    }, function(err) {
        res.json(500, {})
    });
    res.json(200, {});
});

server.post('/api/cups', function(req, res) {
	User.findById(req.body.userId, function(err, data) {
		var balance = roundNumber(data._doc.balance - costPerCup, 2);
		var cups = data._doc.totalCups + 1;
		Cup.create({
			userId: req.body.userId,
			date: new Date()
		}, function(err) {});
		User.findOneAndUpdate({
			_id: req.body.userId
		}, {
			balance: balance,
			totalCups: cups
		}, null, function(err, data) {
			if (err)
				res.json(404, {
					error: 'error'
				});
			res.json(201, {});
		});
	});
});

server.delete('/api/cups', function(req, res) {
	var fiveMinutesAgo = new Date(new Date() - 30000);
	var last = req.param('last');
	var userId = req.param('user_id');
	if (last != 1) {
		res.json(500, {});
	} else {
		Cup.findOneAndRemove({
			$and: [{
					userId: userId
				}, {
					date: {
						$gte: fiveMinutesAgo
					}
				}
			]
		}, function(err, deletedDoc) {
			if (err) {
				res.json(403, {});
			} else if (deletedDoc) {
				User.findById(userId, function(err, data) {
					var balance = roundNumber(data._doc.balance + costPerCup, 2);
					var cups = data._doc.totalCups - 1;
					User.findOneAndUpdate({
						_id: userId
					}, {
						balance: balance,
						totalCups: cups
					}, null, function(err, data) {
						if (err) {
							res.json(404, {
								error: 'error'
							});
						} else {
							res.json(200, {});
						}
					});
				});
			} else {
				res.json(404, {});
			}
		});
	}
});


server.get('/stats/group.json', function(req, res) {
	User.find({}, function(err, data) {
		var result = new Object();
		result.name = "FIT";
		result.children = new Array();
		for (var i = 0; i < data.length; i++) {
			result.children.push({
				name: data[i].name,
				size: data[i].totalCups
			})
		}
		res.json(result);
	});
});


server.get('/stats/weekday', function(req, res) {
	//Aggregation by Weekday
	Cup.aggregate({
		$group: {
			_id: {
				weekday: {
					$dayOfWeek: "$date"
				}
			},
			count: {
				$sum: 1
			}
		}
	}, function(error, data) {
		var result = {};
		result.cols = [{
				id: 'Weekday',
				label: 'Weekday',
				type: 'string'
			}, {
				id: 'Cups',
				label: 'Cups',
				type: 'number'
			}
		];
		result.rows = [
			{c:[{v: "Monday"},{v: 0}]},
			{c:[{v: "Tuesday"},{v: 0}]},
			{c:[{v: "Wednesday"},{v: 0}]},
			{c:[{v: "Thursday"},{v: 0}]},
			{c:[{v: "Friday"},{v: 0}]},
			{c:[{v: "Saturday"},{v: 0}]},
			{c:[{v: "Sunday"},{v: 0}]}
		];
		while (data.length > 0) {
			var item = data.pop();
			var weekday = item._id.weekday - 2;
			if (weekday == -1) weekday = 6;
			result.rows[weekday].c[1].v = item.count;
		}
		res.json(result);
	});
});

server.get('/stats/hourly', function(req, res) {
	//Aggregation by Hour of Day
	Cup.aggregate({
		$group: {
			_id: {
				hour: {
					$hour: "$date"
				}
			},
			count: {
				$sum: 1
			}
		}
	}, function(error, data) {
		var result = {};
		result.cols = [{
				id: 'Hours',
				label: 'Hours',
				type: 'string'
			}, {
				id: 'Cups',
				label: 'Cups',
				type: 'number'
			}
		];
		result.rows = [
			{c:[{v: "0"},{v: 0}]},
			{c:[{v: "1"},{v: 0}]},
			{c:[{v: "2"},{v: 0}]},
			{c:[{v: "3"},{v: 0}]},
			{c:[{v: "4"},{v: 0}]},
			{c:[{v: "5"},{v: 0}]},
			{c:[{v: "6"},{v: 0}]},
			{c:[{v: "7"},{v: 0}]},
			{c:[{v: "8"},{v: 0}]},
			{c:[{v: "9"},{v: 0}]},
			{c:[{v: "10"},{v: 0}]},
			{c:[{v: "11"},{v: 0}]},
			{c:[{v: "12"},{v: 0}]},
			{c:[{v: "13"},{v: 0}]},
			{c:[{v: "14"},{v: 0}]},
			{c:[{v: "15"},{v: 0}]},
			{c:[{v: "16"},{v: 0}]},
			{c:[{v: "17"},{v: 0}]},
			{c:[{v: "18"},{v: 0}]},
			{c:[{v: "19"},{v: 0}]},
			{c:[{v: "20"},{v: 0}]},
			{c:[{v: "21"},{v: 0}]},
			{c:[{v: "22"},{v: 0}]},
			{c:[{v: "23"},{v: 0}]}
		];
		while (data.length > 0) {
			var item = data.pop();
			var hour = item._id.hour - 2;
			result.rows[hour].c[1].v = item.count;
		}
		res.json(result);
	});
});


// Helper functions

function handleError(error) {
	console.log(error);

}

function imgFromName(name) {
	return name.replace(/(\r\n|\n|\r|\t|\s)/gm, "") + '.jpg';
}

function renderIndex(req, res) {
	var template = fs.readFileSync('./templates/index.html', 'utf8');
	User.find({}, function(err, data) {
		res.send(mustache.render(template, {
			users: data
		}));
	});
}

function renderUser(req, res) {
	console.log('render User ' + req.params.id);
	var template = fs.readFileSync('./templates/user.html', 'utf8');
	User.find({
		_id: req.params.id
	}, function(err, data) {
		data = data[0];
		res.send(mustache.render(template, {
			user: data
		}));
	});
}

function roundNumber(number, digits) {
    var multiple = Math.pow(10, digits);
    var rndedNum = Math.round(number * multiple) / multiple;
    return rndedNum;
}


// Off we go!
server.listen(9999, "127.0.0.1");
