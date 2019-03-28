import React, { Component } from 'react';
import { connect } from 'react-redux';
import { fetchUsers } from '../actions';

class UsersListPage extends Component {
	componentDidMount() {
		this.props.fetchUsers()
	}

	renderUsers() {
		return this.props.users.map(user =>
			<li key={user.id}>{user.name}</li>
		)
	}

	render() {
		return (
			<div>
				Here is a list of users:
				<ul>{this.renderUsers()}</ul>
			</div>
		)
	}
}

function mapStateToProps(state) {
	return { users: state.users }
}

const loadData = (store) => {
	return store.dispatch(fetchUsers())
};

const connected = connect(
	mapStateToProps,
	{ fetchUsers }
)(UsersListPage)

export default {
	loadData,
	component: connected
}
