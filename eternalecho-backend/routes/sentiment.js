const express = require("express");
const { OpenAI } = require("openai");
const router = express.Router();
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

router.post("/", async (req, res) => {
  try {
    const { text } = req.body;

    const completion = await openai.chat.completions.create({
      model: "gpt-4", // or "gpt-3.5-turbo"
      messages: [
        { role: "system", content: "You are an emotion analyzer." },
        { role: "user", content: `Analyze the emotion in this message: ${text}` },
      ],
    });

    const sentiment = completion.choices[0].message.content;
    res.status(200).json({ sentiment });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Sentiment analysis failed" });
  }
});

module.exports = router;
