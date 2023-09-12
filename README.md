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
* `duration`: Episode length (in seconds).
* `description`: Episode description.
* `show`: Show to which episode belongs ([Armchair Anonymous](https://armchairexpertpod.com/armchair-anonymous), [Armchaired & Dangerous](https://armchairexpertpod.com/armchaired-dangerous), [Flightless Bird](https://armchairexpertpod.com/flightless-bird), [Monica & Jess Love Boys](https://armchairexpertpod.com/monica-jess-love-boys), [Race to 270](https://armchairexpertpod.com/race-to-270), Race to 35, [Synced](https://armchairexpertpod.com/synced), or [We Are Supported By...](https://armchairexpertpod.com/we-are-supported-by)), if applicable.

Finally, I save the R session information to [`episodes.log`](episodes.log).

## License

CC0
