#!/bin/bash
_cassandra_version=$1
_cassandra_tag=$2
_release_build=false

if [ -z "${_cassandra_version}" ]; then
	source CASSANDRA_VERSION
	_cassandra_version=$CASSANDRA_VERSION
	_cassandra_tag=$CASSANDRA_VERSION
	_release_build=true
fi

echo "CASSANDRA_VERSION: ${_cassandra_version}"
echo "DOCKER TAG: ${_cassandra_tag}"
echo "RELEASE BUILD: ${_release_build}"

docker build --build-arg CASSANDRA_VERSION=${_cassandra_version} --tag "stakater/cassandra:${_cassandra_tag}"  --no-cache=true .

if [ $_release_build == true ]; then
	docker build --build-arg CASSANDRA_VERSION=${_cassandra_version} --tag "stakater/cassandra:latest"  --no-cache=true .
fi
