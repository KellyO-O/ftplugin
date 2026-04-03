local dap = require("dap")

dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Launch Java Fx",
    vmArgs = "" .. os.getenv("fx"),
  },
}
