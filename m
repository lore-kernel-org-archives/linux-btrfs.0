Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56964 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaJGNmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 09:42:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XbV1c-0004E1-Su
	for linux-btrfs@vger.kernel.org; Tue, 07 Oct 2014 15:42:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Oct 2014 15:42:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Oct 2014 15:42:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: [Bug] 3.17.0 mixed-bg enospc but both btrfs fi show and btrfs fi df
 say there's plenty
Date: Tue, 7 Oct 2014 13:41:49 +0000 (UTC)
Message-ID: <pan$40d93$809c9f3a$611f994e$934f6422@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is with my small 256 MiB btrfs mixed-bg dup-mode /boot, or actually, 
with its backup (same size partition, different device).  Kernel 3.17.0, 
btrfs-progs 3.16.1 (both actually from git), gentoo.

It was time to renew my backups so I did a mkfs.btrfs on the backup to 
start fresh:

mkfs.btrfs -d dup -m dup -L bt0238gcn0+35l0 -O extref,skinny-metadata,no-
holes -f /dev/sdb3

Of course with the 256 MiB size, mkfs.btrfs naturally added mixed-bg to 
the features as well.

I then did a balance to remove the single-mode mkfs-time artifacts.

Mount-options on both the working and backup filesystems are identical:

nodev,nosuid,noauto,compress=lzo,autodefrag

Mounting both filesystems, I then tried to use mc to copy everything from 
the working filesystem to the mkfs-fresh backup.  That failed with 
enospc.  However, in the past, repeated copy attempts, using "if size 
differs" when mc pops up the duplicate filename warnings, have eventually 
copied everything over just fine.

This time, while repeated copy attempts did result in most files copying, 
the (dracut generated) cpio archive that gets appended to my kernels as 
the initramfs failed to copy over.

However, the source filesystem is an identically sized btrfs with the 
same mount options (and I think the same features enabled, tho I'm not 
sure), and the files fit there with "plenty" (for the fs size) of room to 
spare!

And both btrfs filesystem show and btrfs filesystem df say there's lots 
of room left.

Destination filesystem (without the 14905 KiB cpio file, #>> indicates 
the prompt):

#>>btrfs filesystem show /bk/bt
Label: 'bt0238gcn0+35l0'  uuid: 4d310294-c899-4dcc-be81-580d477060e9
        Total devices 1 FS bytes used 30.59MiB
        devid    1 size 256.00MiB used 132.00MiB path /dev/sdb3

Btrfs v3.16.1

#>>btrfs filesystem df /bk/bt
System, DUP: total=16.00MiB, used=4.00KiB
Data+Metadata, DUP: total=50.00MiB, used=30.59MiB
GlobalReserve, single: total=4.00MiB, used=0.00


Source filesystem (including the 14905 KiB cpio file):

c#>>btrfs filesystem show /bt
Label: 'bt0238gcn1+35l0'  uuid: d6539322-0834-4eeb-928d-a13eb32dcbb2
        Total devices 1 FS bytes used 44.48MiB
        devid    1 size 256.00MiB used 159.00MiB path /dev/sda3

Btrfs v3.16.1

#>>btrfs filesystem df /bt
System, DUP: total=15.50MiB, used=4.00KiB
Data+Metadata, DUP: total=64.00MiB, used=44.48MiB
GlobalReserve, single: total=4.00MiB, used=0.00


On the destination, 50 MiB data+metadata allocated - 30.59 MiB used = 
19.41 MiB free in the chunk(s).  So an approximately 14.6 MiB file 
shouldn't even require additional chunk allocation.  But as can be seen 
from the show output, even if it did, there's plenty of unallocated space 
left to allocate new chunks if need be.

So why am I getting enospc?


FWIW, if I try to cp it instead of using mc, 14208 KiB copies before I 
get the enospc.

At that point, with the partially copied (14208/14905 KiB) file, this is 
what I get:

#>>btrfs filesystem show /bk/bt
Label: 'bt0238gcn0+35l0'  uuid: 4d310294-c899-4dcc-be81-580d477060e9
        Total devices 1 FS bytes used 43.59MiB
        devid    1 size 256.00MiB used 132.00MiB path /dev/sdb3

Btrfs v3.16.1

#>>btrfs filesystem df /bk/bt
System, DUP: total=16.00MiB, used=4.00KiB
Data+Metadata, DUP: total=50.00MiB, used=43.58MiB
GlobalReserve, single: total=4.00MiB, used=0.00


So no further chunk allocation, data+metadata usage increased from 30.59 
MiB to 43.58 MiB, almost exactly 13 MiB.  The file is 14905 MiB and 14208 
copied but it couldn't handle that last ~700 KiB, even tho data+metadata 
still shows nearly 6.5 MiB still unused in the existing chunk and there's 
still 124 MiB unallocated, nearly half the 256 MiB filesystem size!  That 
can be halved due to dup-mode for ~62 MiB of usable space, barring bugs 
like this one.

And it all fits on the basically identical source btrfs, with 97 MiB 
still unallocated to chunks and 19+ MiB free in the data+metadata 
chunks.  So why is the new filesystem prematurely enospcing me?

I can btrfs image the filesystems if necessary, and/or even dd-image them 
and send the whole thing, tho it /does/ have kernel config and system-
maps, etc as well as my grub2 config, so while it's not too private it's 
probably not something I want on a public list.  Tho I'd guess it to be a 
reasonably generic issue to duplicate, given the information above.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

