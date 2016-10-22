require 'rspec'
require 'mobiusloop/objective'

describe 'Objective' do

  it 'should create only one Objective instance with a unique name' do
    obj1 = Objective.add_current("My goal is for us to...")
    expect(obj1.name).to eql("My goal is for us to...")

    obj2 = Objective.add_current("My goal is for us to...")
    expect(obj1).to eql(obj2)

    obj3 = Objective.add_current("A completely different goal...")
    expect(obj3).to_not eql(obj1)
    expect(obj3).to_not eql(obj2)

    expect(Objective.get_all.size).to eql(2) # ensure only 2 unique ones exist
  end

  it 'should return the current one (last one added)' do
    obj1 = Objective.add_current("My goal is for us to...")
    expect(obj1).to eql(Objective.get_current)
  end

  it 'should save the results to a .json file' do
    # expect there to be no files in the goals/measures directory
    project_root = File.dirname(File.absolute_path(__FILE__)) + "/../../goals/measures"
    expect(Dir.glob(project_root).count).to eql(0)

    create_and_save_objective

    # expect there to be a new file and then cleanup
    expect(Dir.glob(project_root).count).to eql(1)
    FileUtils.rm_r project_root
  end


  def create_and_save_objective
    objective = Objective.add_current("My goal is for us to...")
    outcome = Outcome.new("test", ScaleSample.new)
    objective.add_outcome(outcome)

    outcome.baseline = 100
    outcome.baseline_date = "01/01/2017"
    outcome.target = 200
    outcome.target_date = "01/01/2018"

    outcome.measure
    objective.save
  end

end