class SessionService
  
  def initialize
    @secret = {
        "client_id": ENV['client_id'],
        "client_secret": ENV['client_secret'],
        "scope": [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/"
        ],
        "refresh_token": ENV['refresh_token']
      }
  end

  def validate
    file = Tempfile.new('temp')
    begin
      file.write(@secret.to_json)
      file.rewind
      begin
        session = GoogleDrive::Session.from_config(file.path)
      rescue
        return nil
      end
    ensure
      file.close
      file.unlink   # deletes the temp file
    end
    return session
  end

end
