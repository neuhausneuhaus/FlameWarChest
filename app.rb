require_relative "db/connection"
require_relative "models/user"
require_relative "models/topic"
require_relative "models/comment"

# https://github.com/ryanto/acts_as_votable


module App
  class Server < Sinatra::Base
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    # =====Setup==========================================
    enable :sessions #keeps state during requests.   !!!?Same as 'set :sessions, true'
    enable :method_override #_method to put/delete forms in browsers that don't support it.
    configure :development do
      register Sinatra::Reloader
    end


    # =====Vars_&_Methods==========================================
      def current_user
        if session[:current_user]
          User.find_by_id(session[:current_user])
        end
      end

      def logged_in?
        !!current_user #same as !current_user.nil?
      end
    

    # =====Validation===============================================
      # Login validation
        before do
          
          if request.path_info=="/login" || request.path_info=="/"
            pass
          elsif logged_in?
            pass
          else
            @message = "You must Log in to do that."
            erb :login
            redirect '/login'
          end
        end

      # Admin validation


    
    # =====Routes==========================================
      # -- test --
        get('/test') do
          binding.pry
          erb :test
        end

      # -- root --
        get('/') do
            #if not loggedin
          redirect '/login'
            #else erb :topics
        end
      
      # -- login --
        get('/login') do
          erb :login
        end

        post('/login') do
          @user = User.find_by_email(params[:email])
          
          if @user && params[:password]==@user.password
            session[:current_user]=@user.id
            redirect '/topics'
          else
            @message = "gofuckyourself"
            erb :login
          end 
        end
      # -- /user/:id --
        get '/user/:id' do
          @user = User.find_by_id(params[:id])
          erb :profile
        end
      # -- /users --
        get '/users' do
          @users = $db.exec_params("SELECT * FROM users")
          erb :user_list
        end

      # -- /topic views --
        get '/topics' do
          @topics = Topic.list_all
          erb :topics
        end

        get '/topics/:id' do
          @topic = Topic.find_by_id(params[:id])
          @topic_creator = User.find_by_id(@topic.topic_creator_id)
          @topic_comments = Comment.find_by_topic_id(params[:id])
          erb :convo
        end

      # -- topic and comment POSTs --
        post '/topics' do
          @topic = Topic.create(params, current_user)
          topic_url = "/topics/#{@topic.id}"
          redirect topic_url
        end

        post '/comments' do
          @comment = Comment.create(params, current_user)
        
          topic_url = "/topics/#{params[:parent_topic_id]}"
          redirect topic_url

        end

        # -- vote button posts --
        post '/upvote/:id'do
          @topic = Topic.find_by_id(params[:id])
          @topic.upvote(current_user.id)
          @topics = Topic.list_all
          erb :topics
        end

        post '/downvote/:id'do
          @topic = Topic.find_by_id(params[:id])
          @topic.downvote(current_user.id)
          @topics = Topic.list_all
          erb :topics
        end

    # ====================================================

  end #Server class
end #Module App