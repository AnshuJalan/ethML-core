const level = require("level");

const db = level("../model_store");

db.put(1, "social.py", (err) => {
  if (!err) console.log("Success!");
  else console.log(err);
});
