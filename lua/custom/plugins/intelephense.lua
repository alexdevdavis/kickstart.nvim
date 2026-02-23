return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      intelephense = {
        root_dir = function(fname)
          local util = require 'lspconfig.util'
          local path = type(fname) == 'string' and fname or vim.api.nvim_buf_get_name(0)
          if path == "" then path = vim.uv.cwd() end
          
          -- Prioritize WordPress root
          local wp_root = util.root_pattern('wp-config.php')(path)
          if wp_root then
             return wp_root
          end
          -- Fallback to standard markers
          return util.root_pattern('.git', 'composer.json')(path) or util.path.dirname(path)
        end,
        settings = {
          intelephense = {
            stubs = { 'wordpress', 'wordpress-globals', 'wordpress-stubs', 'apache', 'bcmath', 'bz2', 'calendar', 'Core', 'curl', 'date', 'dom', 'fileinfo', 'filter', 'gd', 'gettext', 'hash', 'iconv', 'imap', 'intl', 'json', 'libxml', 'mbstring', 'mcrypt', 'mysqli', 'mysqlnd', 'openssl', 'pcntl', 'pcre', 'PDO', 'pdo_mysql', 'pdo_sqlite', 'Phar', 'posix', 'readline', 'Reflection', 'session', 'shmop', 'SimpleXML', 'soap', 'sockets', 'sodium', 'SPL', 'sqlite3', 'standard', 'superglobals', 'sysvmsg', 'sysvsem', 'sysvshm', 'tokenizer', 'xml', 'xmlreader', 'xmlwriter', 'xsl', 'zip', 'zlib' },
            files = { maxSize = 5000000 },
            telemetry = { enabled = false },
          },
        },
      },
    },
  },
}
