# Queues

A simple copy of Pivotal Tracker

## Glossary

- User - a person who uses the system 
- Project - a collection of tasks for a particular purpose
- Card - an individual task within a project

## Principles

Cards are pieces of work that must be completed.  

They are either in the backlog, in which case they are awaiting being worked on, they are in progress, in QA, awaiting deployment or completed.  They can also be cancelled.  

Each project has a "velocity" which is an estimate of how much work will get completed in the next iteration.  Each card has a complexity, which is then used, within the backlog, to attach a date to the card.  For example, if a project has a velocity of 4, and the backlog contains 4 "simple" cards, the estimate would state that the first two cards will be completed in the next iteration, with two cards completed in the following iteration (as "simple" has a value of 2).  The backlog can then be reordered so the impact of changes on delivery times can easily be seen.  

## To do

- [x] Ask Claude to add an email validation
- [x] Ask Claude to write specs for user, project and card
- [ ] Ask Claude to add cards to the project page
- [ ] Ask Claude to add option to create a card using a CardsController
- [ ] Ask Claude to write specs for the card controller, using the project controller as a guide
- [ ] Ask Claude to start a task
- [ ] Ask Claude to split the cards view into backlog and not backlog cards
- [ ] Ask Claude to estimate when backlog tasks will be completed given a velocity