Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51368 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2JZG0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 02:26:18 -0400
Date: Thu, 25 Oct 2012 23:26:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Gabriel <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Systemcall for offline deduplication
Message-ID: <20121026062614.GA19617@blackbox.djwong.org>
References: <507C4343.6060305@shiftmail.org>
 <20121015201516.GB10679@twin.jikos.cz>
 <k5m5du$keo$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <k5m5du$keo$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 17, 2012 at 11:39:42AM +0000, Gabriel wrote:
> On Mon, 15 Oct 2012 22:15:16 +0200, David Sterba wrote:
> > On Mon, Oct 15, 2012 at 07:09:23PM +0200, Bob Marley wrote:
> >> I would really appreciate a systemcall (or ioctl or the like) to allow
> >> deduplication of a block of a file against a block of another file.
> >> (ok if blocks need to be aligned to filesystem blocks)
> > 
> > It exists, is called
> > 
> > BTRFS_IOC_CLONE_RANGE
> > (http://lxr.free-electrons.com/source/fs/btrfs/ioctl.h#L399)
> > 
> > btrfs_ioctl_clone_range_args
> > http://lxr.free-electrons.com/source/fs/btrfs/ioctl.h#L254
> > 
> >> The syscall should presumably check that the regions are really equal
> >> and perform the deduplication atomically.
> >> 
> >> This would be the start for a lot of deduplication algorithms in
> >> userspace.
> >> It would be a killer feature for backup systems.
> > 
> > It doesn't do any checks if the range contents match, but for a backup
> > system, the ranges can be merged at a calm state, ie not new data in
> > flight.
> 
> Thanks for bringing this up.
> 
> I'm the author of bedup[1], a btrfs deduplication tool which currently 
> uses the IOC_CLONE_RANGE syscall (and a host of other btrfs features: 
> search, fiemap, inode-to-path backrefs, etc).
> 
> By far the biggest drawback is that the same-range check is done in 
> userland; that means I need to lock files in userland to guarantee I have 
> exclusive access to both files at the time the clone call is done.
> I've found a way that might be okay against non-root users, but I 
> wouldn't swear to it, and if it isn't that creates a security risk.
> 
> The other drawbacks come from CLONE_RANGE being a write operation.
> It can't be done with read-only subvolumes, which is a shame because 
> backup filesystems containing mostly read-only snapshots are a great 
> candidate for deduplication. And it updates the mtime, when deduplication 
> should be an implementation detail with no impact on file metadata.
> 
> Now, here's my proposal for fixing that:
> A BTRFS_IOC_SAME_RANGE ioctl would be ideal. Takes two file descriptors, 
> two offsets, one length, does some locking, checks that the ranges are 
> identical (returns EINVAL if not), and defers to an implementation that 
> works like clone_range with the metadata update and the writable volume 
> restriction moved out.
> 
> I didn't go with something block-based or extent-based because with 
> compression and fragmentation, extents would very easily fail to be 
> aligned.
> 
> Thoughts on this interface?
> Anyone interested in getting this implemented, or at least providing some 
> guidance and patch review?

This sounds quite a bit like what Josef had proposed with the FILE_EXTENT_SAME
ioctl a couple of years ago[1].  At the time, he was only interested in writing
a userland dedupe program for various reasons, and afaict it hasn't gone
anywhere.  If you're going to do the comparing from userspace, I'd imagine you
ought to have a better method to pin an extent than chattr +i...

I guess you could create a temporary file, F_E_S the parts of the files you're
trying to compare into the temp file, link together whichever parts you want
to, and punch_hole the entire temp file before moving on.  I think it's the
case that if the candidate files get rewritten during the dedupe operation, the
new data will be written elsewhere; the punch hole operation will release the
disk space if its refcount becomes zero.  The offline dedupe scheme seems like
a good way to reclaim disk space if you don't mind having fewer copies of data.


As for online dedupe (which seems useful for reducing writes), would it be
useful if one could, given a write request, compare each of the dirty pages in
that request against whatever else the fs has loaded in the page cache, and try
to dedupe against that?  We could probably speed up the search by storing
hashes of whatever we have in the page cache and using that to find candidates
for the memcmp() test.  This of course is not a comprehensive solution, but (a)
we combine it with offline dedupe later and (b) we don't make a disk write out
data that we've recently read or written.  Obviously you'd want to be able to
opt-in to this sort of thing with an inode flag or something.

Does any of this sound reasonable?

--D

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07779.html

> [1] https://github.com/g2p/bedup#readme
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
