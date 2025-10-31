// src/pages/LoginAdmin.jsx
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./Login.css";

const LoginAdmin = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = (e) => {
    e.preventDefault();
    // demo: store user in localStorage
    localStorage.setItem("user", JSON.stringify({ role: "Admin", id: 0, username }));
    navigate("/admin/dashboard");
  };

  return (
    <div className="login-container">
      <div className="login-box">
        <h2>Admin Login</h2>
        <form onSubmit={handleLogin}>
          <input value={username} onChange={e => setUsername(e.target.value)} placeholder="Username" />
          <input value={password} onChange={e => setPassword(e.target.value)} placeholder="Password" type="password" />
          <button className="btn" type="submit">Login</button>
        </form>
        <div className="login-links">
          <a href="/login/doctor">Doctor Login</a> | <a href="/login/patient">Patient Login</a>
        </div>
      </div>
    </div>
  );
};

export default LoginAdmin;
