typeset -A config
config=(
  [gitrepo]="https://github.com/nnamtug/rdf-autopublishing"
  [graphdb]="http://graphdb-auto-publisher:7200"
  [modelpath]="model"
  [repo_prod]="prod"
  [repo_staging]="staging"
  [graph_prod]="http://example.org/autoupload"
)

typeset -A config_modelfolders
config_modelfolders=(
  [0]="."
  [1]="things"
  [2]="things/persons"
)
