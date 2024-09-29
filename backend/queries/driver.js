const express = require('express');
const router = express.Router();
const connection = require('../db');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const { sendDriverEmail } = require('./emailService');

(async () => {
	await connection.query(`
		CREATE TABLE IF NOT EXISTS DriverDetails(
			DriverId Varchar(20) primary key,
			DriverName Varchar(50),
			DriverPhone Varchar(20),
			DriverEmail Varchar(50),
			DriverPassword varchar(255),
			DriverGender Varchar(20),
			DriverDOB Varchar(40),
			DriverAddress Varchar(300),
			DriverAadhar Varchar(300),
			DriverLicense Varchar(300),
			DriverPAN Varchar(255),
			DriverImage Varchar(300),
			DriverExperience float,
			LeaveCount int Default 0,
			DriverTrips int Default 0,
			DriverVehicleStatus boolean Default 0,
			VehicleId Varchar(40),
			VendorId Varchar(30),
			DriverStatus boolean Default 1,
			DriverAddedDate Varchar(255)
			);
		`);
}
)();

router.post('/addDriver', (req, res) => {
	const {
		DriverName,
		DriverPhone,
		DriverEmail,
		DriverGender,
		DriverDOB,
		DriverAddress,
		DriverAadhar,
		DriverLicense,
		DriverPAN,
		DriverImage,
		DriverExperience,
		VendorId
	} = req.body;

	const DriverPassword = DriverDOB;
	const DriverAddedDate = new Date().toISOString().split('T')[0];

	const query = `
		INSERT INTO DriverDetails 
		(DriverName, DriverPhone, DriverEmail, DriverPassword, DriverGender, DriverDOB, DriverAddress, DriverAadhar, DriverLicense, DriverPAN, DriverImage, DriverExperience, VendorId, DriverAddedDate) 
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
	`;

	const values = [
		DriverName,
		DriverPhone,
		DriverEmail,
		DriverPassword,
		DriverGender,
		DriverDOB,
		DriverAddress,
		DriverAadhar,
		DriverLicense,
		DriverPAN,
		DriverImage,
		DriverExperience,
		VendorId,
		DriverAddedDate
	];

	connection.query(query, values, (err, result) => {
		if (err) {
			console.error('Error inserting driver:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		res.status(201).json({ message: 'Driver added successfully', driverId: result.insertId });
	});
});

router.delete("/deleteDriverById/:DriverId", (req, res) => {
	const DriverId = req.params.DriverId;
	console.log(DriverId);

	if (!DriverId) {
		return res.status(400).send({ message: "Driver name is required" });
	}

	const query = "DELETE FROM DriverDetails WHERE DriverId = ?"

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

router.put('/updateDriverById/:DriverId', (req, res) => {
	const { DriverId } = req.params;
	const {
		DriverName,
		DriverPhone,
		DriverEmail,
		DriverGender,
		DriverDOB,
		DriverAddress,
		DriverAadhar,
		DriverLicense,
		DriverImage,
		DriverExperience,
		VendorId
	} = req.body;

	const query = `
		UPDATE DriverDetails 
		SET 
			DriverName = ?, 
			DriverPhone = ?, 
			DriverEmail = ?, 
			DriverGender = ?, 
			DriverDOB = ?, 
			DriverAddress = ?, 
			DriverAadhar = ?, 
			DriverLicense = ?, 
			DriverImage = ?, 
			DriverExperience = ?, 
			VendorId = ?
		WHERE DriverId = ?`;

	const values = [
		DriverName,
		DriverPhone,
		DriverEmail,
		DriverGender,
		DriverDOB,
		DriverAddress,
		DriverAadhar,
		DriverLicense,
		DriverImage,
		DriverExperience,
		VendorId,
		DriverId
	];

	connection.query(query, values, (err, result) => {
		if (err) {
			console.error('Error updating driver details:', err);
			return res.status(500).json({ error: 'Database error' });
		}

		if (result.affectedRows === 0) {
			return res.status(404).json({ error: 'Driver not found' });
		}
		res.status(200).json({ message: 'Driver details updated successfully' });
	});
});

router.post('/importDrivers', upload.single('file'), (req, res) => {
	const filePath = req.file.path;
	const workbook = xlsx.readFile(filePath);
	const sheetName = workbook.SheetNames[0];
	const sheetData = xlsx.utils.sheet_to_json(workbook.Sheets[sheetName]);

	const query = `INSERT INTO DriverDetails (DriverName,VendorName, Contact, Email, Gender, DOB, Address, Experience, Aadhar, Pan, LicenceNumber, ProfilePic) 
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
	const query = 'SELECT * FROM DriverDetails';

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
		DriverDetails d
	LEFT JOIN 
		VehicleDetails v ON d.vehicleId = v.vehicleId 
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