/*
 * @author [piratematt](https://github.com/pirate-matt)
 * @repo https://github.com/pirate-matt/Pirate_Util_SOQL
 * @license https://github.com/pirate-matt/Pirate_Util_SOQL/blob/master/LICENSE
 *
 * @description  Test class for similarly named utilty class.
 * */
@isTest
public class Pirate_Util_SOQL_TEST {


    static testMethod void testSelectClauseFormers() {
        List<String> emptyList = new List<String>();
        Set<String>  emptySet = new Set<String>();

        List<String> knownList = new List<String>{ 'Name', 'CreatedDate', 'OwnerId' };
        Set<String>  knownSet = new Set<String> { 'Name', 'CreatedDate', 'OwnerId' };

        String expectedSelectClauseStart = 'SELECT ';
        String expectedFieldNameString = 'Name,CreatedDate,OwnerId';

        Test.startTest();
        // Test empty collections
        System.assertEquals( '', Pirate_Util_SOQL.prepFieldNamesForSelectClause( emptyList ) );
        System.assertEquals( '', Pirate_Util_SOQL.prepFieldNamesForSelectClause( emptySet ) );
        System.assertEquals( expectedSelectClauseStart, Pirate_Util_SOQL.formSelectClause( emptyList ) );
        System.assertEquals( expectedSelectClauseStart, Pirate_Util_SOQL.formSelectClause( emptySet ) );

        // Test non empty collections
        System.assertEquals( expectedFieldNameString, Pirate_Util_SOQL.prepFieldNamesForSelectClause( knownList ) );
        System.assertEquals( expectedFieldNameString, Pirate_Util_SOQL.prepFieldNamesForSelectClause( knownSet ) );
        System.assertEquals( expectedSelectClauseStart + expectedFieldNameString, Pirate_Util_SOQL.formSelectClause( knownList ) );
        System.assertEquals( expectedSelectClauseStart + expectedFieldNameString, Pirate_Util_SOQL.formSelectClause( knownSet ) );
        Test.stopTest();
    }


    static testMethod void testStringEncodes() {
        Test.startTest();
        System.assertEquals( '\'wrap with escaped single quotes\'', Pirate_Util_SOQL.encode( 'wrap with escaped single quotes' ) );
        Test.stopTest();
    }


    static testMethod void testDatetimeEncodes() {
        Datetime before_insertion = Datetime.now();
        Date knownDate = Date.newInstance( 2016, 3, 14 );

        Contact knownContact = new Contact(
            LastName = 'known',
            BirthDate = knownDate
        );
        insert knownContact;

        // Fetch from database to get a known Datetime (CreatedDate)
        knownContact = [SELECT Id, BirthDate, CreatedDate
                        FROM Contact
                        WHERE Id = :knownContact.Id
                        LIMIT 1];

        Datetime knownDatetime = knownContact.CreatedDate;

        String baseClause = 'SELECT Id, BirthDate, CreatedDate  FROM Contact ';

        Test.startTest();
        Contact foundByDate = Database.query( baseClause + 'WHERE BirthDate = ' + Pirate_Util_SOQL.encode( knownDate ) + ' LIMIT 1' );
        System.assertNotEquals( null, foundByDate, 'Should have been able to locate contact by encoded Date' );

        Contact foundByDatetime = Database.query( baseClause + ' WHERE CreatedDate >= ' + Pirate_Util_SOQL.encode( before_insertion ) + ' LIMIT 1' );
        System.assertNotEquals( null, foundByDatetime, 'Should have been able to locate contact by encoded Datetime "now"' );
        System.assertEquals( knownDatetime, foundByDatetime.CreatedDate, 'Found CreatedDate should have matched known datetime' );

        Contact foundByDateEncodedAsDatetime = Database.query( baseClause + ' WHERE CreatedDate >= ' + Pirate_Util_SOQL.encodeAsDatetime( Date.today() ) + ' LIMIT 1' );
        System.assertNotEquals( null, foundByDateEncodedAsDatetime, 'Should have been able to locate contact by Date encoded for Datetime field (CreatedDate)' );
        Test.stopTest();
    }


    static testMethod void testSetAndListEncodes() {
        // Setup Knowns and Expecteds
        Set<Object> knownSet = new Set<Object>{ 'Indianapolis', 'San Fran', 'Pittsburgh' };
        List<Object> knownList = new List<Object>{ 'Indianapolis', 'San Fran', 'Pittsburgh' };

        String expectedResult = '(\'Indianapolis\',\'San Fran\',\'Pittsburgh\')';

        // Run Tests
        Test.startTest();
        String result;

        result = Pirate_Util_SOQL.encode( knownList );
        System.assertEquals(result, expectedResult);

        // can't gurarentee order
        result = Pirate_Util_SOQL.encode( knownSet );
        System.assertEquals( result.startsWith( '(' ), true, 'Result should have started with an open paren.' );
        System.assertEquals( result.endsWith( ')' ), true, 'Result should have ended with a close paren.' );
        for ( Object known : knownList ) {
            System.assertEquals( result.contains( '\'' + known + '\'' ), true, 'Result should have contained: ' + known + ', wrapped in escaped single quotes.' );
        }
        Test.stopTest();
    }

}
