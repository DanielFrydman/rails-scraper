// api.js

import axios from 'axios';

function ApiClient() {
  const api = axios.create({
    baseURL: 'http://localhost:3000/v1'
  });

  return api;
}

export default ApiClient;
