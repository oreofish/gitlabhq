class DailyMail
  def self.perform
    Notify.daily_email(User.find(13)).deliver
  end
end
