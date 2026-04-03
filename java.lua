local javafx = os.getenv("HOME") .. "/module/javafx/lib/"
local modules = os.getenv("HOME") .. "/module/"

local root_dir = vim.fs.root(0, {
  ".git",
  "mvnw",
  "gradlew",
  "build.gradle",
  ".project",
  ".classpath",
  ".pom.xml",
})

local root_name = vim.fn.fnamemodify(root_dir, ":t")

local workspace_dir = "/home/kellyy/.local/share/java/workspace/" .. root_name

local config = {
  name = "jdtls",

  cmd = {
    "jdtls",
    "-data",
    workspace_dir,
  },

  root_dir = root_dir,
  -- root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

  settings = {
    java = {
      configurations = {
        runtimes = {
          {
            name = "JavaSE-25",
            path = "/home/kellyy/.sdkman/candidates/java/current",
          },
        },
      },

      project = {
        referencedLibraries = {
          --most just causinf bloat, not optimal to have all
          -- javafx .. "javafx.base.jar",
          javafx .. "javafx.controls.jar",
          javafx .. "javafx.fxml.jar",
          -- javafx .. "javafx.graphics.jar",
          -- javafx .. "javafx.media.jar",
          -- javafx .. "javafx.swing.jar",
          -- javafx .. "javafx.swt.jar",
          -- javafx .. "javafx.web.jar",
          modules .. "hikaricp.jar",
          -- modules .. "slf4j.jar",
          modules .. "mariadb.jar",
          modules .. "sqlite.jar",
        },

        sourcePaths = {
          "src/main/java", --for import resolution of both java and test java files,
          "src/test/java",
          "src/main/resources", --automaic build saves a lot of time, say images will be copied to output (auto)
          "sauce/", --for non projects that still use imports,
        },

        -- outputPath = "out",
      },

      referencesCodeLens = {
        enabled = true,
      },
    },
  },
}

--java test configuration and java debug
local bundles = {
  vim.fn.glob(
    os.getenv("HOME")
      .. "/.local/share/java/javadebug/extension/server/debug/com.microsoft.java.debug.plugin-0.53.2.jar"
  ),
}

local java_test_bundles =
  vim.split(vim.fn.glob(os.getenv("HOME") .. "/.local/share/java/javadebug/extension/server/*.jar", 1), "\n")
local excluded = {
  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
  "jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ":t")
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end

config["init_options"] = {
  bundles = bundles,
}

require("jdtls").start_or_attach(config)
