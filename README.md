# taskfile.nvim

A plugin to bring [Taskfile][1] functionality to neovim.

## Features

* Run a task with a user command
* Show a list of task and select one to run with a user command
* Show a [telescope picker][2] with a list of task and select one to run

## Installation

[Lazy][3] with telescope:

```lua
return {
  {
    'chefe/taskfile.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('taskfile').setup()
    end,
    cmd = 'Task',
    keys = {
      {
        '<leader>ft',
        '<cmd>lua require("taskfile.telescope").run_task()<cr>',
        desc = 'Telescope - Run task',
      },
    },
  },
}
```

[Lazy][3] without telescope:

```lua
return {
  {
    'chefe/taskfile.nvim',
    config = function()
      require('taskfile').setup()
    end,
    cmd = 'Task',
  },
}
```

## Usage

* Run `:Task` to show a menu menu of all defined tasks.
* Run `:Task {task}` to run the task `{task}` in a terminal buffer.
* Run `:Task {task} {arguments}` to run the task with the given arguments.
* Run `:lua require("taskfile.telescope").run_task()` to open a telescope
  picker or use the keymap defined in the Lazy plugin definition.

## Configuration

```lua
require('taskfile').setup({
  -- Specify a custom path to the `task` binary.
  -- Default: 'task' (if omitted)
  command = '/path/to/special/go-task-binary'
  -- Enable or diable the registration of the `:Task` command.
  -- Default: true (if omitted)
  register_command = false,
})
```

## Credits

* [ShadowApex/Taskfile.nvim][4]

[1]: https://taskfile.dev
[2]: https://github.com/nvim-telescope/telescope.nvim
[3]: https://lazy.folke.io
[4]: https://github.com/ShadowApex/Taskfile.nvim
