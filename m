From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Slow snapshot deletion
Date: Thu, 28 Jul 2011 16:28:04 -0400
Message-ID: <1311884805-sup-7662@shiny>
References: <20110728200444.GA30801@untroubled.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bruce Guenter <bruce@untroubled.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110728200444.GA30801@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bruce Guenter's message of 2011-07-28 16:04:45 -0400:
> 
> At work we have a backup server system running btrfs.  The main backup
> pool is a 1.3TB partition (on LVM).  Every night, a series of backups
> are done with rsync, with each backup onto a separate subvolume, and a
> snapshot made of each backup.  Compression is used to minimize disk
> space used.
> 
> When the system was first provisioned, all the operations ran
> impressively fast, but now it is almost unusably slow.  It has taken 2
> days to delete snapshots that recovered 30GB of space, and some of the
> backups are taking longer than 24 hours to complete.
> 
> Is there any way to monitor the progress of the snapshot deletions?
> 
> What could be causing it to run so slow?
> 
> What could we do to speed things up?
> 
> Kernel is 2.6.39-gentoo-r3.  It was last rebooted 2 days ago, and
> rebooting does not seem to improve the situation.  Mount options
> according to /proc are "rw,nosuid,noatime,nodiratime,compress=zlib,noacl"
> btrfs filesystem df shows:
> 
> Data: total=1.15TB, used=1.10TB
> System, DUP: total=8.00MB, used=184.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=49.38GB, used=31.59GB
> Metadata: total=8.00MB, used=0.00
> 

The slow performance is probably coming from reading in the metadata
associated with the snapshot extents.  The new readahead extentions from
Arne should help once we've adapted them to it.  The easiest way to make
sure is to hit sysrq-w a few times while it is slow (or run a patched
latencytop).

-chris
