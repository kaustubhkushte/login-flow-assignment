export function toUserPayload(user) {
  return {
    _id: user._id.toString(),
    name: user.name,
    email: user.email
  };
}
