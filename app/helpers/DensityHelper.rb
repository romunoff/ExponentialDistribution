class DensityHelper
  def self.calculate(x, lambda)
    x < 0 ? 0 : lambda * Math.exp(-lambda * x)
  end

  def self.find_max(lambda)
    DensityHelper.calculate(0, lambda)
  end

  def self.mean(lambda)
    1 / lambda
  end

  def self.variance(lambda)
    1 / lambda ** 2
  end

  def self.deviation(lambda, count)
    variance = DensityHelper.variance(lambda)
    Math.sqrt(variance / count)
  end
end
