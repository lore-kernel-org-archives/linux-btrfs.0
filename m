Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44929 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbbI1Hwu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 03:52:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZgTEt-0004KI-Os
	for linux-btrfs@vger.kernel.org; Mon, 28 Sep 2015 09:52:48 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 09:52:47 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 09:52:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fstrim silently does nothing on dev add/dev rem'd filesystem
Date: Mon, 28 Sep 2015 07:52:39 +0000 (UTC)
Message-ID: <pan$aca60$e905a348$c86187f4$a2bdc65@cox.net>
References: <20150927175252.GA24990@blind.goeswhere.com>
	<pan$73c0$b0528a34$f375bb55$bda81535@cox.net>
	<CAGfcS_n7czPgSomGo8wFFn8Zxoi4QWA0L+NtK+LreA0j3aewnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Sun, 27 Sep 2015 23:08:49 -0400 as excerpted:

> On Sun, Sep 27, 2015 at 10:45 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> But I think part of reasoning behind the relatively low priority this
>> issue has received is that it's a low visibility issue not really
>> affecting most people running btrfs, either because they're not running
>> on ssd or because they simply don't have a particularly high awareness
>> of what trim does and thus about how it's failing to work here and what
>> that means to them.  If we get a rash of people posting on-list that
>> it's affecting them, that relative priority is likely to go up, and
>> with it the patch testing and integration schedule for the affected
>> patches.
> 
> I've never actually seen fstrim do anything on btrfs (0 bytes trimmed). 
> I stopped using it a few months ago when the news came out about all the
> issues with its implementation, and I believe my drive is still
> blacklisted anyway.
> 
> It really should be fixed, but right now that goes all around - if btrfs
> fixed it tomorrow I'd still be stuck until somebody figures out how to
> reliably do it on a Samsung 850.

FWIW, just checked here, and fstrim -v says it trims rather more than I 
expected, actually -- tho I should mention that I *am* on 4.3-rc2+, so I 
should be running those patches mentioned as going into 4.3 that at least 
partially address the problem.

On my home filesystem (actually /h here):

Btrfs raid1 on two 20-gig partitions:

# btrfs fi sh /h
Label: 'hm0238gcnx+35l0'  uuid: c9f93efc-5ae1-4d89-b501-2d7944856e98
        Total devices 2 FS bytes used 13.24GiB
        devid    1 size 20.00GiB used 14.78GiB path /dev/sda6
        devid    2 size 20.00GiB used 14.78GiB path /dev/sdb6

# btrfs fi usage /h

Overall:
    Device size:                  40.00GiB
    Device allocated:             29.56GiB
    Device unallocated:           10.44GiB
    Device missing:                  0.00B
    Used:                         26.48GiB
    Free (estimated):              6.44GiB      (min: 6.44GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              160.00MiB      (used: 0.00B)

Data,RAID1: Size:14.00GiB, Used:12.78GiB
   /dev/sda6      14.00GiB
   /dev/sdb6      14.00GiB

Metadata,RAID1: Size:768.00MiB, Used:476.02MiB
   /dev/sda6     768.00MiB
   /dev/sdb6     768.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/sda6      32.00MiB
   /dev/sdb6      32.00MiB

Unallocated:
   /dev/sda6       5.22GiB
   /dev/sdb6       5.22GiB

# fstrim -v /h
/h: 13.3 GiB (14255448064 bytes) trimmed

OK, so I'm used to thinking in per-device sizes, IOW ratio two, here.  
And I guess that 13.3 GiB trimmed as reported by fstrim isn't divided by 
two, which is why it looks so unexpectedly large to me on a filesystem of 
20 GiB capacity, 2*20 GiB partitions in raid1.  That'd be 6.5+ GiB per 
partition trimmed, on a 20 GiB partition that's 5.22 GiB unallocated.  
That's not to bad, actually. =:^)

At first I was thinking wait a minute, 20 GiB per partition, 12.78 GiB of 
actual data on each, and 13.3 GiB trimmed.  WTF?  That doesn't add up!  
Of course not, because all those figures but trimmed are cut in half, per 
partition numbers, while trimmed is total for the filesystem.  So either 
trimmed needs cut in half too, or the other numbers need doubled to 
reflect filesystem totals.  /Then/ it makes sense! =:^)

FWIW, the SSDs are both Corsair Neutrons, 256 GB (238.5 GiB) capacity, 
partitioned up with the largest partitions 24 GiB each, but only just 
under 51% (121 GiB of the 238.5) actually partitioned, 117.5 GiB of 
unpartitioned free space.  (Upthread I said about 55% partitioned, seems 
I was a bit conservative.)

As I said upthread, that leaves the FTL plenty of room to do wear-
leveling, even without active fstrim, so working fstrim is simply "nice 
to have" for me, not anything like necessary.

So obviously my Corsair Neutrons aren't blacklisted. =:^)  I've actually 
been rather pleasantly surprised indeed with 'em, as I didn't know half 
what I do now about SSDs when I purchased them, but it seems I made a 
pretty good choice.  The controllers don't do the invisible dedup/
compression that sandforce controllers do so I can rely on what I write, 
including dup-mode copies, actually being written; they're aimed at the 
server market where consistent speed is more important than burst speed 
and the behavior demonstrates exactly that, etc.

The one bad point, and it's probably luck of the draw, is that of the 
three identical units I purchased together, from Fry's Electronics, one 
was apparently returned by someone else and I too really should have 
returned it, as it gave me problems almost from the beginning, but I 
didn't.

OTOH, I ran for several months with the bad one and one of the good ones 
paired in the raid1, using btrfs' data integrity features and scrub to 
repair the data as sectors went bad and the scrub forced the FTL to mark 
a bad sector and replace it with one of the spares, and thus have far 
more practical experience now with btrfs raid1 in failing-data 
conditions, btrfs scrub restoring from the good copy, and the behavior of 
ssds as more and more sectors go bad, along with how smartctl -A reports 
the damage, than I ever would have gotten had I simply returned the 
defective device.

In fact, I was able to watch as over time, smartctl -A dropped that stat 
line cooked value from 255 "clean", to 100 immediately as the first spare 
sector was swapped in, down thru several hundred sectors per percentage 
point, until I finally decided I had enough, at 85 percent (with a 
threshold of 36% for that value, so I was still nowhere near threshold 
fail for that value, tho the more immediate per-session read-retry-rate 
would go thru the roof and drop that cooked value to 1, with a threshold 
of 6 so definitely failing right then, any time I did a big update or 
balance and then a scrub).

I just replaced it a few days ago, less than a week, I think, with the 
still unused third one of the three, originally bought for a netbook I 
never installed it in and eventually lost, with the third one so far 
seemed every bit as healthy as the good one of the pair, no bad blocks 
reported by scrub or spare sectors reported swapped in by smartctl -A, on 
either one, so far.  Which of course was why I was able to let the bad 
one go so long, since the good one of the pair was absolutely reliable. 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

