// routes/ai.js
const express = require('express');
const multer = require('multer');
const { transcribeWithWhisper } = require('../utils/whisper');
const { cloneVoice } = require('../utils/elevenlabs');

const router = express.Router();
const upload = multer({ dest: 'uploads/' }); // Save files temporarily

// Route: Transcribe and (optionally) clone voice
router.post('/transcribe', upload.single('file'), async (req, res) => {
  try {
    const filePath = req.file.path;

    const transcription = await transcribeWithWhisper(filePath);

    const clonedAudioURL = await cloneVoice(transcription);

    res.json({
      transcription,
      voiceURL: clonedAudioURL
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to process file' });
  }
});

module.exports = router;
