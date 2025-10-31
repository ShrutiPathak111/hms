// src/pages/DoctorDashboard.jsx
import React from "react";
import Navbar from "../components/Navbar";
import Sidebar from "../components/Sidebar";
import DashboardCard from "../components/DashboardCard";
import Footer from "../components/Footer";
import "./DoctorDashboard.css";

const DoctorDashboard = () => {
  const appointments = [
    { id: 1, patient: "Anita Sharma", date: "2025-10-17", time: "09:15" },
    { id: 2, patient: "Rohan Patel", date: "2025-10-18", time: "10:00" },
  ];

  return (
    <>
      <Navbar />
      <Sidebar role="Doctor" />
      <div className="dashboard doctor-dashboard">
        <h2>Doctor Dashboard</h2>
        <div className="cards">
          <DashboardCard title="Today Appointments" value={appointments.length} />
        </div>

        <table className="appointments-table">
          <thead>
            <tr><th>Patient</th><th>Date</th><th>Time</th></tr>
          </thead>
          <tbody>
            {appointments.map(a => (
              <tr key={a.id}><td>{a.patient}</td><td>{a.date}</td><td>{a.time}</td></tr>
            ))}
          </tbody>
        </table>

        <Footer />
      </div>
    </>
  );
};

export default DoctorDashboard;
