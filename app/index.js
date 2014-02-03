'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var YogurtGenerator = module.exports = function YogurtGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(YogurtGenerator, yeoman.generators.Base);

YogurtGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.
  console.log(this.yeoman);

  var prompts = [{
    type: 'confirm',
    name: 'someOption',
    message: 'Would you like to enable this option?',
    default: true
  }];

  this.prompt(prompts, function (props) {
    this.someOption = props.someOption;

    cb();
  }.bind(this));
};

YogurtGenerator.prototype.app = function app() {
  this.mkdir('app');

  // Jade templates
  this.mkdir('app/jade');
  this.mkdir('app/jade/_shared');

  this.copy('jade/index.jade', 'app/jade/index.jade');
  this.copy('jade/catalog.jade', 'app/jade/catalog.jade');
  this.copy('jade/_shared/_first.jade', 'app/jade/_shared/_first.jade');
  this.copy('jade/_shared/_second.jade', 'app/jade/_shared/_second.jade');

  this.copy('_package.json', 'package.json');
  this.copy('_bower.json', 'bower.json');
};

YogurtGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
