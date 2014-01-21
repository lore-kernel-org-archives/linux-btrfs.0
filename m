Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55175 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbaAURI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 12:08:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W5eoK-0002Xv-BV
	for linux-btrfs@vger.kernel.org; Tue, 21 Jan 2014 18:08:24 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 18:08:24 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 18:08:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrubbing with BTRFS Raid 5
Date: Tue, 21 Jan 2014 17:08:01 +0000 (UTC)
Message-ID: <pan$226f4$e1329373$53c2dcca$438e95e@cox.net>
References: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Fleming posted on Tue, 21 Jan 2014 01:06:37 -0800 as excerpted:

> Thanks for all the info guys.
> 
> I ran some tests on the latest 3.12.8 kernel. I set up 3 1GB files and
> attached them to /dev/loop{1..3} and created a BTRFS RAID 5 volume with
> them.
> 
> I copied some data (from dev/urandom) into two test files and got their
> MD5 sums and saved them to a text file.
> 
> I then unmounted the volume, trashed Disk3 and created a new Disk4 file,
> attached to /dev/loop4.
> 
> I mounted the BTRFS RAID 5 volume degraded and the md5 sums were fine. I
> added /dev/loop4 to the volume and then deleted the missing device and
> it rebalanced. I had data spread out on all three devices now. MD5 sums
> unchanged on test files.
> 
> This, to me, implies BTRFS RAID 5 is working quite well and I can in
> fact,
> replace a dead drive.
> 
> Am I missing something?

What you're missing is that device death and replacement rarely happens 
as neatly as your test (clean unmounts and all, no middle-of-process 
power-loss, etc).  You tested best-case, not real-life or worst-case.

Try that again, setting up the raid5, setting up a big write to it, 
disconnect one device in the middle of that write (I'm not sure if just 
dropping the loop works or if the kernel gracefully shuts down the loop 
device), then unplugging the system without unmounting... and /then/ see 
what sense btrfs can make of the resulting mess.  In theory, with an 
atomic write btree filesystem such as btrfs, even that should work fine, 
minus perhaps the last few seconds of file-write activity, but the 
filesystem should remain consistent on degraded remount and device add, 
device remove, and rebalance, even if another power-pull happens in the 
middle of /that/.

But given btrfs' raid5 incompleteness, I don't expect that will work.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

