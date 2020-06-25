# Full-Stack GraphQL Course Updated with Hooks

Hooks are a new way to doing things in React and everyone seems to be, well, hooked!

In addition to [hooks](https://reactjs.org/docs/hooks-overview.html) being  supported in React 16.8, the latest version of Apollo Client [includes hooks](https://blog.apollographql.com/apollo-client-now-with-react-hooks-676d116eeae2) for GraphQL developers using React. For [good reason](https://reactjs.org/docs/hooks-intro.html#motivation) hooks are the way forward, and we're on top of it!

As of today, our [Full-Stack GraphQL course](/courses/unpacked-full-stack-graphql-with-absinthe-phoenix-react) includes a version of the code that has been migrated to use both React and Apollo Client hooks. And we're currently in the process of revising the affected videos. As you might imagine, this part of the update will take a bit longer. 😉 These updates are free to everyone who owns the course!

You don't have to wait to start the course or bail out if you've already started. All the existing code still works, and the migration to hooks is straighforward and only impacts a relatively small part of the frontend portion of the course.

Here's a quick preview of how things change with hooks...

## No More Classes

Prior to the introduction of hooks in React, a component that used state or needed to override a lifecycle method had to be written as a JavaScript class.

That's no longer the case. React hooks let you write all of your components as function components, thereby avoiding the nuances and confusion of class components. In fact, hooks won't work inside class components. You can only use hooks in function components.

So, while you can still write class components, you'll likely see less and less of them over time in React as hooks become more prevalent.

## The useState Hook

React includes a few built-in hooks, the most common of which is `useState`. It's a function that lets you add state to a component without writing a class.

You call the `useState` hook function with an initial state value and you get back an array containing two things---the current state value and a function that lets you update that value:

  ~~~js
  const [count, setCount] = useState(0);
  ~~~

In this example the state is a number initialized to 0. The number represents a count, so we use array destructuring to name the returned pair of values. `count` is a variable referencing the current state value and `setCount` is a function that lets you update it.

To put it in better context, here's a simple function component that uses the `useState` hook:

  ~~~js
  import React, { useState } from "react";

  function Counter() {
    const [count, setCount] = useState(0);

    return (
      <>
        {count}

        <button onClick={() => setCount(count - 1)}>Decrement</button>

        <button onClick={() => setCount(count + 1)}>Increment</button>
      </>
    );
  }

  export default Counter;
  ~~~

First, we import the `useState` function from React. Then inside the `Counter` function component at the top level, we call the `useState` hook. The result is `count` has a value of 0 and `setCount` is a function to change it.

The function then returns JSX that renders the current value of `count` and two buttons. When a button is clicked, it calls the `setCount` function with a new `count` value to increment or decrement the count as appropriate. React then re-renders the component, passing it the new `count` value. In this way, the state value is preserved between function calls.

## Apollo Client Hooks

In addition to `useState` and other built-in hooks provided by React, developers can create their own custom hooks. And that's exactly what the Apollo Client team did in their latest release.

Prior to hooks, you would use the higher-order `Query` and `Mutation` components with a render prop function. Going forward, you can instead use the new `useQuery` and `useMutation` hooks respectively to pull (or hook) these GraphQL behaviors into React components.

Let's look at some examples...

## useQuery Hook

Suppose we have this GraphQL query that fetches getaway places:

  ~~~js
  const GET_PLACES_QUERY = gql`
    query {
      places {
        name
        location
      }
    }
  `;
  ~~~

To run that query using a `Query` component, you pass the query as a prop and provide a render prop function that tells React what to render:

  ~~~js
  <Query query={GET_PLACES_QUERY}>
    {({ data, loading, error }) => {
      // render results
    }}
  </Query>
  ~~~

React calls the render prop function with an object that contains `data`, `loading`, and `error` properties that are used to render the results of the query.

The equivalent `useQuery` hook function streamlines this:

  ~~~js
  const { data, loading, error } = useQuery(GET_PLACES_QUERY);
  ~~~

It takes the query as a function argument and returns an object containing `data`, `loading`, and `error` properties.

I find this a lot more readable, and easier to use. Using a higher-order component and a render prop function always felt clunky. And the syntax became downright onerous when nesting components. Trade all that in for a simple function? You betcha!

To see how this changes your components, let's do a before and after. First, here's a component that uses the higher-order `Query` component to fetch and display a list of places:

  ~~~js
  import React from "react";
  import gql from "graphql-tag";
  import { Query } from "react-apollo";

  function Places() {
    return (
      <Query query={GET_PLACES_QUERY}>
        {({ data, loading, error }) => {

          if (loading) return <Loading />;
          if (error) return <Error error={error} />;

          return (
            <ul>
              {data.places.map(place => (
                <li>
                  {place.name} - {place.location}
                </li>
              ))}
            </ul>
          );
        }}
      </Query>
    );
  }

  export default Places;
  ~~~

And here's the equivalent component that instead uses the `useQuery` hook function:

  ~~~js
  import React from "react";
  import gql from "graphql-tag";
  import { useQuery } from "@apollo/react-hooks";

  function Places() {
    const { data, loading, error } = useQuery(GET_PLACES_QUERY);

    if (loading) return <Loading />;
    if (error) return <Error error={error} />;

    return (
      <ul>
        {data.places.map(place => (
          <li>
            {place.name} - {place.location}
          </li>
        ))}
      </ul>
    );
  }

  export default Places;
  ~~~

First, we need to import the `useQuery` function from `@apollo/react-hooks`. Then inside the `Places` function component we call the `useQuery` hook to run the query and destructure the results.

Basically, the `Query` component and its render prop function get replaced by a simple function call. What's nice is everything else effectively stays the same. After calling `useQuery`, this component returns the same JSX that was returned by the render prop function in the "before" version of the component. So you simply unindent the `return` and its JSX and you're good to go.

## useMutation Hook

Converting a component that runs a mutation is equally straightforward. For example, suppose we have this mutation that cancels a booking for a place:

  ~~~js
  const CANCEL_BOOKING_MUTATION = gql`
    mutation {
      cancelBooking(bookingId: $bookingId) {
        state
      }
    }
  `;
  ~~~

To run that mutation using a `Mutation` component, you pass the mutation and its variables as props, and again you also provide a render prop function that tells React what to render:

  ~~~js
  <Mutation mutation={CANCEL_BOOKING_MUTATION}
            variables={{ bookingId: booking.id }}>
    {(cancel) => {
      ...
    }}
  </Mutation>
  ~~~

React calls the render prop function with a mutate function, in this case named `cancel`. You then call the `cancel` function to run the mutation in response to a specific user action.

The `useMutation` hook function does the same thing in a more concise way:

  ~~~js
  const [cancel] = useMutation(CANCEL_BOOKING_MUTATION, {
    variables: { bookingId: booking.id }
  });
  ~~~

In its simplest form, the `useMutation` function takes the mutation as an argument and returns an array that contains a function to call to run the mutation. We destructured the array to name the function `cancel`.

You can also destructure to get the `error` and `loading` properties, like so:

  ~~~js
  const [cancel, { error, loading }] = useMutation(CANCEL_BOOKING_MUTATION, {
    variables: { bookingId: booking.id }
  });
  ~~~

Now let's do another before and after to see how to migrate from using a  `Mutation` component to using the `useMutation` hook.

First, here's a `Booking` component that uses the `Mutation` component to cancel a booking when a button is clicked:

  ~~~js
  import React from "react";
  import gql from "graphql-tag";
  import { Mutation } from "react-apollo";

  function Booking({ booking }) {
    return (
      <>
        {booking.place.name}

        <Mutation
          mutation={CANCEL_BOOKING_MUTATION}
          variables={{ bookingId: booking.id }}>
          {cancel => <button onClick={cancel}>Cancel</button>}
        </Mutation>
      </>
    );
  }

  export default Booking;
  ~~~

And here's the equivalent component that instead uses the `useMutation` hook function:

  ~~~js
  import React from "react";
  import gql from "graphql-tag";
  import { useMutation } from "@apollo/react-hooks";

  function Booking({ booking }) {
    const [cancel] = useMutation(CANCEL_BOOKING_MUTATION, {
      variables: { bookingId: booking.id }
    });

    return (
      <>
        {booking.place.name}

        <button onClick={cancel}>Cancel</button>
      </>
    );
  }

  export default Booking;
  ~~~

First, we need to import the `useMutation` function from `@apollo/react-hooks`. Then at the top of the `Booking` function component we call `useMutation` and destructure the result to name the mutate function `cancel`. The function component then returns JSX that renders the booking place's name and a button. Clicking the button calls the `cancel` function which runs the mutation.

## useApolloClient Hook

Another handy hook is `useApolloClient` which simply returns the Apollo Client instance:

  ~~~js
  const client = useApolloClient();
  ~~~

Here's an example of how you might use it in a `SignOut` component to clear the Apollo cache:

  ~~~js
  import React from "react";
  import { useApolloClient } from "@apollo/react-hooks";

  function Signout() {
    const client = useApolloClient();

    return (
      <button onClick={() => client.resetStore()}>
        Sign Out
      </button>;
    );
  }

  export default Signout;
  ~~~

## No Big Whoop!

Change is inevitable, and it often seems too frequent when it comes to JavaScript frameworks and libraries. But change can also be good, and in this case I think it's welcomed. Hooks eliminate a lot of boilerplate code and make the remaining code easier to understand. I always prefer simple functions over more elaborate constructs.

We hope this quick overview helps put your mind at east about the course updates coming your way. The good news is that all the concepts you learned in the course haven't changed a bit. The syntax just got easier, and the changes are fairly minimal and localized. And you don't even have to migrate your code right away as the `Query` and `Mutation` components are still supported. But when you're ready, I think you'll find that switching over to hooks is no big whoop!

Carry on.
