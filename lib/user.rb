require 'forwardable'

module Leverans
  class Users

    extend Forwardable
    attr_reader :users, :header, :worksheet
    def_delegators :@users, :map, :size, :[], :empty?, :each_with_index, :select, :sort, :sort_by, :first, :last, :each

    def initialize(rows, header: true, worksheet: false)
      @users = []
      @worksheet = worksheet
      @header = header ? rows[0] : []
      rows.each_with_index do |row, index|
        next if index.zero? && header
        @users << Leverans::User.new(row, index, worksheet) unless row[1].empty?
      end
      @users = @users.sort_by do |u|
        u.share_id
      end
    end

    def marshal_dump
      [@users, @header]
    end

    def marshal_load(array)
      @users, @header = array
    end

    # List of available picksups
    def pickups
      @users.map { |u| u.pickup }.uniq
    end

    def user_by_email(email)
      @users.select { |u| u.email.downcase == email.downcase }.first
    end

    # List of available shares
    def shares
      @users.map { |u| u.share }.uniq
    end

    def weeks
      @header[4..-1]
    end

    def share(type)
      @users.select { |u| u.share == type }
    end

    def pickup(type)
      @users.select { |u| u.pickup == type }
    end

    def week(week)
      @users = @users.select do |u|
        u.week(weeks.index(week.to_s)) == true
      end
      self
    end

    def by_pickup
      @users.group_by do |u|
        u.pickup
      end
    end

    def by_share
      @users.group_by do |u|
        u.share
      end
    end
  end

  class User
    attr_reader :row_number, :name, :email, :share, :pickup

    SHARE_SORT = ['1 andel', '2 andelar', '3 andelar']

    def initialize(user, row_number, worksheet)
      @user = user
      @row_number = row_number
      @worksheet = worksheet
      @name = @user[0]
      @email = @user[1]
      @share = @user[2]
      @pickup = @user[3]
    end

    def share_id
      SHARE_SORT.index(share.downcase)
    end

    def email
      @email.strip.downcase
    end

    def share
      @share.strip.capitalize
    end

    def pickup
      @pickup.strip.capitalize
    end

    def save
      @worksheet.save
    end

    def schedule=(schedule)
      schedule.each_with_index do |state, column|
        @worksheet[@row_number + 1, column + 5] = cell_data(state)
      end
    end

    def to_h
      {
        name: name,
        email: email,
        share: share,
        pickup: pickup
      }
    end

    def schedule
      @schedule ||= @user[4..-1].map do |week|
        week = week.downcase if week.is_a?(String)
        case week
        when 'ingen leverans', 'false', '0', false, 0
          false
        else
          true
        end
      end
    end

    def week(index)
      return nil if index.nil?
      schedule.fetch(index, nil)
    end

    def cell_data(value)
      return 'Leverans' if value
      'Ingen leverans'
    end
  end
end
