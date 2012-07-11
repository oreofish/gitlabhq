class WeeklyMail
  def self.perform
    Notify.weekly_email('fakeuser').deliver
  end
end
