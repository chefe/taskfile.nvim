local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local entry_display = require('telescope.pickers.entry_display')

local taskfile = require('taskfile')

--- @class TaskEntry
--- @field value string
--- @field oridinal string
--- @field description string

--- @param max_length integer
--- @return function
local make_display = function(max_length)
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = max_length },
      { remaining = true },
    },
  })

  --- @param entry TaskEntry
  return function(entry)
    return displayer({
      { entry.value, 'TelescopeResultsIdentifier' },
      entry.description,
    })
  end
end

--- @param display function
--- @return function
local make_entry = function(display)
  --- @param entry TaskDescription
  --- @return TaskEntry
  return function(entry)
    return {
      value = entry.name,
      ordinal = entry.name .. ' ' .. entry.desc,
      description = entry.desc,
      display = display,
    }
  end
end

--- @parama tasks TaskDescription[]
--- @return integer
local get_max_task_name_length = function(tasks)
  local max = 0

  for _, task in ipairs(tasks) do
    local len = string.len(task.name)
    if len > max then
      max = len
    end
  end

  return max
end

local M = {}

--- Open a telescope picker and then run the selected task.
function M.run_task(opts)
  opts = opts or {}
  local tasks = taskfile.get_tasks()
  local max_length = get_max_task_name_length(tasks)
  local display = make_display(max_length)

  pickers
    .new(opts, {
      prompt_title = 'Tasks',
      finder = finders.new_table({
        results = tasks,
        entry_maker = make_entry(display),
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry().value
          taskfile.run_task(selection)
        end)
        return true
      end,
    })
    :find()
end

return M
