const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const driver = require('./queries/driver')
const employee = require('./queries/employee')
const escort = require('./queries/escort')
const trip = require('./queries/trip')
const vehicle = require('./queries/vehicle')
const vendor = require('./queries/vendor')

const app = express();

const corsOptions = {
	origin: '*',
	methods: ['GET', 'POST', 'PUT', 'DELETE'],
	allowedHeaders: ['Content-Type'],
};
app.use(cors(corsOptions));
app.use(bodyParser.json());

app.use('/driver', driver)
app.use('/employee', employee)
app.use('/escort', escort)
app.use('/trip', trip)
app.use('/vehicle', vehicle)
app.use('/vendor', vendor)

app.listen(process.env.PORT, () => {
	console.log(`Server is listening on port ${process.env.PORT}`);
});