require_relative "../db/connection"
require_relative "user"
require_relative "topic"

class Comment
    
    def initialize(params={})
        @id = params["id"]
        @parent_topic_id = params["parent_topic_id"]
        @comment_creator_id = params["comment_creator_id"]
        @comment_content = params["comment_content"]
        @comment_created_date = params["comment_created_date"]
        @comment_karma = params["comment_karma"]
    end

    attr_reader :id
    attr_accessor :parent_topic_id, :comment_creator_id, :comment_content, :comment_created_date, :comment_karma

    def self.create (attrs, c_user)
        
        result = $db.exec_params(
            "INSERT INTO comments (parent_topic_id, comment_creator_id, comment_content, comment_created_date)
            VALUES($1,$2,$3,CURRENT_TIMESTAMP) RETURNING *",
            [attrs[:parent_topic_id], c_user.id, attrs[:comment_content]]).first
        Topic.new(result)
    end

    def self.find_by_topic_id(id)
        result = $db.exec_params("SELECT * FROM comments WHERE parent_topic_id=$1", [id]).map do |row|
            new row
        end
    end

end #class Comment


    ##METHODS COPIED FROM THE TOPIC CLASS
    # def self.find_by_id(id)
    #     result = $db.exec_params("SELECT * FROM topics WHERE id=$1", [id]).first
    #     Topic.new(result)
    # end

    # def self.find_by_creator(creator_id)
    #     result = $db.exec_params("SELECT * FROM topics WHERE topic_creator_id=$1", [creator_id]).first
    #     Topic.new(result)
    # end

    # def clean_timestamp
    #     id = self.id
    #     result = $db.exec_params("SELECT to_char(topic_created_date, 'FMMonth Dth, YYYY') as formatted_time FROM topics WHERE id=$1", [id]).first['formatted_time']
    #     # Time.parse(result).strftime("%B %-d")
    # end

    # def self.list_all #!!!!USE ME!!!!!
    #     $db.exec("SELECT * FROM topics").map do |row| #could have been exec_params, too
    #         new row
    #     end
    # end


    # # def self.find_by_date(YMD)
    # #     result = $db.exec_params("SELECT * FROM topics WHERE to_char(topic_created_date, 'YYYY_MM_DD')=$1", [YMD]).first
    # #     Topic.new(result)
    # # end
