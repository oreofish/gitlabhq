module Gitlab
  class Tag
    attr_accessor :user

    def initialize(user)
      self.user = user
    end

    def push(project, branch, tag)
      # reuse auto merge repo
      Grit::Git.with_timeout(100.seconds) do
        lock_file = File.join(Rails.root, "tmp", "merge_repo_#{project.path}.lock")

        File.open(lock_file, "w+") do |f|
          f.flock(File::LOCK_EX)

          unless project.satellite.exists?
            raise "You should run: rake gitlab:app:enable_automerge"
          end
          
          project.satellite.clear

          Dir.chdir(project.satellite.path) do
            merge_repo = Grit::Repo.new('.')
            merge_repo.git.sh "git reset --hard"
            merge_repo.git.sh "git fetch origin"
            merge_repo.git.sh "git config user.name \"#{user.name}\""
            merge_repo.git.sh "git config user.email \"#{user.email}\""
            merge_repo.git.sh "git checkout -b #{branch} origin/#{branch}"
            merge_repo.git.sh "git tag #{tag}"
            merge_repo.git.sh "git push --tags"
          end
        end
      end

    rescue Grit::Git::GitTimeout
      return false
    end
  end
end
