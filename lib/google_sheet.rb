require 'google_drive'
require 'user'

module Leverans
  # Absraction of Google Sheet leverans
  class Sheet
    attr_accessor :weeks, :users
    def initialize(sheet)
      @session_file = 'nybrukarna-f38b5301abf8.json'
      @worksheet = session.spreadsheet_by_key(sheet).worksheets[0]
      puts @worksheet.to_a
      @users = []
      @weeks = []
      load_worksheet!
    end

    def load_worksheet!
      @worksheet.rows.each_with_index do |row, index|
        next if index.zero?
        @users << Leverans::User.new(row, index, @worksheet) unless row[1].blank?
      end
      @weeks = @worksheet.rows[0][4..-1]
    end

    def user(email)
      @users.select { |u| u.email == email }.first
    end

    def session
      GoogleDrive::Session.from_service_account_key(File.join(@session_file))
    end

    def update_row(row, column, information)
      @worksheet[row, column] = information
    end

    def save
      @worksheet.save
    end

    # User object in row
  end
end
