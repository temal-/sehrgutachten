namespace :papers do
  desc 'switch logger to stdout'
  task to_stdout: :environment do
    Rails.logger = Logger.new(STDOUT)
  end

  desc 'Import new papers'
  task :import_new, [:department] => [:environment] do |_t, args|
    department = Department.find_by_short_name(args[:department])
    Rails.logger.info "Adding job for importing new papers in [#{department.short_name}]"
    ImportNewPapersJob.perform_now(department)
  end

  desc 'Download new papers'
  task :download_new, [:department] => [:environment] do |_t, args|
    department = Department.find_by_short_name(args[:department])
    Rails.logger.info "Adding job for downloading new papers in [#{department.short_name}]"
    department.papers.where(downloaded_at: nil).find_each do |paper|
      DownloadPaperJob.perform_now(paper)
    end
  end
end
