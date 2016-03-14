Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49319 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbcCNBFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 21:05:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1afGxC-0001dp-75
	for linux-btrfs@vger.kernel.org; Mon, 14 Mar 2016 02:05:50 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 02:05:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 02:05:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Date: Mon, 14 Mar 2016 01:05:39 +0000 (UTC)
Message-ID: <pan$4099$d134b7c1$fa33147d$c2943157@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<pan$9abbc$75454df4$bbede296$bf2d7878@cox.net>
	<20160313210537.GW2334@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Haber posted on Sun, 13 Mar 2016 22:05:37 +0100 as excerpted:

> On Sun, Mar 13, 2016 at 05:12:35PM +0000, Duncan wrote:
>> Marc Haber posted on Sun, 13 Mar 2016 12:58:10 +0100 as excerpted:
>> > I see the same metadata spread as with the old filesystem in btrfs fi
>> > df,
>> > totl at 23 and used at 2.38 GiB. What I find strange is that this
>> > filesystem has Data, System and Metadata in "single" profile, is this
>> > the new default for a 200 GiB file system?
>> 
>> Single is default for data.  Metadata (and system) will normally
>> default to dup on a single device, raid1 on multi-device, EXCEPT on
>> detected SSDs, where it defaults to single as well, because the
>> firmware on some ssds will dedup it in any case.  If you know your ssd
>> isn't one of the deduping ones (as I do, here), you can of course
>> overrule that by specifying modes at mkfs.btrfs time.
> 
> It was both times the same Samsung 840 EVO. Has this SSD detection been
> added recently, or did older versions of mkfs.btrfs not detect an SSD
> through a crypto layer, maybe?

Btrfs' ssd detection has been there for quite some time now (for 
userspace, since well before the releases synced to kernel version with 
3.12 or so, which effectively makes it ancient history in btrfs terms).

But according to the mkfs.btrfs manpage, the detection is based on 
/sys/block/DEV/queue/rotational (with DEV substituted appropriately), and 
various layers got support for correctly passing that thru at various 
times, some before btrfs, some after.  So that's very likely why btrfs 
didn't detect it originally, if it was on top of crypto and/or some other 
layer that might not have been passing that thru.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

