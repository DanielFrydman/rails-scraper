// api.js

import axios from 'axios';

function ApiClient() {
  const baseURL = process.env.NODE_ENV === 'development'
    ? 'http://localhost:3000/v1'
    : 'https://rails-scraper.onrender.com/v1';

  const api = axios.create({
    baseURL: baseURL
  });

  return api;
}

export default ApiClient;
