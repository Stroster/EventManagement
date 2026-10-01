-- Create Database
CREATE DATABASE MiniTrackDB;
GO

USE MiniTrackDB;
GO

-- User Table
CREATE TABLE [User]
(
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'Member',
    CONSTRAINT CK_User_Role
        CHECK (Role IN ('Admin', 'Member'))
);
GO

-- Session Table
CREATE TABLE Session
(
    SessionId INT IDENTITY(1,1) PRIMARY KEY,
    Topic NVARCHAR(100) NOT NULL,
    SessionDate DATE NOT NULL,
    CreatedByUserId INT NOT NULL,

    CONSTRAINT FK_Session_User
        FOREIGN KEY (CreatedByUserId)
        REFERENCES UserId
);
GO

-- Attendance Table
CREATE TABLE Attendance
(
    AttendanceId INT IDENTITY(1,1) PRIMARY KEY,
    SessionId INT NOT NULL,
    UserId INT NOT NULL,
    CheckInTime DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Attendance_Session
        FOREIGN KEY (SessionId)
        REFERENCES Session(SessionId)
        ON DELETE CASCADE,

    CONSTRAINT FK_Attendance_User
        FOREIGN KEY (UserId)
        REFERENCES UserId
);
GO

-- Seed Users
INSERT INTO [User]
(FullName, Email, PasswordHash, Role)
VALUES
('Thabo Nkosi', 'thabo@minitrack.com', 'AQAAAAEAACcQ...hash1', 'Admin'),
('Aisha Patel', 'aisha@minitrack.com', 'AQAAAAEAACcQ...hash2', 'Member'),
('Sipho Dlamini', 'sipho@minitrack.com', 'AQAAAAEAACcQ...hash3', 'Member');
GO

-- Seed Sessions
INSERT INTO Session
(Topic, SessionDate, CreatedByUserId)
VALUES
('Intro to Git', '2026-08-03', 1),
('C# Delegates Workshop', '2026-08-10', 1);
GO

-- Seed Attendance
INSERT INTO Attendance
(SessionId, UserId)
VALUES
(1, 2),
(1, 3),
(2, 2);
GO

-- Admin Dashboard Query
SELECT
    s.SessionId,
    s.Topic,
    s.SessionDate,
    COUNT(a.AttendanceId) AS TotalAttendees
FROM Session s
LEFT JOIN Attendance a
    ON s.SessionId = a.SessionId
GROUP BY
    s.SessionId,
    s.Topic,
    s.SessionDate;
GO