defmodule RobotSimulator do
  @directions [:north, :south, :east, :west]
  @instructions ["L", "R", "A"]

  defguard invalid_position_tuple(position)
    when is_tuple(position) != true
    or tuple_size(position) > 2

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})
  def create(direction, _position) when direction not in @directions do
    {:error, "invalid direction"}
  end

  def create(_direction, position) when invalid_position_tuple(position) do
    {:error, "invalid position"}
  end

  def create(_direction, {x, y}) when is_integer(x) != true or is_integer(y) != true do
    {:error, "invalid position"}
  end

  def create(direction, position) do
    %Robot{name: "Wall-E", direction: direction, position: position}
  end

  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes()
    |> validate_instructions()
    |> maybe_reduce(robot)
  end

  defp validate_instructions(instructions) do
    case MapSet.subset?(MapSet.new(instructions), MapSet.new(@instructions)) do
       true -> {:ok, instructions}
       false -> {:error, "invalid instruction"}
    end
  end

  def maybe_reduce({:ok, instructions}, robot) do
    instructions
    |> Enum.reduce(robot, fn
        instruction, acc -> do_instruction(acc, instruction)
      end)
  end

  def maybe_reduce(error_tuple, _robot) do
    error_tuple
  end

  def do_instruction(%{direction: :north, position: {x, y}} = robot, "A") do
    robot
    |> Map.put(:position, {x, y + 1})
  end

  def do_instruction(%{direction: :east, position: {x, y}} = robot, "A") do
    robot
    |> Map.put(:position, {x + 1, y})
  end

  def do_instruction(%{direction: :south, position: {x, y}} = robot, "A") do
    robot
    |> Map.put(:position, {x, y - 1})
  end

  def do_instruction(%{direction: :west, position: {x, y}} = robot, "A") do
    robot
    |> Map.put(:position, {x - 1, y})
  end

  def do_instruction(%{direction: :north} = robot, "R") do
    robot
    |> Map.put(:direction, :east)
  end

  def do_instruction(%{direction: :east} = robot, "R") do
    robot
    |> Map.put(:direction, :south)
  end

  def do_instruction(%{direction: :south} = robot, "R") do
    robot
    |> Map.put(:direction, :west)
  end

  def do_instruction(%{direction: :west} = robot, "R") do
    robot
    |> Map.put(:direction, :north)
  end

  def do_instruction(%{direction: :north} = robot, "L") do
    robot
    |> Map.put(:direction, :west)
  end

  def do_instruction(%{direction: :west} = robot, "L") do
    robot
    |> Map.put(:direction, :south)
  end

  def do_instruction(%{direction: :south} = robot, "L") do
    robot
    |> Map.put(:direction, :east)
  end

  def do_instruction(%{direction: :east} = robot, "L") do
    robot
    |> Map.put(:direction, :north)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
