Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55364 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2JQLpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 07:45:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TOS3c-00058t-2H
	for linux-btrfs@vger.kernel.org; Wed, 17 Oct 2012 13:45:04 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 13:45:04 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 13:45:04 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: [RFC] Systemcall for offline deduplication
Date: Wed, 17 Oct 2012 11:39:42 +0000 (UTC)
Message-ID: <k5m5du$keo$1@ger.gmane.org>
References: <507C4343.6060305@shiftmail.org>
	<20121015201516.GB10679@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 15 Oct 2012 22:15:16 +0200, David Sterba wrote:
> On Mon, Oct 15, 2012 at 07:09:23PM +0200, Bob Marley wrote:
>> I would really appreciate a systemcall (or ioctl or the like) to allow
>> deduplication of a block of a file against a block of another file.
>> (ok if blocks need to be aligned to filesystem blocks)
> 
> It exists, is called
> 
> BTRFS_IOC_CLONE_RANGE
> (http://lxr.free-electrons.com/source/fs/btrfs/ioctl.h#L399)
> 
> btrfs_ioctl_clone_range_args
> http://lxr.free-electrons.com/source/fs/btrfs/ioctl.h#L254
> 
>> The syscall should presumably check that the regions are really equal
>> and perform the deduplication atomically.
>> 
>> This would be the start for a lot of deduplication algorithms in
>> userspace.
>> It would be a killer feature for backup systems.
> 
> It doesn't do any checks if the range contents match, but for a backup
> system, the ranges can be merged at a calm state, ie not new data in
> flight.

Thanks for bringing this up.

I'm the author of bedup[1], a btrfs deduplication tool which currently 
uses the IOC_CLONE_RANGE syscall (and a host of other btrfs features: 
search, fiemap, inode-to-path backrefs, etc).

By far the biggest drawback is that the same-range check is done in 
userland; that means I need to lock files in userland to guarantee I have 
exclusive access to both files at the time the clone call is done.
I've found a way that might be okay against non-root users, but I 
wouldn't swear to it, and if it isn't that creates a security risk.

The other drawbacks come from CLONE_RANGE being a write operation.
It can't be done with read-only subvolumes, which is a shame because 
backup filesystems containing mostly read-only snapshots are a great 
candidate for deduplication. And it updates the mtime, when deduplication 
should be an implementation detail with no impact on file metadata.

Now, here's my proposal for fixing that:
A BTRFS_IOC_SAME_RANGE ioctl would be ideal. Takes two file descriptors, 
two offsets, one length, does some locking, checks that the ranges are 
identical (returns EINVAL if not), and defers to an implementation that 
works like clone_range with the metadata update and the writable volume 
restriction moved out.

I didn't go with something block-based or extent-based because with 
compression and fragmentation, extents would very easily fail to be 
aligned.

Thoughts on this interface?
Anyone interested in getting this implemented, or at least providing some 
guidance and patch review?

[1] https://github.com/g2p/bedup#readme

