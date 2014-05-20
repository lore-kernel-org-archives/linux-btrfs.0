Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44015 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaETXCR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 19:02:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wmt32-0004qI-1P
	for linux-btrfs@vger.kernel.org; Wed, 21 May 2014 01:02:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 01:02:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 01:02:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check, btrfsck, fsck.btrfs
Date: Tue, 20 May 2014 23:02:01 +0000 (UTC)
Message-ID: <pan$bfe22$348a9807$13d86fd5$5784dae1@cox.net>
References: <9B5A4230-5A2F-4C00-AC4F-D9CA36A91620@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 20 May 2014 10:56:26 -0600 as excerpted:

> Should the initrd/initramfs no longer include btrfsck, and instead
> include btrfs and fsck.btrfs?

btrfs (the program) should be included in any case as btrfs device scan 
should be run (normally triggered via udev rules when a btrfs filesystem 
block device is detected) to enable mounting multi-device btrfs' (the 
filesystem) from within the initr*.

That's already the case with dracut's btrfs module, anyway, and has been 
for some time.

> In btrfs-progs 3.14 there is now a 1K /sbin/fsck.btrfs placeholder file.

To be more exact, it's a nearly noop shell-script (basically copied from 
fsck.xfs) that simply verifies that the passed in filename exists.  If it 
does, in auto-mode (if called automatically via a passno > 0 in fstab), 
it exits without error.  In non-auto-mode, it simply points the user at 
btrfs check.  If the device doesn't exist, it exits with "8" as the error 
status.  No check other than that the last parameter passed in is 
actually an existing file, not even whether it's actually a device or 
not, is done.

As btrfs (the filesystem) doesn't need a pre-mount check, the 
recommendation is to set passno to 0 for btrfs in any case, in which case 
fsck.btrfs shouldn't be needed at all.

As such, fsck.btrfs really shouldn't be needed in an initr*, since 
whatever's creating the initr* shouldn't be running a pre-mount auto-fsck 
against btrfs in any case, as to do so is certainly a bug.

(Tho with compression the incremental size of a single shell-script just 
over 1 KiB in size before compression should be trivial.)

> btrfs and btrfsck files are the same binary, the difference is btrfsck
> only can do check/repair. Including btrfs instead allows more
> flexibility to use additional subcommands, and it's also consistent with
> fsck.btrfs which references btrfs not btrfsck.

Ideally, btrfsck would be a symlink to btrfs in btrfs-progs, and 
potentially not included in an initr* at all, or if included, likewise 
included as a symlink.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

