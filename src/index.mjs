import http from 'http';

const hostname = '0.0.0.0';
const port = 8080;

const server = http.createServer((req, res) => {
  console.log(req)
  if (req.url.startsWith('/add')) {
    const a = req.url.split('/')[2]
    const b = req.url.split('/')[3]

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end((parseInt(a) + parseInt(b)).toString());
  } else if (req.url.startsWith('/mult')) {
    const a = req.url.split('/')[2]
    const b = req.url.split('/')[3]

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end((parseInt(a) * parseInt(b)).toString());
  } else if (req.url === '/uuid') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('697a898b-d28e-4264-bd77-d8d09e7e45cd');
  } else {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, World!');
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
