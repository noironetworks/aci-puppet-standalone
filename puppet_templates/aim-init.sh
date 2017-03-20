#!/bin/sh
aimctl db-migration upgrade head
aimctl config update
aimctl infra create
aimctl manager load-domains --enforce

systemctl start aim-aid
systemctl start aim-event-service-polling
systemctl start aim-event-service-rpc

