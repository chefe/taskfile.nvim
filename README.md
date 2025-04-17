# taskfile.nvim

A plugin to bring [Taskfile][1] functionality to neovim.

## Features

* Run a task with a user command
* Show a list of task and select one to run with a user command

## Installation

[Lazy][2]:

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

## Configuration

```lua
require('taskfile').setup({
  -- Default: 'task' (if omitted)
  command = '/path/to/special/go-task-binary'
})
```

## Credits

* [ShadowApex/Taskfile.nvim][3]

[1]: https://taskfile.dev
[2]: https://lazy.folke.io
[3]: https://github.com/ShadowApex/Taskfile.nvim
