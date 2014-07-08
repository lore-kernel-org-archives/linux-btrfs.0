Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52003 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaGHCoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jul 2014 22:44:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X4LNz-0001ed-Tc
	for linux-btrfs@vger.kernel.org; Tue, 08 Jul 2014 04:44:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jul 2014 04:44:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jul 2014 04:44:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
Date: Tue, 8 Jul 2014 02:43:51 +0000 (UTC)
Message-ID: <pan$5e578$d83c9a0b$aad1fa2b$9a41848@cox.net>
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
	<53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com>
	<53B594E7.9070500@inwind.it> <53B6032D.6090207@cn.fujitsu.com>
	<53B6E744.1060204@inwind.it> <53B9FBE4.6040300@cn.fujitsu.com>
	<53BADAF1.80803@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Mon, 07 Jul 2014 19:37:53 +0200 as
excerpted:

> For "mounted RO" I mean the VFS flag, the "one" passed via the mount
> command. I say "one" as 1, because I am convinced that it has to act
> globally,
> e.g. on the whole filesystem; the flag should be set at the first mount,
> then it can be changed (only ?) issuing a "mount -o remount,rw/ro"
[...]
> So for each filesystem, there is a "globally" flag ro/rw which acts on
> the whole filesystem. Clear and simple.
> 
> Step 2: a more fine grained control of the subvolumes.
> We have already the capability to make a subvolume read-only/read-write
> doing
> 
>    # btrfs property set -t s /path/to/subvolume ro true
> 
> or
> 
>    # btrfs property set -t s /path/to/subvolume ro false
> 
> My idea is to use this flag. It could be done at the mount time for
> example:
> 
>   # mount -o subvolmode=ro,subvol=subvolname /dev/sda1 /
> 
> (this example doesn't work, it is only a my idea)
> 
> So:
> - we should not add further code
> - the semantic is simple
> - the property is linked to the subvolume in a understandable way
> 
> We should only add the subvolmode=ro option to the mount command.
> 
> Further discussion need to investigate the following cases:
> - if the filesystem is mounted as ro (mount -o ro....), does mounting a
> subvolume rw ( mount -o subvolmode=rw...) should raise an error ? 
> (IMHO yes)
> - if the filesystem is mounted as ro (mount -o ro....), does mounting
> the filesystem a 2nd time rw ( mount -o rw...) should raise an error ? 
> (IMHO yes)
> - if a subvolume is mounter rw (or ro), does mounting the same subvolume
> a 2nd time as ro (or rw) should raise an error ?
> (IMHO yes)

Makes sense.

Assuming I'm following you correctly, then, no subvolumes could be rw if 
the filesystem/vfs flag was set ro.

Which would mean that in ordered to mount any particular subvolume rw, 
the whole filesystem would have to be rw.

Extending now:

For simplicity and backward compatibility, if subvolmode isn't set, it 
corresponds to the whole-fs/vfs mode.  That way, setting mount -o ro,... 
(or -o rw,...) with the first mount would naturally propagate to all 
subsequent subvolume mounts, unless of course (1) all subvolumes and the 
filesystem itself are umounted, after which a new mount would be the 
first one again, or (2) a mount -o remount,... is done that changes the 
whole-fs mode.

Further, if it happened that one wanted the first subvolume mounted to be 
ro, but the filesystem as a whole rw so that other subvolumes could be 
mounted rw, the following would accomplish that:

mount -o rw,subvolmode=ro

That way, the subvol would be ro as desired, but the filesystem as a 
whole would be rw, so other subvolumes could be successfully mounted rw.

I like the concept. =:^)

The remaining problem to deal with is that if say the root subvol (id=5) 
is mounted rw,subvolmode=rw, while a subvolume below it is mounted 
subvolmode=ro, then what happens if someone tries to make an edit in the 
portion of the filesystem visible in the subvolume, but from the parent, 
id=5/root in this case?  Obviously if that modification is allowed from 
the parent, it'll change what's visible in the child subvolume as well, 
which would be rather unexpected.

I'd suggest that the snapshotting border rule should apply to writes as 
well.  Snapshots stop at subvolume borders, and writes should as well.  
Attempting to write in a child subvolume should error out -- child 
subvolumes are not part of a parent snapshot and shouldn't be writable 
from the parent subvolume, either.  Child-subvolume content should be 
read-only because it's beyond the subvolume border.

That would seem to be the safest.  Altho I believe it's a change from 
current behavior, where it's possible to write into any subvolume visible 
from the parent (that is, not covered by an over-mount, perhaps even of 
the same subvolume that would otherwise be visible in the same location 
from the parent subvolume), provided the parent is writable.

Regardless, my biggest take-away from the discussion so far is that I'm 
glad I decided to go with entirely separate filesystems, each on their 
own partitions, so my ro vs writable mounts do exactly what I expect them 
to do without me having to worry or think about it too much!  That wasn't 
the reason I did it -- I did it because I didn't want all my data eggs in 
the same whole-filesystem basket such that if a filesystem was damaged, 
the damage was compartmentalized -- but now that see all the subvolume rw/
ro implications discussed in this thread, I'm VERY glad I personally 
don't have to worry about it, and it all simply "just works" for me, 
because each filesystem is independent of the others, not simply a 
subvolume!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

