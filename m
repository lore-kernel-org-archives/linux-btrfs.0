From: Ken A <ka@pacific.net>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 09:50:34 -0500
Message-ID: <4E4BD53A.7080708@pacific.net>
References: <4E4B2452.9070407@oracle.com> <20110817140433.GA32261@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817140433.GA32261@hendrix.borisch.local>
List-ID: <linux-btrfs.vger.kernel.org>

and much easier than trying to get snapper to compile on fedora
libblocxx ?
:-)
Ken


On 8/17/2011 9:04 AM, Dave wrote:
> I've already done something similar.  I take hourly, daily, weekly, and monthly
> snapshots of my /home subvolume.  Here's the script I've created for this:
>
> #! /bin/bash
>
> if [ "$#" -ne 2 ]; then
>     echo Usage $0 SNAPSHOT_PREFIX NUM_SNAPSHOTS
>     exit 1
> fi
>
> SNAPS=/var/lib/btrfs-root/__snapshot/home
>
> btrfs subvolume snapshot -r /home $SNAPS/$1_$(date +%F_%T.%N)
>
> num_snaps=$(ls -1d $SNAPS/$1_* | sort | wc -l)
>
> if [ "$num_snaps" -gt "$2" ]; then
>     let over=$num_snaps-$2
>     ls -1d $SNAPS/$1_* | head -n $over | while read s; do
>        btrfs subvolume delete $s
>     done
> fi
>
>
> Here's my crontab:
> 0 * * * * /usr/local/bin/snapshot hourly 6
> 0 0 * * * /usr/local/bin/snapshot daily 7
> 0 0 * * 0 /usr/local/bin/snapshot weekly 4

-- 
Ken Anderson
