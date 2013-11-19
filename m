Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57639 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3KSXRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 18:17:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1ViuXn-0006XP-Te
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 00:17:19 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 00:17:19 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 00:17:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Date: Tue, 19 Nov 2013 23:16:58 +0000 (UTC)
Message-ID: <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
	<20131119090602.GV4315@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 19 Nov 2013 09:06:02 +0000 as excerpted:

> This will happen with RAID-10. The allocator will write stripes as wide
> as it can: in this case, the first stripes will run across all 8
> devices, until the SSDs are full, and then will write across the
> remaining 4 devices.

Hugo, it doesn't change the outcome for this case, but either your 
assertion above is incorrect, or the wiki discussion is incorrect (of 
course, or possibly I'm the one misunderstanding something, in which case 
hopefully replies to this will correct my understanding).

Because I distinctly recall reading on the wiki that for raid, regardless 
of the raid level, btrfs always allocates in pairs (well, I guess it'd be 
pairs of pairs for raid10 mode, and I believe that statement pre-dated 
raid5/6 support so that isn't included).  I was actually shocked by that 
because while I knew that was the case for raid1, I had thought that 
other raid levels would stripe as widely as possible, which is what you 
assert above as well.

Now I just have to find where I read that on the wiki...

OK, here's one spot, FAQ, md-raid/device-mapper-raid/btrfs-raid 
differences, btrfs:

https://btrfs.wiki.kernel.org/index.php/FAQ#btrfs

>>>>

btrfs combines all the drives into a storage pool first, and then 
duplicates the chunks as file data is created. RAID-1 is defined 
currently as "2 copies of all the data on different disks". This differs 
from MD-RAID and dmraid, in that those make exactly n copies for n disks. 
In a btrfs RAID-1 on 3 1TB drives we get 1.5TB of usable data. Because 
each block is only copied to 2 drives, writing a given block only 
requires exactly 2 drives spin up, reading requires only 1 drive to 
spinup.

RAID-0 is similarly defined, with the stripe split among exactly 2 disks. 
3 1TB drives yield 3TB usable space, but to read a given stripe only 
requires 2 disks.

RAID-10 is built on top of these definitions. Every stripe is split 
across to exactly 2 RAID1 sets and those RAID1 sets are written to 
exactly 2 disk (hense 4 disk minimum). A btrfs raid-10 volume with 6 1TB 
drives will yield 3TB usable space with 2 copies of all data, but only 4

<<<<

[Yes, that ending sentence is incomplete in the wiki.]

So we have:

1) raid1 is exactly two copies of data, paired devices.

2) raid0 is a stripe exactly two devices wide (reinforced by to read a 
stripe takes only two devices), so again paired devices.

3) raid10 is a combination of the above raid0 and raid1 definitions, 
exactly two raid1 pairs, paired in raid0.

So btrfs raid10 is pairs of pairs, each raid0 stripe a pair of raid1 
mirrors.  If there's 8 devices, four smaller, four larger, the first  
allocated chunks should be one per device, until the smaller devices fill 
up it'll chunk across the remaining four, but it'll be pairs of pairs of 
pairs, two pair(0)-of-pair(1) stripes wide instead of a single quad(0)-of-
pair(1) stripe wide.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

