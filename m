Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33975 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbcDBE4I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 00:56:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amDbP-0007Yv-TT
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 06:56:04 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 06:56:03 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 06:56:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Another ENOSPC situation
Date: Sat, 2 Apr 2016 04:55:56 +0000 (UTC)
Message-ID: <pan$68f59$f32b7e2a$86338be2$5ab70cec@cox.net>
References: <20160401134029.GH9342@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Haber posted on Fri, 01 Apr 2016 15:40:29 +0200 as excerpted:

> Hi,
> 
> just for a change, this is another btrfs on a different host. The host
> is also running Debian unstable with mainline kernels, the btrfs in
> question was created (not converted) in March 2015 with btrfs-tools
> 3.17. It is the root fs of my main work notebook which is under
> workstation load, with lots of snapshots being created and deleted.
> 
> Balance immediately fails with ENOSPC
> 
> balance -dprofiles=single -dusage=1 goes through "fine" ("had to
> relocate 0 out of 602 chunks")
> 
> balance -dprofiles=single -dusage=2 also ENOSPCes immediately.
> 
> [4/502]mh@swivel:~$ sudo btrfs fi usage /
> Overall:
>     Device size:                 600.00GiB
>     Device allocated:            600.00GiB
>     Device unallocated:            1.00MiB

That's the problem right there.  The admin didn't do his job and spot the 
near full allocation issue (perhaps with the help of some script set to 
run periodically and tell him about it) before it got critical, and now 
there's no room left to balance, to fix the problem.

This despite the fact that the admin chose to run a not yet entirely 
stable filesystem that's well known to run off the rails in precisely 
this sort of way, occasionally, with specific use-cases such as heavy 
snapshotting more often than others.

>     Device missing:                  0.00B
>     Used:                        413.40GiB
>     Free (estimated):            148.20GiB      (min: 148.20GiB)

Tho the used vs. free isn't all that bad... it's just that the allocated 
vs. unallocated was allowed to run off the rails and get the filesystem 
in a bind.

But that does mean it should be possible to do something about it. =:^)

>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:553.93GiB, Used:405.73GiB
>    /dev/mapper/swivelbtr         553.93GiB
> 
> Metadata,DUP: Size:23.00GiB, Used:3.83GiB
>    /dev/mapper/swivelbtr          46.00GiB
> 
> System,DUP: Size:32.00MiB, Used:112.00KiB
>    /dev/mapper/swivelbtr          64.00MiB
> 
> Unallocated:
>    /dev/mapper/swivelbtr           1.00MiB
> [5/503]mh@swivel:~$

Both data and metadata have several GiB free, data ~140 GiB free, and 
metadata isn't into global reserve, so the system isn't totally wedged, 
only partially, due to the lack of unallocated space.

> btrfs balance -mprofiles seems to do something. one kworked and one
> btrfs-transaction process hog one CPU core each for hours, while
> blocking the filesystem for minutes apiece, which leads to the host
> being nearly unuseable up to the point of "clock and mouse pointer
> frozen for nearly ten minutes".
> 
> The btrfs balance cancel I issued after four hours of this state took
> eleven minutes alone to complete.

It's worth noting as an aside that Linux isn't necessarily tuned for 
interactivity by default, tho there are definitely ways to make it more 
so.  Additionally, on some mobos at least, it's possible to tweak the 
BIOS balance between interactivity and thruput.  An old Tyan board (PCI 
not the newer PCIE, which avoids some of the problems with multiple 
dedicated buses) I had was tilted a bit heavily toward thruput, which did 
make sense as it was actually a server board, until I tweaked things a 
bit.  That made a LOT of difference, curing the dragging, but also curing 
occasional audio runouts, etc.  Turns out it was simply tuned to do huge 
bus "packets" (I forgot the proper in-context term, and that board died a 
few years ago, so...), increasing thruput, but also increasing latency 
beyond what the sound card and keyboard/mouse (or in that case the human 
operating them) could reasonably deal with.  By shortening the PCI 
"packet length", it reduced thruput a bit but greatly improved latency, 
letting other users have their turn when they needed it, not some time 
later.

Of course in addition to PCIE putting many of those things on dedicated 
buses these days, ssds are so much faster that a lot of things that could 
potentially be problems on spinning rust, simply don't tend to be issues 
on ssds.  As much as anything, I think that's what a lot of users 
bothered by such problems are turning to, and I'd bet that's a good part 
of why SSDs are as popular as they are, as well.  I know I've simply not 
had many of the problems here that others had, and while I think part of 
it is the multiple relatively small but independent filesystems and part 
of it may be because I don't use snapshotting, I also think a major part 
of it is simply that the SSDs I'm running btrfs on are simply so much 
faster than spinning rust that the problems either don't occur, or if 
they do, they're done before I even notice them.

FWIW, I do still use spinning rust, but for my media partition and 
(second) backups, not for anything speed critical at all.  And FWIW, I 
still use reiserfs on that spinning rust, not btrfs, which I only use on 
the SSDs.

But I'll skip the tuning detail discussion here.  If necessary, that 
could go in a different thread.

[snip logging and apparently unrelated traceback]

> This btrfs is ripe for the backup-format-restore procedure, right?

What was the exact balance -mprofiles filter you used?  The -mprofiles 
alone says -m, metadata, profiles, but doesn't say what to actually /do/ 
with the profiles, no selection, no conversion, no nothing, so it would 
presumably do exactly the same thing as -m by itself.  While that could 
could conceivably help if you let it do the full metadata balance (which 
is what the effect would be), that's not the most efficient way to go 
about it, for sure.

OK, so until you have at least a GiB unallocated, attempting to even 
touch data chunks (beyond -dusage=0) is likely to result in an ENOSPC as 
there's simply not enough room to write a new chunk.  (The only reason 
-dusage=1 worked for you at this point is because there were no not 
entirely empty chunks under 1% full to balance, but there's apparently 
one at 1-2% full, and it failed.)  And -dusage=0 and -dusage=1 didn't 
free any entirely empty chunks, so you can't get out of the tight spot 
that way.

Did you try -musage=0 and incrementing by 5 or 10% at a time from there?  
That's what I'd try next, hoping that would give me some gigs to work 
with, tho it's possible it will ENOSPC as well.  But assuming it works...

According to btrfs fi usage, you have 23 GiB worth of metadata chunks, 
but under 4 GiB nominal usage, so say 4.5 GiB with the half GiB of global 
reserve.  With those figures, were you to rebalance all metadata, you'd 
probably end up freeing 18 GiB or so of metadata chunks.  However, if 
you've incremented usage gradually until it's starting to take "too 
long", and it has freed say 3-5 GiB, hopefully that'll be enough to work 
with to start rebalancing the data chunks, which is where the real payoff 
should be as there's ~140 GiB that should be reclaimable there.

So assuming you can free some gigs with -musage=, then try -dusage, again 
incrementing, until you reach something reasonable, say at least 50 GiB, 
unallocated.

I wouldn't touch the profiles filter unless you have to.  And as you 
suggested, in that case it could well be faster to simply do the backup/
format/restore thing.

Of course you should already have a backup if it's worth backing up, so 
you shouldn't really need to worry about that step unless you want to 
freshen up your backup, and can simply do the mkfs and restore steps.

Depending on how deep into -musage= and -dusage= you have to go, and how 
long it takes on your spinning rust, it may actually be faster to do the 
mkfs and restore from backup in any case, but given what you posted so 
far, it's not necessary yet, so your choice, based I guess on what you 
think will be faster vs what you might lose... really not a lot if you've 
already deleted all the snapshots and you either have current backups or 
freshen them before doing the blow-away.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

