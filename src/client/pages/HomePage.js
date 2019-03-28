import React from 'react';

const HomePage = () => {
	return (
		<div>
			<div>I am the home page</div>
			<button onClick={() => console.log('hi there')} >Click</button>
		</div>
	)
};

export default {
	component: HomePage,
};
