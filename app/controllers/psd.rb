Psdgo::App.controllers :psd do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index do
    @paths = []
    pwd = Dir.pwd
    Dir.chdir(self.class.psd_folder)
    begin      
      Dir.glob("**/*.psd").each do|path|
        @paths << path
      end
    ensure
      Dir.chdir(pwd)
    end
    render 'index'
  end  

  get :info do
    begin
      @layer_names = []
      filepath = "#{self.class.psd_folder}/#{params[:path]}"  
      if File.file?(filepath)  
        PSD.open(filepath) do|psd|  
          psd.layers.each do|layer|
            @layer_names << layer.name 
          end
        end
        render 'info'
      else
        halt 404, "PSD File(#{filepath}) Not Exists"
      end
    rescue Exception => e
      halt 400, e.message
    end
  end
  
  get :preview, :provides => [:any] do
    begin
      # "6-buttons.psd"
      filepath = "#{self.class.psd_folder}/#{params[:path]}"  
      if File.file?(filepath)        
        PSD.open(filepath) do|psd|  
          #psd.image.methods.each do|m|
          #  puts "#{m} => #{psd.image.method(m).source_location}"
          #end 
          layer = psd.layers.detect{|layer| layer.name == params[:layer]}
          layer.image.__send__("to_#{params[:format]}").to_blob
        end
      else
        halt 404, "PSD File(#{filepath}) Not Exists"
      end
    rescue Exception => e
      puts e.message
      halt 400, e.message
    end
  end

end
