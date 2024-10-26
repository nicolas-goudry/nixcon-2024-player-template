import http from 'http';

const hostname = '0.0.0.0';
const port = 8080;

const server = http.createServer((req, res) => {
  console.log(req)
  if (req.url.startsWith('add')) {
    const a = req.url.split('/')[1]
    const b = req.url.split('/')[2]

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end(a + b);
  } else {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, World!');
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
