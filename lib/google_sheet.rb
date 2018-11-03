require 'google_drive'
require 'user'

module Leverans
  # Absraction of Google Sheet leverans
  class Sheet
    attr_accessor :weeks, :users
    def initialize(sheet)
      @session_file = 'nybrukarna-819a30e26eb7.json'
      @worksheet = session.spreadsheet_by_key(sheet).worksheets[0]
      @users = Leverans::Users.new(@worksheet.rows, worksheet: @worksheet)
      @weeks = @users.weeks
    end

    def user(email)
      @users.select { |u| u.email == email }.first
    end

    def session
      GoogleDrive::Session.from_service_account_key(File.expand_path(File.join(File.dirname(__FILE__), @session_file)))
    end

    def update_row(row, column, information)
      @worksheet[row, column] = information
    end

    def save
      @worksheet.save
    end
  end
end
