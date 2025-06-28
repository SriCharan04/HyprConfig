local fn = vim.fn
local version = vim.version
local M = {}

--- Check if an executable exists
--- @param name string An executable name/path
--- @return boolean
function M.executable(name)
  return fn.executable(name) > 0
end

--- Create a dir if it does not exist
function M.may_create_dir(dir)
  local res = fn.isdirectory(dir)

  if res == 0 then
    fn.mkdir(dir, "p")
  end
end

--- check whether a feature exists in Nvim
--- @return boolean
M.has = function(feat)
  if fn.has(feat) == 1 then
    return true
  end

  return false
end

--- check if we are inside a git repo
--- @return boolean
function M.inside_git_repo()
  local result = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
  if result.code ~= 0 then
    return false
  end

  -- Manually trigger a special user autocmd InGitRepo (used lazyloading.
  vim.cmd([[doautocmd User InGitRepo]])

  return true
end

return M
