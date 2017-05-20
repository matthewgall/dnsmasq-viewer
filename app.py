#!/usr/bin/env python

import sys, os, logging, json, datetime, time, re, socket
from bottle import route, request, response, redirect, hook, error, default_app, view, static_file, template, HTTPError
from beaker.cache import CacheManager
from beaker.util import parse_cache_config_options

def display_time(timestamp):
	return datetime.datetime.fromtimestamp(
		int(timestamp)
	).strftime('%d/%m/%Y %H:%M:%S')

def fetch(path=os.getenv('DNSMASQ_LEASES', '/var/lib/misc/dnsmasq.leases')):
	with open(path, 'r') as f:
		data = []
		for line in f.readlines():
			line = line.strip().split(' ')

			webui = False
			ports = [80, 8080, 8081, 8888]
			i = 0
			while webui == False and i < len(ports):
				for port in ports:
					try:
						s = socket.socket()
						s.settimeout(1)
						s.connect((line[3], port))
						webui = True
						s.close()
						break
					except:
						pass
					i = i + 1

			data.append({
				'expires': display_time(int(line[0])),
				'linkAddr': line[1],
				'ip': line[2],
				'hostname': line[3],
				'clientIdent': line[4],
				'webui': webui,
				'port': port
			})
		return data

def fetch_static(path=os.getenv('DNSMASQ_STATIC', '')):
	if path == '':
		return []
	else:
		data = []
		for file in path.split(','):	
			with open(file, 'r') as f:
				for line in f.readlines():
					line = re.split('\t|\s', re.sub(' +',' ', line))
					data.append({
						'ip': line[0],
						'hostname': line[1].strip(),
					})
		return data

@route('/static/<filepath:path>')
def server_static(filepath):
	return static_file(filepath, root='views/static')
	
@route('/')
def index():
	results = cache.get(key='leases', createfunc=fetch)
	staticHosts = cache.get(key='static', createfunc=fetch_static)
	return template('index', leases=results, staticHosts=staticHosts)

if __name__ == '__main__':
	app = default_app()

	cache_opts = {
		'cache.type': 'file',
		'cache.data_dir': 'cache/data',
		'cache.lock_dir': 'cache/lock'
	}
	cacheMgr = CacheManager(**parse_cache_config_options(cache_opts))
	cache = cacheMgr.get_cache('data')

	serverHost = os.getenv('IP', 'localhost')
	serverPort = os.getenv('PORT', '5000')

	# Now we're ready, so start the server
	# Instantiate the logger
	log = logging.getLogger('log')
	console = logging.StreamHandler()
	log.setLevel(logging.INFO)
	log.addHandler(console)

	# Now we're ready, so start the server
	try:
		app.run(host=serverHost, port=serverPort, server='tornado')
	except:
		log.error("Failed to start application server")