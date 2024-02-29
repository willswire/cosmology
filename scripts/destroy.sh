#!/bin/bash

# it's safer to do this: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# destroy infrastructure
cd infrastructure
tofu destroy -auto-approve
