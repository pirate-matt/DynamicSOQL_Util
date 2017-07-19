# Pirate_Util_SOQL
An apex utility class (and related test class) that has some utility methods that are tremendously useful when dealing with dynamic SOQL.


### Latest Update Notes

Okay so this is a large structural change, but not an overly large content change. The basic overview looks like:

* Adding in structure to use Salesforce Migration Tools, to allow for better development, testing, etc.
* Moved and renamed actual utility file names.
* Made comments less verbose
* Added input sanitization using `String.escapeSingleQuotes( .. )` as recommended by the [docs](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dynamic_soql.htm?search_text=dynamic%20soql).
* Added List/Set `encode` support.


### @FUTURE

_Notes on what's up next (if anything)._



---



# Usage

It's got an MIT license, so you can pretty much do what you want. My recommendation is twofold:

1. **Using this as a tool inside a Salesforce Project.**
    * Get a copy of the file. (git clone/pull, copy-pasta, whatever)
    * Rename the class to follow whatever your naming conventions are.
    * I'd just ask that you leave in the link back to this repo.
      * The attribution is nice.
      * It's a big help to future people picking up your project if there are ever updates to this thing.
1. **Contributing**
    * Get a clean developer edition. (Use the [signup link](https://developer.salesforce.com/).)
    * Follow the [Setup](#setup) to get your local tools in order.
    * Run `ant deployUtil` from the `/pirate-scripts` directory to make sure all's in order. (You may need to manually create the classes in salesforce first.)
    * Develop
      * _remotely_ w/ the _Developer Console_ and "retrieve" to your local, or
      * _locally_ w/ your _favorite editor_ and "deploy" to salesforce.
    * Use your git tools on your local.
    * Submit a pull request or something. _No one's done this yet, so be the first I guess._




---



# Setup

_How to connect your local machine to a remote salesforce instance._

> :warning: Note these instructions are Mac based.

### Some prework

_(Note this involves knowing how to brew... see [this](https://brew.sh/) for info if you are unfamiliar.)_
1. Get java installed `brew cask install java` _(installs an sdk version)_
1. Get ant installed `brew install ant`

The repo includes a copy of the **Salesforce Migration Tool** for the 39th API version. If you need a different version, you can find one [here](https://developer.salesforce.com/page/Force.com_Migration_Tool#Force.com_Migration_Tool_Download).


### Using the Ant Scripts

1. Copy the [`sanitized-build.properties`](/tools_salesforce_ant_39.0/pirate-scripts/sanitized-build.properties) file into a new file named: `build.properties`.
    1. Edit the file with your access credentials.
    1. _(You may need to append your security token to your password.)_
1. Navigate to `/tools_salesforce_ant_39.0/pirate-scripts/`
1. Run `ant -p` to see what commands you can run.
    1. `ant deployUtil` - _takes what's specified in `/src/package.xml` and sends it to the salesforce instance behind the configured credentials._
    1. `ant retrieveUtil` - _pulls what's specified in `/src/package.xml` and saves it to your local `/src` directory._


### Adding a File, Setting, Etc.

You will need to manually update the [`package.xml`](/src/package.xml) file found in the [`/src`](/src) directory.

You can see a list of the supported metadata types in [this documentation](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_types_list.htm).




---



# Testing

`Pirate_Util_SOQL_TEST` is the test class for `Pirate_Util_SOQL`.

It's salesforce running tests is pretty well documented.  I recommend opening the test class in the _Developer Console_ and selecting the `Run Test` button. Results show up in the bottom right of the panel.

Write good tests.  Shoot for 100% test coverage for any new code.
