## Description

Sends custom metrics to a specified metrics endpoint. This action makes a POST request using a bearer token for authorization.

## Inputs

| parameter           | description                                               | required | default |
|---|---|---|---
| METRICS_ENDPOINT_URL| The metrics endpoint URL where the data will be sent.     | `true`   |         |
| BEARER_TOKEN        | The authorization token for the endpoint.                 | `true`   |         |
| data                | The metric data to send, formatted as required by the endpoint. | `true`  |         |

### Example Usage

Replace `METRICS_ENDPOINT_URL` and `BEARER_TOKEN` with your actual metrics endpoint URL and bearer token, which should be stored as secrets in your GitHub repository.

```
jobs:
  send-metrics:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Send Custom Metrics
      uses: your-username/send-custom-metrics-action@main
      with:
        METRICS_ENDPOINT_URL: ${{ secrets.METRICS_ENDPOINT_URL }}
        BEARER_TOKEN: ${{ secrets.BEARER_TOKEN }}
        data: 'your_metric{label="value"} 123'
```
