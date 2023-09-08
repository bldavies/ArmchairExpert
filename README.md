# armchair-expert

This repository contains a list of [*Armchair Expert*](https://armchairexpertpod.com) podcast episodes.

## Workflow

[`episodes.R`](episodes.R) queries the [Spotify API](https://developer.spotify.com/documentation/web-api) for data on each episode.
It authenticates with the API using the credentials stored in `credentials.yaml`.
This file has form

```yaml
client_id: xxxxx
secret: xxxxx
```

I store each episode's data in `episodes/`.
I combine these data into a single table, which I export to [`episodes.csv`](episodes.csv).
This table has five columns:

* `id`: Episode ID on Spotify.
* `date`: Episode release date (in YYYY-MM-DD format).
* `title`: Episode title.
* `duration_ms`: Episode length (in milliseconds).
* `description`: Episode description.

Finally, I save the R session information to [`episodes.log`](episodes.log).

## License

C00
