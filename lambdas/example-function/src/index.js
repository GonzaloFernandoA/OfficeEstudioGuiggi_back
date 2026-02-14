/**
 * Example Lambda Function
 * 
 * This is a template for creating AWS Lambda functions.
 * Modify this file according to your specific use case.
 */

exports.handler = async (event, context) => {
  console.log('Event received:', JSON.stringify(event, null, 2));
  
  try {
    // Parse the request body if it exists
    const body = event.body ? JSON.parse(event.body) : event;
    
    // Your business logic here
    const response = {
      message: 'Function executed successfully',
      input: body,
      timestamp: new Date().toISOString()
    };
    
    // Return success response
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
      },
      body: JSON.stringify(response)
    };
    
  } catch (error) {
    console.error('Error:', error);
    
    // Return error response
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        error: 'Internal server error',
        message: error.message
      })
    };
  }
};
