using { AdminService.Books, AdminService.Authors } from './admin-service.cds';

annotate Books with @(restrict: [
  {
    grant: ['DELETE'],
    to: 'admin',
    where: 'stock = 0'
  },
  {
    grant: ['READ', 'CREATE', 'UPDATE'],
    to: 'admin'
  }
]);

annotate Authors with @(requires: 'admin');