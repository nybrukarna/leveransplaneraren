# Helper methods defined here can be accessed in any controller or view in the application

module Leverans
  class App
    module AdminHelper
      def format_phone(phone)
        phone = phone.gsub(/[\s\-]/, '')
        phone = '+'+phone[2..-1] if phone[0..1] == '00'
        phone = '+46'+phone[1..-1] if phone[0..1] == '07'
        phone
      end
    end

    helpers AdminHelper
  end
end
