const mysql = require('mysql');
require('dotenv').config();

const connection = mysql.createConnection({
	host: process.env.DB_URL,
	port: process.env.DB_PORT,
	user: process.env.DB_USERNAME,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_NAME
});

module.exports = connection;