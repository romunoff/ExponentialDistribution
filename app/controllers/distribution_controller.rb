class DistributionController < ApplicationController
  def index
    n = params['n']
    x_limit = params['x']
    lambda = params['lambda']
    step = 0.1

    if n && x_limit && lambda
      n = n.to_i
      x_limit = x_limit.to_f
      lambda = lambda.to_f
    else
      return
    end

    generator = Generator.new(n, x_limit, step)
    total_generations = generator.get_total_generations

    calculate = ->(x) {
      DensityHelper.calculate(x, lambda)
    }

    mode = 0
    max = DensityHelper.find_max(lambda)
    mean = DensityHelper.mean(lambda)
    variance = DensityHelper.variance(lambda)
    deviation = DensityHelper.deviation(lambda, total_generations)

    calculate_neumann = ->() {
      Calculation.neumann(calculate, max, x_limit)
    }

    prev_x = mode
    calculate_metropolis = ->() {
      result = Calculation.metropolis(calculate, x_limit, prev_x)
      prev_x = result
      result
    }

    calculate_inverse= ->() {
      Calculation.inverse(lambda)
    }

    neumann_data = generator.init(calculate_neumann)
    metropolis_data = generator.init(calculate_metropolis)
    inverse_function_data = generator.init(calculate_inverse)

    neumann_mean = Calculation.get_mean(neumann_data['sum'], total_generations)
    metropolis_mean = Calculation.get_mean(metropolis_data['sum'], total_generations)
    inverse_function_mean = Calculation.get_mean(inverse_function_data['sum'], total_generations)

    neumann_variance = Calculation.get_variance(neumann_data['sum'], neumann_data['squares_sum'], total_generations)
    metropolis_variance = Calculation.get_variance(metropolis_data['sum'], metropolis_data['squares_sum'], total_generations)
    inverse_function_variance = Calculation.get_variance(inverse_function_data['sum'], inverse_function_data['squares_sum'], total_generations)

    neumann_deviation = Calculation.get_deviation(neumann_data['sum'], neumann_data['squares_sum'], total_generations)
    metropolis_deviation = Calculation.get_deviation(metropolis_data['sum'], metropolis_data['squares_sum'], total_generations)
    inverse_function_deviation = Calculation.get_deviation(inverse_function_data['sum'], inverse_function_data['squares_sum'], total_generations)

    @results = {
      'n' => n,
      'x' => x_limit,
      'lambda' => lambda,
      'step' => step,

      'analyticalMean' => mean,
      'analyticalVariance' => variance,
      'analyticalDeviation' => deviation,

      'neumannMean' => neumann_mean,
      'neumannVariance' => neumann_variance,
      'neumannDeviation' => neumann_deviation,

      'metropolisMean' => metropolis_mean,
      'metropolisVariance' => metropolis_variance,
      'metropolisDeviation' => metropolis_deviation,

      'inverseFunctionMean' => inverse_function_mean,
      'inverseFunctionVariance' => inverse_function_variance,
      'inverseFunctionDeviation' => inverse_function_deviation,

      'neumannData' => neumann_data['frequencies'],
      'metropolisData' => metropolis_data['frequencies'],
      'inverseFunctionData' => inverse_function_data['frequencies'],
    }
  end
end
