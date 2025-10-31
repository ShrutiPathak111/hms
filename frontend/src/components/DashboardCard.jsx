// src/components/DashboardCard.jsx
import React from "react";
import "./DashboardCard.css";

const DashboardCard = ({ title, value }) => {
  return (
    <div className="dash-card">
      <div className="dash-card-title">{title}</div>
      <div className="dash-card-value">{value}</div>
    </div>
  );
};

export default DashboardCard;
