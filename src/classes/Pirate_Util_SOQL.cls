/*
 * @author [piratematt](https://github.com/pirate-matt)
 * @repo https://github.com/pirate-matt/Pirate_Util_SOQL
 * @license https://github.com/pirate-matt/Pirate_Util_SOQL/blob/master/LICENSE
 *
 * @description  Utility class that has some convenient utility methods when dealing with dynamic SOQL.
 * */
public class Pirate_Util_SOQL {


    // -------------------------------- STATIC PROPERTIES --------------------------------
    // (I mean... it's a utility class, it should all be static)

    static public Time DAYS_START_TIME = Time.newInstance( 0, 0, 0, 0 );




    // -------------------------------- SELECT CLAUSE METHODS --------------------------------
    // (Mostly convenience methods, with one workhorse that sanitizes input & joins)


    /*
     * @description Convenience method that accepts a Set, rather than a List.
     * */
    static public String formSelectClause ( Set<String> fieldNames ) {
        return formSelectClause( new List<String>( fieldNames ) );
    }

    /*
     * @description Using provided list of field names, forms a select clause.
     * */
    static public String formSelectClause ( List<String> fieldNames ) {
        return 'SELECT ' + prepFieldNamesForSelectClause( fieldNames );
    }


    /*
     * @description Convenience method that accepts a Set, rather than a List.
     * */
    static public String prepFieldNamesForSelectClause ( Set<String> fieldNames ) {
        return prepFieldNamesForSelectClause( new List<String>( fieldNames ) );
    }

    /*
     * @description Protecting against SOQL Injection, forms the comma separated list of
     * */
    static public String prepFieldNamesForSelectClause ( List<String> fieldNames ) {
        List<String> sanitizedNames = new List<String>();

        for ( String fieldName : fieldNames ) {
            sanitizedNames.add( String.escapeSingleQuotes( fieldName ) );
        }

        return String.join( sanitizedNames, ',' );
    }




    // -------------------------------- ENCODE METHODS --------------------------------
    // (these methods return properly encoded strings for the various data types)
    // (Mostly convenience methods, with a few workhorse methods)

    
    // ---------------- DATETIME ----------------

    /*
     * @description Returns an encoded string for the provided Datetime object.
     * */
    static public String encode ( Datetime providedDatetime ) {
        return providedDatetime.format( 'yyyy-MM-dd\'T\'hh:mm:ss\'Z\'' );
    }

    /*
     * @description Accepts Datetime objects, and returns an encoded string for only the Date infomration.
     * */
    static public String encodeAsDate ( Datetime providedDatetime ) {
        return providedDatetime.format( 'yyyy-MM-dd' );
    }

    
    // ---------------- DATE ----------------

    /*
     * @description Utilizes the build in formatting for Datetime objects & returns an encoded string for the provided Date object.
     * */
    static public String encode ( Date providedDate ) {
        return encodeAsDate( Datetime.newInstance( providedDate, DAYS_START_TIME ) );
    }

    /*
     * @description  Accepts Date objects, and returns an encoded string for a representative datetime object.  NOTE representative 
     *               datetime object is considered of the same date at the very start of the day 00:00:00.
     * */
    static public String encodeAsDatetime ( Date providedDate ) {
        return encode( Datetime.newInstance( providedDate, DAYS_START_TIME ) );
    }

    
    // ---------------- LISTS ----------------
    // (Note )
    
    /*
     * @description Convenience method that accepts a Set, rather than a List.
     * */
    static public String encode ( Set<Object> providedSet ) {
        return encode( new List<Object>( providedSet ) );
    }
    
    /*
     * @description Converts the provided list of Objects into the format required by dynamic soql.
     * 
     *              NOTE: this method is typically called with Ids or Strings, as each object must be converted to a String for both 
     *                    sanitization and dynamic SOQL. Using other object types may experience unexpected results.
     * */
    static public String encode ( List<Object> providedList ) {
        List<String> convertedAndSanitized = new List<String>();
        
        for ( Object obj : providedList ) {
            String converted = String.valueOf( obj );
            convertedAndSanitized.add( String.escapeSingleQuotes( converted ) );
        }
        
        return '(\'' + String.join( convertedAndSanitized, '\',\'' ) + '\')';
    }

}