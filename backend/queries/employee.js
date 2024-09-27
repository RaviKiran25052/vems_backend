const express = require("express");
const router = express.Router();
const connection = require("../db");
const { sendEmployeeEmail } = require("./emailService");
const multer = require("multer");
const upload = multer({ dest: "uploads/" });

(async () => {
	await connection.query(
		`CREATE TABLE IF NOT EXISTS EmployeeDetails (
			EmployeeId VARCHAR(100) PRIMARY KEY, 
			EmployeeName VARCHAR(200), 
			EmployeeGender VARCHAR(20), 
			EmployeeAddress VARCHAR(255), 
			EmployeeCity VARCHAR(100), 
			EmployeeLatitude VARCHAR(100), 
			EmployeeLongitude VARCHAR(100), 
			EmployeeEmail VARCHAR(100), 
			EmployeeContact VARCHAR(20), 
			EmployeeEmergencyContact VARCHAR(20), 
			EmployeePassword VARCHAR(100), 
			EmployeeImage VARCHAR(255)
		)`
	);
})();

const generateRandomPassword = (length = 6) => {
	return crypto.randomBytes(length).toString('hex').slice(0, length);
};

router.post("/upload", upload.single("file"), (req, res) => {
	const filePath = path.join(uploadsDir, req.file.filename);

	const workbook = xlsx.readFile(filePath);
	const sheet_name = workbook.SheetNames[0];
	const sheet = xlsx.utils.sheet_to_json(workbook.Sheets[sheet_name]);

	sheet.forEach((row) => {
		const EmployeePassword = generateRandomPassword();
		const query = `
      INSERT INTO EmployeeDetails 
      (EmployeeId, EmployeeName, EmployeeGender, EmployeeAddress, EmployeeCity, EmployeeLatitude, EmployeeLongitude, EmployeeEmail, EmployeeContact, EmployeeEmergencyContact, EmployeePassword, EmployeeImage) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE 
        EmployeeName = VALUES(EmployeeName),
        EmployeeGender = VALUES(EmployeeGender),
        EmployeeAddress = VALUES(EmployeeAddress),
        EmployeeCity = VALUES(EmployeeCity),
        EmployeeLatitude = VALUES(EmployeeLatitude),
        EmployeeLongitude = VALUES(EmployeeLongitude),
        EmployeeEmail = VALUES(EmployeeEmail),
        EmployeeContact = VALUES(EmployeeContact),
        EmployeeEmergencyContact = VALUES(EmployeeEmergencyContact),
        EmployeePassword = VALUES(EmployeePassword),
        EmployeeImage = VALUES(EmployeeImage)
      `;

		const values = [
			row.EmployeeId,
			row.EmployeeName,
			row.EmployeeGender,
			row.EmployeeAddress,
			row.EmployeeCity,
			row.EmployeeLatitude,
			row.EmployeeLongitude,
			row.EmployeeEmail,
			row.EmployeeContact,
			row.EmployeeEmergencyContact,
			EmployeePassword,
			row.EmployeeImage,
		];

		connection.query(query, values, (err, result) => {
			if (err) {
				console.error("Error inserting data into MySQL:", err);
			} else {
				console.log("Data inserted/updated successfully.");
			}
		});
		row.EmployeePassword = EmployeePassword;
	});

	res.send("File uploaded and mails are being processed.");

	const emailQueue = async.queue((row, callback) => {
		sendEmployeeEmail(row)
			.then(() => {
				callback();
			})
			.catch((error) => {
				console.error("Error sending email:", error);
				callback(error);
			});
	}, 1);

	sheet.forEach((row) => {
		emailQueue.push(row, (err) => {
			if (err) {
				console.error("Error processing email for:", row.EmployeeId, row.EmployeeEmail, err);
			} else {
				console.log("Email processed for:", row.EmployeeId, row.EmployeeEmail);
			}
		});
	});

	emailQueue.drain(() => {
		console.log("All emails have been sent.");
		fs.unlink(filePath, (err) => {
			if (err) {
				console.error("Error deleting the file:", err);
			} else {
				console.log("Uploaded file deleted.");
			}
		});
	});
});

router.post("/addEmp", (req, res) => {
	const {
		EmployeeImage,
		EmployeeId,
		EmployeeName,
		EmployeeGender,
		EmployeeAddress,
		EmployeeCity,
		EmployeeLatitude,
		EmployeeLongitude,
		EmployeeEmail,
		EmployeeContact,
		EmployeeEmergencyContact,
	} = req.body;
	const EmployeePassword = generateRandomPassword();

	const query = `
   INSERT INTO EmployeeDetails 
   (EmployeeId, EmployeeName, EmployeeGender, EmployeeAddress, EmployeeCity, EmployeeLatitude, EmployeeLongitude, EmployeeEmail, EmployeeContact, EmployeeEmergencyContact, EmployeePassword, EmployeeImage) 
   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE 
      EmployeeName = VALUES(EmployeeName),
      EmployeeGender = VALUES(EmployeeGender),
      EmployeeAddress = VALUES(EmployeeAddress),
      EmployeeCity = VALUES(EmployeeCity),
      EmployeeLatitude = VALUES(EmployeeLatitude),
      EmployeeLongitude = VALUES(EmployeeLongitude),
      EmployeeEmail = VALUES(EmployeeEmail),
      EmployeeContact = VALUES(EmployeeContact),
      EmployeeEmergencyContact = VALUES(EmployeeEmergencyContact),
      EmployeePassword = VALUES(EmployeePassword),
      EmployeeImage = VALUES(EmployeeImage)
   `;

	const values = [
		EmployeeId,
		EmployeeName,
		EmployeeGender,
		EmployeeAddress,
		EmployeeCity,
		EmployeeLatitude,
		EmployeeLongitude,
		EmployeeEmail,
		EmployeeContact,
		EmployeeEmergencyContact,
		EmployeePassword,
		EmployeeImage,
	];

	connection.query(query, values, (err, result) => {
		if (err) {
			console.error("Error inserting data into MySQL:", err);
			res.status(500).send("Error saving data");
		} else {
			console.log("Data inserted/updated successfully.");

			const employeeData = {
				EmployeeId,
				EmployeeName,
				EmployeeEmail,
				EmployeePassword,
			};

			sendEmployeeEmail(employeeData)
				.then(() => {
					res.send("Employee added successfully and Email sent");
				})
				.catch((error) => {
					console.error("Error sending email:", error);
					res.status(500).send("Error sending Email");
				});
		}
	});
});

router.put("/updateEmpById/:empId", (req, res) => {
	const empId = req.params.empId;
	const {
		EmployeeName,
		EmployeeGender,
		EmployeeAddress,
		EmployeeCity,
		EmployeeLatitude,
		EmployeeLongitude,
		EmployeeContact,
		EmployeeEmergencyContact,
	} = req.body;

	const query = `
		UPDATE EmployeeDetails SET 
			EmployeeName = ?, 
			EmployeeGender = ?, 
			EmployeeAddress = ?, 
			EmployeeCity = ?, 
			EmployeeLatitude = ?, 
			EmployeeLongitude = ?, 
			EmployeeContact = ?, 
			EmployeeEmergencyContact = ?
		WHERE EmployeeId = ?
	`;

	const values = [
		EmployeeName,
		EmployeeGender,
		EmployeeAddress,
		EmployeeCity,
		EmployeeLatitude,
		EmployeeLongitude,
		EmployeeContact,
		EmployeeEmergencyContact,
		empId,
	];

	connection.query(query, values, (err, result) => {
		if (err) {
			console.error("Error updating employee details:", err);
			return res.status(500).send("Database update failed");
		}

		res.send({ message: "Employee details updated successfully!" });
	});
});

router.delete("/deleteEmpById/:empId", (req, res) => {
	const empId = req.params.empId;
	const query = "DELETE FROM EmployeeDetails WHERE EmployeeId = ?";
	connection.query(query, empId, (err, result) => {
		if (err) return res.status(500).send(err);
		res.send({ message: "Employee Deleted successfully!" });
	});
});

router.get("/getAllEmp", (req, res) => {
	const query = "SELECT * FROM EmployeeDetails";
	connection.query(query, (err, result) => {
		if (err) return res.status(500).send(err);
		res.send(result);
	});
});

module.exports = router;
