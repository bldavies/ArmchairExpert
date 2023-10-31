# ArmchairExpert

ArmchairExpert is an R package containing data on [*Armchair Expert*](https://armchairexpertpod.com) podcast episodes.
It provides these data via a single table: `episodes`.

## Workflow

[`data-raw/episodes.R`](data-raw/episodes.R) queries the [Spotify API](https://developer.spotify.com/documentation/web-api) for data on each episode.
It authenticates with the API using the credentials stored in `credentials.yaml`.
This file has form

```yaml
client_id: xxxxx
secret: xxxxx
```

I store each episode's data in `data-raw/episodes/`.
I combine these data into a single table, which I export to [`data-raw/episodes.csv`](data-raw/episodes.csv) and `data/episodes.rda`.

## License

CC0
