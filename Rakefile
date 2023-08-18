require_relative "config/application"

Rails.application.load_tasks

desc "Fastly cache purge"
task fastly_cache_purge: :environment do
  api_instance = Fastly::PurgeApi.new
  opts = {
    service_id: ENV['FASTLY_SERVICE_ID'],
    fastly_soft_purge: 1
  }

  begin
    result = api_instance.purge_all(opts)
    p result
  rescue Fastly::ApiError => e
    Rails.logger.error("Exception when calling PurgeApi->purge_all: #{e}")
  end
end

desc "code theme seed"
task code_theme_seed: :environment do
  data = YAML.load_file(Rails.root.join('db', 'seeds', 'code_themes.yaml'))
  CodeTheme.create(data)
end

desc "Index search"
task index_search: :environment do
  Post.reindex!
end
