// src/pages/LoginDoctor.jsx
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./Login.css";

const LoginDoctor = () => {
  const [doctorId, setDoctorId] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = (e) => {
    e.preventDefault();
    localStorage.setItem("user", JSON.stringify({ role: "Doctor", id: doctorId }));
    navigate("/doctor/dashboard");
  };

  return (
    <div className="login-container">
      <div className="login-box">
        <h2>Doctor Login</h2>
        <form onSubmit={handleLogin}>
          <input value={doctorId} onChange={e => setDoctorId(e.target.value)} placeholder="Doctor ID" />
          <input value={password} onChange={e => setPassword(e.target.value)} placeholder="Password" type="password" />
          <button className="btn" type="submit">Login</button>
        </form>
        <div className="login-links">
          <a href="/login/admin">Admin Login</a> | <a href="/login/patient">Patient Login</a>
        </div>
      </div>
    </div>
  );
};

export default LoginDoctor;
