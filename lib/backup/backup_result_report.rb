module DreamhostPersonalBackup

  class BackupResultReport

    def generate_for(result)
      raise ArgumentError, 'Result cannot be nil' if result.nil?

      result_report = Array.new

      if result.success?
        if result.changes.count > 0
          result_report << '  Results:'

          result.changes.each do |change|
            result_report << "   #{change.summary} - #{change.filename}"
          end
        else
          result_report << '  No changes took place!'
        end

        result_report << '  Backup completed successfully'
      else
        result_report << "  Backup failed, error: #{result.error}"
      end

      result_report.join("\n")
    end

  end

end