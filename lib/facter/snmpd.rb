
pw_file = '/etc/snmp/reader.pw'

Facter.add("snmpd_reader_password") do
	setcode do
		File.open(pw_file).read rescue nil if File.exist?(pw_file)
	end
end
