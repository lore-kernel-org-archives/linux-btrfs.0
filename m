Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45316 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaHMXTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 19:19:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XHhpL-0001IA-J6
	for linux-btrfs@vger.kernel.org; Thu, 14 Aug 2014 01:19:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 01:19:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 01:19:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: delete missing /dev/sdd which is now added as /dev/sdd1
Date: Wed, 13 Aug 2014 23:19:20 +0000 (UTC)
Message-ID: <pan$d18a1$d124172b$7cfbfa6b$9072ec25@cox.net>
References: <53EAF935.4040605@rasmusa.net>
	<20140813145155.GA20611@merlins.org>
	<1407944166.3763056.152323965.0FFD88B6@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rasmus Abrahamsen posted on Wed, 13 Aug 2014 17:36:06 +0200 as excerpted:

>  I now did the following
> 
> dd if=/dev/zero of=/dev/sdd
> 
> Finally, btrfs does not recognize the partition as part of my raid
> anymore, but what's worse is that it now tells me that two missing
> devices is a no go, so I cannot mount it as anything but read-only. All
> the data is there, /dev/sdd1 was never used and /dev/sdd was the
> originally missing one. Mounting as read-only prevents you from adding
> devices.

There's a patch in-flight that should, I believe, help with this.  I
haven't followed the specific details, but IIRC, it has something to do
with a missing sysfs entry.  Because of that missing entry, btrfs
(userspace) doesn't have the same view of filesystem device status that
the kernel has, and device add/replace/delete can go haywire.
Additionally, in some cases it triggers too many missing devices errors,
forcing the mount read-only, which in turn won't let you add devices to
fix the problem even if due to the circumstances you know all files are
actually there and intact.

So at this point you have three choices:

1) Give up on the filesystem, do a mkfs and go from there.

2) Wait for the patch to make it into kernel 3.17 and go from there.

3) Go read the list and find and cherrypick that patch, then rebuild with
it included, and go from there.


Meanwhile, an observation on the btrfs behavior that contributed to
getting you into this situation in the first place, and how to avoid it in
the future:

Btrfs filesystem and filesystem device detection relies on a "magic
string" found in the superblock to identify btrfs filesystems, and other
metadata within the superblock to determine what specific btrfs filesystem
it belongs to.  When events such as btrfs device add/delete/ replace that
change the devices composing a filesystem don't complete properly, this
superblock information can remain to confuse btrfs when it tries working
with the remaining device components in the filesystem.

That's what was happening to you, tho the missing sysfs entries mentioned
above make the situation rather worse.  Btrfs was still detecting these
remaining bits of superblock information saying that the device in
question belonged to the btrfs it originated with, and was getting
confused.

One way to avoid this problem is to use a tool called wipefs, part of
util-linux, to erase the magic-string btrfs detection uses, so that
particular device will no longer be detected as part of a btrfs, and thus
can't confuse btrfs.  Alternatively, you can simply zero-out the correct 8
bytes on the raw device manually, using for instance dd to write directly
to the device.

See this link from the btrfs wiki problem-FAQ for more (including how to
restore the 8-byte magic string using dd if you decide you made a mistake,
something not really possible if you zero out the entire device as you did
above):

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_old_superblock_.3F

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

