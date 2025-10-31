// src/App.jsx
import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";

import LoginAdmin from "./pages/LoginAdmin";
import LoginDoctor from "./pages/LoginDoctor";
import LoginPatient from "./pages/LoginPatient";
import AdminDashboard from "./pages/AdminDashboard";
import DoctorDashboard from "./pages/DoctorDashboard";
import PatientDashboard from "./pages/PatientDashboard";

const Home = () => (
  <div className="login-container">
    <div className="login-box">
      <h2>Choose Role</h2>
      <div style={{ display: "flex", gap: 8 }}>
        <Link to="/login/admin"><button className="btn">Admin</button></Link>
        <Link to="/login/doctor"><button className="btn">Doctor</button></Link>
        <Link to="/login/patient"><button className="btn">Patient</button></Link>
      </div>
    </div>
  </div>
);

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/login/admin" element={<LoginAdmin />} />
        <Route path="/login/doctor" element={<LoginDoctor />} />
        <Route path="/login/patient" element={<LoginPatient />} />
        <Route path="/admin/dashboard" element={<AdminDashboard />} />
        <Route path="/doctor/dashboard" element={<DoctorDashboard />} />
        <Route path="/patient/dashboard" element={<PatientDashboard />} />
      </Routes>
    </Router>
  );
}
