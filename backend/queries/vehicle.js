const express = require('express');
const router = express.Router();
const connection = require('../db');

(async () => {
	// await connection.query('');
})();

router.post('/addVehicle', (req, res) => {
	console.log('Request body:', req.body);
	const { VehicleName, VehicleType, VehicleNumber, VendorName, InsuranceNumber, Mileage, YearOfManufacturing, FuelType, SeatCapacity, VehicleImage } = req.body;
	const query = `INSERT INTO VehicleDetails (VehicleName, VehicleType, VehicleNumber, VendorName,  InsuranceNumber, Mileage, YearOfManufacturing, FuelType, SeatCapacity, VehicleImage) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

	connection.query(query, [
		VehicleName, VehicleType, VehicleNumber, VendorName, InsuranceNumber, Mileage, YearOfManufacturing, FuelType, SeatCapacity, VehicleImage
	], (err, result) => {
		if (err) {
			console.log(err);
			console.error('Error inserting vehicle:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		res.status(201).json({ message: 'Vehicle added successfully', vehicleId: result.insertId });
	});
});

router.get('/getAllVehicles', (req, res) => {
	const query = "SELECT * FROM VehicleDetails";
	connection.query(query, (err, results) => {
		if (err) {
			console.error('Error retrieving vehicles:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		res.status(200).json(results);
	});
});

router.get('/getVehicleById/:vehicleId', (req, res) => {
	const vehicleId = req.params.vehicleId;
	const query = `SELECT v., d. FROM VehicleDetails v LEFT JOIN driver_details d ON v.vehicleId = d.vehicleId WHERE v.vehicleId = ? `

	connection.query(query, [vehicleId], (err, result) => {
		if (err) {
			console.error('Error fetching vehicle details:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		if (result.length === 0) {
			return res.status(404).json({ error: 'Vehicle not found' });
		}
		res.status(200).json(result[0]);
	});
});

router.delete('/deleteVehicleById/:vehicleId', (req, res) => {
	const { vehicleId } = req.params;
	const query = "DELETE FROM VehicleDetails WHERE vehicleId = ?";

	connection.query(query, [vehicleId], (err, result) => {
		if (err) {
			console.error('Error deleting vehicle:', err);
			return res.status(500).json({ error: 'Database error' });
		}
		if (result.affectedRows === 0) {
			return res.status(404).json({ error: 'Vehicle not found' });
		}

		res.status(200).json({ message: 'Vehicle deleted successfully' });
	});
});

router.put('/updateVehicleById/:vehicleId', (req, res) => {
	const { vehicleId } = req.params;

	const {
		VehicleName,
		VehicleNumber,
		VehicleMileageRange,
		VehicleManufacturedYear,
		VehicleSeatCapacity,
		VehicleType,
		VehicleImage,
		VehicleInsuranceNumber,
		VehicleFuelType,
		VendorName,
		VehicleStatus,
		VehicleAddedDate
	} = req.body;

	const query = `UPDATE VehicleDetails SET 
		VehicleName = ?, 
		VehicleNumber = ?, 
		VehicleMileageRange = ?, 
		VehicleManufacturedYear = ?, 
		VehicleSeatCapacity = ?, 
		VehicleType = ?, 
		VehicleImage = ?, 
		VehicleInsuranceNumber = ?, 
		VehicleFuelType = ?, 
		VendorName = ?, 
		VehicleStatus = ?, 
		VehicleAddedDate = ? 
		WHERE VehicleId = ?`;

	connection.query(query, [
		VehicleName,
		VehicleNumber,
		VehicleMileageRange,
		VehicleManufacturedYear,
		VehicleSeatCapacity,
		VehicleType,
		VehicleImage,
		VehicleInsuranceNumber,
		VehicleFuelType,
		VendorName,
		VehicleStatus,
		VehicleAddedDate,
		vehicleId
	], (err, result) => {
		if (err) {
			console.error('Error updating vehicle:', err);
			return res.status(500).json({ error: 'Database error' });
		}

		if (result.affectedRows === 0) {
			return res.status(404).json({ error: 'Vehicle not found' });
		}

		res.status(200).json({ message: 'Vehicle updated successfully' });
	});
});


module.exports = router;