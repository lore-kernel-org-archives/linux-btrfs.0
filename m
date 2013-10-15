Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46096 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3JOEnJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 00:43:09 -0400
Date: Mon, 14 Oct 2013 21:43:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: David Madden <dhm@mersenne.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: OK to take hourly snapshots, then cull older ones?
Message-ID: <20131015044306.GX30504@merlins.org>
References: <525CBF0D.1020609@mersenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525CBF0D.1020609@mersenne.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 14, 2013 at 09:05:33PM -0700, David Madden wrote:
> I'd like to use BTRFS to do something like the old NetApp snapshot
> system: every hour or so, there'd be a snapshot, then the 23 of the
> snapshots during a day would be deleted, leaving just a day snapshot,
> then after a month, 6 of 7 snapshots would be deleted, leaving just a
> week snapshot, and so on.
> 
> Is this a reasonable thing to do in a cron job with a BTRFS filesystem?
>  Apart from running out of space, are there any resources that might get
> used up?  Has anybody done this for a year or two in an active
> filesystem, and encountered success or weirdness?

Way ahead of you there, been doing this for a year, no problems:

gandalfthegreat:~$ cat /etc/cron.d/btrfs_backup 
0 * * * * root test -d /mnt/btrfs_pool1 && grep -q rootflags=subvol=root /proc/cmdline && /var/local/scr/btrfs_snaps hourly 3 | egrep -v '(Create a snapshot of|Will delete the oldest|Delete subvolume|Making snapshot of )'
1 0 * * * root test -d /mnt/btrfs_pool1 && grep -q rootflags=subvol=root /proc/cmdline && /var/local/scr/btrfs_snaps daily  4 | egrep -v '(Create a snapshot of|Will delete the oldest|Delete subvolume|Making snapshot of )'
2 0 * * 0 root test -d /mnt/btrfs_pool1 && grep -q rootflags=subvol=root /proc/cmdline && /var/local/scr/btrfs_snaps weekly 4 | egrep -v '(Create a snapshot of|Will delete the oldest|Delete subvolume|Making snapshot of )'

/var/local/scr/btrfs_snaps:
---------------------------
#!/bin/bash

: ${BTRFSROOT:=/mnt/btrfs_pool1}
DATE="$(date '+%Y%m%d_%H:%M:%S')"

type=${1:-hourly}
keep=${2:-3}

cd "$BTRFSROOT"

for i in *
do
    # Skip snapshot names.
    [ "${i/_/-}" != "$i" ] && continue
    # Skip duplicate dirs once a year on DST 1h rewind.
    test -d "$BTRFSROOT/${i}_${type}_$DATE" && continue
    echo "Making snapshot of $type"
    /sbin/btrfs subvolume snapshot "$BTRFSROOT"/$i "$BTRFSROOT/${i}_${type}_$DATE"
    count="$(ls -d ${i}_${type}_* | wc -l)"
    echo "Will delete the oldest $clip snapshots for $type"
    clip=$(( $count - $keep ))
    if [ $clip -gt 0 ]; then
	for sub in $(ls -d ${i}_${type}_* | head -n $clip)
	do
	    #echo "Will delete $sub"
	    /sbin/btrfs subvolume delete "$sub"
	done
    fi
done
---------------------------

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
