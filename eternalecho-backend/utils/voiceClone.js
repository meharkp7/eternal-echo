// utils/voiceClone.js
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const cloneVoice = async (text) => {
  const voiceID = 'EXAVITQu4vr4xnSDxMaL'; // Use a default voice or your own custom one

  const response = await axios.post(
    `https://api.elevenlabs.io/v1/text-to-speech/${voiceID}`,
    {
      text,
      voice_settings: {
        stability: 0.5,
        similarity_boost: 0.5
      }
    },
    {
      headers: {
        'xi-api-key': process.env.ELEVENLABS_API_KEY,
        'Content-Type': 'application/json'
      },
      responseType: 'arraybuffer'
    }
  );

  const audioPath = path.join(__dirname, `../uploads/${uuidv4()}.mp3`);
  fs.writeFileSync(audioPath, response.data);

  return audioPath; // return local file path or upload to S3/CDN if needed
};

module.exports = { cloneVoice };