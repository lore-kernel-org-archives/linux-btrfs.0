Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42136 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdKPQPS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 11:15:18 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eFMoi-0006gy-66
        for linux-btrfs@vger.kernel.org; Thu, 16 Nov 2017 17:15:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
Date: Thu, 16 Nov 2017 17:13:30 +0100
Message-ID: <20171116171330.7493c9c4@jupiter.sol.kaishome.de>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu>
 <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
 <20171114135040.65a659c0@natsu>
 <CAH=dxU7wjag+BPNdu__WidU1qNPeF7Sxgc8YthAVvxbrHx5VmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Link 2 slipped away, adding it below...

Am Tue, 14 Nov 2017 15:51:57 -0500
schrieb Dave <davestechshop@gmail.com>:

> On Tue, Nov 14, 2017 at 3:50 AM, Roman Mamedov <rm@romanrm.net> wrote:
> >
> > On Mon, 13 Nov 2017 22:39:44 -0500
> > Dave <davestechshop@gmail.com> wrote:
> >  
> > > I have my live system on one block device and a backup snapshot
> > > of it on another block device. I am keeping them in sync with
> > > hourly rsync transfers.
> > >
> > > Here's how this system works in a little more detail:
> > >
> > > 1. I establish the baseline by sending a full snapshot to the
> > > backup block device using btrfs send-receive.
> > > 2. Next, on the backup device I immediately create a rw copy of
> > > that baseline snapshot.
> > > 3. I delete the source snapshot to keep the live filesystem free
> > > of all snapshots (so it can be optimally defragmented, etc.)
> > > 4. hourly, I take a snapshot of the live system, rsync all
> > > changes to the backup block device, and then delete the source
> > > snapshot. This hourly process takes less than a minute currently.
> > > (My test system has only moderate usage.)
> > > 5. hourly, following the above step, I use snapper to take a
> > > snapshot of the backup subvolume to create/preserve a history of
> > > changes. For example, I can find the version of a file 30 hours
> > > prior.  
> >
> > Sounds a bit complex, I still don't get why you need all these
> > snapshot creations and deletions, and even still using btrfs
> > send-receive.  
> 
> 
> Hopefully, my comments below will explain my reasons.
> 
> >
> > Here is my scheme:
> > ============================================================================
> > /mnt/dst <- mounted backup storage volume
> > /mnt/dst/backup  <- a subvolume
> > /mnt/dst/backup/host1/ <- rsync destination for host1, regular
> > directory /mnt/dst/backup/host2/ <- rsync destination for host2,
> > regular directory /mnt/dst/backup/host3/ <- rsync destination for
> > host3, regular directory etc.
> >
> > /mnt/dst/backup/host1/bin/
> > /mnt/dst/backup/host1/etc/
> > /mnt/dst/backup/host1/home/
> > ...
> > Self explanatory. All regular directories, not subvolumes.
> >
> > Snapshots:
> > /mnt/dst/snaps/backup <- a regular directory
> > /mnt/dst/snaps/backup/2017-11-14T12:00/ <- snapshot 1
> > of /mnt/dst/backup /mnt/dst/snaps/backup/2017-11-14T13:00/ <-
> > snapshot 2
> > of /mnt/dst/backup /mnt/dst/snaps/backup/2017-11-14T14:00/ <-
> > snapshot 3 of /mnt/dst/backup
> >
> > Accessing historic data:
> > /mnt/dst/snaps/backup/2017-11-14T12:00/host1/bin/bash
> > ...
> > /bin/bash for host1 as of 2017-11-14 12:00 (time on the backup
> > system).
> > ============================================================================
> >
> > No need for btrfs send-receive, only plain rsync is used, directly
> > from hostX:/ to /mnt/dst/backup/host1/;  
> 
> 
> I prefer to start with a BTRFS snapshot at the backup destination. I
> think that's the most "accurate" starting point.

No, you should finish with a snapshot. Use the rsync destination as a
"dirty" scratch area, let rsync also delete files which are no longer
in the source. After successfully running rsync, make a snapshot of
that directory and make it RO, leave the scratch in place (even when
rsync dies or becomes killed).

I once made some scripts[2] following those rules, you may want to adapt
them.


> > No need to create or delete snapshots during the actual backup
> > process;  
> 
> Then you can't guarantee consistency of the backed up information.

Take a temporary snapshot of the source, rsync to to the scratch
destination, take a RO snapshot of that destination, remove the
temporary snapshot.

BTW: From user API perspective, btrfs snapshots do not guarantee
perfect granular consistent backups. A user-level file transaction may
still end up only partially in the snapshot. If you are running
transaction sensitive applications, those usually do provide some means
of preparing a freeze and a thaw of transactions.

I think the user transactions API which could've been used for this
will even be removed during the next kernel cycles. I remember
reiserfs4 tried to deploy something similar. But there's no consistent
layer in the VFS for subscribing applications to filesystem snapshots
so they could prepare and notify the kernel when they are ready.


> > A single common timeline is kept for all hosts to be backed up,
> > snapshot count not multiplied by the number of hosts (in my case
> > the backup location is multi-purpose, so I somewhat care about
> > total number of snapshots there as well);
> >
> > Also, all of this works even with source hosts which do not use
> > Btrfs.  
> 
> That's not a concern for me because I prefer to use BTRFS everywhere.

At least I suggest looking into bees[1] to deduplicate the backup
destination. Rsync is not very efficient to work with btrfs snapshots.
It will break reflinks often and write inefficiently sized blocks, even
with inplace option. Also, rsync won't efficiently catch files moved
back and forth often. Bees will be able to fix up all these problems
within a short amount of time (after initial scan) and also reduce
fragmentation of reflinks broken across multiple historical snapshots.
In the process it may also free up storage of no longer referenced
blocks of reflinked and broken extents.


[1]: https://github.com/Zygo/bees
[2]: https://gist.github.com/kakra/5520370

-- 
Regards,
Kai

Replies to list-only preferred.

