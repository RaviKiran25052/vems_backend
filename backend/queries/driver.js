const express = require('express');
const router = express.Router();
const connection = require('../db');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const { sendDriverEmail } = require('./emailService');

(async () => {
	// await connection.query('');
})();

router.post("/addDriver", (req, res) => {
	console.log('Request body:', req.body);

	const { DriverName, VendorName, Contact, Email, Gender, DOB, Address, Experience, Aadhar, Pan, LicenceNumber, ProfilePic } = req.body;
	const Password = crypto.randomBytes(7).toString('hex');
	const query = `
		INSERT INTO Driver_Details 
		(DriverName, VendorName, Contact, Email, Gender, DOB, Address, Experience, Aadhar, Pan, LicenceNumber, ProfilePic,Password) 
		VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`;

	connection.query(query, [DriverName, VendorName, Contact, Email, Gender, DOB, Address, Experience, Aadhar, Pan, LicenceNumber, ProfilePic, Password], (err, result) => {
		if (err) {
			console.error('Error inserting driver:', err);
			return res.status(500).json({ message: "Error in adding driver" });
		}
		sendDriverEmail({ DriverName, Email, Password })
			.then(response => res.status(201).json({ message: 'Driver added successfully, email sent', emailResponse: response }))
			.catch(error => res.status(500).json({ message: 'Error sending email', error }));
	});
});

router.delete("/deleteDriverById/:DriverId", (req, res) => {
	const DriverId = req.params.DriverId;
	console.log(DriverId);

	if (!DriverId) {
		return res.status(400).send({ message: "Driver name is required" });
	}

	const query = "DELETE FROM Driver_Details WHERE DriverId = ?"

	connection.query(query, [DriverId], (err, result) => {
		if (err) {
			console.error('Error deleting driver:', err);
			return res.status(500).send({ message: "Error in deleting driver" });
		}

		if (result.affectedRows === 0) {
			return res.status(404).send({ message: "Driver not found" });
		}

		res.status(200).json({ message: 'Driver deleted successfully' });
	});
});

router.post('/importDrivers', upload.single('file'), (req, res) => {
	const filePath = req.file.path;
	const workbook = xlsx.readFile(filePath);
	const sheetName = workbook.SheetNames[0];
	const sheetData = xlsx.utils.sheet_to_json(workbook.Sheets[sheetName]);

	const query = `INSERT INTO Driver_Details (DriverName,VendorName, Contact, Email, Gender, DOB, Address, Experience, Aadhar, Pan, LicenceNumber, ProfilePic) 
	VALUES (?,?,?,?,?,?,?,?,?,?,?)`;

	const values = sheetData.map(row => [
		row.DriverName,
		row.VendorName,
		row.Contact,
		row.Email,
		row.gender,
		row.DOB,
		row.Address,
		row.Experience,
		row.aadhar,
		row.Pan,
		row.licenceNumber,
		row.profilePic
	]);

	connection.query(query, [values], (err, result) => {
		fs.unlink(filePath, (unlinkErr) => {
			if (unlinkErr) {
				console.error('Error deleting file:', unlinkErr);
			}
		});
		if (err) {
			console.error('Error importing Driver data:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		res.status(201).json({ message: 'Drivers Data imported successfully', insertedRows: result.affectedRows });
	});
});

router.get('/getAllDrivers', (req, res) => {
	const query = 'SELECT * FROM Driver_Details';

	connection.query(query, (err, results) => {
		if (err) {
			console.error('Error retrieving driverss:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		res.status(200).json(results);
	});
});

router.get('/getDriverById/:driverId', (req, res) => {
	const driverId = req.params.driverId;

	const query = `SELECT 
		d.*, v.* 
	FROM 
		Driver_Details d
	LEFT JOIN 
		Vehicle_Details v ON d.vehicleId = v.vehicleId 
	WHERE 
		d.driverId = ?`;

	connection.query(query, [driverId], (err, result) => {
		if (err) {
			console.error('Error fetching driver details:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		if (result.length === 0) {
			return res.status(404).json({ error: 'Driver not found' });
		}
		res.status(200).json(result[0]);
	});
});

module.exports = router