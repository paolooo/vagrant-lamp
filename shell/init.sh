#!/bin/bash

echo "Hello!, Let's start"

echo "[CentOS] Yum cleaners..."
yum clean headers
yum clean packages
yum clean metadata
# yum install yum-plugin-fastestmirror
