class SmsStatus
  attr_reader :recipient, :message
  def initialize(status, recipient, opts={})
    @status = status
    @recipient = recipient
    @css_class = opts.delete(:css_class)
    @message = opts.delete(:message)
  end

  def status
    @status.to_sym
  end

  def css_class
    @css_class || status.to_s
  end
end
