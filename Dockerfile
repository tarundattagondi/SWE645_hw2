FROM nginx:alpine

# (optional) remove the default nginx page
RUN rm -rf /usr/share/nginx/html/*

# copy everything in your repo (your .dockerignore will keep junk out)
COPY . /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
