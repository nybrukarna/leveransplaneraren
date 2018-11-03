require 'prawn'
require 'prawn/labels'
require 'prawn/measurement_extensions'

module Leverans
  module Pdf
    class Labels
        MM=2.834645669291339
      def initialize(users, week)
        Prawn::Font::AFM.hide_m17n_warning = true

        # http://www.herma.de/uploads/formatvorlagen/info/herma4227-A4-64,6x33,8.pdf
        Prawn::Labels.types = {
          "herma4227" => {
            "paper_size"=> "A4",
            "top_margin"=> 13.03.mm,
            "bottom_margin"=> 13.03.mm,
            "left_margin"=> 8.1.mm,
            "right_margin"=> 8.1.mm,
            "columns"=> 3,
            "rows"=> 8,
            "row_gutter"=> 0
          }}

        # Sortering
        # Utlamningsplats - andel
        #@users = users.sort_by(&:pickup)
        # TODO: Use settings.pickup_weekday instead
        pickup_thursday = ['Rottne', 'Tjureda', 'Växjö c', 'Linneuniversitetet', 'Biskopshagen']
        pickup_friday = ['Tolg', 'Lädja', 'Ör', 'Bråna']
        @users = []
        (pickup_thursday+pickup_friday).each do |location|
          users.each do |user|
            @users << user if user.pickup.downcase == location.downcase
          end
        end
        @basedir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public', 'images'))
        @week = week
      end

      def generate(filename)
        @labels = Prawn::Labels.generate("labels_#{@week}.pdf", @users, :type => "herma4227") do |pdf, user|
          label(pdf, user)
        end
      end

      def render
        Prawn::Labels.render(@users, :type => "herma4227") do |pdf, user|
          label(pdf, user)
        end
      end

      def label(pdf, user)
        pdf.move_down 8
        pdf.text "<b>#{user.name}</b>", inline_format: true, align: :center
        pdf.move_down 8
        pdf.text "<font size='9'>#{@week} / #{user.share} / #{user.pickup}</font>", inline_format: true, align: :center
        pdf.move_down 8
        pdf.image File.join(@basedir, 'logo.png'), width: 50.mm, position: :center
      end
    end
  end
end
