const express = require('express');
const router = express.Router();
const connection = require('../db');

(async () => {
	// await connection.query('');
})();

router.get('/getAllEscorts', (req, res) => {
	const sql = "SELECT * FROM escort";
	connection.query(sql, (err, result) => {
		if (err) {
			console.error('Error fetching data:', err);
			return res.status(500).json({ message: "Failed to fetch data", error: err });
		}
		res.status(200).json({ data: result });
	});
});

router.get('/getEscortById/:id', (req, res) => {
	const vendorId = req.params.id;
	const sql = "SELECT * FROM escort WHERE EscortName = ?";

	connection.query(sql, [vendorId], (err, result) => {
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

router.put('/updateEscortById/:EscortName', (req, res) => {
	const EscortName = req.params.EscortName;
	const {
		ContactNumber,
		Age,
		Address,
		AadharCardUpload,
		CertificationUpload,
		EscortProfilePicUpload,
		AccountHandlerName,
		AccountNumber,
		BankName,
		BranchName,
		IFSCCode,
		Shift
	} = req.body;

	const sql = `UPDATE escort SET 
		ContactNumber = ?, Age = ?, Address = ?,
		AadharCardUpload = ?, CertificationUpload = ?, EscortProfilePicUpload = ?,
		AccountHandlerName = ?, AccountNumber = ?, BankName = ?, BranchName = ?, IFSCCode = ?, Shift = ?
		WHERE EscortName = ?`;

	connection.query(sql, [
		ContactNumber, Age, Address,
		AadharCardUpload, CertificationUpload, EscortProfilePicUpload,
		AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode, Shift,
		EscortName
	], (err, result) => {
		if (err) {
			console.error('Error updating data:', err);
			return res.status(500).json({ message: "Failed to update escort", error: err });
		}
		if (result.affectedRows > 0) {
			res.status(200).json({ message: "Escort updated successfully" });
		} else {
			res.status(404).json({ message: "Escort not found" });
		}
	});
});

router.delete('/deleteEscortById/:EscortName', (req, res) => {
	const EscortName = req.params.EscortName;
	const sql = "DELETE FROM escort WHERE EscortName = ?";

	connection.query(sql, [EscortName], (err, result) => {
		if (err) {
			console.error('Error deleting data:', err);
			return res.status(500).json({ message: "Failed to delete escort", error: err });
		}
		if (result.affectedRows > 0) {
			res.status(200).json({ message: "Escort deleted successfully" });
		} else {
			res.status(404).json({ message: "Escort not found" });
		}
	});
});

router.post('/addEscort', (req, res) => {
	try {
		const {
			EscortName,
			ContactNumber,
			Age,
			Address,
			AadharCardUpload,
			CertificationUpload,
			EscortProfilePicUpload,
			AccountHandlerName,
			AccountNumber,
			BankName,
			BranchName,
			IFSCCode,
			Shift
		} = req.body;

		const sql = `INSERT INTO escort (EscortName, ContactNumber, Age, Address, AadharCardUpload, CertificationUpload, EscortProfilePicUpload, AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode, Shift) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

		connection.query(sql, [
			EscortName, ContactNumber, Age, Address, AadharCardUpload, CertificationUpload, EscortProfilePicUpload,
			AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode, Shift
		], (err, result) => {
			if (err) {
				console.error('Error inserting data:', err);
				return res.status(500).json({ message: "Failed to register escort", error: err });
			}
			res.status(200).json({ message: "Escort registered successfully", result });
		});
	} catch (error) {
		console.error('Error processing request:', error);
		res.status(500).json({ message: "An unexpected error occurred", error });
	}
});

module.exports = router;