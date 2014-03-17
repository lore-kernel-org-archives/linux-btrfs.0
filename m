Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49979 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaCQFmZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 01:42:25 -0400
Date: Sun, 16 Mar 2014 22:42:24 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Understanding btrfs and backups => automatic snapshot script
Message-ID: <20140317054224.GD6143@merlins.org>
References: <loom.20140306T191655-366@post.gmane.org> <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 06, 2014 at 09:33:24PM +0000, Duncan wrote:
> However, best snapshot management practice does progressive snapshot 
> thinning, so you never have more than a few hundred snapshots to manage 
> at once.  Think of it this way.  If you realize you deleted something you 
> needed yesterday, you might well remember about when you deleted it and 
> can thus pick the correct snapshot to mount and copy it back from.  But 
> if you don't realize you need it until a year later, say when you're 
> doing your taxes, how likely are you to remember the specific hour, or 
> even the specific day, you deleted it?  A year later, getting a copy from 
> the correct week, or perhaps the correct month, will probably suffice, 
> and even if you DID still have every single hour's snapshots a year 
> later, how would you ever know which one to pick?  So while a day out, 
> hourly snapshots are nice, a year out, they're just noise.

I'm happy to share my script with others if that helps:
http://marc.merlins.org/linux/scripts/btrfs-snaps

Or for the list archives/google:
----------------------------------------------------------------------------
#!/bin/bash

# By Marc MERLIN <marc_soft@merlins.org>
# License GPL-2 or BSD at your option.

# This lets you create sets of snapshots at any interval (I use hourly,
# daily, and weekly) and delete the older ones automatically.

# Usage:
# This is called from /etc/cron.d like so:
# 0 * * * * root btrfs-snaps hourly 3 | egrep -v '(Create a snapshot of|Will delete the oldest|Delete subvolume|Making snapshot of )'
# 1 0 * * * root btrfs-snaps daily  4 | egrep -v '(Create a snapshot of|Will delete the oldest|Delete subvolume|Making snapshot of )'
# 2 0 * * 0 root btrfs-snaps weekly 4 | egrep -v '(Create a snapshot of|Will delete the oldest|Delete subvolume|Making snapshot of )'

: ${BTRFSROOT:=/mnt/btrfs_pool1}
DATE="$(date '+%Y%m%d_%H:%M:%S')"

type=${1:-hourly}
keep=${2:-3}

cd "$BTRFSROOT"

for i in $(btrfs subvolume list -q . | grep "parent_uuid -" | awk '{print $11}')
do
    # Skip duplicate dirs once a year on DST 1h rewind.
    test -d "$BTRFSROOT/${i}_${type}_$DATE" && continue
    echo "Making snapshot of $type"
    /sbin/btrfs subvolume snapshot "$BTRFSROOT"/$i "$BTRFSROOT/${i}_${type}_$DATE"
    count="$(ls -d ${i}_${type}_* | wc -l)"
    clip=$(( $count - $keep ))
    if [ $clip -gt 0 ]; then
	echo "Will delete the oldest $clip snapshots for $type"
	for sub in $(ls -d ${i}_${type}_* | head -n $clip)
	do
	    #echo "Will delete $sub"
	    /sbin/btrfs subvolume delete "$sub"
	done
    fi
done
----------------------------------------------------------------------------
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
