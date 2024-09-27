const express = require('express');
const router = express.Router();
const connection = require('../db');

(async () => {
	// await connection.query('');
})();

router.get('/showtrips', (req, res) => {
	const query = "SELECT * FROM CabBookingTable";
	connection.query(query, (err, result) => {
		if (err) return res.status(500).send(err);
		res.send(result);
	})
});

module.exports = router;