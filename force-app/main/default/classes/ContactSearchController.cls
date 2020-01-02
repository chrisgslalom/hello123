Public without sharing class ContactSearchController {
public List<categoryWrapper> searchResults {
get {
if(searchResults==null) searchResults = new List<categoryWrapper>();
return searchResults;
}
set;
}
// the categories that were checked/selected.
public List<categoryWrapper> selectedCategories {
get {
if (selectedCategories == null) selectedCategories = new
List<categoryWrapper>();
return selectedCategories;
}
set;
}
// the soql without the order and limit
private String soql {get;set;}
// the collection of contacts to display
public List<Contact> contacts {get;set;}
// the current sort direction. defaults to asc
public String sortDir {
get { if (sortDir == null) { sortDir = 'asc'; } return sortDir; }
set;
}
// the current field to sort by. defaults to last name
public String sortField {
get { if (sortField == null) {sortField = 'lastName'; } return sortField; }
set;
}
// format the soql for display on the visualforce page
public String debugSoql {
get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 100'; }
set;
}
// init the controller and display some sample data when the page loads
public ContactSearchController() {
soql = 'select id,firstname, lastname, account.id,account.name,Account.Owner.name,Account.BillingState,Account.industry from contact where account.name != null';
runQuery();
}
public ContactSearchController(ApexPages.StandardController stdController) {
System.debug('Inside the Constructor called from Category Results Page');
soql = 'select id,firstname, lastname,account.name,Account.id,Account.Owner.name,Account.BillingState,Account.industry from contact where account.name != null';
runQuery();
}
// toggles the sorting of query from asc<-->desc
public void toggleSort() {
// simply toggle the direction
sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
// run the query again
runQuery();
}
// runs the actual query
public void runQuery() {
System.debug('Query Called');
contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 100');
searchResults.clear();
for(Contact c : contacts) {
// create a new wrapper by passing it the category in the constructor
CategoryWrapper cw = new CategoryWrapper(c);
// add the wrapper to the results'
searchResults.add(CW);
}
System.debug('searchResults=='+searchResults);
}
// runs the search with parameters passed via Javascript
public PageReference runSearch() {
String firstName = Apexpages.currentPage().getParameters().get('firstname');
String lastName = Apexpages.currentPage().getParameters().get('lastname');
String accountName = Apexpages.currentPage().getParameters().get('accountName');
String industry = Apexpages.currentPage().getParameters().get('industry');
soql = 'select id,Account.id,firstname,lastname,account.name,account.owner.name,Account.BillingState,Account.industry from contact where account.name != null';
if (!firstName.equals(''))
soql += ' and firstname LIKE \''+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('firstname'))
+'%\'';
if (!lastName.equals(''))
soql += ' and lastname LIKE \''+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('lastname'))
+'%\'';
if (!accountName.equals(''))
soql += ' and account.name LIKE \''+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('accountName'))+'%\'';
if (!industry.equals(''))
soql += ' and Account.industry in (\''+Apexpages.currentPage().getParameters().get('industry')+'\')';
//System.debug('SOQL=' +SOQL);
// run the query again
runQuery();
return null;
}
// use apex describe to build the picklist values
public List<String> industry {
get {
if (industry == null) {
industry = new List<String>();
Schema.DescribeFieldResult field = Account.industry.getDescribe();
for (Schema.PicklistEntry f : field.getPicklistValues())
industry.add(f.getLabel());
}
return industry;
}
set;
}
Public Void doFollow() {
selectedCategories.clear();
integer i=0;
// add the selected categories to a new List
for (CategoryWrapper cw : searchResults) {
if (cw.checked)
{
selectedCategories.add(new CategoryWrapper(cw.cat));
ConnectApi.ChatterUsers.follow(null, 'me',CW.cat.Accountid);
i++;
}
}
}
Public Void doUnFollow() {
selectedCategories.clear();
integer i=0;
// add the selected categories to a new List
for (CategoryWrapper cw : searchResults) {
if (cw.checked)
{
selectedCategories.add(new CategoryWrapper(cw.cat));
ConnectApi.Chatter.deleteSubscription(null, CW.cat.Accountid);
i++;
}
}
}
Public PageReference ChangeOwner()
{
selectedCategories.clear();
Integer i=0;
// add the selected categories to a new List
List<id> AccIds=New List<id>();
for (CategoryWrapper cw : searchResults) {
if (cw.checked)
{
AccIds.add(Cw.cat.Accountid);
i++;
}
}
List<Account> AccountsToUpdate=[Select id,Ownerid from Account where Id in
:AccIds];
for(Account AcIds : AccountsToUpdate) {
AcIds.OwnerId=UserInfo.getUserId();
}
Update AccountsToUpdate;
PageReference newpage = new
PageReference(System.currentPageReference().getURL());
newpage.setRedirect(true);
return newpage;
}
}