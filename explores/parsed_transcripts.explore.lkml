include: "/views/*"


explore: parsed_transcripts_core {
  extension: required
  sql_preamble:   CREATE TEMP FUNCTION proto2json(prototext STRING, arrayKeys STRING)
      RETURNS STRING
      LANGUAGE js AS """

        /*TODO: maybe escape existing # in case it shows up in an unquoted key */

        /* Replace all strings with opaque reference to avoid matching inside them */
        var strings = []
        prototext = prototext.replace(
          /"([^"\\\\]*(\\\\.[^"\\\\]*)*)"/g,
          function(match){
            strings.push(match);
            return '#'+(strings.length-1)+' '
            }
          )

        /*Strip the leading type declaration*/
        prototext = prototext.replace(/^[A-za-z0-0 _]+\\s*:/,'');
        /* Add a colon between object key and abject */
        prototext = prototext.replace(/([a-zA-Z0-9_]+)\\s*\\{/g, function(match,m1){return m1+': {';});
        /* Add quotes around keys */
        prototext = prototext.replace(/([a-zA-Z0-9_]+):/g, function(match,m1){return '"'+m1+'" :';});
        /* Add commas between values */
        prototext = prototext.replace(/([0-9"}]|true|false)\\s*\\n\\s*"/g, function(match, m1){return m1+' ,\\n "';});

        /* If array keys, take matching keys and prep them to not collapse */
        if(arrayKeys){
          if(arrayKeys && !arrayKeys.match(/^[A-Za-z0-9_]+(,[A-Za-z0-9_]+)*$/)){
            throw "Only [A-Za-z0-9_] array keys are currently supported, delimited by commas"
          }
          arrayKeys = arrayKeys.split(',')
          var arrayKeyRegex = new RegExp('"('+arrayKeys.join('|')+')"','g')
          var counter=0
          prototext = prototext.replace(arrayKeyRegex,function(match,key){
            counter++
            return '"'+key+'#'+counter+'"'
            })
          }

        /* Replace string references with their original values*/
        prototext = prototext.replace(
          /#(\\d+) /g,
          function(match,m1){
            return strings[parseInt(m1)]
            }
          )
        var jsonish = '{'+prototext+'}'

         if(!arrayKeys){return jsonish}
        var obj
        try{
          /* Parse jsonish, but replace all key#n entries with arrays*/
          obj = JSON.parse(jsonish, function(key,objValue){
            if(typeof objValue !== "object"){return objValue}
            var returnValue = {}
            var entries = Object.entries(objValue)
            /* Entries should already come out in lexicographical order, but if not we could sort here */
            for(let [entryKey,entryVal] of entries){
              let [groupKey,n] = entryKey.split('#')
              if(n===undefined){
                returnValue[entryKey] = entryVal
                }
              else{
                returnValue[groupKey] = (returnValue[groupKey]||[]).concat(entryVal)
              }
            }
            return returnValue
          })
        }
        catch(e){return "JSON Error! "+e+"\\n"+jsonish}
        return JSON.stringify(obj,undefined,1)
      """; ;;
  sql_always_where: ${payload_type} = 'Dialogflow Response ' ;;
  join: parameters {
    view_label: "Custom Parameters"
    sql: LEFT JOIN UNNEST(${parsed_transcripts.parameters}) as parameters ;;
    relationship: one_to_one
  }
  join: session_facts {
    relationship: many_to_one
    sql_on: ${session_facts.session_id} = ${parsed_transcripts.session_id} ;;
  }
}
