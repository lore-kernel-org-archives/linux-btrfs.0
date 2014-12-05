Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39328 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbaLEXTR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 18:19:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xx29b-0000eM-WE
	for linux-btrfs@vger.kernel.org; Sat, 06 Dec 2014 00:19:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Dec 2014 00:19:15 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Dec 2014 00:19:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Possibility to have a "transient" snapshot?
Date: Fri, 5 Dec 2014 23:19:05 +0000 (UTC)
Message-ID: <pan$8f4a4$d039ef96$56b7642$3b07e2c1@cox.net>
References: <5481F91B.6090700@terminalsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James West posted on Fri, 05 Dec 2014 12:27:39 -0600 as excerpted:

> I'm sure some creative shell scripting could do something like this
> already,

Indeed...

> but I was more looking for something more bulletproof.

See below...

> General idea would be to have a transient snapshot (optional quota
> support possibility here) on top of a base snapshot (possibly readonly).
> On system start/restart (whether clean or dirty), the transient snapshot
> would be flushed, and the system would restart the snapshot, basically
> restarting from the base snapshot.

So to this point we're effectively restoring from a "golden image" at 
boot, wiping the history of the last session away.  I guess a lot of 
internet cafes do this sort of thing, either directly, or (these days) 
running from a VM, with multiple terminals, each logging into their own VM 
image.

> If desired, the transient snapshot
> could be promoted to a regular snapshot (say after a software upgrade).
> If desired, a different base snapshot could be selected (although I'm
> sure the file system would have to be restarted to do this)

So optionally make the transient image permanent, effectively upgrading 
it to the golden image (presumably with a fallback to the previous golden 
image if necessary).

>  From a caching perspective, this could make a noticable performance
> difference, since if you're running in a transient snapshot, the file
> system can be _extremely_ lazy about committing changes to disk.

Indeed.


I'm doing something here with a similar effect for root, except much less 
complicated and it doesn't require btrfs, tho btrfs snapshotting would be 
a useful if complicating variant.

Basically all I did is stick ro in the mount-options for root, so when it 
would normally be remounted rw, it's remounted with all the extra 
operating options, but still ro.

I only switch it to rw when I'm actively doing system maintenance.  Since 
I have all the other options I want loaded and in fstab already, all I 
have to do is remount rw, and it automatically picks up the compression, 
autodefrag, etc, from fstab and the previous mount.

Tho I don't use snapshots, instead preferring a backup of root, done 
manually when I've boot-tested the current config and believe it's stable 
enough, plus that it's time for a new backup.  Since root is only 8 GiB 
in size, backup can and does consist of a simple mkfs on the backup (also 
8 GiB), followed by mounting it and a mount-bind of root somewhere else 
so I can get at anything normally under a mountpoint and a straight copy 
won't accidentally stray into other filesystems, and copy everything 
over.  fstab is already a symlink (effectively) pointing to 
fstab.working, with an fstab.backup already prepared as well, so after 
the copy I switch the fstab symlink pointer on the backup and modify an 
ID file (making it easier to double-check what root is actually mounted).

I then umount the backup and the bind-mount, reboot, and select the grub 
menu entry that sets the kernel commandline root= to the backup instead 
of working copy, and verify that the backup is actually bootable.

Thus I effectively have a working (normal root) and backup (backup root) 
"golden image", with the working golden image mounted writable and 
updated whenever I update or modify system configuration, and the 
fallback image selectable from grub.

Of course I have secondary and tertiary backups as well, tertiary not 
normally attached, just in case, as well.

Gets rid of a lot of headaches, since I don't have to worry about root 
being corrupted in the normal crash-case at all, and if the working root 
/is/ ever unbootable either due to bad update or corruption while mounted 
writable, I can always boot to several levels of backup and have the 
fully working system I'm used to, including access to all manpages, X, 
the internet, etc, just as it was when I did the backup, to use as a 
recovery image. =:^)

/home and /var/log (with others including the packages partition mounted 
only on demand) are of course mounted writable, with their own backups as 
well, but it's nice to have a fully functional and uncorrupted root 
complete with all tools and reference material, that I know will boot 
even if they're corrupted, to use when doing repair if they do get 
corrupted. =:^)

I'm using fully independent filesystems instead of subvolumes and 
snapshots, since it didn't make any sense to me to risk putting all my 
data eggs in a single filesystem basket, and have them all broken at once 
if the bottom falls out, given that subvolumes and snapshots are still on 
the same filesystem, such that if one subvolume/snapshot is corrupted and 
unmountable, there's a good chance they're all gone.  Better to have 
partition and filesystem barriers in place to contain the damage, 
particularly when corruption on the writable /var/log could easily mean 
the read-only root that I'd otherwise be using to repair /var/log, is 
corrupted as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

