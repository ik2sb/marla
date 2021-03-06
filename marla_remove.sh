 #!/bin/bash

# MARLA - MApReduce on AWS Lambda
# Copyright (C) GRyCAP - I3M - UPV 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. 


if [ $# -ne 2 ]; then
  echo "Usage: $0 region cluster-name"
  exit -1
fi

REGION=$1
CLUSTERNAME=$2

rm $HOME/.marla/$CLUSTERNAME/stderr &> /dev/null
if aws lambda delete-function --region $REGION --function-name HC-$CLUSTERNAME-lambda-mapper
then
    echo "Mapper function removed from cluster '$CLUSTERNAME'"
else
    echo "Error removing mapper function from cluster '$CLUSTERNAME'"
    more $HOME/.marla/$CLUSTERNAME/stderr
    exit 1
fi

rm $HOME/.marla/$CLUSTERNAME/stderr &> /dev/null
if aws lambda delete-function --region $REGION --function-name HC-$CLUSTERNAME-lambda-reducer
then
    echo "Reducer function removed from cluster '$CLUSTERNAME'"
else
    echo "Error removing reducer function from cluster '$CLUSTERNAME'"
    more $HOME/.marla/$CLUSTERNAME/stderr
    exit 1
fi


rm $HOME/.marla/$CLUSTERNAME/stderr &> /dev/null
if aws lambda delete-function --region $REGION --function-name HC-$CLUSTERNAME-lambda-coordinator
then
    echo "Coordinator function removed from cluster '$CLUSTERNAME'"
else
    echo "Error removing coordinator function from cluster '$CLUSTERNAME'"
    more $HOME/.marla/$CLUSTERNAME/stderr
    exit 1
fi

rm -r $HOME/.marla/$CLUSTERNAME &> /dev/null
