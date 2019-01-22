module.exports = ipv6discovery = {}

ipv6discovery.getInterfaces = ->
	os = require 'os'
	netInterfaces = os.networkInterfaces()
	delete netInterfaces.lo
	interfaces = new Set()
	for interfaceName,interfaceEntry of netInterfaces
		for entry in interfaceEntry
			if entry.family is 'IPv6'
				interfaces.add interfaceName
	Array.from interfaces

ipv6discovery.getLocalAddresses = ->
	os = require 'os'
	netInterfaces = os.networkInterfaces()
	delete netInterfaces.lo
	addresses = new Set()
	for interfaceName,interfaceEntry of netInterfaces
		for entry in interfaceEntry
			if entry.family is 'IPv6'
				addresses.add entry.address + '%' + interfaceName
	Array.from addresses

ipv6discovery.scanInterface = (int) ->
	child_process = require 'child_process'
	new Promise (resolve, reject) ->
		process = child_process.spawn '/bin/ping', ['-6bnr', '-c', '3', 'ff02::1%' + int]
		process.on 'exit', (code, signal) ->
			if code or signal
				console.error @stderr.read().toString()
				reject "Child process exited with non-zero status. code: #{code}, signal: #{signal}"
				return
			try
				output = @stdout.read().toString().split('\n').filter (str) => str.includes 'bytes from'
				hosts = new Set()
				localAddresses = ipv6discovery.getLocalAddresses()
				for str in output
					host = str.split(' ')[3]
					if host.endsWith ':'
						host = host.substring 0, host.length - 1
					if not localAddresses.includes host
						hosts.add host
				return resolve Array.from hosts
			catch error
				reject "Child process error: #{error.message}"
		process.on 'error', (error) ->
			reject "Child process error: #{error.message}"
