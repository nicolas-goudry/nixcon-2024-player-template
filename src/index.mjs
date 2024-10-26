import http from 'http';
import cp from 'child_process';

const hostname = '0.0.0.0';
const port = 8080;

console.log(process.argv)
const server = http.createServer((req, res) => {
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
  } else if (req.url.startsWith('/cowsay')) {
    const exec = cp.exec;
    exec(`${process.argv[2]} ${decodeURIComponent(req.url.split('/')[2])}`, (err, stdout, stderr) => {
      res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
      res.end(stdout);
    });
  } else {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, World!');
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
