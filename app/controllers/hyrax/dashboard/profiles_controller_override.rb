# Attempting to override from Hyrax Gem 2.1.0:
#   Profiles Controller - app/controllers/hyrax/dashboard/profiles_controller.rb

module Hyrax
  module Dashboard
    module ProfilesControllerOverride
      # Process changes from profile form

      def update
        if params[:user]
          @user.attributes = user_params
          #@user.populate_attributes if update_directory?

          if !params[:user_links].blank?
            params[:user_links].each do |user_link|
              link = UserLink.find_or_create_by({link: user_link})
              link.link = user_link
              @user.user_links << link if !user_link.blank?
            end
          end
        end

        super
      end

      def user_link_delete
        link = UserLink.find_by_id_and_user_id(params[:link_id], @user.id)
        if (destroyed = link.destroy)
          ret_obj = destroyed
        else
          ret_obj = {"errors": true, "msg": "error deleting user_link"}
        end
        render json: ret_obj
      end

      private
        def user_params
          params.require(:user).permit(:display_name, :personal_statement, :avatar, :facebook_handle, :twitter_handle,
                                       :googleplus_handle, :linkedin_handle, :remove_avatar, :orcid, 
                                       :soundcloud_handle)
        end
    end
  end
end
