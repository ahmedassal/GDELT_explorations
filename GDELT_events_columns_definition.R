
# Classes for GDELT daily events files

dailyEventsColClassesV1_03 = c(
      # EVENTID AND DATE ATTRIBUTES (5) ##################################
      class(257880160),     # "numeric", # GLOBALEVENTID bigint(2) ,     1
      class(20030703),      # "numeric", # Day: SQLDATE int(11) ,        2
      class(200307),        # "numeric", # MonthYear char(6) ,           3                                                                                                           
      class(2003),          # "numeric", # Year char(4) ,                4                                                                                                             
      class(2003.5014),     # "numeric", # FractionDate double ,         5
      # Actor Attributes (20) ############################################
      class("AFGINSTAL"),        # "", # Actor1Code                      6
      class("TALIBAN "),         # "", # Actor1Name                      7
      class("AFG"),              # "", # Actor1CountryCode               8
      class("TAL"),              # "", # Actor1KnownGroupCode            9
      class(""),                 # "", # Actor1EthnicCode               10
      class(""),                 # "", # Actor1Religion1Code            11
      class(""),                 # "", # Actor1Religion2Code            12 
      class(""),                 # "", # Actor1Type1Code                13
      class(""),                 # "", # Actor1Type2Code                14
      class(""),                 # "", # Actor1Type3Code                15
      class("AFGINSTAL"),        # "", # Actor2Code                     16
      class("TALIBAN "),         # "", # Actor2Name                     17
      class("AFG"),              # "", # Actor2CountryCode              18
      class("TAL"),              # "", # Actor2KnownGroupCode           19
      class(""),                 # "", # Actor2EthnicCode               20
      class(""),                 # "", # Actor2Religion1Code            21
      class(""),                 # "", # Actor2Religion2Code            22 
      class(""),                 # "", # Actor2Type1Code                23
      class(""),                 # "", # Actor2Type2Code                24
      class(""),                 # "", # Actor2Type3Code                25
      # Event Action Attributes (10) #####################################
      class(TRUE),               # "", # IsRootEvent int(11) ,          26
      class("0051"),             # "", # EventCode char(4) ,            27
      class("0051"),             # "", # EventBaseCode char(4) ,        28
      class("0051"),             # "", # EventRootCode char(4) ,        29
      class(1),                  # "", # QuadClass int(11) ,            30
      class(50),                 # "", # GoldsteinScale double ,        31
      class(50),                 # "", # NumMentions int(11) ,          32
      class(50),                 # "", # NumSources int(11) ,           33
      class(50),                 # "", # NumArticles int(11) ,          34
      class(50),                 # "", # AvgTone double ,               35
      # Event Geography Attributes (21) ##################################
      class("1"),                # "", # Actor1Geo_Type int(11) ,       36
      class("dasdasd"),          # "", # Actor1Geo_FullName char(255) , 37
      class("EG"),               # "", # Actor1Geo_CountryCode char(2) ,38 
      class("USTX"),             # "", # Actor1Geo_ADM1Code char(4) ,   39
      class(40.230051),          # "", # Actor1Geo_Lat float ,          40
      class(40.230051),          # "", # Actor1Geo_Long float ,         41
      class("-51"),              # "", # Actor1Geo_FeatureID int(11) ,  42
      class("1"),                # "", # Actor2Geo_Type int(11) ,       43
      class("dasdasd"),          # "", # Actor2Geo_FullName char(255) , 44
      class("EG"),               # "", # Actor2Geo_CountryCode char(2) ,45 
      class("USTX"),             # "", # Actor2Geo_ADM1Code char(4) ,   46 
      class(40.230051),          # "", # Actor2Geo_Lat float ,          47
      class(40.230051),          # "", # Actor2Geo_Long float ,         48
      class("-51"),              # "", # Actor2Geo_FeatureID int(11) ,  49
      class("1"),                # "", # ActionGeo_Type int(11) ,       50
      class("dasdasd"),          # "", # ActionGeo_FullName char(255) , 51
      class("EG"),               # "", # ActionGeo_CountryCode char(2) ,52 
      class("USTX"),             # "", # ActionGeo_ADM1Code char(4) ,   53 
      class(40.230051),          # "", # ActionGeo_Lat float ,          54
      class(40.230051),          # "", # ActionGeo_Long float ,         55
      class("-51"),              # "", # ActionGeo_FeatureID int(11) ,  56
      # DATA MANAGEMENT FIELDS (2) #######################################
      class(20030703),           # "", # DATEADDED int(11),             57
      class("http://")           # "", # SOURCEURL char(),              58
      # end ##############################################################
  )


dailyEventsColNamesV1_03 = c(
      # EVENTID AND DATE ATTRIBUTES (5) ################################################
      "GLOBALEVENTID", #class(257880160), # "numeric", # GLOBALEVENTID bigint(2) ,     1
      "Day",      #"class(20030703),      # "numeric", # Day: SQLDATE int(11) ,        2
      "MonthYear", # class(200307),       # "numeric", # MonthYear char(6) ,           3                                                                                                           
      "Year", # class(2003),              # "numeric", # Year char(4) ,                4                                                                                                             
      "FractionDate", # class(2003.5014), # "numeric", # FractionDate double ,         5
      # Actor Attributes (20) ##########################################################
      "Actor1Code", # class("AFGINSTAL"),      # "", # Actor1Code                      6
      "Actor1Name", # class("TALIBAN "),       # "", # Actor1Name                      7
      "Actor1CountryCode", # class("AFG"),     # "", # Actor1CountryCode               8
      "Actor1KnownGroupCode", # class("TAL"),  # "", # Actor1KnownGroupCode            9
      "Actor1EthnicCode", # class(""),         # "", # Actor1EthnicCode               10
      "Actor1Religion1Code", # class(""),      # "", # Actor1Religion1Code            11
      "Actor1Religion2Code", # class(""),      # "", # Actor1Religion2Code            12 
      "Actor1Type1Code", # class(""),          # "", # Actor1Type1Code                13
      "Actor1Type2Code", # class(""),          # "", # Actor1Type2Code                14
      "Actor1Type3Code", # class(""),          # "", # Actor1Type3Code                15
      "Actor2Code", # class("AFGINSTAL"),      # "", # Actor2Code                     16
      "Actor2Name", # class("TALIBAN "),       # "", # Actor2Name                     17
      "Actor2CountryCode", # class("AFG"),     # "", # Actor2CountryCode              18
      "Actor2KnownGroupCode", # class("TAL"),  # "", # Actor2KnownGroupCode           19
      "Actor2EthnicCode", # class(""),         # "", # Actor2EthnicCode               20
      "Actor2Religion1Code", # class(""),      # "", # Actor2Religion1Code            21
      "Actor2Religion2Code", # class(""),      # "", # Actor2Religion2Code            22 
      "Actor2Type1Code", # class(""),          # "", # Actor2Type1Code                23
      "Actor2Type2Code", # class(""),          # "", # Actor2Type2Code                24
      "Actor2Type3Code", # class(""),          # "", # Actor2Type3Code                25
      # Event Action Attributes (10) ###################################################
      "IsRootEvent", # class(TRUE),            # "", # IsRootEvent int(11) ,          26
      "EventCode", # class("0051"),            # "", # EventCode char(4) ,            27
      "EventBaseCode", # class("0051"),        # "", # EventBaseCode char(4) ,        28
      "EventRootCode", # class("0051"),        # "", # EventRootCode char(4) ,        29
      "QuadClass", # class(1),                 # "", # QuadClass int(11) ,            30
      "GoldsteinScale", # class(50),           # "", # GoldsteinScale double ,        31
      "NumMentions", # class(50),              # "", # NumMentions int(11) ,          32
      "NumSources", # class(50),               # "", # NumSources int(11) ,           33
      "NumArticles", # class(50),              # "", # NumArticles int(11) ,          34
      "AvgTone", # class(50),                  # "", # AvgTone double ,               35
      # Event Geography Attributes (21) ################################################
      "Actor1Geo_Type", # class("1"),          # "", # Actor1Geo_Type int(11) ,       36
      "Actor1Geo_FullName", # class("dasdasd"),# "", # Actor1Geo_FullName char(255) , 37
      "Actor1Geo_CountryCode", # class("EG"),  # "", # Actor1Geo_CountryCode char(2) ,38 
      "Actor1Geo_ADM1Code", # class("USTX"),   # "", # Actor1Geo_ADM1Code char(4) ,   39
      "Actor1Geo_Lat", # class("40.230051"),   # "", # Actor1Geo_Lat float ,          40
      "Actor1Geo_Long", # class("40.230051"),  # "", # Actor1Geo_Long float ,         41
      "Actor1Geo_FeatureID", # class("-51"),   # "", # Actor1Geo_FeatureID int(11) ,  42
      "Actor2Geo_Type", # class("1"),          # "", # Actor2Geo_Type int(11) ,       43
      "Actor2Geo_FullName", # class("dasdasd"),# "", # Actor2Geo_FullName char(255) , 44
      "Actor2Geo_CountryCode", # class("EG"),  # "", # Actor2Geo_CountryCode char(2) ,45 
      "Actor2Geo_ADM1Code", # class("USTX"),   # "", # Actor2Geo_ADM1Code char(4) ,   46 
      "Actor2Geo_Lat", # class("40.230051"),   # "", # Actor2Geo_Lat float ,          47
      "Actor2Geo_Long", # class("40.230051"),  # "", # Actor2Geo_Long float ,         48
      "Actor2Geo_FeatureID", # class("-51"),   # "", # Actor2Geo_FeatureID int(11) ,  49
      "ActionGeo_Type", # class("1"),          # "", # ActionGeo_Type int(11) ,       50
      "ActionGeo_FullName", # class("dasdasd"),# "", # ActionGeo_FullName char(255) , 51
      "ActionGeo_CountryCode", # class("EG"),  # "", # ActionGeo_CountryCode char(2) ,52 
      "ActionGeo_ADM1Code", # class("USTX"),   # "", # ActionGeo_ADM1Code char(4) ,   53 
      "ActionGeo_Lat", # class("40.230051"),   # "", # ActionGeo_Lat float ,          54
      "ActionGeo_Long", # class("40.230051"),  # "", # ActionGeo_Long float ,         55
      "ActionGeo_FeatureID", # class("-51"),   # "", # ActionGeo_FeatureID int(11) ,  56
      # DATA MANAGEMENT FIELDS (2) #####################################################
      "DATEADDED", # class(20030703),          # "", # DATEADDED int(11),             57
      "SOURCEURL" # class("http://")          # "", # SOURCEURL char(),               58
      # end ############################################################################
)



