import express from "express";
import cors from "cors";

import { zing } from "./index";

const app = express();

app.use(cors());

app.get("/", (_req, res) => {
    res.send("Zing MP3 API Running");
});

app.get("/api/chart-home", async (_req, res) => {
    try {
        const data = await zing.get_home_chart();
        res.json(data);
    } catch (error) {
        res.status(500).json(error);
    }
});

app.get("/api/song", async (req, res) => {
    try {
        const id = req.query.id as string;

        const data = await zing.get_song(id);

        res.json(data);
    } catch (error) {
        res.status(500).json(error);
    }
});

app.get('/api/lyric', async (req, res) => {

  try {

    const id = req.query.id as string;

    const data = await zing.get_song_lyric(id);

    res.json(data);

  } catch (error) {

    res.status(500).json(error);
  }
});

const PORT = 3000;

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});