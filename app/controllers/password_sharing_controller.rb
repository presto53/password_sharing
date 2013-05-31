class PasswordSharingController < ApplicationController

  def index
    if params[:k]
      @key = params[:k]
      render :show
    end
  end

  def share
    if APP_CONFIG['default_password_size']
      default_password_size = APP_CONFIG['default_password_size'].to_i
    else
      default_password_size = 16
    end
    type = []
    if params[:generate]
      if (1..255) === params[:password_length].to_i
        password_size = params[:password_length].to_i
      else
        password_size = default_password_size
      end
      type << :uppercase if params[:uppercase]
      type << :lowercase if params[:lowercase]
      type << :numbers if params[:numbers]
      type << :special if params[:special]
      @password = generate_password(password_size, type)
    else
      @password = params[:password].to_s
    end

    @key = generate_key

    if Storage.create(:password => @password, :key => @key).save
      PasswordSender.send_email(:message => params[:message], :url => "#{request.protocol}#{request.host_with_port}/?k=#{@key}", :to => params[:email]).deliver if /^.+@.+\..+$/.match(params[:email]) and params[:email_checkbox]
      render :show_link
    else
      flash[:alert] = "Error: can't save password."
      redirect_to(action: 'index')
    end
  end

  def show
    if params[:show] == 'yes'
      if Storage.find_by_key(params[:key])
        @password = Storage.find_by_key(params[:key])[:password]
        Storage.find_by_key(params[:key]).destroy
        render :show
      else
        redirect_to "#{request.protocol}#{request.host_with_port}/error.html"
      end
    else
      redirect_to(action: 'index')
    end
  end

  def generate_key
    key_size = 8
    symbol_pool="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')
    key = get_random_string(symbol_pool, key_size)
    if Storage.find_by_key(key)
      key = generate_key
    end
    key
  end

  def generate_password(password_size, type)
    symbol_pool = []
    symbol_pool << "ABCDEFGHIJKLMNOPQRSTUVWXYZ" if type.include?(:uppercase)
    symbol_pool << "abcdefghigklmnopqrstuvwxyz" if type.include?(:lowercase)
    symbol_pool << "0123456789" if type.include?(:numbers)
    symbol_pool << ",/.'!@#\$_-(){}[]*&?^%+=:;" if type.include?(:special)
    if symbol_pool.empty?
      symbol_pool << ",/.'!@#\$_-(){}[]*&?^%+=:;0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end
    symbol_pool = symbol_pool.join.split('')
    get_random_string(symbol_pool, password_size)
  end

  def get_random_string(pool, size)
    string = []
    size.times do
      string << pool[rand(max=pool.size)]
    end
    string.join
  end

end
