export function notFoundHandler(req, res) {
  res.status(404).json({ message: "Route not found." });
}

export function errorHandler(error, req, res, next) {
  if (res.headersSent) {
    return next(error);
  }

  if (error?.code === 11000) {
    return res.status(409).json({
      message: "An account with this email already exists.",
      errors: [{ field: "email", message: "Email is already registered." }]
    });
  }

  return res.status(error.statusCode || 500).json({
    message: error.message || "Unexpected server error.",
    ...(error.details ? { errors: error.details } : {})
  });
}
