class WeeklyMilestone
  def self.perform
    projects = Project.all

    # add next milestone "pgMMDD".
    next_end = Date.today.next_week.end_of_week
    next_mtitle = "pg#{next_end.strftime("%m%d")}"
    projects.each do |project|
      # auto add milestone
      thisweekmilestone = project.milestones.select{|m| m.title == next_mtitle }
      if thisweekmilestone.count == 0
        project.milestones.create(:title => next_mtitle,
                                  :description => 'Pending',
                                  :due_date => next_end.to_s
                                 )
      end
    end

    # auto add tag
    prev_end = Date.yesterday.end_of_week
    user = User.find_by_email('jianxing@redflag-linux.com')
    autotag = Gitlab::Tag.new(user)
    projects.each do |project|
      # auto add 
      autotag.push(project, 'master', "pg#{prev_end.strftime("%m%d")}")
    end
  end
end
