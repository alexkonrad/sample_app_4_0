ActionMailer::Base.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    user_name:            'sample.app.4.0',
    password:             'rubyonrails',
    authentication:       'plain',
    enable_starttls_auto: true 
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
