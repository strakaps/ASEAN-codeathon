Autoencoders
------------

Autoencoders learn the probability distribution of complex, unstructured
data such as the 80,000 odd yearly submitted Suspicious Matter Reports
(SMRs). Austrac’s Resources are limited, which means that the majority
of SMRs can not be followed up upon. We create methods to assist the
case officers in directing their attention to important SMRs.

SMRs can be important for two reasons:

1.  Quality assurance: we detect “outlying” reporting entities, which
    report too many irrelevant, or too few SMRs. Thus Austrac has the
    opportunity to correct the reporting behaviour of these entities,
    providing better SMRs in the future.

2.  Urgent relevance: certain SMRs need to be acted on immediately.

For both situations, we train autoencoders to learn the probability
distribution of SMRs which do **not** require attention from the quality
assurance point of view, and which do **not** require attention from the
urgency point of view. A case officer trains adds an SMR to the training
set of the autoencoder every time they decide that this SMR does not
need attention.

Being trained, autoencoders can quickly compute how unlikely it is that
an SMR does not require attention. We then present the case officer with
a list of SMRs in decreasing order of this probability. The more cases
an officer works through, the better the more experienced and better the
autoencoder gets.

Mock-up data
------------

Not having access to SMR data, we have generated mock-up data of 1000
rows, via [Mockaroo](https://mockaroo.com/), with the following
variables:

    ##  [1] "Contact_FirstName"                        
    ##  [2] "Contact_LastName"                         
    ##  [3] "Contact_EntityName"                       
    ##  [4] "Contact_EntityPhone"                      
    ##  [5] "Contact_EntityAddress"                    
    ##  [6] "Customer_FirstName"                       
    ##  [7] "Customer_LastName"                        
    ##  [8] "Customer_Gender"                          
    ##  [9] "Customer_DateOfBirth"                     
    ## [10] "Customer_Address"                         
    ## [11] "Customer_PostalCode"                      
    ## [12] "Customer_CountryOfCitizenship"            
    ## [13] "Customer_IDType"                          
    ## [14] "Customer_IDNumber"                        
    ## [15] "Customer_IssuingCountry"                  
    ## [16] "Customer_IssueDate"                       
    ## [17] "Customer_ExpiryDate"                      
    ## [18] "Trans_Withdrawl_Deposit"                  
    ## [19] "Trans_Type"                               
    ## [20] "Contact_ReferralDate"                     
    ## [21] "Trans_TransactionDate"                    
    ## [22] "Trans_Time"                               
    ## [23] "Trans_OriginatingCountry"                 
    ## [24] "Trans_DestinationCountry"                 
    ## [25] "Trans_Amount"                             
    ## [26] "Trans_IdentificationOfSuspiciousIndicator"
    ## [27] "Trans_Notes"                              
    ## [28] "SMR_ReviewOutcome"                        
    ## [29] "Att_XLS"                                  
    ## [30] "Att_TIF"                                  
    ## [31] "Att_PDF"                                  
    ## [32] "Att_WMV"                                  
    ## [33] "Att_JPG"                                  
    ## [34] "Att_MPG"                                  
    ## [35] "Att_MP4"                                  
    ## [36] "Att_FLV"                                  
    ## [37] "Att_GIF"                                  
    ## [38] "row_num"

Note that column 27 contains free, unstructured text, which we have
found in Austrac case stories. We model the text as a bag of words,
which counts the number of occurrences of words only, and neglects their
order. So called “stop words” which contain no meaning are discarded.
The result is a document-term matrix, where the rows correspond to
individual SMRs, and the columns to word counts (only 8 columns shown):

    ##     Terms
    ## Docs currency digital exchange increase time transactions funds
    ##    1        1       1        1        1    1            1     0
    ##    2        0       0        0        0    0            0     1
    ##    3        0       0        0        0    0            0     0
    ##    4        0       0        0        0    0            0     0
    ##    5        0       0        0        0    0            0     0

Our autoencoder is a neural network with an input layer of 6645 nodes,
hidden layers with 10, 5 and 10 nodes, and an output layer of 6645
nodes. The output data is equal to the input data. Thus the and thus
learns to represent the SMRs which are not deemed worthy of a case
officer’s attention.
