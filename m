Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51451 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHCCjb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Aug 2014 22:39:31 -0400
From: Russell Coker <russell@coker.com.au>
To: Peter Waller <peter@scraperwiki.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Sun, 03 Aug 2014 12:39:28 +1000
Message-ID: <5254246.Tnvee4txJd@xev>
In-Reply-To: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 3 Aug 2014 00:35:28 Peter Waller wrote:
> I'm running Ubuntu 14.04. I wonder if this problem is related to the
> thread titled "Machine lockup due to btrfs-transaction on AWS EC2
> 
> Ubuntu 14.04" which I started on the 29th of July:
> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/37224
> 
> Kernel: 3.15.7-031507-generic

As an aside, I'm still on 3.14 kernels for my systems and have no immediate 
plans to use 3.15.  There has been discussion here about a number of problems 
with 3.15, so I don't think that any testing I do with 3.15 will help the 
developers and it will just take more of my time.

> $ sudo btrfs fi df /path/to/volume
> Data, single: total=489.97GiB, used=427.75GiB
> Metadata, DUP: total=5.00GiB, used=4.50GiB

As has been noted you are using all the space in 1G data chunks and the system 
can't allocate more 256M metadata chunks (which are allocated in pairs because 
it's "DUP" so allocating 512M at a time.

> In this case, for example, metadata has 0.5GiB free ("sounds like
> plenty for metadata for one mkdir to me"). Data has 62GiB free. Why
> would I get ENOSPC for a file rename?

Some space is always reserved.  Due to the way BTRFS works changes to a file 
requires writing a new copy of the tree.  So the amount of metadata space 
required for an operation that is conceptually simple can be significant.

One thing that can sometimes solve that problem is to delete a subvol.  But 
note that it can take a considerable amount of time to free the space, 
particularly if you are running out of metadata space.  So you could delete a 
couple of subvols, run "sync" a couple of times, and have a coffee break.

If possible avoid rebooting as that can make things much worse.  This was a 
particular problem with kernels 3.13 and earlier which could enter a CPU loop 
requiring a reboot and then you would have big problems.

> I tried a rebalance with btrfs balance start -dusage=10 and tried
> increasing the value until I saw reallocations in dmesg.

/sbin/btrfs fi balance start -dusage=30 -musage=10 /

It's a good idea to have a cron job running a rebalance.  Above is what I use 
on some of my systems, it will free data chunks that are up to 30% used and 
metadata chunks that are only 10% used.  It almost never frees metadata chunks 
and regularly frees data chunks which is what I want.

> and enlarge the volume. When I did this, metadata grew by 1GiB:
> > Data, single: total=490.97GiB, used=427.75GiB
> > System, DUP: total=8.00MiB, used=60.00KiB
> > System, single: total=4.00MiB, used=0.00
> > Metadata, DUP: total=5.50GiB, used=4.50GiB
> > Metadata, single: total=8.00MiB, used=0.00
> > unknown, single: total=512.00MiB, used=0.00

Now that you have solved that problem you could balance the filesystem 
(deallocating ~60 data chunks) and then shrink it.  In the past I've added a 
USB flash disk to a filesystem to give it enough space to allow a balance and 
then removed it (NB you have to do a btrfs remove before removing the USB 
stick).

> * Why didn't the metadata grow before enlarging the disk?
> * Why didn't the rebalance enable the metadata to grow?
> * Why is it necessary to rebalance? Can't it automatically take some
> free space from 'data'?

It would be nice if it could automatically rebalance.  It's theoretically 
possible as the btrfs program just asks the kernel to do it.  But there's 
nothing stopping you from having a regular cron job to do it.  You could even 
write a daemon to poll the status of a btrfs filesystem and run balance when 
appropriate if you were keen enough.

> * What is the best course of action to take (other than enlarging the
> disk or deleting files) if I encounter this situation again?

Have a cron job run a balance regularly.

On Sat, 2 Aug 2014 21:52:36 Nick Krause wrote:
> I have run into this error to and this seems to be a rather big issue as
> ext4 seems to never run of metadata room at least from my testing. I feel
> greatly that this part of btrfs needs be improved and moved into a function
> or set of functions for re balancing metadata in the kernel itself.

Ext4 has fixed size Inode tables that are assigned at mkfs time.  If you run 
out of Inodes then you can't create new files.  If you have too big Inode 
tables then you waste disk space and have a longer fsck time (at least before 
uninit_bg).

The other metadata for Ext4 is allocated from data blocks so it will run out 
when data space runs out (EG if mkdir fails due to lack of space on ext4 then 
you can delete a file to make it work).

But really BTRFS is just a totally different filesystem.  Ext4 lacks the 
features such as full data checksums and subvolume support that make these 
things difficult.

I always found the CP/M filesystem to be easier.  It was when they added 
support for directories that things started getting difficult.  :-#

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/



