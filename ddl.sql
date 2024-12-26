CREATE TABLE youtube_channel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    y_id  VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'UNKNOWN',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE youtube_video (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    y_id  VARCHAR(100) NOT NULL,
    budget_spend  INT CHECK (budget_spend >= 0) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    channel_id UUID NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES youtube_channel (id),
    views_count  INT CHECK (views_count >= 0) DEFAULT NULL,
    likes_count  INT CHECK (likes_count >= 0) DEFAULT NULL,
    comments_count  INT CHECK (comments_count >= 0) DEFAULT NULL,
    duration  INT CHECK (duration >= 0) DEFAULT NULL
);

CREATE TABLE bot (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    telegram_id VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE ad_anchor (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bitly_url VARCHAR(255) NOT NULL,
    clicks_count INT NOT NULL CHECK (clicks_count >= 0) DEFAULT 0,
    video_id UUID UNIQUE,
    FOREIGN KEY (video_id) REFERENCES youtube_video (id),
    bot_id UUID NOT NULL,
    FOREIGN KEY (bot_id) REFERENCES bot (id)
);


CREATE TABLE bot_user (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    telegram_id VARCHAR(100) NOT NULL UNIQUE,
    bot_id UUID NOT NULL,
    FOREIGN KEY (bot_id) REFERENCES bot (id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    anchor_id UUID NOT NULL UNIQUE,
    FOREIGN KEY (anchor_id) REFERENCES ad_anchor (id)
);



CREATE TABLE bot_message (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    telegram_id VARCHAR(100) NOT NULL UNIQUE,
    views_count INT CHECK (views_count >= 0) DEFAULT NULL,
    bot_id UUID NOT NULL,
    FOREIGN KEY (bot_id) REFERENCES bot (id)
);


CREATE TABLE telegram_channel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    telegram_id VARCHAR(100) NOT NULL UNIQUE,
    subscription_price INT CHECK (subscription_price >= 0) DEFAULT NULL
);


CREATE TABLE telegram_subscription (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bot_user_id UUID NOT NULL,
    FOREIGN KEY (bot_user_id) REFERENCES bot_user (id) ON DELETE CASCADE,
    telegram_channel_id UUID NOT NULL,
    FOREIGN KEY (telegram_channel_id) REFERENCES telegram_channel (id) ON DELETE CASCADE, 
    from_date DATE NOT NULL DEFAULT NOW(),
    to_date DATE NOT NULL DEFAULT NOW() + INTERVAL '30 DAY'
);



-- update video metrics such as views, likes, and comments_counts, ensuring that no negative values are set.
CREATE PROCEDURE update_video_metrics(video_uuid UUID, new_views INT, new_likes INT, new_comments INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF new_views >= 0 AND new_likes >= 0 AND new_comments >= 0 THEN
        UPDATE youtube_video
        SET views_count = new_views,
            likes_count = new_likes,
            comments_count = new_comments
        WHERE id = video_uuid;
    ELSE
        RAISE EXCEPTION 'Views, likes, and comments must not be negative';
    END IF;
END;
$$;

-- call update_video_metrics(uuid, 123, 123, 123);




-- automatically checks if the subscription has expired each time data is fetched from telegram_subscription
CREATE FUNCTION check_subscription_validity()
RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
BEGIN
   IF NEW.to_date < CURRENT_DATE THEN
       RAISE NOTICE 'Updated subscription has already expired.';
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_check_subscription 
AFTER UPDATE ON telegram_subscription 
FOR EACH ROW
WHEN (OLD.to_date IS DISTINCT FROM NEW.to_date)  
EXECUTE PROCEDURE check_subscription_validity();