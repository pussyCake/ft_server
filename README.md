# ft_server

##### BUILD THE IMAGE :
``$> docker build -t test .``
##### RUN IMAGE AS A CONTAINER :
``$> docker run -it -p 80:80 -p 443:443 test``
##### PRINT LIST OF CONTAINERS :
``$> docker ps -a``
##### TO RUN A COMMAND IN A RUNING CONTAINER :
``$> docker exec -ti [container's name] bash``
##### AUTOINDEX ON :
``$> ./srcs/index_on.sh``
##### AUTOINDEX OFF :
``$> ./srcs/index_off.sh`` 
##### STOP A CONTAINER :
``$> docker stop [container's name]``
