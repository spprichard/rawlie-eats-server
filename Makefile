build:
	swift build -c release

run:
	build
	



deploy-project:
	scp -i ~/.ssh/rawlie-eats-do -r ./* root@$(SERVER_IP):~/server