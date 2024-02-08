#!/bin/bash

$(du -h -d1 /Library/Addigy/ansible/packages 2>/dev/null | sort -h -r)
$(du -h -d1 /Library/Addigy/download-cache/downloaded 2>/dev/null | sort -h -r)