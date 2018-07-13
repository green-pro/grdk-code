#!/bin/bash

echo "STEP1 - START"

### GRDK-REPO (GITLAB)
SERVICES=$(docker service ls -q -f name=grdk-repo_web | wc -l)
if [[ "$SERVICES" -gt 0 ]]; then
	echo "GRDK-REPO - STACK DEPLOY skiped"
else
	echo "GRDK-REPO - RUN STACK DEPLOY"
	sed -e "s#{{ DK_SERVER_NODE_ROLE }}#${DK_SERVER_NODE_ROLE}#g" \
		-e "s#{{ DK_SERVER_IP }}#${DK_SERVER_IP}#g" \
		-e "s#{{ DK_SERVER_INST_NFS }}#${DK_SERVER_INST_NFS}#g" \
		-e "s#{{ DK_LOGGER_HOST }}#${DK_LOGGER_HOST}#g" \
		-e "s#{{ DK_REPO_HOST }}#${DK_REPO_HOST}#g" \
		-e "s#{{ DK_REPO_NFS_HOST }}#${DK_REPO_NFS_HOST}#g" \
		-e "s#{{ DK_REPO_NFS_PATH }}#${DK_REPO_NFS_PATH}#g" \
		-e "s#{{ DK_REPO_DI_HOST }}#${DK_REPO_DI_HOST}#g" \
		< ./vendor/grdk-core/services/repo/docker-stack.yml \
		> ./vendor/grdk-core/services/repo/_docker-stack.yml
	docker stack deploy --compose-file  ./vendor/grdk-core/services/repo/_docker-stack.yml grdk-repo
	echo "Atencao: Aguarde a inicializacao completa do GRDK-REPO para prosseguir"
fi

echo "STEP1 - END"