module UsersHelper

	def saved_jobs_key
		current_user.jobs.pluck(:job_key)
	end
end
