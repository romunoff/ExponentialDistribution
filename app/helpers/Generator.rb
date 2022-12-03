class Generator
  def initialize(count, x_limit, step)
    @count = count
    @x_limit = x_limit
    @step = step
  end

  def get_total_generations
    (@x_limit.to_f / @step) * @count
  end

  def init(method)
    sum = 0
    squares_sum = 0
    frequencies = []

    ((0 + @step)..@x_limit).step(@step).each do |i|
      total_successes = 0
      prev_step = i - @step

      (0..@count).each do |j|
        result = method.call
        sum += result
        squares_sum += result ** 2

        if result > prev_step and result <= i
          total_successes += 1
        end
      end

      frequencies << total_successes.to_f / @count.to_f
    end

    {
      'sum' => sum,
      'squares_sum' => squares_sum,
      'frequencies' => frequencies,
    }
  end
end