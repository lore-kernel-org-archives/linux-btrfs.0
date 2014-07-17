Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59328 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817AbaGQPqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 11:46:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X7nse-0003jE-SG
	for linux-btrfs@vger.kernel.org; Thu, 17 Jul 2014 17:46:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 17:46:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 17:46:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes (even
 with different options)?
Date: Thu, 17 Jul 2014 15:45:46 +0000 (UTC)
Message-ID: <pan$f3e79$7fe40d55$62df9831$213dbb30@cox.net>
References: <53C6FA3D.9010803@informatik.uni-bonn.de>
	<20140717084153.GG4834@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 17 Jul 2014 09:41:53 +0100 as excerpted:

>> and are there any combinations of possibly conflicting mount options
>> one should be aware of (compression, autodefrag, cache clearing)? Is it
>> advisable to use the same mount options for all mounts pointing to the
>> same physical device?
> 
>    If you assume that the first mount options are the ones used for
> everything, regardless of any different options provided in subsequent
> mounts, then you probably won't go far wrong. It's not quite true: some
> options do work on a per-mount basis, but most are per-filesystem. I'm
> sure there was a list of them on the wiki at some point, but I can't
> seem to track it down right now.

IIRC/AFAIK, the btrfs-specific mount options should be per filesystem, 
while stuff like relatime vs noatime is VFS level and should work per 
subvolume.

There's actually a current discussion about ro vs rw.  Consider the case 
of a parent subvolume (perhaps but not necessarily the root subvolume, 
id=5), being mounted writable in one location, with a child mounted 
elsewhere read-only.  Because it's possible to browse in the parent's 
subvolume down into the child subvolume as well, and someone could write 
a file there, that write would then show up in the elsewhere mounted read-
only child subvolume as well.

That's unexpected behavior to say the least!  Normally, read-only means 
it cannot and will not change, but in this case it wouldn't mean that at 
all!

My idea is that the same rules should apply to ro/rw as apply to btrfs 
snapshots -- they stop at subvolume borders.  Any write into a child 
subvolume would thus throw an error, regardless of how the parent 
subvolume was mounted.  The only way to write into a subvolume would be 
to mount it read-write on its own.  That would solve the ambiguity, but 
it would also be quite a change from existing behavior, where a read-
write mount of the root subvolume can write into any subvolume.

Someone else suggested that we separate filesystem read-write from 
subvolume read-write.  There's already the concept of read-only 
snapshots, used in btrfs-send, for one thing.  The idea here would be 
that a read-only filesystem/root mount means the entire filesystem is 
read-only, but provided the filesystem/root was mounted read-write, 
individual subvolumes could be mounted read-only using a different 
option, subv=ro, or similar, which would be hooked into the existing read-
only subvolume mechanism.  In that case, if the filesystem/root was read-
write, then the subvolume specific rw/ro mount option would take 
precedence and would trigger an error on write to that subvolume even if 
written from the read-write parent mount.

But while btrfs is the first filesystem to do this sort of thing and thus 
to deal with the problem, it might not be the last, so policy 
coordination with the VFS layer should be considered and a generic kernel 
policy for any filesystem dealing with subvolumes should be established.  
IOW, it's bigger than simply btrfs.

So anyway, while there was a patch applied earlier that did allow 
different read-only/read-write subvolume mounts, I believe that's 
reverted for 3.16, while this discussion continues and until it gets 
resolved one way or another, possibly at a kernel conference or the like.

But I believe generic VFS stuff like noatime/relatime/atime and dev/nodev/
suid/nosuid/exec/noexec is fine per-subvolume, because that's enforced at 
the VFS layer and there's no internal or expectation inconsistency to 
worry about if you can access for example the same device-file as a 
device via one mountpoint and not by another.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

