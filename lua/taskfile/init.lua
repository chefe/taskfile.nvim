local M = {
  --- The path to the `task` binary. By default use the `task` binary which is
  --- found in the `PATH`.
  command = 'task',
}

--- @class TaskDescription
--- @field name string The name of the task.
--- @field desc string The description of the task.

--- List all available task from the taskfile.
--- @return TaskDescription[]
function M.get_tasks()
  local response = vim
    .system({ M.command, '--list', '--json' }, { text = true })
    :wait()
  if response.code ~= 0 then
    return {}
  end

  local data = vim.json.decode(response.stdout)
  if data == nil or data.tasks == nil then
    return {}
  end

  return data.tasks
end

--- Run the given task.
--- @param task string
function M.run_task(task)
  vim.fn.execute(':terminal ' .. M.command .. ' ' .. task)
end

--- Open a selection window to select a task to run
local open_menu = function()
  local tasks = M.get_tasks()

  if #tasks == 0 then
    vim.print('No tasks found')
    return
  end

  --- @param task TaskDescription
  local format_item = function(task)
    return task.name .. ': ' .. task.desc
  end

  --- @param item TaskDescription
  local on_choice = function(item)
    M.run_task(item.name)
  end

  vim.ui.select(tasks, {
    prompt = 'Tasks:',
    format_item = format_item,
  }, on_choice)
end

--- This function is called every time a user tries to tab complete
local complete_task_names = function(prefix)
  local suggestions = {}
  local tasks = M.get_tasks()

  -- Suggest all tasks which start with `prefix`.
  for _, task in pairs(tasks) do
    if task.name:lower():match('^' .. prefix:lower()) then
      table.insert(suggestions, task.name)
    end
  end

  -- Sort suggestion alphabetically.
  table.sort(suggestions)

  return suggestions
end

--- Register the `:Task` command.
local register_task_command = function()
  vim.api.nvim_create_user_command('Task', function(command)
    if command.args ~= '' then
      M.run_task(command.args)
    else
      open_menu()
    end
  end, {
    desc = 'Run tasks defined in a Taskfile',
    nargs = '*',
    complete = complete_task_names,
  })
end

--- Resolve the plugin options based on the provided defaults and overrides.
local resolve_options = function(defaults, overrides)
  if overrides == nil then
    return defaults
  end

  local result = {}

  for key, value in pairs(defaults) do
    if overrides[key] ~= nil and type(overrides[key]) == type(value) then
      result[key] = overrides[key]
    else
      result[key] = value
    end
  end

  return result
end

--- @class PluginOptions
--- @field command string|nil Configure the path to the `task` binary (Default: task).
--- @field register_command boolean|nil Configure if the `:Task` command should be registed (Default: true).

--- @type PluginOptions
local default_options = { command = 'task', register_command = true }

--- Setup the taskfile plugin.
--- @param options PluginOptions|nil Setup the plugin with these options.
function M.setup(options)
  options = resolve_options(default_options, options)

  M.command = options.command

  if options.register_command then
    register_task_command()
  end
end

return M
