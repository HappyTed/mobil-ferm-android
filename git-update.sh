#!/usr/bin/env bash
git pull
git submodule update --init --recursive
git pull --recurse-submodule