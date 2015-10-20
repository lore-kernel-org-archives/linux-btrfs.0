Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36087 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbbJTU65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 16:58:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zodzd-0005Lx-3C
	for linux-btrfs@vger.kernel.org; Tue, 20 Oct 2015 22:58:49 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 22:58:49 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 22:58:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to remove missing device on RAID1?
Date: Tue, 20 Oct 2015 20:58:36 +0000 (UTC)
Message-ID: <pan$55e2$eeada9c5$c7289131$4f093ca1@cox.net>
References: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kyle Manna posted on Tue, 20 Oct 2015 10:24:48 -0700 as excerpted:

> Hi all,
> 
> I have a collection of three (was 4) 1-2TB devices with data and
> metadata in a RAID1 mirror.  Last night I was struck by the Click of
> Death on an old Samsung drive.
> 
> I removed the device from the system, rebooted and mounted the volume
> with `-o degraded` and the file system seems fine and usable.  I'm
> waiting on a replacement, drive but want to remove the old drive and
> re-balance in the meantime.
> 
> How do I remove the missing device?  I tried the `btrfs device delete
> missing /mnt` but was greeted with "ERROR: missing is not a block
> device".  A quick look at that btrfs-progs git repo shows that
> `stat("missing")` is called, which of course fails since missing isn't a
> block device.  Nothing other then `btrfs replace` seemed intuitive and
> all the docs mention the older command.  What's the move?
> 
> Thanks!
> - Kyle
> 
> Versions:
> Kernel: 4.2.3-1-ARCH
> btrfs-progs: 4.2.2-1 ᐧ

I believe the current advice given here (that you were likely trying to 
follow, wrapped link)...

https://btrfs.wiki.kernel.org/index.php/
Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices

... is dated and no longer works due to code change some time in the past.

There's a set of (very) recent patches, to the kernel and userspace both 
(I just updated userspace and it's in the git devel-branch v4.2.3-49-
g4db87a1 I just built, kernelspace, I don't see it in linus-mainline yet, 
so I'd guess it's in the btrfs-integration patches, to land in the v4.4 
commit window if not in 4.3 as it's getting late in the cycle for that.

btrfs fi show <path>

That will list the btrfs component devices together with their devids.

Then use the appropriate devid like so:

btrfs dev del <devid> <path>

The -progs commit is d462081f, by Anand Jain, titled:

btrfs-progs: Introduce device delete by devid

According to it, the required kernel commit (title only listed) is 
similar:

Btrfs: Introduce device delete by devid

You can probably find them on-list if you wish to cherry-pick them into a 
current version.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

