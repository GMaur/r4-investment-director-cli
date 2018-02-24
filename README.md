# Renta4 (R4) Director

Eases the orchestration with the [Renta4 automator](https://github.com/GMaur/r4-automator). A part of [Robot Advisor](https://github.com/RobotAdvisor) (GMaur's Investment Ideas)

The dependencies have been written [API-first][api-first], therefore they're not very usable for a person, but for systems. This project aims to connect the different operations of both services.

Think of this as glue to connect the underlaying building blocks.

## Necessary services

  * [R4 automator](https://github.com/GMaur/r4-automator): connects to the R4 broker to make read and write operations
  * [Robot advisor](https://github.com/GMaur/robot-advisor): make decisions on your investments

## Technical notes

See TECHNICALNOTES.md

## Limitations / Hypotheses

  * This is a CLI application, to be used by a single user that has access to sensitive information. It is the user's (and not the project's) duty to protect that information.

## Scope

### Out of scope

  * This project can only connect to a single broker (currently, r4-automator). It is not expected to comply with the API of any other broker
 
## Contributing

This project is open to contributions.

We're mainly interested in solving our own problems, not adding features for the sake of completion.
On the other hand, if you need to solve a problem of yours that is not currently solved by this
project, please contact us (message / issue).

### Reaching us

Please send a message (e.g., [twitter](https://twitter.com/alvarobiz)) or an [issue](https://github.com/GMaur/r4-investment-director-cli/issues)

[api-first]: https://medium.com/adobe-io/three-principles-of-api-first-design-fa6666d9f694