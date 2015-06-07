require_relative "../db/connection"
require_relative "user"
require_relative "comment"

class Topic
    

    def initialize(params={})
        @id = params["id"]
        @topic_creator_id = params["topic_creator_id"]
        @topic_title = params["topic_title"]
        @topic_subtitle = params["topic_subtitle"]
        @topic_created_date = params["topic_created_date"]
        @topic_karma = params["topic_karma"]
    end

    attr_reader :id
    attr_accessor :topic_creator_id, :topic_title, :topic_subtitle, :topic_created_date, :topic_karma

    def self.find_by_id(id)
        result = $db.exec_params("SELECT * FROM topics WHERE id=$1", [id]).first
        Topic.new(result)
    end

    def self.find_by_creator(creator_id)
        result = $db.exec_params("SELECT * FROM topics WHERE topic_creator_id=$1", [creator_id]).first
        Topic.new(result)
    end

    def clean_timestamp
        id = self.id
        result = $db.exec_params("SELECT to_char(topic_created_date, 'FMMonth Dth, YYYY') as formatted_time FROM topics WHERE id=$1", [id]).first['formatted_time']
        # Time.parse(result).strftime("%B %-d")
    end

    def self.list_all #!!!!USE ME!!!!!
        $db.exec("SELECT * FROM topics").map do |row| #could have been exec_params, too
            new row
        end
    end

    def self.create (attrs, c_user)
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
        topic_title = markdown.render(attrs[:topic_title])
        topic_subtitle = markdown.render(attrs[:topic_subtitle])
        result = $db.exec_params(
            "INSERT INTO topics (topic_title, topic_subtitle, topic_created_date, topic_creator_id)
            VALUES($1,$2,CURRENT_TIMESTAMP,$3) RETURNING *",
            [topic_title, topic_subtitle, c_user.id]).first
        Topic.new(result)
    end

    def karma_check
        id = self.id
        $db.exec_params("SELECT SUM(vote_value) FROM karma WHERE topic_id=$1", [id]).first['sum']
    end

    def comment_count
        id = self.id
        result = $db.exec_params("SELECT SUM(comment_counter) FROM comments WHERE parent_topic_id = $1", [id]).first['sum'].to_i
    end

    def creator
        id = self.topic_creator_id
        $db.exec_params("SELECT handle FROM users WHERE id = $1", [id]).first['handle']
    end


    def upvote(user_id)
        topic_id = self.id
            # check if current_user is a registered voter or this topic
        voter_registered = $db.exec_params(
            "SELECT EXISTS(
                SELECT vote_value FROM karma 
                WHERE topic_id = $1 and voter_id = $2)", 
            [topic_id, user_id]).first['exists']
        if voter_registered == "t"
            # update karma for topic to upvoted
            @new_karma = $db.exec_params(
                "UPDATE karma SET vote_value = '1' 
                WHERE topic_id = $1 and voter_id = $2 
                RETURNING vote_value", 
                [topic_id, user_id]).first['vote_value']
        elsif voter_registered == "f"
            # register voter AND update karma for topic
            @new_karma = $db.exec_params(
                "INSERT INTO karma (voter_id, topic_id, vote_value)
                VALUES ($1,$2,1)RETURNING vote_value",
                [user_id,topic_id]).first['vote_value']
        end
    end

    def downvote(user_id)
        topic_id = self.id
            # check if current_user is a registered voter or this topic
        voter_registered = $db.exec_params(
            "SELECT EXISTS(
                SELECT vote_value FROM karma 
                WHERE topic_id = $1 and voter_id = $2)", 
            [topic_id, user_id]).first['exists']
        if voter_registered == "t"
            # update karma for topic to upvoted
            @new_karma = $db.exec_params(
                "UPDATE karma SET vote_value = -1 
                WHERE topic_id = $1 and voter_id = $2 
                RETURNING vote_value", 
                [topic_id, user_id]).first['vote_value']
        else
            # register voter AND update karma for topic
            @new_karma = $db.exec_params(
                "INSERT INTO karma (voter_id, topic_id, vote_value)
                VALUES ($1,$2,-1)RETURNING vote_value",
                [user_id,topic_id]).first['vote_value']
        end
    end


    # def self.find_by_date(YMD)
    #     result = $db.exec_params("SELECT * FROM topics WHERE to_char(topic_created_date, 'YYYY_MM_DD')=$1", [YMD]).first
    #     Topic.new(result)
    # end

end #class Topic