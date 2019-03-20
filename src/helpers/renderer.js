import React from 'react';
import { renderToString } from 'react-dom/server';
import { Provider } from 'react-redux';
import { StaticRouter } from 'react-router-dom';

import Router from '../client/Routes';

export default (req, store) => {
	const content = renderToString(
		<Provider store={store}>
			<StaticRouter location={req.path} context={{}}>
				<Router />
			</StaticRouter>
		</Provider>
	);

	return `
		<html>
			<head></head>
			<body>
				<div id="root">${content}</div>
				<script src="bundle.js"></script>
			</body>
		</html>
	`;
}
