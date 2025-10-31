// src/pages/AdminDashboard.jsx
import React from "react";
import Navbar from "../components/Navbar";
import Sidebar from "../components/Sidebar";
import DashboardCard from "../components/DashboardCard";
import Footer from "../components/Footer";
import "./AdminDashboard.css";

const AdminDashboard = () => {
  // demo numbers
  const stats = { doctors: 12, patients: 240, revenue: "₹1,25,000" };

  return (
    <>
      <Navbar />
      <Sidebar role="Admin" />
      <div className="dashboard admin-dashboard">
        <h2>Admin Dashboard</h2>
        <div className="cards">
          <DashboardCard title="Doctors" value={stats.doctors} />
          <DashboardCard title="Patients" value={stats.patients} />
          <DashboardCard title="Revenue" value={stats.revenue} />
        </div>
        <p>Welcome Admin. Use the sidebar to manage the system.</p>
        <Footer />
      </div>
    </>
  );
};

export default AdminDashboard;
