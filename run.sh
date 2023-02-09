#!/bin/bash

set -e

for experiment in 'key_value_stores'; do
  ./$experiment/run_benchmarks.rb > ./$experiment/report.txt
done
