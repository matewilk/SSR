import express from 'express';
import { matchRoutes } from "react-router-config";

import renderer from './helpers/renderer';
import createStore from './helpers/createStore';
import Routes from './client/Routes';

const app = express();

app.use(express.static('public'));

app.get('*', (req, res) => {
	const store = createStore();

	// Map over routes and call loadData if it exist
	const promises = matchRoutes(Routes, req.path).map(
		({ route }) =>
			route.loadData ? route.loadData(store) : null
	);

	Promise.all(promises).then(() =>
		res.send(renderer(req, store))
	)
});

app.listen(5000, () => {
	console.log('Listening on port 5000')
});
