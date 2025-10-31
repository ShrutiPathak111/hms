// src/pages/LoginPatient.jsx
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./Login.css";

const LoginPatient = () => {
  const [patientId, setPatientId] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = (e) => {
    e.preventDefault();
    localStorage.setItem("user", JSON.stringify({ role: "Patient", id: patientId }));
    navigate("/patient/dashboard");
  };

  return (
    <div className="login-container">
      <div className="login-box">
        <h2>Patient Login</h2>
        <form onSubmit={handleLogin}>
          <input value={patientId} onChange={e => setPatientId(e.target.value)} placeholder="Patient ID" />
          <input value={password} onChange={e => setPassword(e.target.value)} placeholder="Password" type="password" />
          <button className="btn" type="submit">Login</button>
        </form>
        <div className="login-links">
          <a href="/login/doctor">Doctor Login</a> | <a href="/login/admin">Admin Login</a>
        </div>
      </div>
    </div>
  );
};

export default LoginPatient;
