require 'prawn'
require 'prawn/table'

module Leverans
  module Pdf
    class PackingList
      def initialize(users, week)
        Prawn::Font::AFM.hide_m17n_warning = true
        @document = Prawn::Document.new
        @users = users.week(week)
        matrix = []
        matrix << [week, *@users.pickups]
        @users.by_share.each do |share, users|
          asdf = users.inject({}) do |m, u|
            m[u.pickup] = 0 if m[u.pickup].nil?
            m[u.pickup] += 1
            m
          end
          xx = @users.pickups.collect do |p|
            asdf[p].nil? ? 0 : asdf[p]
          end
          matrix << [share, *xx, xx.reduce(&:+)]
        end
        matrix << ['', *@users.by_pickup.collect do |m, p|
          p.size
        end]

        @document.text "<font size='20'><b>Vecka #{week}</b></font>", inline_format: true

        @document.table(matrix)

        @document.move_down(20)

        @users.by_pickup.each do |pickup, users|
          @document.text "<font size='16'><b>#{pickup}</b></font>", inline_format: true
          @document.move_down 5
          users.group_by(&:share).each do |share, u|
            @document.text "<b>#{share}</b>", inline_format: true
            u.each do |us|
              @document.text "#{us.name}"
            end
            @document.move_down 10
          end
          @document.move_down 10
        end
      end

      def render_file(name)
        @document.render_file(name)
      end

      def render
        @document.render
      end
    end
  end
end
