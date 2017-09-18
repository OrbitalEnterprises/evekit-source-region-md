# evekit-source-region-md
Retrieve market data and market history snapshots from regions

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

## Install

These instructions assume you have configured the above Maven configuration properties in a Maven profile.

```bash
mvn -P <maven profile> package
./install.sh <install directory>
```

## Configuration

The driver expects a configuration JSON format configuration file, a sample of which is provided in
the file `config.json.sample`.  This file consists of a single JSON object with the following fields:

* `tool_home` - The install directory passed to the install script.
* `source_id` - Your EveKit data platform source ID.
* `structures` - A list of structure IDs to retrieve.
* `tmp_dir` - A directory with sufficient space for staging market data downloads.
* `snapshot_dir` - A directory where market data snapshots should be stored.
* `token_id` - Your EveKit ESI token ID.

Each snapshot file will be stored in a file at path:

```bash
${snapshot_dir}/<structure ID>/structure_<structureID>_<snaptimeInMillisUTC>_<YYYYMMDD>.csv.gz

```
