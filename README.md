```
cat ~/slug.tgz | docker run --rm -i -p 9005:5000 slugr:dev bash -c "tar -xz -C ../ && /start web"
```
