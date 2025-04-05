const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const app = express();
dotenv.config();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.send("Eternal Echo Backend is Live");
});

const uploadRoute = require("./routes/upload");
app.use("/api/upload", uploadRoute);

const transcribeRoute = require("./routes/transcribe");
app.use("/api/transcribe", transcribeRoute);

const sentimentRoute = require("./routes/sentiment");
app.use("/api/sentiment", sentimentRoute);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
