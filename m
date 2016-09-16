Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:32986 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756757AbcIPD0Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 23:26:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkjn1-0000cp-CA
        for linux-btrfs@vger.kernel.org; Fri, 16 Sep 2016 05:26:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: df -i shows 0 inodes 0 used 0 free on 4.4.0-36-generic Ubuntu
 14 - Bug or not?
Date: Fri, 16 Sep 2016 03:26:05 +0000 (UTC)
Message-ID: <pan$7d326$6cdda862$44b6c5c2$506409b6@cox.net>
References: <CAP8EXU2fx5ipNQ77WrntCvMZ8GWSke0yNs-jduaetpM_=RDGVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GWB posted on Thu, 15 Sep 2016 18:58:24 -0500 as excerpted:

> I don't expect accurate data on a btrfs file system when using df, but
> after upgrading to kernel 4.4.0 I get the following:
> 
> $ df -i ...
> /dev/sdc3               0       0          0     - /home
> /dev/sdc4               0       0          0     - /vm0 ...
> 
> Where /dev/sdc3 and /dev/sdc4 are btrfs filesystems.
> 
> So is this a bug or not?

Not a bug.

Btrfs uses inodes, but unlike ext*, it creates them dynamically as-
needed, so showing inodes used vs. free simply makes no sense in btrfs 
context.

Now btrfs /does/ track data and metadata separately, creating chunks of 
each type, and it /is/ possible to have all otherwise free space already 
allocated to chunks of one type or the other and then run out of space in 
the one type of chunk while there's plenty of space in the other type of 
chunk, but that's quite a different concept, and btrfs fi usage (tho your 
v3.14 btrfs-progs will be too old for usage) or btrfs fi df coupled with 
btrfs fi show (the old way to get the same info), gives the information 
for that.

And in fact, the btrfs fi show for vm0 says 374.66 GiB size and used, so 
indeed, all space on that one is allocated.  Unfortunately you don't post 
the btrfs fi df for that one, so we can't tell where all that allocated 
space is going and whether it's actually used, but it's all allocated.  
You probably want to run a balance to get back some unallocated space.

Meanwhile, your kernel is 4.4.x LTS series so not bad there, but your 
userspace is extremely old, 3.12, making support a bit hard as some of 
the commands have changed (btrfs fi usage, for one, and I think the 
checker was still btrfsck in 3.12, while in current btrfs-progs, it's 
btrfs check).  I'd suggest updating that to at least something around the 
4.4 level to match the kernel, tho you can upgrade to the latest 4.7.2 
(don't try 4.6 or 4.7 previous to 4.7.2, or don't btrfs check --repair if 
you do, as there's a bug with it in those versions that's fixed in 4.7.2) 
if you like, as newer userspace is designed to work with older kernels as 
well.

Besides which, while old btrfs userspace isn't a big deal (other than 
translating back and forth between old style and new style commands) when 
your filesystems are running pretty much correctly, as in that case all 
userspace is doing in most cases is calling the kernel to do the real 
work anyway, it becomes a much bigger deal when something goes wrong, 
because it's userspace code that's executing with btrfs check or btrfs 
restore, and newer userspace knows about and can fix a LOT more problems 
than the really ancient 3.12.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

