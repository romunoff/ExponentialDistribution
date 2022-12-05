class Calculation
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
    gamma1 = rand(0.0..1.0)
    gamma2 = rand(0.0..1.0)

    delta = (1.0 / 3.0) * x_limit
    x = prev_x + delta * (-1.0 + 2.0 * gamma1)

    result = func.call(prev_x)
    alpha = func.call(x) / (!result ? 1 : result)

    if alpha >= 1.0 || alpha > gamma2
      return x
    end

    prev_x
  end

  def self.inverse(lambda)
    gamma = rand(0.0..1.0)
    -Math.log(1.0 - gamma) / lambda
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
