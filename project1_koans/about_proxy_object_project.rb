class Proxy
  attr_reader :messages

  def initialize(target_object)
    @object = target_object
    @messages = []
    @method_count = Hash.new(0)
  end

  def method_missing(method_name, *args, &block)
    if @object.respond_to?(method_name)
      # Remember method called
      @messages << method_name

      # Record method called count
      @method_count[method_name] += 1

      # Send method to the actual object
      @object.send(method_name, *args, &block)
    else
      super(method_name, *args, &block)
    end
  end

  def called?(method_name)
    @messages.include?(method_name)
  end

  def number_of_times_called(method_name)
    @method_count[method_name]
  end

  def respond_to_missing?(method_name, include_private = false)
    @object.respond_to?(method_name) || super
  end
end
