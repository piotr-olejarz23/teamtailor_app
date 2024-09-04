class CandidatesFetcher
  extend ::Performable

  CSV_HEADERS = %i[candidate_id first_name last_name email job_application_id job_application_created_at].freeze

  def perform
    fetch_data_and_save_to_csv
  end

  private

  def fetch_data_and_save_to_csv
    CSV.generate(headers: true, **options) do |csv|
      csv << CSV_HEADERS
      page = 1
      while (response = fetch_page(page))
        process_and_save_data(response, csv)
        page += 1
      end
    end
  end

  def process_and_save_data(response, csv)
    candidates = response['data']
    job_applications = response['included'] || []

    candidates.each do |candidate|
      csv << candidate_data(candidate, job_applications)
    end
  end

  def candidate_data(candidate, job_applications)
    candidate_id = candidate['id']
    first_name = candidate.dig('attributes', 'first-name')
    last_name = candidate.dig('attributes', 'last-name')
    email = candidate.dig('attributes', 'email')

    job_application = fetch_job_application(candidate, job_applications)
    job_application_id = job_application&.fetch('id')
    job_application_created_at = job_application&.dig('attributes', 'created-at')

    [candidate_id, first_name, last_name, email, job_application_id, job_application_created_at]
  end

  def fetch_page(page)
    response = teamtailor_client.fetch_candidates_with_jobs(params(page))
    response.dig('links', 'next').present? ? response : nil
  end


  def fetch_job_application(candidate, job_applications)
    job_application_id = candidate.dig('relationships', 'job-applications', 'data').first&.dig('id')
    job_applications.find { |job| job['id'] == job_application_id }
  end

  def options
  { col_sep: ';', encoding: 'utf-8' }
  end

  def params(page_number)
    {
    'page[number]': page_number,
    'include': 'job-applications',
    'fields[job-applications]': 'id, created-at'
    }
  end

  def teamtailor_client
    @teamtailor_client ||= Teamtailor::Client.instance
  end
end
