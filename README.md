**NOTE: This block requires exporting Dialogflow Log Files to BigQuery via Stackdriver. Please [review the step-by-step guide](https://github.com/GoogleCloudPlatform/dialogflow-integrations/tree/master/stacklogs-looker) and ensure the following is complete before attempting to use this block:**
1. Created a Dialogflow Agent
2. Created a BigQuery Dataset to hold Dialogflow Stackdriver Logs and Looker Persistent Derived Table
3. Created a StackDriver Sink Export to BigQuery

___
# Readme

### What does this Block do for me?

**(1) Analyze Dialogflow Efficiency** - Provides visibility into Dialogflow application performance so that you can identify the frequency and type of user queries that are being resolved inefficiently and remediate those interactions accordingly.

**(2) Understand User Behavior** - Provides insight into the topics that users most frequently ask questions about, the nature of how their questions are phrased, and their satisfaction with answers so that you can fine-tune your interactions to maximize customer satisfaction.

### Block Info

This block is modeled on the Dialogflow schema. Each record is parsed to extract the content as well as metadata of a human interaction with the bot. For telephonic interactions, additional metadata, such as the Area Code and Trace are extracted.

### Dialogflow Raw Data Structure

Human interactions with the bot are initially extracted as a payload, which can be converted into a JSON format. Each payload contains all the information about that chat.

### Dialogflow Block Structure

The Dialogflow block consists of an Explore with three underlying views.

**(1) Parsed Transcripts View**

This view creates a Persistent Derived Table which extracts all the data about an interaction from the Dialogflow payload into a JSON object. That JSON is then parsed to extract the content, as well as characteristics, of that interaction, which form the dimensions and measures of the view.

**(2) Session Facts View**

The session_id associated with an interaction is part of the Dialogflow payload. In order to understand the context of the session in which an interaction occurred, a Persistent Derived Table is created that captures the characteristic of that session, such as its start and end time as well as the overall session duration.

**(3) Parameters View**

This view is used to define any custom variables as well as their values that are logged as part of a specific Dialogflow deployment.

### Implementation Instructions
This block is installed via the Looker Marketplace. For more information about the Looker Marketplace, please visit this [link](https://docs.looker.com/data-modeling/marketplace).

#### Constants ####
During installation you will provide two values to populate the following constants:
* Connection Name - the Looker connection with access to and permission to retrieve data from your exported dialogflow tables.
* Schema - the schema name for your exported data.
* Table Partition - Table Partition Name (If Applicable).

#### Customization ####
- This block uses Refinements to allow for modification or extension of the LookML content. For more information on using refinements to customize marketplace blocks, please see [this documentation](https://docs.looker.com/data-modeling/marketplace/customize-blocks).

**Custom Variables**

Using the refinements file, you'll be able to add any custom dimensions that you'd like to track with a dimension declaration. An example that extracts the custom dimension country from a parameter called 'geo-country' is shown below:

```
view +parsed_transcripts {
dimension: country {
  type: string
  sql: (SELECT json_extract_scalar(parameters, '$.value.string_value')
    FROM UNNEST([${TABLE}]) WHERE ${key} = 'geo-country');;
}}
```
