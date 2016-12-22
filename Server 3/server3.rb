require 'socket'                # Get sockets from stdlib
require 'csv'

def read_csv(filename)
	CSV.foreach(filename,headers: true) do |row|
		puts row['file_content']
	end
	return 
end
db_table='server3.csv'
server = TCPServer.open(3003)   # Socket to listen on port 2000
loop {                          # Servers run forever
	puts "Waiting..."
	client = server.accept

  	hello = (client.gets).chop
  	puts hello

  	if hello=="put_data" then
	  	email = (client.gets).chop
	  	file_name = (client.gets).chop
	  	file_contents = ""
	  	while true
	  		line=(client.gets).chop
	  		if line=="End" then
	  			break
	  		else
	  			file_contents=file_contents+line+"\n"
	  		end
	  	end
		client.puts( "Got it.")
		puts email,file_name,file_contents
	    client.close                # Disconnect from the client
	  	CSV.open(db_table,'a+') do |csv|
	  		# csv << ["animal","goat \n bakri","price"]
	  		csv << [email,file_name,file_contents]
	  	end
	elsif hello=="download_file_semi_join_original"
		email_column_values = ((client.gets).chop).split(',')
		filename_column_values = ((client.gets).chop).split(',')
		arr_of_arr_csv = CSV.read(db_table)
		rows_to_send = ""
		for i in 0..(arr_of_arr_csv.length-1)
			row = arr_of_arr_csv[i]
			email = row[0]
			filename = row[1]
			include_row = 0
			for j in 0..(email_column_values.length-1)
				if email==email_column_values[j] && filename==filename_column_values[j] then
					include_row = 1
					break
				end
			end
			str_row = email+','+filename+','+row[2]
			if include_row==1 then
				client.puts(str_row)
				client.puts('end_of_row')
			end
		end
		client.puts('end_of_all_rows')
		

		# puts s,s.class
		# require 'json'
		# arr = JSON.parse(s)
		# print arr,arr.class
	elsif hello=='download_file_bloom_join'
		k = 100
		bit_vector = ((client.gets).chop).split(',')
		print bit_vector,bit_vector.length
		arr_of_arr_csv = CSV.read(db_table)
		rows_to_send = ""
		for i in 0..(arr_of_arr_csv.length-1)
			row = arr_of_arr_csv[i]
			email = row[0]
			filename = row[1]
			include_row = 0

			str = email + filename
			hash_value = 0
			for j in 0..(str.length - 1)
				hash_value = hash_value + (j*(str[j]).ord)
			end
			hash_value = hash_value % k
			if bit_vector[hash_value]=='1' then
				include_row = 1
			end

			str_row = email+','+filename+','+row[2]
			if include_row==1 then
				client.puts(str_row)
				client.puts('end_of_row')
			end
			puts str_row
		end
		client.puts('end_of_all_rows')
		client.close	
	end

}