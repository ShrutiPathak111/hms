// src/components/ProtectedRoute.jsx
import React from "react";
import { Navigate } from "react-router-dom";

/**
 * This demo uses localStorage 'user' object:
 *  { role: "Admin" | "Doctor" | "Patient", id: ... }
 */
const ProtectedRoute = ({ children, allowedRole }) => {
  const raw = localStorage.getItem("user");
  if (!raw) return <Navigate to="/" replace />;
  try {
    const user = JSON.parse(raw);
    if (allowedRole && user.role !== allowedRole) return <Navigate to="/" replace />;
    return children;
  } catch {
    return <Navigate to="/" replace />;
  }
};

export default ProtectedRoute;
