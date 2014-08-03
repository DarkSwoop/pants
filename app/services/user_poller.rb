class UserPoller < Service
  def perform
    users_to_poll.each do |user|
      logger.info "Polling #{user.domain}"

      UserFetcher.perform(user.url)
      if posts = user.poll!
        logger.info "Received #{posts.size} post(s) from #{user.domain}."
      else
        logger.warn "Polling #{user.domain} failed. :("
      end
    end
  end

  private

  def users_to_poll
    User.can_be_polled.order('Random()').first(10)
  end
end
