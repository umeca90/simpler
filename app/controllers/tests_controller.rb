class TestsController < Simpler::Controller #:nodoc:
  def index
    @time = Time.now
    @tests = Test.all
    # render plain: "Plain text response"
    status 201
  end

  def create; end

  def show
    @id = params[:id]
  end
end
