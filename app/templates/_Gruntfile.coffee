#global module:false
LIVERELOAD_PORT = 35729
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
livereloadMiddleware = (connect, options) ->
  [lrSnippet, connect.static(options.base), connect.directory(options.base)]

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    # Metadata.
    pkg: grunt.file.readJSON("package.json")
    connect:
      client:
        options:
          port: 9001
          base: "app/compile"
          keepalive: true
          middleware: livereloadMiddleware

    jade:
      compile:
        options:
          pretty: true
          data:
            debug: false

        files: [
          cwd: "app/jade"
          src: [ "**/*.jade", "!**/_shared/*.jade" ]
          dest: "app/compile"
          expand: true
          ext: ".html"
        ]

    watch:
      options:
        livereload: true

      templates:
        files: ["jade/*.jade"]
        tasks: ["jade"]

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-jade"

  grunt.registerTask "server", "connect"
  grunt.registerTask "default", "watch"
