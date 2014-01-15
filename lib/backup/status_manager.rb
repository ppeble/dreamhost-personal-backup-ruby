module DreamhostPersonalBackup

  module StatusManager

    PID_FILE = '~/.dreamhost_personal_backup/running.pid'

    def self.is_backup_running?
      pid_file = File.expand_path(PID_FILE)
      return false unless File.file?(pid_file)

      pid = File.open(pid_file).read.to_i

      begin
        Process.getpgid(pid)
        return true
      rescue Errno::ESRCH
        return false
      end
    end

    def self.create_pid_file
      File.open(File.expand_path(PID_FILE), "w") { |f| f.write(Process.pid) }
    end

    def self.remove_pid_file
      pid_file = File.expand_path(PID_FILE)
      File.delete(pid_file) if File.file?(pid_file)
    end

  end
end