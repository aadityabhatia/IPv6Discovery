# IPv6 Discovery
Discovers IPv6 nodes on the local area network (LAN) using multicast ping

## Installation
```
npm install ipv6discovery
```

## Example
```js
const ipv6discovery = require("ipv6discovery");
interfaces = ipv6discovery.getInterfaces();
ipv6discovery
    .scanInterface(interfaces[0])
    .then(console.log)
    .catch(console.error);
```

## Usage
- `getInterfaces()`: lists all IPv6 configured network interfaces
- `getLocalAddresses()`: lists all IPv6 addresses configured on local interfaces
- `scanInterface(interface)`: scans a network interface for IPv6 nodes and returns link local addresses using [Promises](https://developer.mozilla.org/docs/Web/JavaScript/Guide/Using_promises).

## Note
 This module relies on the `ping` program on Linux. Windows is currently not supported. Other platforms were not tested. Pull requests are welcome.
