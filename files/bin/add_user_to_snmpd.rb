#!/usr/bin/env ruby

user_pw_file	= '/etc/snmp/reader.pw'
conf_file		= '/etc/snmp/snmpd.conf'

snmpd_init		= '/etc/init.d/snmpd'

user = 'reader'

if File.exist? user_pw_file
	raise "Won't continue as #{user_pw_file} was found."
end

pass = rand(36**26).to_s(36)

# write user creation info
File.open(conf_file, 'a') do |conf|
	conf << "\ncreateUser #{user} SHA #{pass} AES\n"
end

# stop snmpd
puts %x{#{snmpd_init} restart}
if $?.exitstatus != 0
	raise "Restarting snmpd during step 1 failed."
end

# give it some time to create & flush the user
sleep 5

# snmpd had created the user, let's remove the user creation chunk now
File.open(conf_file, 'r+') do |conf|
	conf_str = conf.read
	conf_str.gsub!(/^createUser #{user}.*$/, '')

	conf.rewind
	conf.truncate(0)

	conf.print conf_str
end

puts %x{#{snmpd_init} restart}
if $?.exitstatus != 0
	raise "Restarting snmpd during step 2 failed."
end

# write out password
File.open(user_pw_file, 'w+', 0600) do |userpw|
	userpw << pass
end

# everything's ready
exit 0
