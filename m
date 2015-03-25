Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43186 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbbCYHpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 03:45:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yag0M-0000jR-Ir
	for linux-btrfs@vger.kernel.org; Wed, 25 Mar 2015 08:45:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 08:45:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 08:45:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs RAID 1 Very poor file re read cache
Date: Wed, 25 Mar 2015 07:45:28 +0000 (UTC)
Message-ID: <pan$c7fdb$e9d201e$d7551601$bcec4441@cox.net>
References: <1427169632.2878415.244369134.44ED7B24@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Severance posted on Tue, 24 Mar 2015 00:00:32 -0400 as excerpted:

> System:
> 
> Thinkserver TS140 E3-1225, 32GB ECC RAM, LSI9211-8i (IT unraid), 2 WD xe
> SAS as mdraid-raid1-ext4, 2 WD xe SAS as btrfs-raid1
> 
> Linux xyzzy 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02 CET 2015
> x86_64 GNU/Linux
> 
> btrfs-progs v3.19
> 
> btrfs fi: partition already removed, created with mkfs.btrfs -m raid1 -d
> raid1 -L sdmdata /dev/sdc /dev/sdd
> 
> dmesg: (not a problem with crashing)
> 
> Problem:
> 
> Very poor file reread cache. The database I use organizes both data and
> keys in a single file as a btree. This means that each successive record
> is located randomly around the file. Reading from first to last
> generates a lot of seeks.
> 
> On btrfs the speed is consistent throughout the whole file as it is on
> any system with too little memory for an effective cache. Every reread
> runs at the same slow and consistent speed.
> 
> So I unmount btrfs, quick zero the drives, mkfs.ext4, mount, and unpack
> the same data and run the same test on the same drives.
> 
> On ext4 (and xfs from other testing) the first time I read through the
> whole file it starts slow as it seeks around to uncached data and speeds
> up as more of the file is found in the cache. It is very fast by the
> end. Once in the cache I can read the file over and over super fast. The
> ext4 read cache is mitigating the time cost from the poor arrangement of
> the file.
> 
> I'm the only user on this test system so nothing is clearing my 32GB.

[Caveat.  I'm not a dev, only a fellow btrfs using admin and list 
regular.  My understanding isn't perfect and I've been known to be wrong 
from time to time.]

Interesting.  

But AFAIK it's not filesystem-specific cache, but generic kernel vfs-
level cache, so filesystem shouldn't have much effect on whether it's 
cached or not.

And on my btrfs-raid1 based system with 16 gigs RAM, I definitely notice 
the effects of caching, tho there are some differences.  Among other 
things, I'm on reasonably fast SSD, so 0-ms seeks and cache isn't the big 
deal it was back on spinning rust.  But I have one particular app, as it 
happens the pan news client I'm replying to this post with (via 
gmane.org's list2news service), that loads the over a gig of small text-
message files I have in local cache (unexpiring list/group archive) from 
permanent storage at startup, in ordered to create a threading map in 
memory.  And even on ssd that takes some time at first load, but 
subsequent startups are essentially instantaneous as the files are all 
cached.

So caching on btrfs raid1 is definitely working, tho my use-case is 187k+ 
small files totaling about a gig and a quarter, on ssd, while yours is an 
apparently large single file on spinning rust.

But some additional factors that remain publicly unknown as you didn't 
mention them.  I'd guess #5 is the factor here, but if you plan on 
deploying on btrfs, you should be aware of the other factors as well.

1) Size of that single, apparently large, file.

2) How was the file originally created on btrfs?  Was it created by use, 
that is, effectively appended to and modified over time, or was it 
created as a single file copy of an existing database from other media.

Btrfs is copy-on-write and can fragment pretty heavily on essentially 
random rewrite-in-place operations.

3) Mount options

The autodefrag mount option comes to mind, and nodatacow.

4) Nocow file attribute applied at file creation?  Btrfs snapshotting?  
(Snapshotting can nullify nocow's anti-fragmentation effects.)


Tho all those probably wouldn't have much effect on an effectively 
serially copied all at once file, without live rewriting going on, if 
that's what you were doing for testing.  OTOH, a database level copy 
would likely not have been serial, and it already sounds like you were 
doing a database level read, not serial, for the testing.

5) Does your database use DIO access, turning off thru-the-VFS caching?

I suspect that it does so, thus explaining why you didn't see any VFS 
caching effect.  That doesn't explain why ext4 and xfs get faster, which 
you attributed to caching, except that apps doing DIO access are 
effectively expected to manage their own caching, and your database's own 
caching may simply not work well with btrfs yet.  Additionally, btrfs has 
had some DIO issues in the past and you may be running into still 
existing bugs there.  You can be commended for testing with a current 
kernel, however, as so many doing database work are running hopelessly 
old kernels for a filesystem still under as intense bugfixing and 
development as btrfs is at this point.  And DIO is known to be an area 
that's likely to need further attention.  So any bugs you're experiencing 
are likely to be of interest to the devs, if you're interested in working 
with them to pin them down.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

