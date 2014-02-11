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

    sass:
      dist:
        files:
          "app/compile/css/application.css": "app/sass/application.sass"

    copy:
      bower:<% if (cssreset == 'normalize') { %>
        src: 'bower_components/normalize-css/normalize.css'
        dest: 'app/compile/css/normalize.css'<% } %><% if (cssreset == 'meyer') { %>
        src: 'bower_components/reset-css/reset.css'
        dest: 'app/compile/css/reset.css'<% } %>

    watch:
      options:
        livereload: true

      templates:
        files: ["jade/*.jade"]
        tasks: ["jade"]

      css:
        files: "sass/*.sass"
        tasks: ["sass"]

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-copy"

  grunt.registerTask "server", "connect"
  grunt.registerTask "default", "watch"
