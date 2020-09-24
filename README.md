# Readme

### What does this Block do for me?

**(1) Analyze DialogFlow Efficiency** - Provides visibility into DialogFlow application performance so that you can identify the frequency and type of user queries that are being resolved inefficiently and remediate those interactions accordingly.

**(2) Understand User Behavior** - Provides insight into the topics that users most frequently ask questions about, the nature of how their questions are phrased, and their satisfaction with answers so that you can fine-tune your interactions to maximize customer satisfaction.

### Block Info

This block is modeled on the DialogFlow schema. Each record is parsed to extract the content as well as metadata of a human interaction with the bot. For telephonic interactions, additional metadata, such as the Area Code and Trace are extracted.

### DialogFlow Raw Data Structure

Human interactions with the bot are initially extracted as a payload, which can be converted into a JSON format. Each payload contains all the information about that chat.

### DialogFlow Block Structure

The DialogFlow block consists of an Explore with three underlying views.

**(1) Parsed Transcripts View**

This view creates a Persistent Derived Table which extracts all the data about an interaction from the DialogFlow payload into a JSON object. That JSON is then parsed to extract the content, as well as characteristics, of that interaction, which form the dimensions and measures of the view.

**(2) Session Facts View**

The session_id associated with an interaction is part of the DialogFlow payload. In order to understand the context of the session in which an interaction occurred, a Persistent Derived Table is created that captures the characteristic of that session, such as its start and end time as well as the overall session duration.

**(3) Parameters View**

This view is used to define any custom variables as well as their values that are logged as part of a specific DialogFlow deployment.

### Implementation Instructions / Required Customizations

**(1) Schema and Table Name in parsed_transcripts View**

On line 82 of the parsed_transcripts view file, you'll need to replace the schema and table name in the FROM statement to reflect the schema and table names for where the DialogFlow transcripts are stored.

**(2) Custom Variables**

Within the parameters_view, you'll need to add any custom dimensions that you'd like to track with a dimension declaration. An example that extracts the custom dimension country from a parameter called 'geo-country' is shown below:

dimension: country {
  type: string
  sql: (SELECT json_extract_scalar(parameters, '$.value.string_value') from UNNEST([${TABLE}]) WHERE ${key} = 'geo-country');;
}

### What if I find an error? Suggestions for improvements?

Great! Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommentation, simply create a "New Issue" in the corresponding [Github repo for this Block](https://github.com/llooker/dialogflow/issues). Please be as detailed as possible in your explanation, and we'll address it as quick as we can.
