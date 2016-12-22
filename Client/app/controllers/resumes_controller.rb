require 'open-uri'
class ResumesController < ApplicationController
  def index
  	      @resumes = Resume.all
          
  end

  def new
  	      @resume = Resume.new
  end

  def create
      file = resume_params[:attachment]
      file_name = file.original_filename
      file_size = file.size #in bytes
      if file.respond_to?(:read)
        @file_contents = file.read
      elsif file.respond_to?(:path)
        @file_contents = File.read(file.path)
      else
        logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      end

   		@resume = Resume.new(resume_params)
        @resume.email = User.find(current_user.id).email
      if @resume.save
         redirect_to root_path, notice: "The resume #{file_name} has been uploaded."
      else
         render "new"
      end  	
      category = params['resume']['cat']
      if category !='machine recommendation' then
        object = Cat.new(:email => User.find(current_user.id).email, :filename => file_name, :cat => category)
        object.save
      else
        # RUN THE NAIVE BAYES CLASSIFIER

        stopwords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]

        # text processing
        all_text = @file_contents.gsub(/\W/, ' ')
        all_bag_of_words = all_text.split
        all_bag_of_words1 = []
        for word in all_bag_of_words
          all_bag_of_words1.push(word.downcase)
        end
        all_bag_of_words=all_bag_of_words1
        all_bag_of_words = all_bag_of_words - stopwords
        all_bag_of_words1 = []
        for word in all_bag_of_words
          all_bag_of_words1.push(word.stem)
        end
        all_bag_of_words=all_bag_of_words1    
        # print all_bag_of_words   
        #
        dict_all = {}
        for word in all_bag_of_words
          if dict_all.key?(word) then
            dict_all[word] = dict_all[word] + 1
          else
            dict_all[word] = 1
          end
        end  
        all_keys = dict_all.keys      
        
        str = ""
        File.open("art_trained.txt", "r") do |f|
          f.each_line do |line|
            str = str + line + " "
          end
        end    
        prob_words_given_arts = JSON.parse(str)
        str = ""
        File.open("politics_trained.txt", "r") do |f|
          f.each_line do |line|
            str = str + line + " "
          end
        end    
        prob_words_given_politics = JSON.parse(str) 
        str = ""
        File.open("fun_trained.txt", "r") do |f|
          f.each_line do |line|
            str = str + line + " "
          end
        end    
        prob_words_given_fun = JSON.parse(str)
        str = ""
        File.open("science_trained.txt", "r") do |f|
          f.each_line do |line|
            str = str + line + " "
          end
        end    
        prob_words_given_science = JSON.parse(str)         

        score_arts = 0.25
        score_science = 0.25
        score_fun = 0.25
        score_politics = 0.25
        for key in all_keys
          if prob_words_given_arts.key?(key) then
            # puts "here"
            score_arts=score_arts*prob_words_given_arts[key].to_f
            score_science=score_science*prob_words_given_science[key].to_f
            score_fun=score_fun*prob_words_given_fun[key].to_f
            score_politics=score_politics*prob_words_given_politics[key].to_f
          end
        end    
        array = [score_arts,score_science,score_politics,score_fun]
        max_index = array.each_with_index.max[1]
        if max_index==0 then
          category='arts'
        elsif max_index==1
           category='science'       
        elsif max_index==2
          category='politics'
        else
          category='entertainment'
        end

        puts "HAHAHA",array,category,"END..."
        object = Cat.new(:email => User.find(current_user.id).email, :filename => file_name, :cat => category)
        object.save
      end

        
      my_email = User.find(current_user.id).email
      @file_contents.force_encoding('UTF-8')
      # puts "LOL", @file_contents.encoding

      
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
        
      if file_size < 1000
        #store it on 1 server. ie. Server1
        # ServerOne.create(:email=> my_email, :filename=> file_name, :myfiledata=> @file_contents)
        hostname = server1_add
        port = 3001
        s = TCPSocket.open(hostname, port)
        s.puts("put_data")
        s.puts(my_email)
        s.puts(file_name)
        arr_contents = @file_contents.split('\n')
        for line in arr_contents
          s.puts(line)          
        end
        s.puts("End")
        server_says = s.gets
        puts server_says
        s.close               # Close the socket when done        
      else
        #divide the file into 4 parts. Store each part on each of the servers. i.e. Server1,2,3,4.
        each_size = @file_contents.length/4
        @file1 = @file_contents[0..(each_size-1)]
        @file2 = @file_contents[each_size..(2*each_size-1)]
        @file3 = @file_contents[(2*each_size)..(3*each_size-1)]
        @file4 = @file_contents[(3*each_size)..(@file_contents.length-1)]
        
        # ServerOne.create(:email=> my_email, :filename=> file_name, :myfiledata=> file1)
        hostname = server1_add
        port = 3001
        s = TCPSocket.open(hostname, port)
        s.puts("put_data")
        s.puts(my_email)
        s.puts(file_name)
        arr_contents = @file1.split('\n')
        for line in arr_contents
          s.puts(line)          
        end
        s.puts("End")
        server_says = s.gets
        puts server_says
        s.close        
        
        # ServerTwo.create(:email=> my_email, :filename=> file_name, :myfiledata=> file2)
        hostname = server2_add
        port = 3002
        s = TCPSocket.open(hostname, port)
        s.puts("put_data")
        s.puts(my_email)
        s.puts(file_name)
        arr_contents = @file2.split('\n')
        for line in arr_contents
          s.puts(line)          
        end
        s.puts("End")
        server_says = s.gets
        puts server_says
        s.close               # Close the socket when done        
        
        # ServerThree.create(:email=> my_email, :filename=> file_name, :myfiledata=> file3)
        hostname = server3_add
        port = 3003
        s = TCPSocket.open(hostname, port)
        s.puts("put_data")
        s.puts(my_email)
        s.puts(file_name)
        arr_contents = @file3.split('\n')
        for line in arr_contents
          s.puts(line)          
        end
        s.puts("End")
        server_says = s.gets
        puts server_says
        s.close               # Close the socket when done        

        # ServerFour.create(:email=> my_email, :filename=> file_name, :myfiledata=> file4)
        hostname = server4_add
        port = 3004
        s = TCPSocket.open(hostname, port)
        s.puts("put_data")
        s.puts(my_email)
        s.puts(file_name)
        arr_contents = @file4.split('\n')
        for line in arr_contents
          s.puts(line)          
        end
        s.puts("End")
        server_says = s.gets
        puts server_says
        s.close               # Close the socket when done                
      end
  end

  def parallel_semi_join
    array_url=(Resume.find(params[:id]).attachment_url).split("/")
    file_name = array_url[array_url.length-1]    
    my_email = User.find(current_user.id).email
    # 1. At Client, compute the projection of Files table(email,file_name) onto the join columns (in this case
    # just the email and file_name field), and ship this projection to the Servers.
    # 2. Each server computes the join with the join columns received and ships the results back to Client.
    # 3. The client then combines all the results and selects the row with email=user_email and file_name=required_file_name
    email_column_values = ""
    filename_column_values = ""
    @resumes = Resume.all
    @resumes.each do |resume|
      email_column_values=email_column_values+resume.email+','
      array_url=(resume.attachment_url).split("/")
      len=array_url.length
      filename_column_values=filename_column_values+array_url[len-1]+','
    end
    email_column_values=email_column_values.chop #remove last ','
    filename_column_values=filename_column_values.chop #remove last ','
    ##
    result1=""
    result2=""
    result3=""
    result4=""
    threads = []
    rows1=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    rows2=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    rows3=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    rows4=[] #[[email,filename,filecontent],[email,filename,filecontent]]


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


    start0 = Time.now
    threads << Thread.new {
      result1="ok"
      hostname = server1_add
      port = 3001
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_semi_join_original")
      s.puts(email_column_values)
      s.puts(filename_column_values)

      rows1=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows1.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close          
    }
    threads << Thread.new {
      result2="ok"
      hostname = server2_add
      port = 3002
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_semi_join_original")
      s.puts(email_column_values)
      s.puts(filename_column_values)

      rows2=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows2.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close        
    }
    threads << Thread.new {
      result3="ok"
      hostname = server3_add
      port = 3003
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_semi_join_original")
      s.puts(email_column_values)
      s.puts(filename_column_values)

      rows3=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows3.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close      
    }
    threads << Thread.new {
      result4="ok"
      hostname = server4_add
      port = 3004
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_semi_join_original")
      s.puts(email_column_values)
      s.puts(filename_column_values)

      rows4=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows4.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close         
    }
    threads.each &:join
    finish0=Time.now   
    puts result1,result2,result3,result4
    #####
    start1 = Time.now
    total = ""
    for r in rows1
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows2
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows3
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows4
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    finish1 = Time.now
    
    diff0=(finish0-start0)*1000
    diff1=(finish1-start1)*1000
    diff=diff0+diff1
    #####
    print "BEGIN",rows1,"end"   
    File.open('Downloads/'+file_name, 'w') do |f|
      f.write(total.force_encoding('UTF-8'))
    end
    flash[:notice] = "'#{file_name}' was downloaded successfully using PARALLELSEMI-JOIN!"
    flash[:notice1] = "COMMUNICATION TIME: #{diff0} ms. "
    flash[:notice2] = "COMPUTATION TIME: #{diff1} ms. "
    flash[:notice3] = "TOTAL TIME: #{diff} ms."      
    redirect_to user_path(User.find(current_user.id))
  end

  def download_file_semi_join_original
    array_url=(Resume.find(params[:id]).attachment_url).split("/")
    file_name = array_url[array_url.length-1]    
    my_email = User.find(current_user.id).email
    # 1. At Client, compute the projection of Files table(email,file_name) onto the join columns (in this case
    # just the email and file_name field), and ship this projection to the Servers.
    # 2. Each server computes the join with the join columns received and ships the results back to Client.
    # 3. The client then combines all the results and selects the row with email=user_email and file_name=required_file_name
    email_column_values = ""
    filename_column_values = ""
    @resumes = Resume.all
    @resumes.each do |resume|
      email_column_values=email_column_values+resume.email+','
      array_url=(resume.attachment_url).split("/")
      len=array_url.length
      filename_column_values=filename_column_values+array_url[len-1]+','
    end
    email_column_values=email_column_values.chop #remove last ','
    filename_column_values=filename_column_values.chop #remove last ','


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

    ##
    start0 = Time.now
    hostname = server1_add
    port = 3001
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_semi_join_original")
    s.puts(email_column_values)
    s.puts(filename_column_values)

    rows1=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows1.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close      
    ##
    hostname = server2_add
    port = 3002
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_semi_join_original")
    s.puts(email_column_values)
    s.puts(filename_column_values)

    rows2=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows2.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close  
    ##
    hostname = server3_add
    port = 3003
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_semi_join_original")
    s.puts(email_column_values)
    s.puts(filename_column_values)

    rows3=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows3.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close
    ##
    hostname = server4_add
    port = 3004
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_semi_join_original")
    s.puts(email_column_values)
    s.puts(filename_column_values)

    rows4=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows4.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close   
    finish0=Time.now                               
    #####
    start1 = Time.now
    total = ""
    for r in rows1
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows2
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows3
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows4
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    finish1 = Time.now
    
    diff0=(finish0-start0)*1000
    diff1=(finish1-start1)*1000
    diff=diff0+diff1
    #####
    print "BEGIN",rows1,"end"   
    File.open('Downloads/'+file_name, 'w') do |f|
      f.write(total.force_encoding('UTF-8'))
    end
    flash[:notice] = "'#{file_name}' was downloaded successfully using SEMI-JOIN!"
    flash[:notice1] = "COMMUNICATION TIME: #{diff0} ms. "
    flash[:notice2] = "COMPUTATION TIME: #{diff1} ms. "
    flash[:notice3] = "TOTAL TIME: #{diff} ms."  
    redirect_to user_path(User.find(current_user.id))
  end

  def parallel_bloom_join
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



    array_url=(Resume.find(params[:id]).attachment_url).split("/")
    file_name = array_url[array_url.length-1]    
    my_email = User.find(current_user.id).email
    #### calculating bit-vector
    k = 100
    bit_vector = []
    for i in 0..(k-1)
      bit_vector.push('0')
    end
    email_column_values = ""
    filename_column_values = ""
    @resumes = Resume.all
    @resumes.each do |resume|
      email_column_values=email_column_values+resume.email+','
      array_url=(resume.attachment_url).split("/")
      len=array_url.length
      filename_column_values=filename_column_values+array_url[len-1]+','
    end
    email_column_values=email_column_values.chop #remove last ','
    filename_column_values=filename_column_values.chop #remove last ','
    emails = email_column_values.split(',')
    filenames = filename_column_values.split(',')

    for i in 0..(emails.length - 1)
      email = emails[i]
      filename = filenames[i]
      str = email + filename
      hash_value = 0
      for j in 0..(str.length - 1)
        hash_value = hash_value + (j*str[j].ord)
      end
      hash_value = hash_value % k
      bit_vector[hash_value] = '1'
    end
    str_bit_vector = ""
    for b in bit_vector
      str_bit_vector=str_bit_vector+b+','
    end
    str_bit_vector=str_bit_vector.chop
    ##
    rows1=[]
    rows2=[]
    rows3=[]
    rows4=[]
    start0 = Time.now    
    threads = []
    threads << Thread.new {
      hostname = server1_add
      port = 3001
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_bloom_join")
      s.puts(str_bit_vector)

      rows1=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows1.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close      
    }
    threads << Thread.new {
      hostname = server2_add
      port = 3002
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_bloom_join")
      s.puts(str_bit_vector)

      rows2=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows2.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close  
    }
    threads << Thread.new {
      hostname = server3_add
      port = 3003
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_bloom_join")
      s.puts(str_bit_vector)

      rows3=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows3.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close    
    }
    threads << Thread.new {
      hostname = server4_add
      port = 3004
      s = TCPSocket.open(hostname, port)
      s.puts("download_file_bloom_join")
      s.puts(str_bit_vector)

      rows4=[] #[[email,filename,filecontent],[email,filename,filecontent]]
      r=""
      while true
        line=(s.gets).chop
        if line=="end_of_row" then
          rows4.push(r.split(','))
          r=""
        elsif line=="end_of_all_rows"
          break
        else
          r=r+line+"\n"
        end
      end    
      s.close             
    }
    threads.each &:join
    finish0=Time.now
    ##
    start1 = Time.now
    total = ""
    for r in rows1
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows2
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows3
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows4
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    finish1 = Time.now
    diff0=(finish0-start0)*1000
    diff1=(finish1-start1)*1000
    diff=diff0+diff1    

    print "BEGIN",rows1,"end"   
    File.open('Downloads/'+file_name, 'w') do |f|
      f.write(total.force_encoding('UTF-8'))
    end
    ####
    flash[:notice] = "'#{file_name}' was downloaded successfully using PARALLELBLOOM-JOIN!"
    flash[:notice1] = "COMMUNICATION TIME: #{diff0} ms. "
    flash[:notice2] = "COMPUTATION TIME: #{diff1} ms. "
    flash[:notice3] = "TOTAL TIME: #{diff} ms."      


    redirect_to user_path(User.find(current_user.id))
  end

  def download_file_bloom_join
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



    array_url=(Resume.find(params[:id]).attachment_url).split("/")
    file_name = array_url[array_url.length-1]    
    my_email = User.find(current_user.id).email
    #### calculating bit-vector
    k = 100
    bit_vector = []
    for i in 0..(k-1)
      bit_vector.push('0')
    end
    email_column_values = ""
    filename_column_values = ""
    @resumes = Resume.all
    @resumes.each do |resume|
      email_column_values=email_column_values+resume.email+','
      array_url=(resume.attachment_url).split("/")
      len=array_url.length
      filename_column_values=filename_column_values+array_url[len-1]+','
    end
    email_column_values=email_column_values.chop #remove last ','
    filename_column_values=filename_column_values.chop #remove last ','
    emails = email_column_values.split(',')
    filenames = filename_column_values.split(',')

    for i in 0..(emails.length - 1)
      email = emails[i]
      filename = filenames[i]
      str = email + filename
      hash_value = 0
      for j in 0..(str.length - 1)
        hash_value = hash_value + (j*str[j].ord)
      end
      hash_value = hash_value % k
      bit_vector[hash_value] = '1'
    end
    str_bit_vector = ""
    for b in bit_vector
      str_bit_vector=str_bit_vector+b+','
    end
    str_bit_vector=str_bit_vector.chop
    ##
    start0 = Time.now
    hostname = server1_add
    port = 3001
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_bloom_join")
    s.puts(str_bit_vector)

    rows1=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows1.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close      
    ##
    # start0 = Time.now
    hostname = server2_add
    port = 3002
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_bloom_join")
    s.puts(str_bit_vector)

    rows2=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows2.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close  
    ##
    # start0 = Time.now
    hostname = server3_add
    port = 3003
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_bloom_join")
    s.puts(str_bit_vector)

    rows3=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows3.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close    
    ##
    # start0 = Time.now
    hostname = server4_add
    port = 3004
    s = TCPSocket.open(hostname, port)
    s.puts("download_file_bloom_join")
    s.puts(str_bit_vector)

    rows4=[] #[[email,filename,filecontent],[email,filename,filecontent]]
    r=""
    while true
      line=(s.gets).chop
      if line=="end_of_row" then
        rows4.push(r.split(','))
        r=""
      elsif line=="end_of_all_rows"
        break
      else
        r=r+line+"\n"
      end
    end    
    s.close             
    finish0=Time.now
    ##
    start1 = Time.now
    total = ""
    for r in rows1
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows2
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows3
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    for r in rows4
      if my_email==r[0] then
        if file_name==r[1] then
          for i in 2..(r.length-1)
            total=total+r[i]+','
          end
          total=total.chop
          # break
        end
      end
    end
    finish1 = Time.now
    diff0=(finish0-start0)*1000
    diff1=(finish1-start1)*1000
    diff=diff0+diff1    

    print "BEGIN",rows1,"end"   
    File.open('Downloads/'+file_name, 'w') do |f|
      f.write(total.force_encoding('UTF-8'))
    end
    ####
    flash[:notice] = "'#{file_name}' was downloaded successfully using BLOOM-JOIN!"
    flash[:notice1] = "COMMUNICATION TIME: #{diff0} ms. "
    flash[:notice2] = "COMPUTATION TIME: #{diff1} ms. "
    flash[:notice3] = "TOTAL TIME: #{diff} ms."      
    redirect_to user_path(User.find(current_user.id))
  end

  def download_file
    start = Time.now
    url = Resume.find(params[:id]).attachment_url
    array_url=(Resume.find(params[:id]).attachment_url).split("/")
    file_name = array_url[array_url.length-1]    
    page_string=""
    open('http://localhost:3000'+url) do |f|
      page_string = f.read
    end
    puts "LOOOL",page_string,"LOLOLOL"
    File.open('Downloads/'+file_name, 'w') do |f|
      f.write(page_string.force_encoding('UTF-8'))
    end
    finish = Time.now
    lapse = (finish-start)*1000
    flash[:notice] = " #{file_name} downloaded successfully! TIME TAKEN: #{lapse} ms."  
    redirect_to resumes_path
  end

  def destroy
  	  @resume = Resume.find(params[:id])
      @resume.destroy
      redirect_to resumes_path, notice:  "The resume #{@resume.email} has been deleted."
  end

  private
      def resume_params
      params.require(:resume).permit(:email, :attachment)
   end
end
