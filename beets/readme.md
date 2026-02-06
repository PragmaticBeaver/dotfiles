# Beets Docker help

## commands

### Startup

Start beets

```bash
cd beets/
docker compose up --build
```

Open shell inside Docker-Container

```bash
docker exec -it -u abc beets bash
```

### Runtime commands

Edit config

```bash
beet config -e
```

View music library

```bash
beet ls
```

Update smart Playlists

```bash
beet splupdate
```

Update music genres

```bash
beet lastgenre
```
