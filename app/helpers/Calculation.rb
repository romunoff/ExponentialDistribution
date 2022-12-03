class Calculation
  @slices = 100

  def self.neumann(func, max, x_limit)
    while true
      x = rand(0.0..1.0) * x_limit
      y = rand(0.0..1.0) * max

      if func.call(x) > y
        return x
      end
    end
  end

  def self.metropolis(func, x_limit, prev_x)
    gamma1 = rand
    gamma2 = rand

    delta = (1.0 / 3.0) * x_limit
    x1 = prev_x + delta * (-1.0 + 2.0 * gamma1)

    result = func.call(prev_x)
    alpha = func.call(x1) / (!result ? 1 : result)

    if alpha >= 1.0||alpha > gamma2
      return x1
    end

    prev_x
  end

  def self.piecewise_find_max(func, x_limit)
    sum = 0.0

    (1..@slices).each do |i|
      x = i * (1.0 / @slices) * 1.0 * x_limit
      sum += func.call(x)
    end

    sum
  end

  def self.piecewise_approximation(func, x_limit, sum)
    random = rand
    x = 0
    p = 0.0

    (1..@slices).each do |i|
      x = i * (1.0 / @slices) * 1.0 * x_limit
      p += func.call(x) / sum
      break if random < p
    end

    delta = rand

    x - delta * x_limit / @slices
  end

  def self.get_mean(sum, count)
    sum / count
  end

  def self.get_variance(sum, squares_sum, count)
    mean = Calculation.get_mean(sum, count)
    (squares_sum - (mean * mean * count)) / (count - 1)
  end

  def self.get_deviation(sum, squares_sum, count)
    variance = Calculation.get_variance(sum, squares_sum, count)
    Math.sqrt(variance / count)
  end
end
