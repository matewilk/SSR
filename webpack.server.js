const path = require('path');
const merge = require('webpack-merge');
const baseConfig = require('./webpack.base');
const webpackNodeExternals = require('webpack-node-externals');

const config = {
	// Inform webpack it's node.js app
	target: 'node',

	// Tell webpack the root file of our server app
	entry: [
		'babel-polyfill',
		'./src/index.js'
	],

	// Tell webpack where to put the output file
	output: {
		filename: 'bundle.js',
		path: path.resolve(__dirname, 'build')
	},

	// Do not bundle what's in node_modules
	externals: [webpackNodeExternals()]
};

module.exports = merge(baseConfig, config);
