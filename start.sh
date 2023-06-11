#!/bin/sh

# Start services
nginx -g "daemon off;" &
python3 /app/run.py --host=0.0.0.0
```
