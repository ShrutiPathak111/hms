// src/components/Footer.jsx
import React from "react";
import "./Footer.css";

const Footer = () => {
  return (
    <footer className="app-footer">
      © {new Date().getFullYear()} Hospital Demo — for demo only
    </footer>
  );
};

export default Footer;
