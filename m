Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50568 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbdKBUq1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 16:46:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAMNT-0006wW-Ns
        for linux-btrfs@vger.kernel.org; Thu, 02 Nov 2017 21:46:15 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
Date: Thu, 2 Nov 2017 21:46:13 +0100
Message-ID: <20171102214613.10af365e@jupiter.sol.kaishome.de>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
        <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
        <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 1 Nov 2017 02:51:58 -0400
schrieb Dave <davestechshop@gmail.com>:

> >  
> >> To reconcile those conflicting goals, the only idea I have come up
> >> with so far is to use btrfs send-receive to perform incremental
> >> backups  
> >
> > As already said by Romain Mamedov, rsync is viable alternative to
> > send-receive with much less hassle. According to some reports it
> > can even be faster.  
> 
> Thanks for confirming. I must have missed those reports. I had never
> considered this idea until now -- but I like it.
> 
> Are there any blogs or wikis where people have done something similar
> to what we are discussing here?

I used rsync before, backup source and destination both were btrfs. I
was experiencing the same btrfs bug from time to time on both devices,
luckily not at the same time.

I instead switched to using borgbackup, and xfs as the destination (to
not fall the same-bug-in-two-devices pitfall). Borgbackup achieves a
much higher deduplication density and compression, and as such also is
able to store much more backup history in the same storage space. The
first run is much slower than rsync (due to enabled compression) but
successive runs are much faster (like 20 minutes per backup run instead
of 4-5 hours).

I'm currently storing 107 TB of backup history in just 2.2 TB backup
space, which counts a little more than one year of history now,
containing 56 snapshots. This is my retention policy:

  * 5 yearly snapshots
  * 12 monthly snapshots
  * 14 weekly snapshots (worth around 3 months)
  * 30 daily snapshots

Restore is fast enough, and a snapshot can even be fuse-mounted (tho,
in that case mounted access can be very slow navigating directories).

With latest borgbackup version, the backup time increased to around 1
hour from 15-20 minutes in the previous version. That is due to
switching the file cache strategy from mtime to ctime. This can be
tuned to get back to old performance, but it may miss some files during
backup if you're doing awkward things to file timestamps.

I'm also backing up some servers with it now, then use rsync to sync
the borg repository to an offsite location.

Combined with same-fs local btrfs snapshots with short retention times,
this could be a viable solution for you.


-- 
Regards,
Kai

Replies to list-only preferred.

