# Technical notes

## Session

As of 2018-02, This project is still very early alpha phase, therefore we value being able to reproduce cases than user experience. We value being able to repeat steps individually, to stop to think, debug, fix, therefore shortening the feedback cycle.

For this purpose, all data is saved into a session folder plus a file (`session`) to store all the information.

Any invocation can read/write any information on the session, effectively making it a global state container.  It is not ideal, but given the system is not production-ready and the operator has full access to the data (see 'limitations')

Keeping the state at the boundaries helps the services be as stateless as possible.
