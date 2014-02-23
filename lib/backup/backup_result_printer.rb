module DreamhostPersonalBackup

  class BackupResultPrinter

    def print(result)
      if result.success?
        if result.changes.count > 0
          DreamhostPersonalBackup.logger.info("  Results:")

          result.changes.each do |change|
            DreamhostPersonalBackup.logger.info("   #{change.summary} - #{change.filename}")
          end
        else
          DreamhostPersonalBackup.logger.info("  No changes took place!")
        end

        DreamhostPersonalBackup.logger.info("  Backup completed successfully")
      else
        DreamhostPersonalBackup.logger.error("  Backup failed, error: #{result.error}")
      end
    end

  end

end