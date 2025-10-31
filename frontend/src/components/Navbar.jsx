// src/components/Navbar.jsx
import React from "react";
import "./Navbar.css";

const Navbar = ({ title = "Hospital Management System" }) => {
  return (
    <header className="navbar">
      <div className="navbar-left">🏥 {title}</div>
      <div className="navbar-right">Demo</div>
    </header>
  );
};

export default Navbar;
