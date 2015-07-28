defmodule Tanx.GameManager do

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end


  defmodule PlayerEvent do
    use GenEvent

    def handle_event({:player_views, player_views}, state) do
      Tanx.Endpoint.broadcast!("game", "view_players", %{players: player_views})
      {:ok, state}
    end

  end


  #### GenServer callbacks

  use GenServer


  def init(_opts) do
    Tanx.Core.Game.start_link(name: :game_core,
      player_change_handler: {PlayerEvent, nil},
      structure: structure1)
  end


  # A sample maze with diagonal passages and an open area in the center.
  defp structure1 do
    pi = :math.pi()

    %Tanx.Core.Structure{
      width: 20.0,height: 20.0,

      walls: [
        [{-8.5, 10}, {-8, 10}, {-8, 7}, {-8.5, 7}],
        [{8.5, -10}, {8, -10}, {8, -7}, {8.5, -7}],
        [{10, 8.5}, {10, 8}, {7, 8}, {7, 8.5}],
        [{-10, -8.5}, {-10, -8}, {-7, -8}, {-7, -8.5}],

        [{-8, 5}, {-8, 4}, {-1, 4}, {-5, 4}, {-3, 0}, {-5, 4}, {-8, 4}],
        [{8, -5}, {8, -4}, {1, -4}, {5, -4}, {3, 0}, {5, -4}, {8, -4}],

        [{-6, 6}, {-6, 8}, {-3, 8}, {-6, 8}],
        [{6, -6}, {6, -8}, {3, -8}, {6, -8}],

        [{-8, 2}, {-6, 2}, {-4, -2}, {-6, 2}],
        [{8, -2}, {6, -2}, {4, 2}, {6, -2}],

        [{-4, 6}, {0, 6}, {1, 4}, {3, 4}, {1, 4}, {0, 6}],
        [{4, -6}, {0, -6}, {-1, -4}, {-3, -4}, {-1, -4}, {0, -6}],

        [{2, 6}, {4, 6}, {6, 2}, {4, 6}],
        [{-2, -6}, {-4, -6}, {-6, -2}, {-4, -6}],

        [{8, 2}, {5, 8}, {6, 6}, {8, 6}, {6, 6}],
        [{-8, -2}, {-5, -8}, {-6, -6}, {-8, -6}, {-6, -6}],

        [{1, 8}, {3, 8}],
        [{-1, -8}, {-3, -8}],

        [{-1, 10}, {-1, 8}],
        [{1, -10}, {1, -8}],

        [{10, 0}, {7, 0}],
        [{-10, 0}, {-7, 0}],

        [{-10, -10}, {10, -10}, {10, 10}, {-10, 10}]
      ],

      entry_points: [
        %Tanx.Core.Structure.EntryPoint{
          name: "nw",
          x: -9.25, y: 9.25, heading: -pi/2,
          buffer_left: 0.75, buffer_right: 1.25, buffer_up: 0.75, buffer_down: 9.25
        },
        %Tanx.Core.Structure.EntryPoint{
          name: "ne",
          x: 9.25, y: 9.25, heading: pi,
          buffer_left: 9.75, buffer_right: 0.75, buffer_up: 0.75, buffer_down: 1.25
        },
        %Tanx.Core.Structure.EntryPoint{
          name: "se",
          x: 9.25, y: -9.25, heading: pi/2,
          buffer_left: 1.25, buffer_right: 0.75, buffer_up: 9.25, buffer_down: 0.75
        },
        %Tanx.Core.Structure.EntryPoint{
          name: "sw",
          x: -9.25, y: -9.25, heading: 0.0,
          buffer_left: 0.75, buffer_right: 9.75, buffer_up: 1.25, buffer_down: 0.75
        },
      ]
    }
  end

end
