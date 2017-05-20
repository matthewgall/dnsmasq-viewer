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
										<a href="http://{{lease['hostname']}}" target="_blank">{{lease['hostname']}}</a>
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
		<small>Data delayed by 5 minutes</small>
</div>
% include('footer.tpl')