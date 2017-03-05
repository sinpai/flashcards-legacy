module ApplicationHelper
  def flickr_image_url(item)
    farm = "farm#{item['farm']}"
    server_id = item['server']
    photo_id = item['id']
    secret = item['secret']
    size = "m"

    "https://#{farm}.staticflickr.com/#{server_id}/#{photo_id}_#{secret}_#{size}.jpg"
  end

  def track_user_creation
    identify
    track('Create User')
  end

  def track_user_sign_in
    identify
    track('Sign In User')
  end

  def track_user_oauth_sign_in
    identify
    track('Oauth Sign In User')
  end

  def track_user_created_card
    identify
    track('User created card')
  end

  def track_user_reviewed_card
    identify
    track('Card review by user')
  end

  def track_user_used_flickr_load
    identify
    track('User loaded Flickr picture')
  end

  private

  def identify
    Analytics.identify(user_id: current_user.id,
                       traits: { email: "#{ current_user.email }",
                                 locale: "#{current_user.locale}" })
  end

  def track(event)
    Analytics.track(
      {
        user_id: current_user.id,
        event: event
      }
    )
  end
end
