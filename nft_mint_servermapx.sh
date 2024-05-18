#!/bin/bash

# Function to handle the GET request and call the dfx command
handle_request() {
  # Read the GET request
  read request

  # Check if the request is a GET request
  if [[ "$request" =~ ^GET ]]; then
    # Execute the dfx command
    dfx canister call dip721_nft_container mintDip721 "(
      principal\"$(dfx identity get-principal)\",
      vec {
        record {
          purpose = variant{Rendered};
          data = blob\"Developer Journey NFT\";
          key_val_data = vec {
            record { key = \"description\"; val = variant{TextContent=\"The NFT metadata can hold arbitrary metadata\"}; };
            record { key = \"tag\"; val = variant{TextContent=\"education\"}; };
            record { key = \"contentType\"; val = variant{TextContent=\"text/plain\"}; };
            record { key = \"locationType\"; val = variant{Nat8Content=4:nat8} };
          }
        }
      }
    )"
    echo "HTTP/1.1 200 OK"
    echo "Content-Type: text/plain"
    echo ""
    echo "dfx command executed"
  else
    echo "HTTP/1.1 400 Bad Request"
    echo "Content-Type: text/plain"
    echo ""
    echo "Invalid request"
  fi
}

# Listen on port 8080 and handle requests
while true; do
  # Use netcat to listen on port 8080 and pass requests to the handle_request function
  nc -l -p 8080 -q 1 | handle_request
done
