const express = require('express');
const router = express.Router();
const connection = require('../db');

(async () => {
	// await connection.query('');
})();

router.get('/getAllVenders', (req, res) => {
	const sql = "SELECT * FROM vendor";
	connection.query(sql, (err, result) => {
		if (err) {
			console.error('Error fetching data:', err);
			return res.status(500).json({ message: "Failed to fetch data", error: err });
		}
		res.status(200).json({ data: result });
	});
});

router.get('/getVenderByName/:VendorName', (req, res) => {
	const VendorName = req.params.VendorName;
	const sql = "SELECT * FROM vendor WHERE VendorName = ?";

	connection.query(sql, [VendorName], (err, result) => {
		if (err) {
			console.error('Error fetching data:', err);
			return res.status(500).json({ message: "Failed to fetch data", error: err });
		}
		if (result.length > 0) {
			res.status(200).json(result[0]);
		} else {
			res.status(404).json({ message: "Vendor not found" });
		}
	});
});

router.post('/addVender', (req, res) => {
	try {
		const {
			VendorName,
			ContactNumber,
			Email,
			Address,
			AccountHandlerName,
			AccountNumber,
			BankName,
			BranchName,
			IFSCCode,
			AgreementStartDate,
			AgreementEndDate,
			AgreementAmount,
			AadharCardUpload,
			AgreementUpload
		} = req.body;

		const sql = 'INSERT INTO vendor (VendorName, ContactNumber, Email, Address, AadharCardUpload, AgreementUpload, AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode, AgreementStartDate, AgreementEndDate, AgreementAmount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
		connection.query(sql, [
			VendorName, ContactNumber, Email, Address,
			AadharCardUpload, AgreementUpload,
			AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode,
			AgreementStartDate, AgreementEndDate, AgreementAmount
		], (err, result) => {
			if (err) {
				console.error('Error inserting data:', err);
				return res.status(500).json({ message: "Failed to register vendor", error: err });
			}
			res.status(200).json({ message: "Vendor registered successfully", result });
		});
	} catch (error) {
		console.error('Error processing request:', error);
		res.status(500).json({ message: "An unexpected error occurred", error });
	}
});

router.put('/updateVenderByName/:VendorName', (req, res) => {
	const VendorName = req.params.VendorName;
	const {
		ContactNumber,
		Email,
		Address,
		AccountHandlerName,
		AccountNumber,
		BankName,
		BranchName,
		IFSCCode,
		AgreementStartDate,
		AgreementEndDate,
		AgreementAmount,
		AadharCardUpload,
		AgreementUpload
	} = req.body;

	const sql = `UPDATE vendor SET 
		ContactNumber = ?, Email = ?, Address = ?,
		AadharCardUpload = ?, AgreementUpload = ?,
		AccountHandlerName = ?, AccountNumber = ?, BankName = ?, BranchName = ?, IFSCCode = ?,
		AgreementStartDate = ?, AgreementEndDate = ?, AgreementAmount = ?
		WHERE VendorName = ?`;

	connection.query(sql, [
		ContactNumber, Email, Address,
		AadharCardUpload, AgreementUpload,
		AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode,
		AgreementStartDate, AgreementEndDate, AgreementAmount,
		VendorName
	], (err, result) => {
		if (err) {
			console.error('Error updating data:', err);
			return res.status(500).json({ message: "Failed to update vendor", error: err });
		}
		res.status(200).json({ message: "Vendor updated successfully" });
	});
});

router.delete('/deleteVenderByName/:VendorName', (req, res) => {
	const VendorName = req.params.VendorName;
	const sql = "DELETE FROM vendor WHERE VendorName = ?";

	connection.query(sql, [VendorName], (err, result) => {
		if (err) {
			console.error('Error deleting data:', err);
			return res.status(500).json({ message: "Failed to delete vendor", error: err });
		}
		if (result.affectedRows > 0) {
			res.status(200).json({ message: "Vendor deleted successfully" });
		} else {
			res.status(404).json({ message: "Vendor not found" });
		}
	});
});

module.exports = router;