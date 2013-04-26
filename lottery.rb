class Lottery
  def initialize(size)
    raise ArgumentError, 'size must be larger than or equal to 0' unless size >= 0
    @size = size
    @member_table = {}
  end

  def add(member, weight)
    raise ArgumentError, 'member must be unique' unless @member_table[member].nil?
    raise ArgumentError, 'weight must be larger than 0' unless weight > 0
    @member_table[member] = weight
  end

  def winners
    array = lottery_array
    Array.new(@size){ array.delete(array.sample) }.compact
  end

  private

  def lottery_array
    @member_table.map{|member, weight| Array.new(weight, member) }.flatten
  end
end
