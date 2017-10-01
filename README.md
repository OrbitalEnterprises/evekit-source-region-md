# evekit-source-region-md
Retrieve order book data and market history snapshots from all EVE regions.

This package consists of a Java program which is used to track snapshot retrieval
status (against a database), as well as a series of scripts which perform the actual
retrieval.  The tracking mechanism is part of the EveKit Data Platform.
See the [EveKit Data Platform github project](https://github.com/OrbitalEnterprises/evekit-data-platform)
for more details.

These tools are intended to be run in a UNIX-like environment with the following dependencies:

* A standard UNIX environment with bash and other common command line tools
* Java 8 or better
* The [`jq` command line JSON processor](https://stedolan.github.io/jq/)

We've tested these tools on Linux (Ubuntu) and MacOS.  We believe these tools will also work with little difficulty
on Windows with Cygwin.

## Build Configuration

The executable jar produced by this package expects the following Maven configuration settings which can
be set at install time or, more typically, in your Maven profile:

* `enterprises.orbital.token.eve_client_id` - Your EVE SSO application client ID to be used to re-authorize ESI tokens.
* `enterprises.orbital.token.eve_secret_key` - Your EVE SSO application secret key to be used to re-authorize ESI tokens.
* `enterprises.orbital.evekit.dataplatform.db.account.url` - The MySQL connection URL for EveKit account information.
* `enterprises.orbital.evekit.dataplatform.db.account.user` - The EveKit account database user name.
* `enterprises.orbital.evekit.dataplatform.db.account.password` - The EveKit account database password.
* `enterprises.orbital.evekit.dataplatform.db.registry.url` - The MySQL connection URL for the data platform.
* `enterprises.orbital.evekit.dataplatform.db.registry.user` - The data platform database user name.
* `enterprises.orbital.evekit.dataplatform.db.registry.password` - The data platform database password.

All other Maven configuration properties have suitable defaults defined in `pom.xml`.

*NOTE:* the ESI does not currently require authentication for regional order book and history data.  Therefore, it is not
necessary to set a proper client ID and key in the above configuration.  These values are still required by the
underlying libraries, but they can be set to dummy values as they are not used.

## Install

These instructions assume you have configured the above Maven configuration properties in a Maven profile.

```bash
mvn -P <maven profile> package
./install.sh <install directory>
```

## Configuration

The two driver scripts expects a configuration JSON format configuration file, a sample of which is provided in
the file `config.json.sample`.  This file consists of a single JSON object with the following fields:

* `tool_home` - The install directory passed to the install script.
* `source_id` - Your EveKit data platform source ID.
* `tmp_dir` - A directory with sufficient space for staging market data downloads.
* `snapshot_dir` - A directory where market data snapshots should be stored.
* `threads` - The number of separate market history download processes to run.
* `cycle_time_marketdata` - The number of minutes between successive download cycles for market history.
* `cycle_time_orderbook` - The number of minutes between successive download cycles for order book data.

## Running the Tools

Market history snapshots can be retrieved by running `markethistory_driver` as follows:

```bash
$ markethistory_driver config.json
```

This script will use the [EVE Swagger Interface (ESI)](https://esi.tech.ccp.is/latest/) to download the current
set of regions and the current market types in each region; then download market history for each
region and market type pair.  Setting the `threads` configuration parameter controls download parallelism
(that is, the number of simulataneous region/market type pair downloads).  Once all history data has
been retrieved, the script will sleep so that the next download cycle doesn't begin sooner than
`cycle_time_marketdata` minutes from the start of the last cycle.

We recommend setting `threads` to 20 and `cycle_time_marketdata` to 1200.  This will therefore download complete history
at least once every 20 hours.

Market history files will be stored in a file at path:

```bash
${snapshot_dir}/history/<typeID>/history_<snaptimeInMillisUTC>_<regionID>_<YYYYMMDD>.gz

```

Order book snapshots can be retrieved by running `orderbook_driver` as follows:

```bash
$ orderbook_drive config.json
```

This script downloads the current set of regions and spawns a separate thread to download order book snapshots
for each region.  Each download thread will retrieve the latest snapshot, store it to disk, then sleep so that
the next snapshot is not retrieved before `cycle_time_orderbook` minutes since the start of the previous
retrieval.

At present, the ESI caches order book data for 5 minutes.  Therefore, in order to retrieve every snapshot without
missing data, you should set `cycle_time_orderbook` to 5.

Order book files will be stored in a file at path:

```bash
${snapshot_dir}/regions/<regionID>/region_<snaptimeInMillisUTC>_<YYYYMMDD>.gz
```
