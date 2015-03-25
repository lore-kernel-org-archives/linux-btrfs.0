Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbbCYBTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 21:19:39 -0400
Date: Wed, 25 Mar 2015 02:19:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Marc Cousin <cousinmarc@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
Message-ID: <20150325011937.GB20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <550E7917.5030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <550E7917.5030602@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 22, 2015 at 09:11:03AM +0100, Marc Cousin wrote:
> I've noticed this problem for a while (I started to use snapper a
> while ago): while destroying snapshots, it's almost impossible to do
> IO on the volume.

The snapshots get cleaned in the background, which usuall touches lots
of data (depending on the "age" of the extents, IOW the level of sharing
among the live and deleted snapshots).

The slowdown is caused due to contention on the metadata (locking,
readig from disk, scattered blocks, lots of seeking).

Snapper might add to that if you have

EMPTY_PRE_POST_CLEANUP="yes"

as it reads the pre/post snapshots and deletes them if the diff is
empty. This adds some IO stress.

> The btrfs cleaner is 100% active:
> 
>  1501 root      20   0       0      0      0 R 100,0  0,0   9:10.40 [btrfs-cleaner]    

That points to the snapshot cleaning, but the cleaner thread does more
than that. It may also process delayed file deletion and work scheduled
if 'autodefrag' is on.

> As soon as it terminates its job, the filesystem becomes usable again.
> But while waiting it is extremely unresponsive. Any program doing a
> write there hangs.
> 
> Some more information: the 3 disks are 2.7TB, the raid is RAID1
> 
> # btrfs fi df /mnt/btrfs
> Data, RAID1: total=3.18TiB, used=3.14TiB
> System, RAID1: total=32.00MiB, used=480.00KiB
> Metadata, RAID1: total=6.00GiB, used=4.32GiB

Space looks ok, enough data and metadata so it's not affected by low
space conditions.

> What is "funny" is that the filesystem seems to be working again when
> there is some IO activity and btrfs-cleaner gets to a lower cpu usage
> (around 70%).

Possibly a behaviour caused by scheduling (both cpu and io), the other
process gets a slice and slows down cleaner that hogs the system.

> By the way, there are quite a few snapshots there:
> 
> # btrfs subvolume  list /mnt/btrfs | wc -l
> 142
> 
> and I think snapper tries to destroy around 10 of them on one go.

The snapshots get cleaned in the order of deletion, and if there is some
amount of sharing, the metadata blocks are probably cached. So it may
actually help to delete them in a group.

> I can do whatever test you want, as long as I keep the data on my disks :)

So far it looks like effects of filesystem aging in the presence of
snapshots. Right now, I think we could try to somehow adjust the io
scheduling priority in case the cleaner processes the deleted
subvolumes, but this is unfortunatelly done in an asynchronous manner
and the metadata are read by other threads so this could be fairly
intrusive patch.

Or, introduce an interface that would set the subvolume cleaning
behaviour, eg. only if idle, or normal or immediate. The dead and
uncleaned subvolumes pin the space so we cannot make it 'idle' by
default.
