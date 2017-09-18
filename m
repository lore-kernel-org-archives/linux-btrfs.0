Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36681 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdIRBvN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 21:51:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dtlDD-00074d-PO
        for linux-btrfs@vger.kernel.org; Mon, 18 Sep 2017 03:51:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to run balance successfully (No space left on device)?
Date: Mon, 18 Sep 2017 01:50:55 +0000 (UTC)
Message-ID: <pan$7f915$e8624ff5$2ef93d2$d70cd65d@cox.net>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Mon, 18 Sep 2017 00:02:46 +0900 as excerpted:

> I'm trying to run balance on a 4.13.2 kernel without much luck:
> 
> # time btrfs balance start -v /var/lib/lxd -dusage=5 -musage=5
> [works, but only 1 chunk balanced]

> # time btrfs balance start -v /var/lib/lxd -dusage=0 -musage=0
> [no chunks with 0 usage to balance]
> 
> 
> # time btrfs balance start -v /var/lib/lxd
> [...]
> ERROR: error during balancing '/var/lib/lxd': No space left on device

OK, that fails.  Let's see what your unallocated space looks like, 
below...

> # df -h /var/lib/lxd

FWIW, standard (aka util-linux) df is effectively useless in a situation 
such as this, as it really doesn't give you the information you need (it 
can say you have lots of space available, but if btrfs has all of it 
allocated into chunks, even if the chunks have space in them still, there 
can be problems).

And actually, (util-linux) df really doesn't give you a whole lot of 
useful information on a btrfs in enough cases that most list regulars 
tend to discount its output almost entirely.  The only thing it's really 
useful for is getting a reasonable idea as to whether your next major 
file operation can be expected to succeed or not -- if it says you have 
50 MB left and you're trying to put a new 1 GiB file on the btrfs, it's 
unlikely to work, but if it says you have 300 GiB left in a multi-TB 
multi-device filesystem, you might have 300, or 3000 (its estimates are 
deliberately on the pessimistic side).

For better numbers, always use the btrfs tools, btrfs fi usage is the one 
I tend to use most, but btrfs dev usage can be very useful if you're more 
interested in a per-device listing, and btrfs fi show combined with btrfs 
fi df provide much the same information, tho it needs a bit more 
interpreting.

But you do provide them too. =:^)

> # btrfs fi df /var/lib/lxd
> Data, RAID1: total=318.00GiB, used=313.82GiB
> System, RAID1: total=32.00MiB, used=80.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.17GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

Looks reasonably healthy.  No global reserve used, good as that's a major 
indicator of problems, and data and metadata usage is reasonably close to 
totals -- no huge number of mostly empty allocated chunks.

> # btrfs fi show /var/lib/lxd Label: 'btrfs'  uuid:
> f5f30428-ec5b-4497-82de-6e20065e6f61
>          Total devices 2 FS bytes used 316.98GiB
>          devid    1 size 423.13GiB used 323.03GiB path /dev/sda3
>          devid    2 size 423.13GiB used 323.03GiB path /dev/sdb3

OK, given the ENOSPC error on balance above, those device lines are the 
real interesting numbers, and...

Healthy here too.  Very much so, in fact, as only 323 gigs out of 423 is 
allocated on each device -- 100 gigs not chunk-allocated and therefore 
free for chunk allocation on each device. =:^)

The ENOSPC is therefore a bug -- it shouldn't be happening.

And as it happens, AFAIK from reading the list, there's a currently known 
bug with over-reservation under certain circumstances that among other 
things, can (wrongly) trigger ENOSPC on balances, when there's plenty of 
space.

Also AFAIK, there's a patch on-list and (I think) in 4.14-rc1, that is I 
believe marked for stable as well, that will very likely fix your 
problem.  If it doesn't, there's another bug triggering similar symptoms.

But I'm not a dev and haven't been tracking the specific patch, so you'll 
need to either track it down (or wait to see if a dev or someone else 
points you at it) and apply it on your 4.13.x, or wait until it hits 
stable backports and you can get it there, or try 4.14-rc1 or wait until 
later/safer rcs or full release.

Meanwhile...

> # btrfs fi usage /var/lib/lxd Overall:
>      Device size:                 846.25GiB
>      Device allocated:            646.06GiB
>      Device unallocated:          200.19GiB
>      Device missing:                  0.00B
>      Used:                        633.97GiB
>      Free (estimated):            104.28GiB      (min: 104.28GiB)
>      Data ratio:                       2.00
>      Metadata ratio:                   2.00
>      Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,RAID1: Size:318.00GiB, Used:313.82GiB
>     /dev/sda3     318.00GiB
>     /dev/sdb3     318.00GiB
> 
> Metadata,RAID1: Size:5.00GiB, Used:3.17GiB
>     /dev/sda3       5.00GiB
>     /dev/sdb3       5.00GiB
> 
> System,RAID1: Size:32.00MiB, Used:80.00KiB
>     /dev/sda3      32.00MiB
>     /dev/sdb3      32.00MiB
> 
> Unallocated:
>     /dev/sda3     100.10GiB
>     /dev/sdb3     100.10GiB

As I said above, btrfs fi usage output provides much of the same info, 
but in a much nicer format and with a bit more detail, than the 
combination of btrfs fi show and btrfs fi df.

This confirms the above 100 gigs per device unallocated, plenty for a 
balance if it's not bugging out, and data and metadata chunk usage in the 
same ball park as the totals, so as I said above, the ENOSPC during 
balance is very definitely a bug.  Everything looks healthy, which means 
an ENOSPC during balance /must/ be a bug, because it simply shouldn't be 
happening.

But chances are pretty good that one you get that patch integrated, 
whether by integrating it yourself to what you have currently, or by 
trying 4.14-rc1 or waiting until it hits release or stable, that bug will 
have been squashed! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

