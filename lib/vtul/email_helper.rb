class EmailHelper
  def get_emails(user_values)
    email_hash = Hash.new
    user_values.each do |value|
      email = User.find_by(email: value).email rescue nil
      if email.nil?
        email = User.find_by(display_name: value).email rescue nil
      end
      if email.nil?
        reverse_name = value.gsub(',', '').split(' ').reverse.join(' ')
        email = User.find_by(display_name: reverse_name).email rescue nil
      end
      email_hash[value] = email if !email.nil?
    end
    return email_hash
  end
end
