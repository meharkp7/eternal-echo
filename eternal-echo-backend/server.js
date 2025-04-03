require('dotenv').config();
const express = require('express');
const multer = require('multer');
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const FormData = require('form-data'); 
const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = './uploads';
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir);
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    }
});
const upload = multer({ storage });

// 🎙️ Whisper API - Speech-to-Text
const transcribeAudio = async (filePath) => {
    const openaiApiKey = process.env.OPENAI_API_KEY;
    const audioFile = fs.createReadStream(filePath);

    const formData = new FormData();
    formData.append('file', audioFile);
    formData.append('model', 'whisper-1');

    try {
        const response = await axios.post('https://api.openai.com/v1/audio/transcriptions', formData, {
            headers: {
                Authorization: `Bearer ${openaiApiKey}`,
                ...formData.getHeaders()
            }
        });
        return response.data.text;
    } catch (error) {
        console.error('🚨 Error in Whisper API:', error.response?.data || error.message);
        throw new Error('Speech-to-text conversion failed');
    }
};

const analyzeSentiment = async (text) => {
    const openaiApiKey = process.env.OPENAI_API_KEY;

    try {
        const response = await axios.post(
            'https://api.openai.com/v1/chat/completions',
            {
                model: 'gpt-4',
                messages: [
                    { role: 'system', content: 'Analyze the sentiment and predict future implications.' },
                    { role: 'user', content: text }
                ]
            },
            { headers: { Authorization: `Bearer ${openaiApiKey}`, 'Content-Type': 'application/json' } }
        );
        return response.data.choices[0].message.content.trim();
    } catch (error) {
        console.error('🚨 Error in GPT-4:', error.response?.data || error.message);
        throw new Error('Sentiment analysis failed');
    }
};

const cloneVoice = async (text) => {
    const elevenLabsApiKey = process.env.ELEVENLABS_API_KEY;

    try {
        const response = await axios.post(
            'https://api.elevenlabs.io/v1/text-to-speech',
            { text },
            { headers: { 'xi-api-key': elevenLabsApiKey, 'Content-Type': 'application/json' } }
        );

        if (response.data && response.data.audio_url) {
            return response.data.audio_url;
        } else {
            throw new Error('Invalid response from ElevenLabs API');
        }
    } catch (error) {
        console.error('🚨 Error in ElevenLabs API:', error.response?.data || error.message);
        throw new Error('Voice cloning failed');
    }
};

app.post('/process-audio', upload.single('audio'), async (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'No audio file uploaded' });
    }

    const filePath = path.resolve(req.file.path);

    try {
        const text = await transcribeAudio(filePath);
        const sentiment = await analyzeSentiment(text);
        const clonedVoiceUrl = await cloneVoice(text);

        res.json({ text, sentiment, clonedVoiceUrl });
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        fs.unlink(filePath, (err) => {
            if (err) console.error('Failed to delete file:', err);
        });
    }
});

app.get('/', (req, res) => {
    res.send('🚀 Eternal Echo Backend is Running...');
});

app.listen(PORT, () => {
    console.log(`✅ Server running on port ${PORT}`);
});