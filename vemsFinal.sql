create database if not exists vemsFinal;
use vemsFinal;

																	-- CREATE TABLES --  

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS VendorDetails;

CREATE TABLE VendorDetails (
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
  );
  
DROP TABLE IF EXISTS VendorAgreement;

CREATE TABLE VendorAgreement(
AgreementId Varchar(40) primary key,
VendorId Varchar(30),
AgreementStartDate Varchar(30),
AgreementEndDate Varchar(30),
AgreementAmount float,
AmountPaid float,
AgreementUpload Varchar(300),
TransactionStatus boolean Default 0
);

DROP TABLE IF EXISTS VendorTransactions;

CREATE TABLE VendorTransactions(
 TransactionId Varchar(100) primary key,
 VendorId Varchar(30),
 TotalAmount float,
 AmountPaid float,
 AmountDue float Default 0,
 TransactionDate Varchar(30)
 );
 
DROP TABLE IF EXISTS VehicleDetails;

CREATE TABLE VehicleDetails(
VehicleId Varchar(30) primary key,
VehicleName Varchar(50),
VehicleNumber Varchar(50),
VehicleMileageRange Varchar(50),
VehicleManufacturedYear Varchar(30),
VehicleSeatCapacity int,
VehicleType Varchar(30),
VehicleImage Varchar(300),
VehicleInsuranceNumber Varchar(40),
VehicleFuelType Varchar(30),
VehicleStatus boolean Default 0,
VendorId Varchar(30),
VendorName Varchar(50),
VehicleAddedDate Varchar(255)
);

DROP TABLE IF EXISTS DriverDetails;

CREATE TABLE DriverDetails(
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
  
DROP TABLE IF EXISTS LeavesTable;

CREATE TABLE IF NOT EXISTS LeavesTable(
LeaveId Varchar(255) primary key,
DriverId Varchar(255),
LeaveDate Varchar(255),
Reason Varchar(255));
  
DROP TABLE IF EXISTS EscortManagement;

CREATE TABLE EscortManagement(
EscortId Varchar(40) primary key,
EscortName Varchar(50),
EscortProfilePicUpload Varchar(300),
ContactNumber Varchar(20),
Age INT,
AadharCardUpload Varchar(300),
Address Varchar(300), 
CertificationUpload Varchar(300),
AccountHandlerName Varchar(255),
AccountNumber Varchar(40),
BankName Varchar(40),
IFSCCode Varchar(40),
BranchName Varchar(50),
ShiftStartTime Varchar(30),
ShiftEndTime Varchar(255),
EscortAddedDate Varchar(255)
);

DROP TABLE IF EXISTS EmployeeDetails;

CREATE TABLE IF NOT EXISTS EmployeeDetails(
EmployeeId Varchar(255) primary key,
EmployeeName Varchar(255),
EmployeeContact Varchar(255) UNIQUE,
EmployeeEmergencyContact Varchar(255),
EmployeeEmail Varchar(255) UNIQUE,
EmployeePassword Varchar(255),
EmployeeGender Varchar(255),
EmployeeAddress Varchar(255),
EmployeeCity Varchar(255),
Latitude Varchar(255),
Longitude Varchar(255),
EmployeeImage Varchar(255));

DROP TABLE IF EXISTS CabBookingTable;

CREATE TABLE IF NOT EXISTS CabBookingTable (
    BookingId varchar(255) PRIMARY KEY,
    EmployeeId varchar(255),
    EmployeeName varchar(255),
    EmployeeGender varchar(255),
    EmployeeAddress varchar(500),
    EmployeeCity varchar(30),
    Latitude varchar(30),
    Longitude varchar(30),
    TripDate varchar(255),
    BookingDateTime varchar(255),
    LoginTime varchar(255),
    LogoutTime varchar(255),
    VehicleAssigned BOOLEAN DEFAULT 0,
    EscortId varchar(255) DEFAULT NULL
);

DROP TABLE IF EXISTS DriverFeedback;

CREATE TABLE IF NOT EXISTS DriverFeedback(
FeedbackId Varchar(255) primary key,
DriverId Varchar(255),
EmployeeId Varchar(255),
Rating Decimal(2,1),
Feedback text);

DROP TABLE IF EXISTS rideallocation_pickup;

CREATE TABLE IF NOT EXISTS rideallocation_pickup(
BookingId varchar(255) primary key,
EmployeeId varchar(255),
EmployeeName varchar(255),
EmployeeGender varchar(255),
EmployeeAddress varchar(255),
EmployeeCity varchar(255),
Latitude varchar(255),
Longitude varchar(255),
TripDate varchar(255),
LoginTime varchar(255),
LogoutTime varchar(255),
VehicleId varchar(255),
VehicleNumber varchar(255),
VehicleSeatCapacity int,
CumulativeTravleTime decimal(10,2),
PriorityOrder int);

DROP TABLE IF EXISTS rideallocation_drop;

CREATE TABLE IF NOT EXISTS rideallocation_drop(
BookingId varchar(255) primary key,
EmployeeId varchar(255),
EmployeeName varchar(255),
EmployeeGender varchar(255),
EmployeeAddress varchar(255),
EmployeeCity varchar(255),
Latitude varchar(255),
Longitude varchar(255),
TripDate varchar(255),
LoginTime varchar(255),
LogoutTime varchar(255),
VehicleId varchar(255),
VehicleNumber varchar(255),
VehicleSeatCapacity int,
CumulativeTravleTime decimal(10,2),
PriorityOrder int,
EsortId varchar(255)); 

DROP TABLE IF EXISTS TripHistory;

CREATE TABLE IF NOT EXISTS TripHistory(
TripId Varchar(255) primary key,
RideId varchar(255),
BookingId Varchar(255),
EmployeeId Varchar(255),
EmployeeName varchar(255),
EmployeeGender varchar(20),
EmployeeAddress varchar(255),
EmployeeCity varchar(255),
LoginTime Varchar(255),
LogoutTime Varchar(255),
DriverId Varchar(255),
DriverName varchar(255),
VehicleNumber Varchar(255),
PriorityOrder int,
EscortName varchar(255),
TripType ENUM('PICKUP', 'DROP'),
TripDate Varchar(255));

																		-- ADD FOREIGN KEYS --  

SET FOREIGN_KEY_CHECKS = 1;

 ALTER TABLE VendorTransactions
 ADD CONSTRAINT fk_VendorTransactions_VendorId
 FOREIGN KEY (VendorId) REFERENCES VendorDetails(VendorId)
 ON DELETE CASCADE
 ON UPDATE CASCADE;
 
ALTER TABLE VendorAgreement
ADD CONSTRAINT fk_VendorAgreement_VendorId  
FOREIGN KEY (VendorId) REFERENCES VendorDetails(VendorId)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE VehicleDetails 
ADD CONSTRAINT fk_VehicleDetails_VendorId
foreign key (VendorId) REFERENCES VendorDetails(VendorId)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE DriverDetails 
ADD CONSTRAINT fk_DriverDetails_VendorId
FOREIGN KEY (VendorId) REFERENCES VendorDetails(VendorId)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT fk_DriverDetails_VehicleId
foreign key (VehicleId) REFERENCES VehicleDetails(VehicleId)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE LeavesTable
ADD CONSTRAINT fk_LeavesTable_DriverId
foreign key (DriverId) REFERENCES DriverDetails(DriverId)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE CabBookingTable
ADD CONSTRAINT fk_CabBookingTable_EmployeeId
foreign key (EmployeeId) REFERENCES EmployeeDetails(EmployeeId)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE DriverFeedback
ADD CONSTRAINT fk_DriverFeedback_DriverId
foreign key (DriverId) REFERENCES DriverDetails(DriverId)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT fk_DriverFeedback_EmployeeId
foreign key (EmployeeId) REFERENCES EmployeeDetails(EmployeeId)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TripHistory
ADD CONSTRAINT fk_TripHistory_BookingId
FOREIGN KEY (BookingId) REFERENCES CabBookingTable(BookingId)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT fk_TripHistory_EmployeeId 
FOREIGN KEY (EmployeeId) REFERENCES EmployeeDetails(EmployeeId)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT fk_TripHistory_DriverId
FOREIGN KEY (DriverId) REFERENCES DriverDetails(DriverId)
ON DELETE CASCADE
ON UPDATE CASCADE;

																-- TRIGGERS TO AUTO GENERATE Id's --  

DROP TRIGGER IF EXISTS autoGen_VendorId;
  
  DELIMITER //
  CREATE TRIGGER autoGen_VendorId
  BEFORE INSERT ON VendorDetails
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(VendorId, 3)AS UNSIGNED)),0) into max_Id FROM VendorDetails;
  SET NEW.VendorId = CONCAT('VD', LPAD(max_Id + 1,3,0));
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_agreementId;

  DELIMITER //
  CREATE TRIGGER autoGen_agreementId
  BEFORE INSERT ON VendorAgreement
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(AgreementId, 4)AS UNSIGNED)),0) into max_Id FROM VendorAgreement;
  SET NEW.AgreementId = CONCAT('AID', LPAD(max_Id+ 1,3,0));
  END;
  //
  
  DELIMITER ;
    
DROP TRIGGER IF EXISTS autoGen_transactionId;
 
  DELIMITER //
  CREATE TRIGGER autoGen_transactionId
  BEFORE INSERT ON VendorTransactions
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(TransactionId, 4)AS UNSIGNED)),0) into max_Id FROM VendorTransactions;
  SET NEW.TransactionId = CONCAT('TID', LPAD(max_Id + 1,3,0));
  SET NEW.TransactionDate = Date_format(CURRENT_DATE(), '%d/%m/%Y');
  END;
  //
    
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_VehicleId;

  DELIMITER //
  CREATE TRIGGER autoGen_VehicleId
  BEFORE INSERT ON VehicleDetails
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(VehicleId, 4)AS UNSIGNED)),0) into max_Id FROM VehicleDetails;
  SET NEW.VehicleId = CONCAT('VID', LPAD(max_Id + 1,3,0));
  SET NEW.VehicleAddedDate = Date_format(CURRENT_TIME(), '%d/%m/%Y');
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_DriverId;

  DELIMITER //
  CREATE TRIGGER autoGen_DriverId
  BEFORE INSERT ON DriverDetails
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(DriverId, 4)AS UNSIGNED)),0) into max_Id FROM DriverDetails;
  SET NEW.DriverId = CONCAT('DID', LPAD(max_Id + 1,3,0));
  SET NEW.DriverAddedDate = Date_format(CURRENT_TIME(), '%d/%m/%Y');
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_leaveId;

  DELIMITER //
  CREATE TRIGGER autoGen_leaveId  BEFORE INSERT ON LeavesTable
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(LeaveId, 4)AS UNSIGNED)),0) into max_Id FROM LeavesTable;
  SET NEW.LeaveId = CONCAT('LID', LPAD(max_Id + 1,3,0));
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_escortId;

  DELIMITER //
  CREATE TRIGGER autoGen_escortId
  BEFORE INSERT ON EscortManagement
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(EscortId, 6)AS UNSIGNED)),0) into max_Id FROM EscortManagement;
  SET NEW.EscortId = CONCAT('ESCID', LPAD(max_Id + 1,3,0));
  SET NEW.EscortAddedDate = Date_format(CURRENT_TIME(), '%d/%m/%Y');
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_EmployeeId;

  DELIMITER //
  CREATE TRIGGER autoGen_EmployeeId
  BEFORE INSERT ON EmployeeDetails
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  IF NEW.EmployeeId IS null
  THEN
  SELECT coalesce(max(cast(substring(EmployeeId, 8)AS UNSIGNED)),0) into max_Id FROM EmployeeDetails 
  WHERE substring(EmployeeId,1,7) = CONCAT('VTS', Date_format(current_Date(), '%Y')+1);
  SET NEW.EmployeeId = CONCAT('VTS', Date_format(current_Date(), '%Y')+1, LPAD(max_Id + 1,3,'0'));
  END IF;
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_bookingId;

  DELIMITER //
  CREATE TRIGGER autoGen_bookingId
  BEFORE INSERT ON CabBookingTable
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(BookingId, 4)AS UNSIGNED)),0) into max_Id FROM CabBookingTable;
  SET NEW.BookingId = CONCAT('BID', LPAD(max_Id + 1,3,0));
  SET NEW.BookingDateTime = Date_format(CURRENT_TIMESTAMP(), '%d/%m/%Y-%H:%i:%s'); 
  END;
  //
  
  DELIMITER ;

DROP TRIGGER IF EXISTS autoGen_feedbackId;

  DELIMITER //
  CREATE TRIGGER autoGen_feedbackId
  BEFORE INSERT ON DriverFeedback
  FOR EACH ROW 
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(substring(FeedbackId, 4)AS UNSIGNED)),0) into max_Id FROM DriverFeedback;
  SET NEW.FeedbackId = CONCAT('FID', LPAD(max_Id + 1,3,0));
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS autoGen_TripHistoryId;

  DELIMITER //
  CREATE TRIGGER autoGen_TripHistory
  BEFORE INSERT ON TripHistory
  FOR EACH ROW
  BEGIN
  DECLARE max_Id int;
  SELECT coalesce(max(cast(SUBSTRING(TripId, 5) AS UNSIGNED)), 0) INTO max_Id FROM TripHistory;
  SET NEW.TripId = CONCAT('TRIP', LPAD(max_Id + 1,3,0));
  SET NEW.TripDate = date_format(current_date(), '%d/%m/%Y');
  END;
  //
  DELIMITER ;
  

									
															-- TRIGGERS TO UPDATE OR INSERT IN TABLES --  
  
DROP TRIGGER IF EXISTS transactionStatusUpDate;  
  
  DELIMITER //
  CREATE TRIGGER transactionStatusUpDate
  AFTER UPDATE ON VendorAgreement
  FOR EACH ROW
  BEGIN 
  IF NEW.TransactionStatus = 1
  THEN 
  INSERT INTO VendorTransactions(VendorId, TotalAmount, AmountPaid, AmountDue, TransactionDate)
  VALUES (NEW.VendorId, NEW.AgreementAmount, NEW.AmountPaid, NEW.AgreementAmount - NEW.AmountPaid, Date_format(CURRENT_DATE(), '%d/%m/%Y'));
  END IF;
  END;
  //
  DELIMITER ;
  
DROP TRIGGER IF EXISTS update_VendorId_Vehicle;   
  
  DELIMITER //
  CREATE TRIGGER update_VendorId_Vehicle
  BEFORE INSERT ON VehicleDetails
  FOR EACH ROW 
  BEGIN
  DECLARE VenId VARCHAR(30);
  SELECT VendorId INTO VenId
  FROM VendorDetails
  WHERE VendorName = NEW.VendorName
  LIMIT 1;
  IF VenId IS NOT NULL 
  THEN
  SET NEW.VendorId = VenId;
  END IF;
  END;
  //

  DELIMITER ;

DROP TRIGGER IF EXISTS update_VendorId_Driver;
  
  DELIMITER //
  CREATE TRIGGER update_VendorId_Driver
  BEFORE INSERT ON DriverDetails
  FOR EACH ROW 
  BEGIN
  DECLARE VenId VARCHAR(30);
  SELECT VendorId INTO VenId
  FROM VendorDetails
  WHERE VendorName = NEW.VendorName
  LIMIT 1;
  IF VenId IS NOT NULL 
  THEN
  SET NEW.VendorId = VenId;
  END IF;
  END;
  //

  DELIMITER ;
  
DROP TRIGGER IF EXISTS checkDriver; 

  DELIMITER //
  CREATE TRIGGER checkDriVer
  BEFORE INSERT ON DriverDetails 
  FOR EACH ROW
  BEGIN
  DECLARE DriverCount int;
  DECLARE VehicleCount int;
  
  SELECT COUNT(*) INTO VehicleCount FROM VehicleDetails;
  SELECT COUNT(*) into DriVerCount FROM DriVerDetails;
  
  IF DriverCount>=VehicleCount THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No Vehicles for Drivers to Drive';
  END IF;
  END;
  //
  DELIMITER ;

DROP TRIGGER IF EXISTS updateDriverId_Vehicle;	
  
  DELIMITER //
  CREATE TRIGGER updateDriverId_Vehicle
  BEFORE INSERT ON DriverDetails
  FOR EACH ROW
  BEGIN
  DECLARE VId Varchar(255);
  SELECT VehicleId INTO VId FROM VehicleDetails WHERE VehicleStatus = 0 
  LIMIT 1;
  IF VId IS NOT NULL THEN
  SET NEW.VehicleId = VId;
  SET NEW.DriverVehicleStatus = 1;
  UPDATE VehicleDetails SET VehicleStatus = 1 WHERE VehicleId = VId;
  END IF;
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS DeleteDriver;

  DELIMITER //
  CREATE TRIGGER DeleteDriver
  AFTER DELETE ON DriverDetails
  FOR EACH ROW
  BEGIN
  UPDATE VehicleDetails SET VehicleStatus = 0 WHERE VehicleId = OLD.VehicleId;
  END;
  //
  
  DELIMITER ;
  
DROP TRIGGER IF EXISTS DeleteVehicle;

  DELIMITER //
  CREATE TRIGGER DeleteVehicle
  BEFORE DELETE ON VehicleDetails
  FOR EACH ROW
  BEGIN
  UPDATE DriverDetails SET DriverVehicleStatus = 0 WHERE VehicleId = OLD.VehicleId ;
  END ; 
  //
  DELIMITER ;
  
DROP TRIGGER IF EXISTS DriverLeaVeCount;

  DELIMITER //
  CREATE TRIGGER DriverLeaveCount
  AFTER INSERT ON LeavesTable
  FOR EACH ROW 
  BEGIN
  UPDATE DriverDetails SET LeaveCount = LeaveCount+1;
  END 
  //

  DELIMITER ;
  
DROP TRIGGER IF EXISTS empToBooking;

DELIMITER //

CREATE TRIGGER empToBooking
BEFORE INSERT ON CabBookingTable
FOR EACH ROW
BEGIN
    SET NEW.EmployeeName = (SELECT EmployeeName FROM EmployeeDetails WHERE EmployeeId = NEW.EmployeeId),
	NEW.EmployeeGender = (SELECT EmployeeGender FROM EmployeeDetails WHERE EmployeeId = NEW.EmployeeId),
    NEW.EmployeeAddress = (SELECT EmployeeAddress FROM EmployeeDetails WHERE EmployeeId = NEW.EmployeeId),
    NEW.EmployeeCity = (SELECT EmployeeCity FROM EmployeeDetails WHERE EmployeeId = NEW.EmployeeId),
    NEW.Latitude = (SELECT Latitude FROM EmployeeDetails WHERE EmployeeId = NEW.EmployeeId),
	NEW.Longitude = (SELECT Longitude FROM EmployeeDetails WHERE EmployeeId = NEW.EmployeeId);
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS populate_trip_management_pickup;

DELIMITER //

CREATE TRIGGER populate_trip_management_pickup
AFTER INSERT ON rideallocation_pickup
FOR EACH ROW
BEGIN
    DECLARE v_VehicleNumber VARCHAR(50);
    DECLARE v_PriorityOrder INT;
    DECLARE v_DriverId VARCHAR(20);
    DECLARE v_DriverName VARCHAR(50);
    DECLARE v_BookingId VARCHAR(20);
    DECLARE v_LoginTime TIME;
    DECLARE v_LogoutTime TIME;
    DECLARE v_EmployeeName VARCHAR(50);
    DECLARE v_EmployeeGender VARCHAR(20);
    DECLARE v_EmployeeAddress VARCHAR(100);
    DECLARE v_EscortName VARCHAR(255);
    DECLARE v_EmployeeCity varchar(255);
    DECLARE v_TripDate varchar(255);
    SELECT BookingId, LoginTime, LogoutTime, EmployeeName,EmployeeGender, EmployeeAddress, EmployeeCity, TripDate
    INTO v_BookingId, v_LoginTime, v_LogoutTime, v_EmployeeName,v_EmployeeGender, v_EmployeeAddress,v_EmployeeCity, v_TripDate
    FROM CabBookingTable
    WHERE EmployeeId = NEW.EmployeeId
    LIMIT 1;
    SELECT VehicleNumber, PriorityOrder
    INTO v_VehicleNumber, v_PriorityOrder
    FROM rideallocation_pickup
    WHERE EmployeeId = NEW.EmployeeId
    LIMIT 1;
    SELECT DriverId, DriverName
    INTO v_DriverId, v_DriverName
    FROM DriverDetails
    WHERE VehicleId = (SELECT VehicleId FROM rideallocation_pickup WHERE EmployeeId = NEW.EmployeeId LIMIT 1)
    LIMIT 1;
    SELECT em.EscortName
    INTO v_EscortName
    FROM EscortManagement em
    JOIN CabBookingTable cb ON cb.EscortId = em.EscortId
    WHERE cb.EmployeeId = NEW.EmployeeId
    LIMIT 1;
    INSERT INTO TripHistory(BookingId, EmployeeId, EmployeeName, EmployeeGender, EmployeeAddress, EmployeeCity, LoginTime, LogoutTime, DriverId, DriverName, VehicleNumber, PriorityOrder, EscortName, TripType, TripDate)
    VALUES (v_BookingId, NEW.EmployeeId, v_EmployeeName, v_EmployeeGender, v_EmployeeAddress, v_EmployeeCity, v_LoginTime, v_LogoutTime, v_DriverId, v_DriverName, v_VehicleNumber, v_PriorityOrder, v_EscortName, 'PICKUP', v_TripDate);
END //

DELIMITER ;

DROP TRIGGER IF EXISTS populate_trip_management_drop;

DELIMITER //

CREATE TRIGGER populate_trip_management_drop
AFTER INSERT ON rideallocation_drop
FOR EACH ROW
BEGIN
    DECLARE v_VehicleNumber VARCHAR(50);
    DECLARE v_PriorityOrder INT;
    DECLARE v_DriverId VARCHAR(20);
    DECLARE v_DriverName VARCHAR(50);
    DECLARE v_BookingId VARCHAR(20);
    DECLARE v_LoginTime TIME;
    DECLARE v_LogoutTime TIME;
    DECLARE v_EmployeeName VARCHAR(50);
    DECLARE v_EmployeeGender VARCHAR(20);
    DECLARE v_EmployeeAddress VARCHAR(100);
    DECLARE v_EscortName VARCHAR(255);
    DECLARE v_EmployeeCity varchar(255);
    DECLARE v_TripDate varchar(255);
    SELECT BookingId, LoginTime, LogoutTime, EmployeeName,EmployeeGender, EmployeeAddress, EmployeeCity, TripDate
    INTO v_BookingId, v_LoginTime, v_LogoutTime, v_EmployeeName,v_EmployeeGender, v_EmployeeAddress,v_EmployeeCity, v_TripDate
    FROM CabBookingTable
    WHERE EmployeeId = NEW.EmployeeId
    LIMIT 1;
    SELECT VehicleNumber, PriorityOrder
    INTO v_VehicleNumber, v_PriorityOrder
    FROM rideallocation_drop
    WHERE EmployeeId = NEW.EmployeeId
    LIMIT 1;
    SELECT DriverId, DriverName
    INTO v_DriverId, v_DriverName
    FROM DriverDetails
    WHERE VehicleId = (SELECT VehicleId FROM rideallocation_drop WHERE EmployeeId = NEW.EmployeeId LIMIT 1)
    LIMIT 1;
    SELECT em.EscortName
    INTO v_EscortName
    FROM EscortManagement em
    JOIN CabBookingTable cb ON cb.EscortId = em.EscortId
    WHERE cb.EmployeeId = NEW.EmployeeId
    LIMIT 1;
    INSERT INTO TripHistory(BookingId, EmployeeId, EmployeeName, EmployeeGender, EmployeeAddress, EmployeeCity, LoginTime, LogoutTime, DriverId, DriverName, VehicleNumber, PriorityOrder, EscortName, TripType, TripDate)
    VALUES (v_BookingId, NEW.EmployeeId, v_EmployeeName, v_EmployeeGender, v_EmployeeAddress, v_EmployeeCity, v_LoginTime, v_LogoutTime, v_DriverId, v_DriverName, v_VehicleNumber, v_PriorityOrder, v_EscortName, 'DROP', v_TripDate);
END //

DELIMITER ;

 DROP TRIGGER IF EXISTS tripHistory_RideId;

DELIMITER //
CREATE TRIGGER tripHistory_RideId
BEFORE INSERT ON tripHistory
FOR EACH ROW
BEGIN
    DECLARE v_RideId varchar(10);
    SELECT RideId INTO v_RideId FROM tripHistory WHERE VehicleNumber = NEW.VehicleNumber AND TripDate = NEW.TripDate AND LoginTime = NEW.LoginTime AND LogOutTime = NEW.LogOutTime LIMIT 1;
    IF v_RideId IS NOT NULL THEN
        SET NEW.RideId = v_RideId;
    ELSE
        SELECT coalesce(max(cast(SUBSTRING(RideId, 5) AS UNSIGNED)), 0) INTO v_RideId FROM tripHistory;
        SET NEW.RideId = concat('RIDE', LPAD(v_RideId+1, 3, '0'));
    END IF;
END;
//
DELIMITER ;


  
																	-- INSERT STATEMENTS -- 
                
INSERT INTO VendorDetails (VendorName, ContactNumber, Email, AadharCardUpload, Address, AccountHandlerName, AccountNumber, BankName, IFSCCode, BranchName) 
VALUES 
('Apex Solutions', '3216549870', 'contact@apexsolutions.com', 'https://aaDharlink.apex.com', '789 InDustrial Park, City, State, Zip', 'Alice Smith', '6543210987654321', 'National Bank', 'NB0009876', 'Main Branch'),
('Elite Logistics', '4321659870', 'info@elitlogistics.com', 'https://aaDharlink.elitlogistics.com', '101 Commerce St, City, State, Zip', 'Bob Johnson', '7654321098765432', 'Global Bank', 'GB0008765', 'Downtown Branch'),
('Metro Transport', '5432165987', 'support@metrotransport.com', 'https://aaDharlink.metrotransport.com', '202 InDustrial Area, City, State, Zip', 'Carol DaVis', '8765432109876543', 'Metro Bank', 'MB0007654', 'Uptown Branch');

INSERT INTO VendorAgreement (VendorId, AgreementStartDate, AgreementEndDate, AgreementAmount, AmountPaid, AgreementUpload) 
VALUES 	
('VD001', '2024-09-10', '2024-12-31', 15000, 2000, 'http://agreementfile2.com'),
('VD002', '2024-10-01', '2025-03-31', 20000, 3000, 'http://agreementfile3.com'),
('VD003', '2024-11-01', '2025-06-30', 18000, 2500, 'http://agreementfile4.com');

INSERT INTO VehicleDetails (VehicleName, VehicleNumber, VehicleMileageRange, VehicleManufacturedYear, VehicleSeatCapacity, VehicleType, VehicleImage, VehicleInsuranceNumber, VehicleFuelType, VendorName) 
VALUES 
('HonDa AccorD', 'MH12CD5678', '12-15 km/l', '2020', 5, 'SeDan', 'https://images.honDa.com/accorD.jpg', 'INS8765432109', 'Petrol', 'Metro Transport'),
('ForD EcoSport', 'KA03DE4567', '14-17 km/l', '2021', 5, 'SUV', 'https://images.forD.com/ecosport.jpg', 'INS2345678910', 'Petrol', 'Apex Solutions'),
('CheVrolet TraVerse', 'TN01FG7890', '10-13 km/l', '2019', 7, 'SUV', 'https://images.cheVrolet.com/traVerse.jpg', 'INS3456789012', 'Diesel', 'Elite Logistics'),
('Nissan Altima', 'MH12GH5678', '15-18 km/l', '2020', 5, 'SeDan', 'https://images.nissan.com/altima.jpg', 'INS4567890123', 'Petrol', 'Apex Solutions'),
('HyunDai Sonata', 'KA03IJ6789', '13-16 km/l', '2021', 5, 'SeDan', 'https://images.hyunDai.com/sonata.jpg', 'INS5678901234', 'Petrol', 'Elite Logistics'),
('SkoDa OctaVia', 'MH12JK9012', '12-16 km/l', '2022', 5, 'SeDan', 'https://images.skoDa.com/octaVia.jpg', 'INS6789012345', 'Petrol', 'Metro Transport');

INSERT INTO DriverDetails (DriverName, DriverPhone, DriverEmail, DriverGender, DriverDOB, DriverAddress, DriverAadhar, DriverLicense, DriverImage, DriverExperience, LeaveCount, DriverTrips, VendorName)
VALUES
('Chris Lee', '9123456780', 'chris.lee@example.com', 'Male', '1987-04-20', '101 Central AVe, City, State, Zip', 'https://aaDhar.example.com/chrislee', 'DL9988776655', 'https://images.example.com/chrislee.jpg', 7.0, 3, 190, 'Metro Transport'),
('AmanDa Clark', '9234567891', 'amanDa.clark@example.com', 'Female', '1990-09-10', '202 RiVer St, City, State, Zip', 'https://aaDhar.example.com/amanDaclark', 'DL8877665544', 'https://images.example.com/amanDaclark.jpg', 5.0, 2, 160, 'Apex Solutions'),
('Ryan ADams', '9345678902', 'ryan.aDams@example.com', 'Male', '1982-06-15', '303 Elm St, City, State, Zip', 'https://aaDhar.example.com/ryanaDams', 'DL7766554433', 'https://images.example.com/ryanaDams.jpg', 9.0, 4, 210, 'Elite Logistics'),
('Sophia Taylor', '9456789013', 'sophia.taylor@example.com', 'Female', '1994-02-28', '404 Maple St, City, State, Zip', 'https://aaDhar.example.com/sophiataylor', 'DL6655443322', 'https://images.example.com/sophiataylor.jpg', 4.0, 1, 130, 'Elite Logistics'),
('Daniel Harris', '9567890124', 'Daniel.harris@example.com', 'Male', '1989-07-10', '505 Oak St, City, State, Zip', 'https://aaDhar.example.com/Danielharris', 'DL5544332211', 'https://images.example.com/Danielharris.jpg', 6.0, 3, 180, 'Apex Solutions');

INSERT INTO EmployeeDetails (EmployeeId, EmployeeName, EmployeeAddress, EmployeeCity, Latitude, Longitude, EmployeeContact, EmployeeEmail, EmployeeEmergencyContact, EmployeeGender, EmployeeImage)
VALUES
('VTS2024877', 'Dasari Hema Amrutha', 'Kandanchavadi', 'Chennai', '12.9669208', '80.2482764', '6301321939', 'Dasariamrutha3@gmail.com', '6301321939', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2024883', 'DUSANAPUDI RAJYA LAKSHMI', 'Kandanchavadi', 'Chennai', '12.9669208', '80.2482764', '9182340469', 'Drajyalakshmi03@gmail.com', '9441073861', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2024884', 'BalaSubrahmanyam DusanapuDi', 'Kandhanchavadi', 'Chennai', '11.9525896', '79.8196606', '9392877127', 'subbuDusanapuDi@gmail.com', '9392877127', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2024888', 'Gelli.Naga Satya DeDeepya', 'Kandanchavadi', 'Chennai', '12.9669208', '80.2482764', '8179854556', 'DeDeepyagelli@gmail.com', '8179854556', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2024944', 'Hema Shanker', '7/35,M.CHETTIPATTI', 'Chennai', '10.6666389', '78.805232', '9003588204', 'siVacharankonDaVeeti@gmail.com', '9003588204', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2024949', 'Vennela', 'SilVer resIdency chennai', 'Chennai', '13.08784', '80.27847', '6303780859', 'Vennelapotla17@gmail.com', '7997911535', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2024950', 'Viharikha Thummalapally', 'SilVer resIdency, Chennai', 'chennai', '13.08784', '80.27847', '7901264981', 'Viharikha950@gmail.com', '9501264981', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025041', 'P.SAI KUMAR', 'SV PG AccommoDation ThiruVanmiyur, Chennai, Tamil NaDu 600041', 'Chennai', '12.9495', '80.2592', '9347145836', 'saikumarpattikayala@gmail.com', '9347145836', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025055', 'Venkata Sai', 'Plot no. 27, thiruVangaDam nagar 2nD Street, perunguDi, chennai', 'Chennai', '13.08784', '80.27847', '7337467988', 'DeVamaDhurikonDaVeti@gmail.com', '9959057702', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025084', 'Pooja K N', '2nD East Street kamarajnagar, thiruVanmiyur, chennai.', 'Chennai', '13.08784', '80.27847', '8317398381', 'poojakn1818@gmail.com', '9535309196', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025121', 'Sai SuDha Kiran', 'E147/1, LB RoaD, 5th W St, Kamaraj Nagar, ThiruVanmiyur, Chennai, Tamil NaDu 600041', 'Chennai', '13.08784', '80.27847', '8985919149', '2000030235cse@gmail.com', '9985466758', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025141', 'HARIBALAN S', 'X63V+QQP SVr luxury gents pg, Bethel Nagar, PerunguDi', 'Chennai', '13.08784', '80.27847', '9345368392', 'srs.haribalan2003@gmail.com', '6380555082', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025165', 'Nitisha ADDala', 'Flast-D,Four square coral apartment,Balamurugan garDens,thoraipakkam', 'Chennai', '13.08784', '80.27847', '9390278978', 'nitishanaIdu20@gmail.com', '9908158158', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025167', 'Mohamed Suhail Akram E', 'ThiruVanmiyur', 'Chennai', '12.9858948', '80.2644215', '9025305797', 'suhailakram2003@gmail.com', '6382042312', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025168', 'Nanmaran M', 'Velacherry', 'Chennai', '12.9832366', '80.217509', '8248516868', 'maaran1314@gmail.com', '9597011765', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025201', 'InfantDaisy P', 'PerunguDi', 'Chennai', '12.9710239', '80.2418051', '9976417775', 'Daisy18071998@gmail.com', '9976417775', 'female', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp'),
('VTS2025246', 'Arshik S', '88, Rajiv Gandhi Nagar , GetticheViyur RoaD , Nambiyur , 638458', 'Chennai', '11.3583', '77.321', '8248436235', 'arshik0404@gmail.com', '8015185744', 'male', 'https://res.clouDinary.com/Dhikrbq2f/image/uploaD/V1725894178/DD2pzbuitf9oprnlqarw.webp');


INSERT INTO EscortManagement (EscortName, EscortProfilePicUpload,ContactNumber, Age, AadharCardUpload, Address, CertificationUpload, AccountHandlerName, AccountNumber, BankName, IFSCCode, BranchName, ShiftStartTime, ShiftEndTime) 
VALUES 
('John Doe', 'https://example.com/profiles/johnDoe.jpg', '9876543210', 28, 'https://example.com/aaDhar/johnDoe.jpg', '123 Main St, City, State, Zip', 'https://example.com/certifications/johnDoe.jpg', 'Alice Smith', '9876543210123456', 'StanDarD Bank', 'SB0001234', 'Main Branch', 9,17),
('Jane Smith', 'https://example.com/profiles/janesmith.jpg', '8765432109', 32, 'https://example.com/aaDhar/janesmith.jpg', '456 Elm St, City, State, Zip', 'https://example.com/certifications/janesmith.jpg', 'Bob Johnson', '8765432109876543', 'Capital Bank', 'CB0005678', 'Downtown Branch', 6, 14),
('Michael Johnson', 'https://example.com/profiles/michaeljohnson.jpg', '7654321098', 40, 'https://example.com/aaDhar/michaeljohnson.jpg', '789 Oak St, City, State, Zip', 'https://example.com/certifications/michaeljohnson.jpg', 'Carol DaVis', '7654321098765432', 'Global Bank', 'GB0008765', 'Uptown Branch', 13, 22);