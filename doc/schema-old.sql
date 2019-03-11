CREATE TABLE DocumentList (
    Dokument,
    Pfad
);

CREATE TABLE CategorieCustomer (
    Kategorie,
    Datum,
    Patient,
    Erledigt
);

CREATE TABLE System (
    Praxis
);

CREATE TABLE TitleList (
    Id INTEGER PRIMARY KEY,
    Title TEXT
);

CREATE TABLE FamilyStatusList (
    Id INTEGER PRIMARY KEY,
    FamilyStatus TEXT
);

CREATE TABLE FeeList (
    Editor TEXT,
    Edited TEXT,
    Creator TEXT,
    Created TEXT,
    Id INTEGER PRIMARY KEY,
    ShortNote TEXT,
    Description TEXT,
    AmountDM NUMERIC,
    Amount NUMERIC
);

CREATE TABLE HandlingData (
    Created TEXT,
    Creator TEXT,
    CustomerId NUMERIC,
    Edited TEXT,
    Editor TEXT,
    HandlingId NUMERIC
);

CREATE TABLE ActivityList (
    AgencyId NUMERIC,
    FeeId NUMERIC,
    Editor TEXT,
    Edited TEXT,
    Created TEXT,
    Creator TEXT,
    Id INTEGER PRIMARY KEY,
    InvoiceId NUMERIC,
    Agency TEXT,
    Date TEXT,
    Shortnote TEXT,
    Description TEXT,
    AmountDM NUMERIC,
    Amount NUMERIC,
    Quantity NUMERIC,
    CustomerId NUMERIC,
    Abrechnen numeric,
    Comment TEXT
);

CREATE TABLE InvoiceList (
    CreditNote NUMERIC,
    InvoiceNumber TEXT,
    Editor TEXT,
    Edited TEXT,
    Created TEXT,
    Creator TEXT,
    Id INTEGER PRIMARY KEY,
    AgencyWhereWrite NUMERIC,
    Date TEXT,
    Cleared NUMERIC,
    CustomerId NUMERIC,
    AgencyId NUMERIC,
    Amount NUMERIC,
    Comment TEXT,
    InvoiceNote TEXT,
    Gen_Diagnose numeric,
    Gen_Text numeric
);

CREATE TABLE CustomerList (
    AgencyId NUMERIC,
    MobilePhone TEXT,
    ChildFrom NUMERIC,
    PartnerFrom NUMERIC,
    Edited TEXT,
    Editor TEXT,
    Created TEXT,
    Creator TEXT,
    DayOfBirth TEXT,
    Id INTEGER PRIMARY KEY,
    Acceptance NUMERIC,
    Agency TEXT,
    Title TEXT,
    AcademicTitle TEXT,
    Forename TEXT,
    Surname TEXT,
    Geburtstag numeric,
    Geburtsmonat numeric,
    Geburtsjahr numeric,
    Street TEXT,
    StreetNumber TEXT,
    City TEXT,
    PostalCode TEXT,
    Country TEXT,
    Citizenship TEXT,
    CallNumber TEXT,
    Email TEXT,
    FamilyStatus TEXT,
    Occupation TEXT,
    Memorandum TEXT,
    Kind numeric,
    verzogen numeric,
    Exitus numeric,
    unbekannt numeric,
    Geburtstagskarte numeric,
    Weihnachtskarte numeric,
    Auswahl numeric
);

CREATE INDEX ActivityList_AgencyId ON ActivityList(AgencyId ASC);

CREATE INDEX ActivityList_CustomerId ON ActivityList(CustomerId ASC);

CREATE INDEX ActivityList_InvoiceId ON ActivityList(InvoiceId ASC);

CREATE INDEX CustomerList_AgencyId ON CustomerList(AgencyId ASC);

CREATE INDEX CustomerList_PartnerFrom ON CustomerList(PartnerFrom ASC);

CREATE INDEX CustomerList_ChildFrom ON CustomerList(ChildFrom ASC);

CREATE INDEX HandlingData_CustomerId ON HandlingData(CustomerId ASC);

CREATE INDEX HandlingData_HandlingId ON HandlingData(HandlingId ASC);

CREATE INDEX InvoiceList_CustomerId ON InvoiceList(CustomerId ASC);

CREATE INDEX InvoiceList_AgencyId ON InvoiceList(AgencyId ASC);

CREATE TABLE AgencyList (
    OrderNumber NUMERIC,
    Agency TEXT,
    ID INTEGER PRIMARY KEY
);

CREATE TABLE HandlingList (
    Standard NUMERIC,
    Handling TEXT,
    Id INTEGER PRIMARY KEY
);

CREATE TABLE TemplateList (
    TemplateFile TEXT,
    Variables TEXT,
    Query TEXT,
    Comment TEXT,
    OrderBy TEXT,
    PermitHandlingList TEXT,
    ForbidHandlingList TEXT,
    AuxiliaryColumns TEXT,
    Filter TEXT,
    AgencyId NUMERIC,
    Filename TEXT,
    Id INTEGER PRIMARY KEY,
    Name TEXT,
    OrderNumber NUMERIC,
    Type TEXT
);
