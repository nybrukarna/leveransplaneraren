# Helper methods defined here can be accessed in any controller or view in the application

module Leverans
  class App
    module ScheduleHelper
      def week_is_disabled(week)
        date = DateTime.now
        week.to_i >= date.cweek && date.wday > 1
      end
    end

    helpers ScheduleHelper
  end
end
