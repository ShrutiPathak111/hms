// src/pages/PatientDashboard.jsx
import React from "react";
import Navbar from "../components/Navbar";
import Sidebar from "../components/Sidebar";
import DashboardCard from "../components/DashboardCard";
import Footer from "../components/Footer";
import "./PatientDashboard.css";

const PatientDashboard = () => {
  const upcoming = [{ id: 10, doctor: "Dr Meera", date: "2025-10-20", time: "09:15" }];

  return (
    <>
      <Navbar />
      <Sidebar role="Patient" />
      <div className="dashboard patient-dashboard">
        <h2>Patient Dashboard</h2>
        <div className="cards">
          <DashboardCard title="Upcoming Appts" value={upcoming.length} />
        </div>

        <table className="patient-table">
          <thead><tr><th>Doctor</th><th>Date</th><th>Time</th></tr></thead>
          <tbody>
            {upcoming.map(u => (<tr key={u.id}><td>{u.doctor}</td><td>{u.date}</td><td>{u.time}</td></tr>))}
          </tbody>
        </table>

        <Footer />
      </div>
    </>
  );
};

export default PatientDashboard;
