public class CategoryWrapper {
public Boolean checked{ get; set; }
public Contact cat { get; set;}
public CategoryWrapper(){
cat = new Contact();
checked = false;
}
public CategoryWrapper(Contact c){
cat = c;
checked = false;
}
}