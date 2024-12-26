import uuid
import random
from datetime import datetime, timedelta

def generate_uuid():
    return str(uuid.uuid4())

def generate_timestamp(days=0):
    return (datetime.now() - timedelta(days=days)).isoformat(sep=' ', timespec='seconds')

countries = ["USA", "Canada", "UK", "Germany", "France"]
bits = ["https://bit.ly/xyz123", "https://bit.ly/abc456", "https://bit.ly/qwe789"]

def main():
    with open('test_data.sql', 'w') as f:
        # YouTube Channels
        channel_ids = [generate_uuid() for _ in range(20)]
        for channel_id in channel_ids:
            country = random.choice(countries)
            f.write(f"INSERT INTO youtube_channel (id, y_id, country, created_at) VALUES ('{channel_id}', '{generate_uuid()}', '{country}', '{generate_timestamp()}');\n")
        
        # YouTube Videos
        video_ids = []
        for channel_id in channel_ids:
            for _ in range(200):  # 200 videos per channel
                video_id = generate_uuid()
                video_ids.append(video_id)
                y_id = generate_uuid()
                budget_spend = random.randint(0, 10000)
                created_at = generate_timestamp(random.randint(0, 365))
                views_count = random.randint(0, 100000)
                likes_count = random.randint(0, 1000)
                comments_count = random.randint(0, 500)
                duration = random.randint(10, 120)
                f.write(f"INSERT INTO youtube_video (id, y_id, budget_spend, created_at, channel_id, views_count, likes_count, comments_count, duration) VALUES ('{video_id}', '{y_id}', {budget_spend}, '{created_at}', '{channel_id}', {views_count}, {likes_count}, {comments_count}, {duration});\n")
        
        # Bot
        bot_id = generate_uuid()
        f.write(f"INSERT INTO bot (id, telegram_id) VALUES ('{bot_id}', '123456789');\n")
        
        # Bot Messages
        for _ in range(50):  # 50 bot messages
            message_id = generate_uuid()
            telegram_id = generate_uuid()
            views_count = random.randint(0, 500)
            f.write(f"INSERT INTO bot_message (id, telegram_id, views_count, bot_id) VALUES ('{message_id}', '{telegram_id}', {views_count}, '{bot_id}');\n")

        # Ad Anchors
        ad_anchor_ids = []
        for video_id in video_ids:
            anchor_id = generate_uuid()
            ad_anchor_ids.append(anchor_id)
            bitly_url = random.choice(bits)
            clicks_count = random.randint(0, 5000)
            f.write(f"INSERT INTO ad_anchor (id, bitly_url, clicks_count, video_id, bot_id) VALUES ('{anchor_id}', '{bitly_url}', {clicks_count}, '{video_id}', '{bot_id}');\n")
        
        # Bot Users and Telegram Channels
        channel_telegram_ids = [f"channel_telegram_{i}" for i in range(5)]
        telegram_channel_ids = []
        
        for telegram_id in channel_telegram_ids:
            subscriber_price = random.randint(50, 5000)
            telegram_channel_id = generate_uuid()
            telegram_channel_ids.append(telegram_channel_id)
            f.write(f"INSERT INTO telegram_channel (id, telegram_id, subscription_price) VALUES ('{telegram_channel_id}', '{telegram_id}', {subscriber_price});\n")

        user_telegram_ids = [f"user_telegram_{i}" for i in range(200)]
        used_anchor_ids = set()
        for user_telegram_id in user_telegram_ids:
            bot_user_id = generate_uuid()
            created_at = generate_timestamp()
            
            anchor_id = random.choice(ad_anchor_ids)
            while anchor_id in used_anchor_ids:
                anchor_id = random.choice(ad_anchor_ids)
            used_anchor_ids.add(anchor_id)
            f.write(f"INSERT INTO bot_user (id, telegram_id, bot_id, created_at, anchor_id) VALUES ('{bot_user_id}', '{user_telegram_id}', '{bot_id}', '{created_at}', '{anchor_id}');\n")\
        
        for telegram_channel_id in telegram_channel_ids:
            from_date = generate_timestamp(30)
            to_date = generate_timestamp()
            subscription_id = generate_uuid()
            f.write(f"INSERT INTO telegram_subscription (id, bot_user_id, telegram_channel_id, from_date, to_date) VALUES ('{subscription_id}', '{bot_user_id}', '{telegram_channel_id}', '{from_date}', '{to_date}');\n")

if __name__ == '__main__':
    main()