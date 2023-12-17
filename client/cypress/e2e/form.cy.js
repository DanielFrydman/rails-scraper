/// <reference types="cypress" />

describe('Form E2E Test', () => {
  beforeEach(() => {
    cy.visit('http://localhost:5174');
  });

  it('should display a warning when clicking "Add Field" without filling existing inputs', () => {
    cy.get('#addFieldButton').click();
    cy.on('window:alert', (text) => {
      expect(text).to.equal('Fill in this field.');
    });
    cy.get('#field').should('have.length', 1);
    cy.get('#urlAddress').should('have.length', 1);
  });

  it('should display a warning when trying to start scrap without filling the URL', () => {
    cy.get('#startScrapButton').click();
    cy.on('window:alert', (text) => {
      expect(text).to.equal('Fill in this field.');
    });
  });

  it('should display a warning when trying to start scrap with empty field inputs', () => {
    cy.get('#urlAddress').type('https://example.com');
    cy.get('#startScrapButton').click();
    cy.on('window:alert', (text) => {
      expect(text).to.equal('Fill in this field.');
    });
  });

  it('should display a warning when trying to start scrap with some empty field inputs', () => {
    cy.get('#urlAddress').type('https://example.com');
    cy.get('#addFieldButton').click();
    cy.get('#startScrapButton').click();
    cy.on('window:alert', (text) => {
      expect(text).to.equal('Fill in this field.');
    });
  });
});
