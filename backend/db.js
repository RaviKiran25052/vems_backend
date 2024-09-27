const mysql2 = require('mysql2');
require('dotenv').config();

const connection = mysql2.createPool({
	host: process.env.DB_URL,
	port: process.env.DB_PORT,
	user: process.env.DB_USERNAME,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_NAME
}).promise();

module.exports = connection;