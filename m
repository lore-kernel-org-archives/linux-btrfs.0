From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: weekend of btrfs findings
Date: Wed, 4 Apr 2012 04:45:24 +0000 (UTC)
Message-ID: <pan.2012.04.04.04.45.23@cox.net>
References: <4F7B4B5E.4050902@hosman.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Remco Hosman posted on Tue, 03 Apr 2012 21:11:26 +0200 as excerpted:

> after getting a USB enclosure that allowes me to access each of its
> disks as individual devices, i played around with btrfs a weekend, and
> here are some questions i hit, but could not find an answer for.
> 
> Setup: 4 disks, 2x 500gig, 2x1500gig, connected to a SATA port
> multiplier backplane to a SATA<->USB converter. PC is a i686 Celeron M,
> running 3.4.0-rc1, running the latest btrfs tools from git.
> 
> *) at first, i created the volume as raid10. i started filling it up,
> and when the 2 500gig disks where full, i got ENOSPC errors. which makes
> me wonder: what is the advantage of raid10 over raid1?

You didn't mention reading the wiki (either one, see below), which covers 
most of these questions directly or indirectly.  That would seem to be 
your next step.

Meanwhile, short and incomplete answer but enough to get you started: 
btrfs' so-called "raid1" and "raid10" really doesn't fit the generally 
used definition thereof.

Starting with raid1, in general usage, a raid1 mirrors the content N 
times across N devices, with the space available being the space on the 
smallest device.  So if you had those four disks and were using the 
entire disk, two half-T, two 1.5T, in a NORMAL raid1, the space available 
would be the half-T of the smallest device, with all data duplicated four 
times, once to each device.  The last 1T of the larger devices would 
remain unused, or if they were partitioned half-T/1T, free for other 
usage, perhaps a second raid1 across only those two devices.

By contrast, btrfs' so-called raid1 is actually only two-way mirroring, 
regardless of the number of devices, a VERY critical difference if the 
intent was to actually allow three of the four devices to die and still 
have access to the data on the fourth one, as a true raid1 would give you 
but btrfs' so-called raid1 will NOT.  However, btrfs WOULD take advantage 
of the full size of the devices (barring bugs, remember btrfs is still 
experimental/development/testing-only in the mainstream kernel at least), 
giving you access to the full (1.5*2+0.5*2)/2=2T of space.  Tho it 
doesn't matter with only two devices, since btrfs' two-way-mirror is the 
same as a standard raid1 in that case.


Raid0 is of course striped for speed, but without redundancy (less 
reliable than a single device since loss of any of them kills the raid0, 
but faster access), and raid10 is normally a stripe of mirrors, aka
raid1+0, tho some implementations including Linux' own md/raid software 
raid allow a hybrid mode that blurs the lines between the two layers.

btrfs raid0 is normal striped, but btrfs raid10 is again not really 
raid10, since the raid1 portion is only two-way, not N-way.

But with four devices, raid10 and the btrfs mode called raid10 will be 
the same anyway.

Of course, with btrfs, you specify the redundancy level for both the data 
and metadata, separately.  With multiple devices, btrfs by default is 
metadata mirrored (so-called raid1 but only two-way) while data is 
striped/raid0 across all available devices.

But critically, with btrfs, raid0 and raid10 modes REQUIRE at least two 
stripes THEY WON'T DO SINGLE "unstriped".  So with four devices, two 
smaller and two 3 times the size of the smaller ones, once the space on 
the smaller ones is used, you get the out-of-space error because there's 
no way to both mirror and stripe further data across only two devices.


When you added the fifth device, even tho it was so small (16 gig), 
because the other devices were bigger and you were now beyond the minimal 
number of devices for the raid10, and because metadata is only two-way-
mirrored anyway, you effectively got a multiple of that 16 gigs, maybe 
16*5=80 gigs or so, tho as a simple user I'm not sure exactly how that 
allotment goes and thus the real multiplier (and it may actually depend 
on your data:metadata usage ratio, etc).

Based on your comments, it sounds like what you actually expected was the 
two-way-mirrored behavior of the so-called raid1 mode, letting you use 
all the space, but without the speed bonus of raid10 striping.

But you REALLY need to read the wiki.  If you weren't yet aware of that, 
there's a whole lot more about btrfs that you need to know that you're 
probably not aware of.  Freespace, what's reported using different 
methods, and what each one actually means, is a big one.  Then there's 
the various mount options, etc.

Oh, and one more thing.  Because btrfs /is/ experimental, (a) be prepared 
to lose any data you put on it (but by your comments you probably 
understand that bit already), and (b) running current kernels is 
critical, as each one still includes a lot of fixes from the one before.  
That means at *LEAST* 3.2.  There's apparently a regression for some 
people in 3.3 but you'd normally be expected to be upgrading to it about 
now, and many testers run the mainline Linus rc kernels (3.4-rc1 
currently), or even newer not-yet-in-linus-tree btrfs.  Again, see the 
wiki for more.

FWIW, there's actually two wikis, a stale version at the official 
kernel.org site that is read-only due to kernel.org security changes 
after the breakin some months ago, and a much more current actually 
updated one but with a less official looking URL.  Hopefully someday the 
official wiki will be writable again, or at least can be static-content 
updated, maybe when btrfs loses its experimental tag in the kernel, but 
meanwhile:

Official but stale read-only wiki: https://btrfs.wiki.kernel.org/

Updated wiki: http://btrfs.ipv5.de/index.php?title=Main_Page

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

