public class Ext_OpportunityHubLightning {
	
    public Opportunity opp {get;set;}
    public OpportunityLineItem oppItem {get;set;}
    
    
    public Ext_OpportunityHubLightning(ApexPages.StandardController ctrl)
    {
        opp = (Opportunity)ctrl.getRecord();
        opp = Database.query(getGenericQuery() + ' WHERE Id = \''+opp.Id+'\'');
    
    	oppItem = new OpportunityLineItem(OpportunityId = opp.Id);
    }
    
    public List<OpportunityLineItem> getProducts()
    {
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        items = Database.query(getGenericQueryItems() + ' WHERE OpportunityId = \''+opp.Id+'\'');
        return items;
    }
    
    private String getGenericQuery()
    {

            Map<String, Schema.DescribeFieldResult> finalMap =
                getFieldMetaData(Opportunity.getSObjectType().getDescribe());
            
            Set<String> requiredFields = new Set<String>();
            //requiredFields.add('UserRole.Name');
            //requiredFields.add('UserRole.DeveloperName');
            for(Schema.DescribeFieldResult field: finalMap.values())
            {   
                requiredFields.add(field.getName());
            }
            
            String query = 'SELECT ';
            for(String f : requiredFields) {
                if(query != 'SELECT ') query +=', ';
                query += f;
            }
            return query + ' FROM Opportunity'; 

            
    }
    
    private String getGenericQueryItems()
    {

            Map<String, Schema.DescribeFieldResult> finalMap =
                getFieldMetaData(OpportunityLineItem.getSObjectType().getDescribe());
            
            Set<String> requiredFields = new Set<String>();
            requiredFields.add('Product2.Name');
            //requiredFields.add('UserRole.DeveloperName');
            for(Schema.DescribeFieldResult field: finalMap.values())
            {   
                requiredFields.add(field.getName());
            }
            
            String query = 'SELECT ';
            for(String f : requiredFields) {
                if(query != 'SELECT ') query +=', ';
                query += f;
            }
            return query + ' FROM OpportunityLineItem'; 

            
    }
    
    public PageReference save()
    {
        
        update opp;
        return null;
        
    }
    
    public void saveItem()
    {
        
        insert oppItem;
        oppItem = new OpportunityLineItem(OpportunityId = opp.Id);
    }
    
    
    public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(
		  Schema.DescribeSObjectResult dsor) {
		  
		  // the map to be returned with the final data
		  Map<String,Schema.DescribeFieldResult> finalMap = 
		    new Map<String, Schema.DescribeFieldResult>();
		  // map of all fields in the object
		  Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
		  for(Schema.SObjectField field : objectFields.values()){
		 		finalMap.put(field.getDescribe().getName(), field.getDescribe());
		  }
		  return finalMap;
	}
    
    
    
    public List<SelectOption> getStages()
    {
           List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult = Opportunity.stagename.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
    }
    
    public List<CustomSelectOption> getStageNames()
    {
           
           List<CustomSelectOption> options = new List<CustomSelectOption>();
                
           Schema.DescribeFieldResult fieldResult = Opportunity.stagename.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              System.debug('***stage:'+opp.StageName+':'+f.getValue()); 
              Boolean isSelected = (opp.StageName == f.getValue());
              System.debug('***stage:'+isSelected); 
              options.add(new CustomSelectOption(f.getLabel(), f.getValue(), isSelected));
           }       
           return options;
    }
    
    public List<SelectOption> getType()
    {
           List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult = Opportunity.Type.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
    }
    
    public List<CustomSelectOption> getTypeNames()
    {
           List<CustomSelectOption> options = new List<CustomSelectOption>();
                
           Schema.DescribeFieldResult fieldResult = Opportunity.Type.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              System.debug('***stage:'+opp.Type+':'+f.getValue()); 
              Boolean isSelected = (opp.Type == f.getValue());
              System.debug('***stage:'+isSelected); 
              
              options.add(new CustomSelectOption(f.getLabel(), f.getValue(), isSelected));
           }       
           return options;
    }
    
    public List<CustomSelectOption> getProductCatalog()
    {
           List<CustomSelectOption> options = new List<CustomSelectOption>();
                
           List<PricebookEntry> products = new List<PricebookEntry>([SELECT Id, Product2.Name FROM PricebookEntry WHERE Pricebook2.Name = 'Standard']);
                
           for( PricebookEntry f : products)
           {
              options.add(new CustomSelectOption(f.Product2.Name, f.Id, false));
           }       
           return options;
    }
    
    
    public class CustomSelectOption
    {
        
        public String label {get;set;}
        public String value {get;set;}
        public Boolean selected {get;set;}
        
        public CustomSelectOption(String label, String value, Boolean selected)
        {
            this.label = label;
            this.value = value;
            this.selected = selected;
        }
    }
    
}