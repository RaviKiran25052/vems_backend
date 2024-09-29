const express = require('express');
const router = express.Router();
const connection = require('../db');

(async () => {
	await connection.query(`
		CREATE TABLE IF NOT EXISTS VendorDetails (
			VendorId Varchar(30) primary key,
			VendorName Varchar(50),
			ContactNumber Varchar(30),
			Email  Varchar(60),
			AadharCardUpload Varchar(300),
			Address Varchar(300),
			AccountHandlerName Varchar(255),
			AccountNumber Varchar(60),
			BankName Varchar(40),
			IFSCCode Varchar(50),
			BranchName  Varchar(100)
		);`
	);
})();

router.get('/getIdnName', (req, res) => {
	const query = 'SELECT VendorId, VendorName FROM VendorDetails';

	connection.query(query, (err, results) => {
		if (err) {
			console.error('Error fetching vendor details: ', err);
			res.status(500).send('Error fetching vendor details');
		} else {
			res.json(results);
		}
	});
})
router.get('/getAllVendors', (req, res) => {
	const sql = "SELECT * FROM VendorDetails";
	connection.query(sql, (err, result) => {
		if (err) {
			console.error('Error fetching data:', err);
			return res.status(500).json({ message: "Failed to fetch data", error: err });
		}
		res.status(200).json({ data: result });
	});
});

router.get('/getVendorByName/:VendorName', (req, res) => {
	const VendorName = req.params.VendorName;
	const sql = "SELECT * FROM VendorDetails WHERE VendorName = ?";

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

router.post('/addVendor', (req, res) => {
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

		const sql = 'INSERT INTO VendorDetails (VendorName, ContactNumber, Email, Address, AadharCardUpload, AgreementUpload, AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode, AgreementStartDate, AgreementEndDate, AgreementAmount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
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

router.put('/updateVendorByName/:VendorName', (req, res) => {
	const VendorName = req.params.VendorName;
	console.log(VendorName);

	const {
		ContactNumber,
		Email,
		Address,
		AadharCardUpload,
		AccountHandlerName,
		AccountNumber,
		BankName,
		BranchName,
		IFSCCode,
		AgreementStartDate,
		AgreementEndDate,
		AgreementAmount,
		// AmountPaid,
		// TransactionStatus
	} = req.body;

	const getVendorIdSQL = `SELECT VendorId FROM VendorDetails WHERE VendorName = ?`;

	connection.query(getVendorIdSQL, [VendorName], (err, results) => {
		if (err) {
			console.error('Error fetching VendorId:', err);
			return res.status(500).json({ message: 'Failed to fetch VendorId', error: err });
		}

		if (results.length === 0) {
			return res.status(404).json({ message: 'Vendor not found' });
		}

		const VendorId = results[0].VendorId;

		const updateVendorDetailsSQL = `
		UPDATE VendorDetails SET 
			ContactNumber = ?, 
			Email = ?, 
			Address = ?, 
			AadharCardUpload = ?, 
			AccountHandlerName = ?, 
			AccountNumber = ?, 
			BankName = ?, 
			BranchName = ?, 
			IFSCCode = ?
		WHERE VendorId = ?`;

		connection.query(updateVendorDetailsSQL, [
			ContactNumber, Email, Address, AadharCardUpload,
			AccountHandlerName, AccountNumber, BankName, BranchName, IFSCCode,
			VendorId
		], (err, result) => {
			if (err) {
				console.error('Error updating VendorDetails:', err);
				return res.status(500).json({ message: 'Failed to update VendorDetails', error: err });
			}
			// Step 3: Update VendorAgreement table
			const updateVendorAgreementSQL = `
			UPDATE VendorAgreement SET 
				AgreementStartDate = ?, 
				AgreementEndDate = ?, 
				AgreementAmount = ?
			WHERE VendorId = ?`;

			connection.query(updateVendorAgreementSQL, [
				AgreementStartDate, AgreementEndDate, AgreementAmount, VendorId
			], (err, result) => {
				if (err) {
					console.error('Error updating VendorAgreement:', err);
					return res.status(500).json({ message: 'Failed to update VendorAgreement', error: err });
				}

				res.status(200).json({ message: 'Vendor and Agreement updated successfully' });
			});
		});
	});
});

router.delete('/deleteVendorByName/:VendorName', (req, res) => {
	const VendorName = req.params.VendorName;
	const sql = "DELETE FROM VendorDetails WHERE VendorName = ?";

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