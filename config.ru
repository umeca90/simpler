require_relative 'config/environment'
require_relative 'lib/middleware/app_logger'

use AppLogger
run Simpler.application
