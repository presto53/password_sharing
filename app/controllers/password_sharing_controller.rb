class PasswordSharingController < ApplicationController

  def index
    if params[:k]
      @key = params[:k]
      render :show
    end
  end

  def share
    default_password_size = 16
    if params[:generate]
      @password = generate_password(default_password_size)
    else
      @password = params[:password].to_s
    end

    @key = generate_key

    if Storage.create(:password => @password, :key => @key).save
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
        flash[:alert] = "Error: can't show password. Please, contact to system administrators."
        redirect_to(action: 'index')
      end
    else
      redirect_to(action: 'index')
    end
  end

  def generate_key
    key_size = 8
    symbol_pool="0123456789abcdefghigklmnopqrstuvwxyz#{'abcdefghigklmnopqrstuvwxyz'.upcase!}".split('')
    key = get_random_string(symbol_pool, key_size)
    if Storage.find_by_key(key)
      key = generate_key
    end
    key
  end

  def generate_password(password_size)
    symbol_pool=",/.'!@#\$_-(){}[]*&?^%+=:;0123456789abcdefghigklmnopqrstuvwxyz#{'abcdefghigklmnopqrstuvwxyz'.upcase!}".split('')
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
