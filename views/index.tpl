% include('header.tpl')
<div class="container">
	<h2>Active Leases</h2>
		<table class="table table-hover table-condensed sortable">
			<thead>
					<tr>
						<th class="col-sm-4" data-defaultsort="asc">Hostname</th>
						<th class="col-sm-2">IP</th>
						<th class="col-sm-2">Link Address</th>
						<th class="col-sm-2">Client Identifier</th>
						<th class="col-sm-4">Expires</th>
					</tr>
					</thead>
					<tbody>
							% for lease in leases:
							<tr>
								<td>
									% if lease['hostname'] == "*":
										None
									% elif lease['webui'] == True:
										% if lease['port'] == 80:
											<a href="http://{{lease['hostname']}}" target="_blank">
												{{lease['hostname']}}
											</a>
										% else:
											<a href="http://{{lease['hostname']}}:{{lease['port']}}" target="_blank">
													{{lease['hostname']}}
											</a>
										% end
									% else:
										{{lease['hostname']}}
									% end
								</td>
								<td>{{lease['ip']}}</td>
								<td>{{lease['linkAddr']}}</td>
								<td>{{lease['clientIdent']}}</td>
								<td>{{lease['expires']}}</td>
							</tr>
							% end
					</tbody>
		</table>

		% if staticHosts != []:
		<h2>Static Allocations</h2>
		<table class="table table-hover table-condensed sortable">
			<thead>
					<tr>
						<th class="col-sm-6" data-defaultsort="desc">IP</th>
						<th class="col-sm-6">Hostname</th>
					</tr>
					</thead>
					<tbody>
							% for static in staticHosts:
							<tr>
								<td>
									{{static['ip']}}
								</td>
								<td>{{static['hostname']}}</td>
							</tr>
							% end
					</tbody>
		</table>
		% end

		<small>Data is delayed, and cached for 5 minutes</small>
</div>
% include('footer.tpl')