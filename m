Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60439 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab2JZP75 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 11:59:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TRmKH-0003ed-QY
	for linux-btrfs@vger.kernel.org; Fri, 26 Oct 2012 18:00:01 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 18:00:01 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 18:00:01 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [RFC] Systemcall for offline deduplication
Date: Fri, 26 Oct 2012 15:59:39 +0000 (UTC)
Message-ID: <k6ec1a$1ad$1@ger.gmane.org>
References: <507C4343.6060305@shiftmail.org>
	<20121015201516.GB10679@twin.jikos.cz> <k5m5du$keo$1@ger.gmane.org>
	<20121026062614.GA19617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 25 Oct 2012 23:26:14 -0700, Darrick J. Wong wrote:
>> Now, here's my proposal for fixing that:
>> A BTRFS_IOC_SAME_RANGE ioctl would be ideal. Takes two file
>> descriptors, two offsets, one length, does some locking, checks that
>> the ranges are identical (returns EINVAL if not), and defers to an
>> implementation that works like clone_range with the metadata update and
>> the writable volume restriction moved out.
>> 
>> I didn't go with something block-based or extent-based because with
>> compression and fragmentation, extents would very easily fail to be
>> aligned.
>> 
>> Thoughts on this interface?
>> Anyone interested in getting this implemented, or at least providing
>> some guidance and patch review?
> 
> This sounds quite a bit like what Josef had proposed with the
> FILE_EXTENT_SAME ioctl a couple of years ago[1].  At the time, he was
> only interested in writing a userland dedupe program for various
> reasons, and afaict it hasn't gone anywhere.  If you're going to do the
> comparing from userspace, I'd imagine you ought to have a better method
> to pin an extent than chattr +i...

The immutable hack is a bit lame, but it will have to stay until we get a 
good kernel API.

> I guess you could create a temporary file, F_E_S the parts of the files
> you're trying to compare into the temp file, link together whichever
> parts you want to, and punch_hole the entire temp file before moving on.
>  I think it's the case that if the candidate files get rewritten during
> the dedupe operation, the new data will be written elsewhere; the punch
> hole operation will release the disk space if its refcount becomes zero.

The FILE_EXTENT_SAME proposal is not the one I'd prefer.
The parameters (fds, offsets, one length) are fine.
It's not as extent-based as the name implies (no extents in the 
parameters), except that it sill needs a single extent on the left side, 
which won't work for fragmented files. That alone may be worked around by 
creating a new tempfile to use on the source side, but that has 
downsides: it will unshare extents and might actually increase disk use, 
and it won't work on read-only snapshots.
It is better to just pass fragmented offsets to the kernel and not put 
workarounds that reduce visibility for the implementation.

The restrictions for compressed or encrypted files and cross-subvolume 
dedup are also inconvenient. That makes me more interested in an 
implementation based on clone_range, which has neither limitation.
That's the proposal above.

>  The offline dedupe scheme seems like a good way to reclaim disk space
> if you don't mind having fewer copies of data.

I'm happy with the gains, although they are entirely dependent on having 
a lot of redundant data in the first place. The messier the better.

> As for online dedupe (which seems useful for reducing writes), would it
> be useful if one could, given a write request, compare each of the dirty
> pages in that request against whatever else the fs has loaded in the
> page cache, and try to dedupe against that?  We could probably speed up
> the search by storing hashes of whatever we have in the page cache and
> using that to find candidates for the memcmp() test.  This of course is
> not a comprehensive solution, but (a)
> we combine it with offline dedupe later and (b) we don't make a disk
> write out data that we've recently read or written.  Obviously you'd
> want to be able to opt-in to this sort of thing with an inode flag or
> something.

That's another kettle of fish, and will require an entirely different 
approach. ZFS has some experience doing that. While their implementation 
may reduce writes it is at the cost of storing hashes of every block in 
RAM.

> [1]
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07779.html
> 
>> [1] https://github.com/g2p/bedup#readme

