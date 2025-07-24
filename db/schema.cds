using { cuid, managed, Country, Currency, sap.common.CodeList } from '@sap/cds/common';

namespace com.sap.learning;

entity Authors: cuid, managed {
        name        : String(100) @mandatory;
        dateOfBirth : Date;
        dateOfDeath : Date;
        epoch       : Association to Epochs;
        books       : Association to many Books
                        on books.author = $self;
}

entity Books: cuid, managed {
    title       : localized String @mandatory;
    genre       : Genre @assert.range: true;
    publCountry : Country;
    stock       : NoOfBooks default 0;
    price       : Price;
    isHardcover : Boolean;
    author      : Association to Authors @mandatory @assert.target;
}

type Genre: Integer enum {
    fiction     = 1;
    non_fiction = 2;
}

type Price {
    amount      : Decimal;
    currency    : Currency;
}

type NoOfBooks  : Integer;

entity Epochs : CodeList {
    key ID: Integer;
}

