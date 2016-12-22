server1_add = ""
server2_add = ""
server3_add = ""
server4_add = ""
File.foreach('server_adds.txt').with_index do |line, line_num|
  # puts "#{line_num}: #{line}"
  if line_num==0 then
    server1_add = line
  elsif line_num==1
    server2_add = line
  elsif line_num==2
    server3_add = line
  elsif line_num==3
    server4_add = line
  end
end
server1_add = server1_add.gsub("\n",'')
server2_add = server2_add.gsub("\n",'')
server3_add = server3_add.gsub("\n",'')
server4_add = server4_add.gsub("\n",'')
# print server1_add
print "-",server1_add,"-\n"
print "-",server2_add,"-\n"
print "-",server3_add,"-\n"
print "-",server4_add,"-\n"