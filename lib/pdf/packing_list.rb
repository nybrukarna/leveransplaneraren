require 'prawn'
require 'prawn/table'

module Leverans
  module Pdf
    class PackingList
      def initialize(users, week)
        Prawn::Font::AFM.hide_m17n_warning = true
        @document = Prawn::Document.new
        @users = users.week(week)
        # TODO: Fix and use settings.pickup_weekday
        pickup_friday = ['Tolg', 'Lädja', 'Ör', 'Bråna']
        pickup_thursday = ['Rottne', 'Tjureda', 'Växjö c', 'Linneuniversitetet', 'Biskopshagen']
        pickup_all = pickup_thursday + pickup_friday

        matrix_total = []
        matrix_total << ["<b>V#{week}</b>", *pickup_all.map{|loc| "<font size='10'>#{loc}</font>"}, ""]
        matrix_thursday = []
        matrix_thursday << ["<b>V#{week}</b>", *pickup_thursday.map{|loc| "<font size='10'>#{loc}</font>"}, ""]
        matrix_friday = []
        matrix_friday << ["<b>V#{week}</b>", *pickup_friday.map{|loc| "<font size='10'>#{loc}</font>"}, ""]

        @users.by_share.each do |share, users|
          m_to = Hash.new{0}
          users.each do |u|
            m_to[u.pickup] += 1
          end
          mm = pickup_all.map { |p| m_to.fetch(p, 0) }
          matrix_total << [share, *mm, mm.reduce(&:+)]
          m_f = pickup_friday.map { |p| m_to[p] }
          m_t = pickup_thursday.map { |p| m_to[p] }
          matrix_friday << [share, *m_f, m_f.reduce(&:+)]
          matrix_thursday << [share, *m_t, m_t.reduce(&:+)]
        end

        matrix_total << ["", *matrix_total[1..-1].map {|r| r[1..-1]}.transpose.map(&:sum)]
        matrix_friday << ["", *matrix_friday[1..-1].map {|r| r[1..-1]}.transpose.map(&:sum)]
        matrix_thursday << ["", *matrix_thursday[1..-1].map {|r| r[1..-1]}.transpose.map(&:sum)]

        @document.text "<font size='20'><b>Vecka #{week}</b></font>", inline_format: true

        @document.table(matrix_total, {cell_style: {inline_format: true}})
        @document.text "\n<b>Torsdagar</b>", inline_format: true
        @document.table(matrix_thursday, {cell_style: {inline_format: true}})
        @document.text "\n<b>Fredagar</b>", inline_format: true
        @document.table(matrix_friday, {cell_style: {inline_format: true}})

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
