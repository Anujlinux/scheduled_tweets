class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :twitter_account

  validates :body, presence: true, length: {minimum: 2, maximum: 280}
  validates :publish_at, presence: true

  after_initialize do
    self.publish_at ||= 24.hours.from_now
  end

  after_save_commit do
    if publish_at_previously_changed?
      TweetJob.set(wait_until: publish_at).perform_later(self)
    end
  end

  def published?
    tweet_id?
  end

  def publish_to_twitter!
    req_body = '{"text":"'+ body+ '"}'
    post = twitter_account.client.post("tweets", req_body)
    update(tweet_id: post["data"]["id"])
  end
end
