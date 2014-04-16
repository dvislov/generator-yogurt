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

    autoprefixer:
      single_file:
        options:
          browsers: ["last 2 version", "> 1%", "ie 8", "ie 7"]

        src: "app/compile/css/application.css"
        dest: "app/compile/css/application.css"

    bowercopy:
      options:
        runBower: false
      css:
        options:
          destPrefix: "app/compile/css"
        files:
          <% if (cssreset == 'normalize') { %>'normalize.css': 'normalize-css/normalize.css'<% } %>
          <% if (cssreset == 'meyer') { %>'reset.css': 'reset-css/reset.css'<% } %>
      <% if (needJs) { %>
      js:
        options:
          destPrefix: "app/compile/js"
        files:
          <% if (jquery) { %>'jquery.min.js': 'jquery/dist/jquery.min.js'<% } %>
      <% } %>

    <% if (datauri) { %>datauri:
      default:
        options:
          classPrefix: "data-"
        src: ["app/compile/img/base64icons/*"]
        dest: ["app/sass/base64.sass"]
    <% } %>

    csso:
      compress:
        options:
          report: 'min'
        files:
          'app/production/css/application.css' : ['app/production/css/application.css']

    imagemin:
      dynamic:
        files: [
          expand: true
          progressive: true
          interlaced: true
          optimizationLevel: 3
          pngquant: true
          cwd: 'app/compile/img'
          src: ['**/*.{png,jpg,gif}']
          dest: 'app/production/img'
        ]

    concat_css:
      all:
        src: 'app/compile/css/**/*.css'
        dest: 'app/production/css/application.css'

    watch:
      options:
        livereload: true

      templates:
        files: ["app/jade/*.jade"]
        tasks: ["jade"]

      css:
        files: "app/sass/*.sass"
        tasks: ["sass", "autoprefixer"]

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-bowercopy"
  grunt.loadNpmTasks "grunt-autoprefixer"
  grunt.loadNpmTasks "grunt-contrib-imagemin"
  grunt.loadNpmTasks "grunt-csso"
  grunt.loadNpmTasks "grunt-concat-css"

  <% if (datauri) { %>grunt.loadNpmTasks "grunt-datauri"<% } %>

  grunt.registerTask "make_production", ["concat_css", "csso", "imagemin"]

  grunt.registerTask "server", "connect"
  grunt.registerTask "default", "watch"
