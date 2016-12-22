require 'mechanize'
require 'logger'
require 'socket' 
require 'json'
require 'rubygems'
require 'fast_stemmer' 

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @latitude = request.location.latitude
    @longitude = request.location.longitude
    @geo_localization = "#{@latitude},#{@longitude}"
    query = Geocoder.search(@geo_localization).first

    @full_address = "query.address"
    @client_ip = request.location.ip

    # @client_ip = request.location.address
    puts "BEGIN.",request.remote_ip,"END............"
  end

  def location_page
    @latitude = request.location.latitude
    @longitude = request.location.longitude
    @geo_localization = "#{@latitude},#{@longitude}"
    query = Geocoder.search(@geo_localization).first

    @full_address = query.address
    @client_ip = request.location.ip

    # @client_ip = request.location.address
    puts "BEGIN.",request.remote_ip,"END............"
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user=User.find(current_user.id)
  end

  def face_book
    fbemail = Facebook.find_by(email: User.find(current_user.id).email)
    fbpass = Facebook.find_by(email: User.find(current_user.id).email)
    if fbemail!=nil then
      fbemail = fbemail.fbemail
    else
      fbemail = ''
    end
    if fbpass!=nil then
      fbpass = fbpass.fbpass
    end

    @website = 'https://www.facebook.com/login.php?login_attempt=1&lwv=110' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
    agent.user_agent_alias = 'Mac Safari'
    agent.follow_meta_refresh = true
    agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.first 
    email_field = login_form.field_with(name: "email")
    password_field = login_form.field_with(name: "pass")  
    email_field.value = fbemail
    password_field.value = fbpass
    home_page = login_form.click_button
    @blah = agent.get("https://m.facebook.com/")
  end

  def google
    redirect_to 'https://google.com'
  end
  def yahoo
    redirect_to 'https://yahoo.com'
  end

  def twitter
    fbemail = Twitter.find_by(email: User.find(current_user.id).email)
    fbpass = Twitter.find_by(email: User.find(current_user.id).email)
    if fbemail!=nil then
      fbemail = fbemail.twitteremail
    else
      fbemail = ''
    end
    if fbpass!=nil then
      fbpass = fbpass.twitterpass
    end


    @website = 'https://twitter.com/login' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.second 
    email_field = login_form.field_with(name: "session[username_or_email]")
    password_field = login_form.field_with(name: "session[password]")  
    email_field.value = fbemail
    password_field.value = fbpass
    home_page = login_form.click_button
    @blah = agent.get("https://twitter.com/")
    # puts "BEGIN...",button,"END..."
  end

  def stack_overflow
    @website = 'https://stackoverflow.com/users/login' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.second 
    email_field = login_form.field_with(name: "email")
    password_field = login_form.field_with(name: "password")  
    email_field.value = ''
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://stackoverflow.com/")
    # puts "BEGIN...",button,"END..."
  end

  def github
    @website = 'https://stackoverflow.com/users/login' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.second 
    email_field = login_form.field_with(name: "email")
    password_field = login_form.field_with(name: "password")  
    email_field.value = ''
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://stackoverflow.com/")
    # puts "BEGIN...",button,"END..."
  end  

  def linkedin
    @website = 'https://stackoverflow.com/users/login' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.second 
    email_field = login_form.field_with(name: "email")
    password_field = login_form.field_with(name: "password")  
    email_field.value = ''
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://stackoverflow.com/")
    # puts "BEGIN...",button,"END..."
  end    

  def g_mail
    fbemail = Gmail.find_by(email: User.find(current_user.id).email)
    fbpass = Gmail.find_by(email: User.find(current_user.id).email)
    if fbemail!=nil then
      fbemail = fbemail.gmailemail
    else
      fbemail = ''
    end
    if fbpass!=nil then
      fbpass = fbpass.gmailpass
    end


    @website = 'https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#identifier' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.first 
    email_field = login_form.field_with(name: "Email")
    email_field.value = fbemail
    login_page = login_form.click_button
    # login_page  = agent.get ("https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#password")
    login_form = login_page.forms.first
    password_field = login_form.field_with(name: "Passwd")  
    password_field.value = fbpass
    home_page = login_form.click_button
    @blah = agent.get("https://mail.google.com/mail/u/0/h/xhur4t66hu4s/")
    # puts "BEGIN...",button,"END..."
  end  

  def googleplus

    @website = 'https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#identifier' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.first 
    email_field = login_form.field_with(name: "Email")
    email_field.value = 'razahuss10'
    login_page = login_form.click_button
    # login_page  = agent.get ("https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#password")
    login_form = login_page.forms.first
    password_field = login_form.field_with(name: "Passwd")  
    password_field.value = 'Lums@123'
    home_page = login_form.click_button
    @blah = agent.get("https://plus.google.com/")
    # puts "BEGIN...",button,"END..."
  end  

  def bayes_train
    stopwords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]

    all_text = ""
    arts_text = ""
    fun_text = ""
    politics_text = ""
    science_text = ""
    for i in 1..10
      File.open("training_data/art"+i.to_s+".txt", "r") do |f|
        f.each_line do |line|
          all_text = all_text + line + " "
          arts_text = arts_text + line + " "
        end
      end      
    end
    for i in 1..10
      File.open("training_data/fun"+i.to_s+".txt", "r") do |f|
        f.each_line do |line|
          all_text = all_text + line + " "
          fun_text = fun_text + line + " "
        end
      end      
    end    
    for i in 1..10
      File.open("training_data/politics"+i.to_s+".txt", "r") do |f|
        f.each_line do |line|
          all_text = all_text + line + " "
          politics_text = politics_text + line + " "
        end
      end      
    end
    for i in 1..10
      File.open("training_data/science"+i.to_s+".txt", "r") do |f|
        f.each_line do |line|
          all_text = all_text + line + " "
          science_text = science_text + line + " "
        end
      end      
    end    
# text processing
    all_text = all_text.gsub(/\W/, ' ')
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
    arts_text = arts_text.gsub(/\W/, ' ')
    arts_bag_of_words = arts_text.split
    arts_bag_of_words1 = []
    for word in arts_bag_of_words
      arts_bag_of_words1.push(word.downcase)
    end
    arts_bag_of_words=arts_bag_of_words1
    arts_bag_of_words = arts_bag_of_words - stopwords
    arts_bag_of_words1 = []
    for word in arts_bag_of_words
      arts_bag_of_words1.push(word.stem)
    end
    arts_bag_of_words=arts_bag_of_words1    
    # print arts_bag_of_words        
    #
    science_text = science_text.gsub(/\W/, ' ')
    science_bag_of_words = science_text.split
    science_bag_of_words1 = []
    for word in science_bag_of_words
      science_bag_of_words1.push(word.downcase)
    end
    science_bag_of_words=science_bag_of_words1
    science_bag_of_words = science_bag_of_words - stopwords
    science_bag_of_words1 = []
    for word in science_bag_of_words
      science_bag_of_words1.push(word.stem)
    end
    science_bag_of_words=science_bag_of_words1    
    # print science_bag_of_words     
    #
    fun_text = fun_text.gsub(/\W/, ' ')
    fun_bag_of_words = fun_text.split
    fun_bag_of_words1 = []
    for word in fun_bag_of_words
      fun_bag_of_words1.push(word.downcase)
    end
    fun_bag_of_words=fun_bag_of_words1
    fun_bag_of_words = fun_bag_of_words - stopwords
    fun_bag_of_words1 = []
    for word in fun_bag_of_words
      fun_bag_of_words1.push(word.stem)
    end
    fun_bag_of_words=fun_bag_of_words1    
    # print fun_bag_of_words   
    #   
    politics_text = politics_text.gsub(/\W/, ' ')
    politics_bag_of_words = politics_text.split
    politics_bag_of_words1 = []
    for word in politics_bag_of_words
      politics_bag_of_words1.push(word.downcase)
    end
    politics_bag_of_words=politics_bag_of_words1
    politics_bag_of_words = politics_bag_of_words - stopwords
    politics_bag_of_words1 = []
    for word in politics_bag_of_words
      politics_bag_of_words1.push(word.stem)
    end
    politics_bag_of_words=politics_bag_of_words1    
    # print politics_bag_of_words   
    #       
    ### training bayes
    dict_all = {}
    dict_arts = {}
    dict_fun = {}
    dict_politics = {}
    dict_science = {}
    for word in arts_bag_of_words
      if dict_arts.key?(word) then
        dict_arts[word] = dict_arts[word] + 1
      else
        dict_arts[word] = 1
      end
    end
    for word in fun_bag_of_words
      if dict_fun.key?(word) then
        dict_fun[word] = dict_fun[word] + 1
      else
        dict_fun[word] = 1
      end
    end
    for word in politics_bag_of_words
      if dict_politics.key?(word) then
        dict_politics[word] = dict_politics[word] + 1
      else
        dict_politics[word] = 1
      end
    end
    for word in science_bag_of_words
      if dict_science.key?(word) then
        dict_science[word] = dict_science[word] + 1
      else
        dict_science[word] = 1
      end
    end
    for word in all_bag_of_words
      if dict_all.key?(word) then
        dict_all[word] = dict_all[word] + 1
      else
        dict_all[word] = 1
      end
    end
    ##
    prob_arts = 0.25
    prob_science = 0.25
    prob_fun = 0.25
    prob_politics = 0.25
    ## 
    prob_words_given_art = {}
    prob_words_given_science = {}
    prob_words_given_fun = {}
    prob_words_given_politics = {}

    all_keys = dict_all.keys
    size_vocab = all_keys.length

    total_words_in_class = 0
    for word in dict_arts.keys
      total_words_in_class=total_words_in_class+dict_arts[word]
    end
    for word in all_keys
      if dict_arts.key?(word) then
        prob_words_given_art[word] = "%f" % ((dict_arts[word]+1).to_f/(total_words_in_class+size_vocab))
      else
        prob_words_given_art[word] = "%f" % ((0+1).to_f/(total_words_in_class+size_vocab))
      end
    end
    total_words_in_class = 0
    for word in dict_science.keys
      total_words_in_class=total_words_in_class+dict_science[word]
    end
    for word in all_keys
      if dict_science.key?(word) then
        prob_words_given_science[word] = "%f" % ((dict_science[word]+1).to_f/(total_words_in_class+size_vocab))
      else
        prob_words_given_science[word] = "%f" % ((0+1).to_f/(total_words_in_class+size_vocab))
      end
    end
    total_words_in_class = 0
    for word in dict_fun.keys
      total_words_in_class=total_words_in_class+dict_fun[word]
    end
    for word in all_keys
      if dict_fun.key?(word) then
        prob_words_given_fun[word] = "%f" % ((dict_fun[word]+1).to_f/(total_words_in_class+size_vocab))
      else
        prob_words_given_fun[word] = "%f" % ((0+1).to_f/(total_words_in_class+size_vocab))
      end
    end
    total_words_in_class = 0
    for word in dict_politics.keys
      total_words_in_class=total_words_in_class+dict_politics[word]
    end
    for word in all_keys
      if dict_politics.key?(word) then
        prob_words_given_politics[word] = "%f" % ((dict_politics[word]+1).to_f/(total_words_in_class+size_vocab))
      else
        prob_words_given_politics[word] = "%f" % ((0+1).to_f/(total_words_in_class+size_vocab))
      end
    end
    print prob_words_given_art
    puts "------------------\n\n\n\n"

    str = prob_words_given_art.to_s.gsub("=>", ":")
    File.open("art_trained.txt", 'w') { |file| file.write(str) }
    str = prob_words_given_politics.to_s.gsub("=>", ":")
    File.open("politics_trained.txt", 'w') { |file| file.write(str) }
    str = prob_words_given_fun.to_s.gsub("=>", ":")
    File.open("fun_trained.txt", 'w') { |file| file.write(str) }
    str = prob_words_given_science.to_s.gsub("=>", ":")
    File.open("science_trained.txt", 'w') { |file| file.write(str) }

    redirect_to user_path(User.find(current_user.id))
  end

  def udp 
    hostname = '131.96.131.76'
    port = 2002
    s = TCPSocket.open(hostname, port)
    s.puts("Hello from Client")
    server_says = s.gets
    puts server_says
    s.close               # Close the socket when done
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if (User.find_by(email: user_params[:email]))==nil then
      respond_to do |format|
        if @user.save
          log_in @user
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to signup_path
    end
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
