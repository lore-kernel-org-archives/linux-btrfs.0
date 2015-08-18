Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59931 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbbHRO7S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 10:59:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZRiM2-0005Oi-CC
	for linux-btrfs@vger.kernel.org; Tue, 18 Aug 2015 16:59:10 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 16:59:10 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 16:59:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: The performance is not as expected when used several disks on
 raid0.
Date: Tue, 18 Aug 2015 14:59:04 +0000 (UTC)
Message-ID: <pan$ec77c$4643ff2d$5835f160$c7fa925@cox.net>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
	<CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
	<55CE4682.3080106@gmail.com>
	<CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
	<55CE4866.6060207@gmail.com> <pan$82931$bcf5ef1b$88d8d18$c8aa5770@cox.net>
	<55D1C7A5.7050204@gmail.com> <pan$9af23$4fb7d57c$d76038f$6f4281af@cox.net>
	<55D31831.1000404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Tue, 18 Aug 2015 07:34:09 -0400 as
excerpted:

>> 4-device raid6, btrfs and mdraid both allow that, good point.  But of
>> course mdraid6 doesn't have the data integrity, only rebuild-parity.
>>
> Huh, I didn't know that mdraid allowed that, I know dm-raid through LVM
> doesn't (which in turn is a large part of what caused me to try btrfs
> raid56 so soon, I had been going to do btrfs raid1 on top of LVM based
> raid6).

Yes.  I ran a 4-device mdraid-6 for a couple years or so.  Then I got 
tired of the write performance, and the devices were getting old and I 
found I had room if I squeezed, so I switched to 4-way mdraid1 on the 
same devices, for awhile.  That's actually what I was running when I 
first looked into btrfs, and was hugely disappointed that btrfs could 
only do pair-mirrored raid1.  The devices were old enough I didn't trust 
pair-mirrored, and wanted at least 3-way, so I didn't switch to btrfs at 
that time.

I only switched to btrfs sometime later, after I upgraded the core 
system, and primary storage to ssd.  I had been impressed with reiserfs, 
which I still use on my spinning rust, but decided its journaling wasn't 
going to be good for ssds, and while I was upgrading to something a bit 
more ssd friendly, decided I might as well go btrfs.

So now I'm running btrfs on the two ssds, partitioned identically, with 
several btrfs raid1 filesystems on parallel partitions on the two, with 
primary (fat-finger-level) backup on other partitions on the same devices.
Only /boot (and the gpt bios and efi partitions, bios currently used, efi 
pre-allocated for easy mobo upgrade) is not btrfs raid1.  It's btrfs 
mixed-bg-mode dup, with an independent btrfs on each device, with grub2-
core independently installed to the gpt bios partition on each device as 
well, so I can boot either one by simply selecting it in the bios, 
allowing the one to be the backup for the other, much like additional 
partitions and btrfs raid1 on the same physical pair are backups for the 
working copy of other partitions.  But a backup raid1 btrfs won't work 
for /boot, since grub can really only point at one /boot (tho of course 
with grub2-core installed in the bios partition, I could use grub 
emergency mode to select a backup /boot if necessary, but that's harder 
than simply having two independent /boots setup, one per device), which 
is why I run two independent dup-mode /boots.

Secondary backup is to reiserfs on another device, spinning rust, with 
third backup to a normally disconnected external USB device.  For my use-
case, I decided off-site backup isn't worth the hassle, as the backup 
that /really/ counts is in my head, and if all the on-site backups 
including the external USB drive are unavailable, chances are a rather 
large real-life disaster (like my neighbor's house that burned down a few 
weeks ago) happened, and the things I'll be worried about then will make 
worrying about a lost computer backup look rather trivial.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

