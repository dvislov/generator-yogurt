'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var YogurtGenerator = module.exports = function YogurtGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({
      skipInstall: options['skip-install'],
      callback: function () {
        var grunt_post_tasks = [];

        if (this.datauri) {
          grunt_post_tasks.push('datauri');
        }

        grunt_post_tasks.push('jade');
        grunt_post_tasks.push('sass');
        grunt_post_tasks.push('autoprefixer');
        grunt_post_tasks.push('bowercopy');

        this.spawnCommand('grunt', grunt_post_tasks);
      }.bind(this)
    });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(YogurtGenerator, yeoman.generators.Base);

YogurtGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.
  console.log(this.yeoman);

  var prompts = [{
    type: 'list',
    name: 'cssreset',
    message: 'Which CSS reset you want to use?',
    choices: [
      {
        name: 'Eric Meyer reset CSS 2.0',
        value: 'meyer'
      },
      {
        name: 'Normalize CSS',
        value: 'normalize'
      }
    ],
    default: 0
  },{
    type: 'checkbox',
    name: 'features',
    message: 'Change awesome features for your build',
    choices: [{
      name: 'jQuery',
      value: 'jquery'
    },{
      name: 'SASS Data URI',
      value: 'datauri'
    },{
      name: 'Ruble sign font',
      value: 'rublefont'
    }
    ,{
      name: 'Sticky footer',
      value: 'stickyfooter'
    },{
      name: 'Twitter Bootstrap 3 Grid',
      value: 'twbootstrapgrid'
    }
    ]
  }];

  this.prompt(prompts, function (props) {

    function hasFeature(feat) { return props.features.indexOf(feat) !== -1; }

    this.cssreset = props.cssreset;
    this.jquery = hasFeature('jquery');
    this.datauri = hasFeature('datauri');
    this.rublefont = hasFeature('rublefont');
    this.stickyfooter = hasFeature('stickyfooter');
    this.twbootstrapgrid = hasFeature('twbootstrapgrid');

    this.needJs = false;
    if (this.jquery) {this.needJs = true;};

    cb();
  }.bind(this));
};

YogurtGenerator.prototype.app = function app() {
  this.mkdir('app');

  // Jade templates
  this.directory('jade', 'app/jade', true);

  // Yeoman jade templating
  this.template('jade/_shared/_header.jade', 'app/jade/_shared/_header.jade');

  // SASS
  this.copy('sass/_partial.sass', 'app/sass/_partial.sass');
  this.template('sass/_application.sass', 'app/sass/application.sass');

  // Compile folders
  this.mkdir('app/compile/');
  this.mkdir('app/compile/js/');
  this.mkdir('app/compile/img/');
  this.mkdir('app/compile/fonts/');

  if (this.datauri) {
    this.directory('img/base64icons', 'app/compile/img/base64icons', true);
  }

  if (this.rublefont) {
    this.directory('fonts', 'app/compile/fonts', true);
  }

  if (this.twbootstrapgrid) {
    this.copy('css/bootstrap-grid.css', 'app/compile/css/bootstrap-grid.css');
  }

  this.copy('_package.json', 'package.json');
  this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
  this.copy('_bower.json', 'bower.json');
};

YogurtGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
