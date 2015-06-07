require_relative "../db/connection"

class User
    def initialize(params={})
        @id = params["id"]
        @fname = params["fname"].capitalize
        @lname = params["lname"].capitalize
        @handle = params["handle"]
        @email = params["email"]
        @password = params["password"]
        @date_joined = params["date_joined"]
        @is_admin = params["is_admin"]
        @user_karma = params["user_karma"]
    end

    attr_reader :id, :password, :is_admin, :date_joined
    attr_accessor :fname, :lname, :handle, :email, :user_karma

    def self.find_by_id(id)
        result = $db.exec_params("SELECT * FROM users WHERE id=$1", [id]).first
        User.new(result)
    end

    def self.find_by_email(email)
        result = $db.exec_params("SELECT * FROM users WHERE email=$1", [email]).first
        if result
          User.new(result)
        end
    end

end