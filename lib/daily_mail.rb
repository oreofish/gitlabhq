class DailyMail
  def self.perform
    Notify.daily_email('fakeuser').deliver
  end
end
