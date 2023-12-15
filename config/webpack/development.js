process.env.NODE_ENV = process.env.NODE_ENV || 'development';

process.env.QRCODE_URL = 'http://0.0.0.0:3000/qr-code';

const environment = require('./environment');

module.exports = environment.toWebpackConfig();
