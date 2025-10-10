-- ========================================================
-- 1. DATABASE CREATION
-- ========================================================
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE hospital_db;

-- ========================================================
-- 2. TABLES
-- ========================================================

-- PATIENT TABLE
CREATE TABLE PATIENT (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    age INT,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    contact_no BIGINT CHECK (contact_no BETWEEN 1000000000 AND 9999999999),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    medical_history BOOLEAN NOT NULL DEFAULT FALSE
);

-- Trigger: Calculate Age Before Insert
DELIMITER //
CREATE TRIGGER calc_age_before_insert
BEFORE INSERT ON PATIENT
FOR EACH ROW
BEGIN
    SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.dob, CURDATE());
END;
//
DELIMITER ;

-- Trigger: Calculate Age Before Update
DELIMITER //
CREATE TRIGGER calc_age_before_update
BEFORE UPDATE ON PATIENT
FOR EACH ROW
BEGIN
    SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.dob, CURDATE());
END;
//
DELIMITER ;

-- DEPARTMENT TABLE
CREATE TABLE DEPARTMENT (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- DOCTOR TABLE
CREATE TABLE DOCTOR (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_no BIGINT CHECK (contact_no BETWEEN 1000000000 AND 9999999999),
    email VARCHAR(100),
    qualification VARCHAR(100),
    specialization VARCHAR(100),
    years_experience INT DEFAULT 0,
    department_id INT,
    CONSTRAINT fk_doctor_dept FOREIGN KEY (department_id)
        REFERENCES DEPARTMENT(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- STAFF TABLE
CREATE TABLE STAFF (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    dob DATE NOT NULL,
    age INT,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    contact_no BIGINT CHECK (contact_no BETWEEN 1000000000 AND 9999999999),
    email VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    department VARCHAR(100),
    role VARCHAR(100),
    joining_date DATE,
    salary DECIMAL(12,2)
);

-- ROOM TABLE
CREATE TABLE ROOM (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL UNIQUE,
    room_type ENUM('General','Semi-Private','Private','ICU') DEFAULT 'General',
    rate DECIMAL(10,2) DEFAULT 0.00,
    availability BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MEDICINE TABLE
CREATE TABLE MEDICINE (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(150) NOT NULL,
    manufacturer VARCHAR(150),
    expiry DATE,
    quantity_avl INT DEFAULT 0,
    unit_price DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRESCRIPTION TABLE
CREATE TABLE PRESCRIPTION (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,
    date_issued DATE DEFAULT (CURRENT_DATE),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_patient FOREIGN KEY (patient_id)
        REFERENCES PATIENT(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (doctor_id)
        REFERENCES DOCTOR(doctor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- PRESCRIPTION_MEDICINES TABLE
CREATE TABLE PRESCRIPTION_MEDICINES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    qty INT NOT NULL DEFAULT 1,
    dosage VARCHAR(100),
    CONSTRAINT fk_pm_prescription FOREIGN KEY (prescription_id)
        REFERENCES PRESCRIPTION(prescription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pm_medicine FOREIGN KEY (medicine_id)
        REFERENCES MEDICINE(medicine_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- APPOINTMENT TABLE
CREATE TABLE APPOINTMENT (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('Scheduled','Completed','Cancelled','No-Show') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
        REFERENCES PATIENT(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id)
        REFERENCES DOCTOR(doctor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE KEY uq_doctor_slot (doctor_id, appointment_date, appointment_time)
);

-- Appointment Time Validation Trigger
DELIMITER $$
CREATE TRIGGER trg_appointment_time_check
BEFORE INSERT ON APPOINTMENT
FOR EACH ROW
BEGIN
    DECLARE hour_part INT;
    DECLARE minute_part INT;

    SET hour_part = HOUR(NEW.appointment_time);
    SET minute_part = MINUTE(NEW.appointment_time);

    IF NOT ((hour_part BETWEEN 8 AND 11) OR (hour_part BETWEEN 16 AND 19)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment time must be between 8 AM–12 PM or 4 PM–8 PM';
    END IF;

    IF (minute_part MOD 15) <> 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment time must be in 15-minute intervals (00, 15, 30, 45)';
    END IF;
END$$
DELIMITER ;

-- LAB_TEST TABLE
CREATE TABLE LAB_TEST (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    staff_id INT,
    test_name VARCHAR(150) NOT NULL,
    result TEXT,
    test_date DATE DEFAULT (CURRENT_DATE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_lab_patient FOREIGN KEY (patient_id)
        REFERENCES PATIENT(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_lab_staff FOREIGN KEY (staff_id)
        REFERENCES STAFF(staff_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- BILLING TABLE
CREATE TABLE BILLING (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    admission_date DATE,
    discharge_date DATE,
    appointment_charges DECIMAL(10,2) DEFAULT 0.00,
    ward_charges DECIMAL(10,2) DEFAULT 0.00,
    pharmacy_charges DECIMAL(10,2) DEFAULT 0.00,
    lab_charges DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(12,2) DEFAULT 0.00,
    payment_status ENUM('Pending','Paid','Partially Paid') DEFAULT 'Pending',
    room_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_billing_patient FOREIGN KEY (patient_id)
        REFERENCES PATIENT(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_billing_room FOREIGN KEY (room_id)
        REFERENCES ROOM(room_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- FEEDBACK TABLE
CREATE TABLE FEEDBACK (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    description TEXT,
    rating TINYINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_patient FOREIGN KEY (patient_id)
        REFERENCES PATIENT(patient_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ========================================================
-- 3. TRIGGERS
-- ========================================================

-- Trigger: Reduce Medicine Stock After Prescription
DELIMITER $$
CREATE TRIGGER trg_after_prescription_medicine_insert
AFTER INSERT ON PRESCRIPTION_MEDICINES
FOR EACH ROW
BEGIN
    UPDATE MEDICINE
    SET quantity_avl = GREATEST(0, quantity_avl - NEW.qty)
    WHERE medicine_id = NEW.medicine_id;

    IF (SELECT quantity_avl FROM MEDICINE WHERE medicine_id = NEW.medicine_id) < 5 THEN
        INSERT INTO STOCK_ALERTS (medicine_id, alert_message, alert_date)
        VALUES (NEW.medicine_id, 'Low stock: less than 5 units remaining', NOW());
    END IF;
END$$
DELIMITER ;

-- Trigger: Prevent Deletion of Doctor with Scheduled Appointments
DELIMITER $$
CREATE TRIGGER trg_before_doctor_delete
BEFORE DELETE ON DOCTOR
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM APPOINTMENT
        WHERE doctor_id = OLD.doctor_id
          AND appointment_date >= CURDATE()
          AND status = 'Scheduled'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete doctor with scheduled appointments';
    END IF;
END$$
DELIMITER ;

-- Trigger: Auto Compute Billing Total
DELIMITER $$
CREATE TRIGGER trg_before_billing_ins_upd
BEFORE INSERT ON BILLING
FOR EACH ROW
BEGIN
    IF NEW.total_amount IS NULL OR NEW.total_amount = 0 THEN
        SET NEW.total_amount = COALESCE(NEW.appointment_charges,0)
                             + COALESCE(NEW.ward_charges,0)
                             + COALESCE(NEW.pharmacy_charges,0)
                             + COALESCE(NEW.lab_charges,0);
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_before_billing_update
BEFORE UPDATE ON BILLING
FOR EACH ROW
BEGIN
    IF NEW.total_amount IS NULL OR NEW.total_amount = 0 THEN
        SET NEW.total_amount = COALESCE(NEW.appointment_charges,0)
                             + COALESCE(NEW.ward_charges,0)
                             + COALESCE(NEW.pharmacy_charges,0)
                             + COALESCE(NEW.lab_charges,0);
    END IF;
END$$
DELIMITER ;

-- Trigger: Update Room Availability on Admission
DELIMITER $$
CREATE TRIGGER trg_after_billing_insert
AFTER INSERT ON BILLING
FOR EACH ROW
BEGIN
    IF NEW.room_id IS NOT NULL THEN
        UPDATE ROOM
        SET availability = FALSE
        WHERE room_id = NEW.room_id;
    END IF;
END$$
DELIMITER ;

-- Trigger: Free Room After Discharge
DELIMITER $$
CREATE TRIGGER trg_after_billing_update_room_free
AFTER UPDATE ON BILLING
FOR EACH ROW
BEGIN
    IF OLD.discharge_date IS NULL AND NEW.discharge_date IS NOT NULL AND NEW.room_id IS NOT NULL THEN
        UPDATE ROOM
        SET availability = TRUE
        WHERE room_id = NEW.room_id;
    END IF;
END$$
DELIMITER ;

-- ========================================================
-- 4. STORED PROCEDURES & FUNCTIONS
-- ========================================================

-- Procedure: Calculate and Update Total Bill
DELIMITER $$
CREATE PROCEDURE sp_calc_and_update_total(IN in_bill_id INT)
BEGIN
    DECLARE a_charges DECIMAL(10,2);
    DECLARE w_charges DECIMAL(10,2);
    DECLARE p_charges DECIMAL(10,2);
    DECLARE l_charges DECIMAL(10,2);

    SELECT appointment_charges, ward_charges, pharmacy_charges, lab_charges
    INTO a_charges, w_charges, p_charges, l_charges
    FROM BILLING
    WHERE bill_id = in_bill_id;

    UPDATE BILLING
    SET total_amount = COALESCE(a_charges,0)
                     + COALESCE(w_charges,0)
                     + COALESCE(p_charges,0)
                     + COALESCE(l_charges,0)
    WHERE bill_id = in_bill_id;
END$$
DELIMITER ;

-- Procedure: Create Appointment
DELIMITER $$
CREATE PROCEDURE sp_create_appointment(
    IN in_patient_id INT,
    IN in_doctor_id INT,
    IN in_date DATE,
    IN in_time TIME,
    OUT out_status VARCHAR(50)
)
BEGIN
    DECLARE conflict_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO conflict_count
    FROM APPOINTMENT
    WHERE doctor_id = in_doctor_id
      AND appointment_date = in_date
      AND appointment_time = in_time
      AND status = 'Scheduled';

    IF conflict_count > 0 THEN
        SET out_status = 'Conflict - doctor not available at this time';
    ELSE
        INSERT INTO APPOINTMENT (patient_id, doctor_id, appointment_date, appointment_time, status)
        VALUES (in_patient_id, in_doctor_id, in_date, in_time, 'Scheduled');
        SET out_status = 'Appointment Scheduled';
    END IF;
END$$
DELIMITER ;

-- Procedure: Admit Patient
DELIMITER $$
CREATE PROCEDURE sp_admit_patient(
    IN in_patient_id INT,
    IN in_room_id INT,
    IN in_admission_date DATE,
    OUT out_bill_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET out_bill_id = -1;
    END;

    START TRANSACTION;

    INSERT INTO BILLING (patient_id, admission_date, room_id, ward_charges, payment_status)
    VALUES (
        in_patient_id,
        in_admission_date,
        in_room_id,
        (SELECT rate FROM ROOM WHERE room_id = in_room_id),
        'Pending'
    );

    SET out_bill_id = LAST_INSERT_ID();

    UPDATE ROOM
    SET availability = FALSE
    WHERE room_id = in_room_id;

    COMMIT;
END$$
DELIMITER ;

-- Function: Get Total Doctors in a Department
DELIMITER $$
CREATE FUNCTION fn_get_doctor_count(dept_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE dcount INT;
    SELECT COUNT(*) INTO dcount
    FROM DOCTOR
    WHERE department_id = dept_id AND is_active = TRUE;
    RETURN dcount;
END$$
DELIMITER ;

-- Function: Get Outstanding Amount for a Patient
DELIMITER $$
CREATE FUNCTION fn_get_outstanding_amount(p_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE outstanding DECIMAL(12,2);
    SELECT COALESCE(SUM(total_amount),0) INTO outstanding
    FROM BILLING
    WHERE patient_id = p_id AND payment_status <> 'Paid';
    RETURN outstanding;
END$$
DELIMITER ;
