Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45339 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755928AbdGXO0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:26:25 -0400
Date: Mon, 24 Jul 2017 16:25:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
Message-ID: <20170724142508.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:47:11PM +0200, Hans van Kranenburg wrote:
>     In the first year of btrfs development, around early 2008, btrfs
> gained a mount option which enables specific functionality for
> filesystems on solid state devices. The first occurance of this
> functionality is in commit e18e4809, labeled "Add mount -o ssd, which
> includes optimizations for seek free storage".
> 
> The effect on allocating free space for doing (data) writes is to
> 'cluster' writes together, writing them out in contiguous space, as
> opposed to a 'tetris' way of putting all separate writes into any free
> space fragment that fits (which is what the -o nossd behaviour does).
> 
> A somewhat simplified explanation of what happens is that, when for
> example, the 'cluster' size is set to 2MiB, when we do some writes, the
> data allocator will search for a free space block that is 2MiB big, and
> put the writes in there. The ssd mode itself might allow a 2MiB cluster
> to be composed of multiple free space extents with some existing data in
> between, while the additional ssd_spread mount option kills off this
> option and requires fully free space.
> 
> The idea behind this is (commit 536ac8ae): "The [...] clusters make it
> more likely a given IO will completely overwrite the ssd block, so it
> doesn't have to do an internal rwm cycle."; ssd block meaning nand erase
> block. So, effectively this means applying a "locality based algorithm"
> and trying to outsmart the actual ssd.
> 
> Since then, various changes have been made to the involved code, but the
> basic idea is still present, and gets activated whenever the ssd mount
> option is active. This also happens by default, when the rotational flag
> as seen at /sys/block/<device>/queue/rotational is set to 0.
> 
>     However, there's a number of problems with this approach.
> 
>     First, what the optimization is trying to do is outsmart the ssd by
> assuming there is a relation between the physical address space of the
> block device as seen by btrfs and the actual physical storage of the
> ssd, and then adjusting data placement. However, since the introduction
> of the Flash Translation Layer (FTL) which is a part of the internal
> controller of an ssd, these attempts are futile. The use of good quality
> FTL in consumer ssd products might have been limited in 2008, but this
> situation has changed drastically soon after that time. Today, even the
> flash memory in your automatic cat feeding machine or your grandma's
> wheelchair has a full featured one.
> 
> Second, the behaviour as described above results in the filesystem being
> filled up with badly fragmented free space extents because of relatively
> small pieces of space that are freed up by deletes, but not selected
> again as part of a 'cluster'. Since the algorithm prefers allocating a
> new chunk over going back to tetris mode, the end result is a filesystem
> in which all raw space is allocated, but which is composed of
> underutilized chunks with a 'shotgun blast' pattern of fragmented free
> space. Usually, the next problematic thing that happens is the
> filesystem wanting to allocate new space for metadata, which causes the
> filesystem to fail in spectacular ways.
> 
> Third, the default mount options you get for an ssd ('ssd' mode enabled,
> 'discard' not enabled), in combination with spreading out writes over
> the full address space and ignoring freed up space leads to worst case
> behaviour in providing information to the ssd itself, since it will
> never learn that all the free space left behind is actually free.  There
> are two ways to let an ssd know previously written data does not have to
> be preserved, which are sending explicit signals using discard or
> fstrim, or by simply overwriting the space with new data.  The worst
> case behaviour is the btrfs ssd_spread mount option in combination with
> not having discard enabled. It has a side effect of minimizing the reuse
> of free space previously written in.
> 
> Fourth, the rotational flag in /sys/ does not reliably indicate if the
> device is a locally attached ssd. For example, iSCSI or NBD displays as
> non-rotational, while a loop device on an ssd shows up as rotational.
> 
> The combination of the second and third problem effectively means that
> despite all the good intentions, the btrfs ssd mode reliably causes the
> ssd hardware and the filesystem structures and performance to be choked
> to death. The clickbait version of the title of this story would have
> been "Btrfs ssd optimizations condered harmful for ssds".
> 
> The current nossd 'tetris' mode (even still without discard) allows a
> pattern of overwriting much more previously used space, causing many
> more implicit discards to happen because of the overwrite information
> the ssd gets. The actual location in the physical address space, as seen
> from the point of view of btrfs is irrelevant, because the actual writes
> to the low level flash are reordered anyway thanks to the FTL.
> 
>     So what now...?
> 
> The changes in here do the following:
> 
> 1. Throw out the current ssd_spread behaviour.
> 2. Move the current ssd behaviour to the ssd_spread option.
> 3. Make ssd mode data allocation identical to tetris mode, like nossd.
> 4. Adjust and clean up filesystem mount messages so that we can easily
> identify if a kernel has this patch applied or not, when providing
> support to end users.
> 
> Instead of directly cutting out all code related to the data cluster, it
> makes sense to take a gradual approach and allow users who are still
> able to find a valid reason to prefer the current ssd mode the means to
> do so by specifiying the additional ssd_spread option.
> 
> Since there are other uses of the ssd mode, we keep the difference
> between nossd and ssd mode. However, the usage of the rotational
> attribute warrants some reconsideration in the future.
> 
> Notes for whoever wants to backport this patch on their 4.9 LTS kernel:
> * First apply commit 8a83665a "btrfs: drop the nossd flag when
>   remounting with -o ssd", or fixup the differences manually.
> * The rest of the conflicts are because of the fs_info refactoring. So,
>   for example, instead of using fs_info, it's root->fs_info in
>   extent-tree.c
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Thanks for the extensive historical summary, this change really deserves
it.

Decoupling the assumptions about the device's block management is really
a good thing, mount option 'ssd' should mean that the device just has
cheap seeks. Moving the the allocation tweaks to ssd_spread provides a
way to keep the behaviour for anybody who wants it.

I'd like to push this change to 4.13-rc3, as I don't think we need more
time to let other users to test this. The effects of current ssd
implementation have been debated and debugged on IRC for a long time.

Reviewed-by: David Sterba <dsterba@suse.com>
