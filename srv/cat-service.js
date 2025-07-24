const cds = require("@sap/cds");
const { SELECT, INSERT, UPSERT, UPDATE, DELETE } = cds.ql;

class CatalogService extends cds.ApplicationService {
  async init() {
    const { Books } = this.entities;

    // Add some discount for overstocked books
    this.after("READ", Books, this.grandDiscount);

    this.on("submitOrder", this.reduceStock);

    return super.init();
  }

  grandDiscount(books) {
    if (Array.isArray(books)) {
      books.forEach((book) => {
        if (book.stock > 200) {
          book.title += " -- 11% Discount! Hurry up!";
        }
      });
    }
  }

  async reduceStock(req) {
    const { Books } = this.entities;
    const { book, quantity } = req.data;

    if (quantity <= 0) {
      return req.error(400, "Invalid order quantity");
    }

    const b = await SELECT.one
      .from(Books)
      .where({ ID: book })
      .columns((b) => {
        b.stock;
      });

    if (!b) {
      return req.error(404, `Book with ID ${book} not found`);
    }

    const { stock } = b;

    if (stock < quantity) {
      return req.error(400, `Not enough stock for book with ID ${book}`);
    }

    await UPDATE(Books)
      .where({ ID: book })
      .with({
        stock: { "-=": quantity },
      });

    return { stock: stock - quantity };
  }
}
module.exports = CatalogService;
