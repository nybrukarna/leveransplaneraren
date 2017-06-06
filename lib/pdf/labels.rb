require 'prawn'
require 'prawn/labels'

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
            "top_margin"=> 13.03*MM,
            "bottom_margin"=> 13.03*MM,
            "left_margin"=> 8.1*MM,
            "right_margin"=> 8.1*MM,
            "columns"=> 3,
            "rows"=> 8,
            "row_gutter"=> 0
          }}

        @users = users
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
        pdf.text "<b>#{user.name}</b>", inline_format: true, align: :center
        pdf.move_down 8
        pdf.text "<font size='9'>#{@week} / #{user.share} / #{user.pickup}</font>", inline_format: true, align: :center
        pdf.move_down 8
        pdf.image File.join(@basedir, 'logo.png'), width: 60*MM, position: :center
      end
    end
  end
end
