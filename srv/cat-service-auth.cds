using { CatalogService.Authors, CatalogService.Books, CatalogService.submitOrder } from './cat-service.cds';

annotate Authors with @readonly;
annotate Books with @readonly;
annotate submitOrder with @(requires: 'authenticated-user');