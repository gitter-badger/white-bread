defmodule WhiteBread.ContextTest do
  use ExUnit.Case
  alias WhiteBread.Gherkin.Elements.Steps, as: Steps

  defmodule ExampleContext do
    use WhiteBread.Context

    given_ "I'm running a simple test" do
      # Nothing happening here
    end

    when_ "I pass in some state", fn state ->
      {:ok, [:test_new_state | state]}
    end

    given_ ~r/I'm running a simple [A-Za-z]+/ do
      # nothing happening here
    end

    when_ ~r/I pass in some [A-Za-z]+/, fn state ->
      {:ok, state}
    end

    then_ ~r/my new state should be (?<new_state>[A-Za-z]+)/, fn _state, new_state: new_state ->
      {:ok, new_state}
    end
  end

  test "Blocks provided with a simple string return ok with the starting state" do
    step = %Steps.Given{text: "I'm running a simple test"}
    state = :old_state
    assert ExampleContext.execute_step(step, state) == {:ok, state}
  end

  test "functions given with a simple string update and return the state" do
    step = %Steps.When{text: "I pass in some state"}
    state = :old_state
    assert ExampleContext.execute_step(step, state) == {:ok, [:test_new_state | :old_state]}
  end

  test "steps can be provided with regexes rather than flat strings" do
    state = :old_state
    first_step = %Steps.Given{text: "I'm running a simple bakery"}
    second_step = %Steps.When{text: "I pass in some pie"}

    assert ExampleContext.execute_step(first_step, state) == {:ok, state}
    assert ExampleContext.execute_step(second_step, state) == {:ok, state}
  end

  test "steps can can use named group capture" do
    state = :old_state
    step = %Steps.Then{text: "my new state should be awesome"}
    assert ExampleContext.execute_step(step, state) == {:ok, "awesome"}
  end

end