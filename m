From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Thu, 3 May 2012 00:46:37 +0000 (UTC)
Message-ID: <pan.2012.05.03.00.46.37@cox.net>
References: <jnpdud$ta9$1@dough.gmane.org> <jnq5os$tdn$1@dough.gmane.org>
	<CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com>
	<jnqf0j$hcd$1@dough.gmane.org>
	<CAG1y0scNSit6oCvySUiP6RChx3_LLDY1QBML0BpGM-39etnZLQ@mail.gmail.com>
	<jnrems$tkh$1@dough.gmane.org> <pan.2012.05.02.18.41.15@cox.net>
	<4FA1C919.1090601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

vivo75@gmail.com posted on Thu, 03 May 2012 01:54:01 +0200 as excerpted:

> Il 02/05/2012 20:41, Duncan ha scritto:
>> Martin posted on Wed, 02 May 2012 15:00:59 +0100 as excerpted:
>>
>>> Multiple pairs of "HDD paired with SSD on md RAID 1 mirror" is a
>>> thought with ext4...
>> FWIW, I was looking at disk upgrades for my (much different use case)
>> home workstation a few days ago, and the thought of raid1 across SSD
>> and "spinning rust" drives occurred here, too.  It's an interesting
>> idea... that I too would love some informed commentary on whether it's
>> practically viable or not.
> 
> I've a similar setup, it's a 2xSSD + 1xHD, but cannot provide real data
> right now. Maybe next month.
> One thing I've forgot to mention is that software raid is very flexible
> and it's very possible to do a raid0 of ssd and then combine it in a
> raid1 with one (or more) traditional HD.
> 
> given the kind of access (many small files) I'm not sure a raid0 is the
> best solution, to be really effective a raid0 need files (and access to
> these) bigger than stripe size.

What occurred to me is that a lot of the cheaper SSDs aren't particularly 
fast at writing, but great at reading.  And of course they have the 
limited write-cycle issue.  So what I was thinking about was setting up a 
raid1 with an SSD (or two in raid0 as you did, or just linear "raid"), 
and the "rust" drive, but configuring the "rust" drive as write-mostly, 
since it's so much slower at reading anyway, and with the slower write 
than read of the SSDs, the write speeds wouldn't be so terribly 
mismatched between the SSD and the write-mostly HD, and it should work 
reasonably well.

That was my thought, anyway.

And I'll agree on the flexibility of software raid, especially md/raid 
(as opposed to dm-raid or the currently extremely limited raid choices 
btrfs offers).  It's also often pointed out that Linux md/raid gets far 
more testing in a MUCH MUCH broader testing environment, than any 
hardware raid could ever HOPE to match.  Plus of course since hardware-
wise it's simply JBOD, if the hardware goes out, there's no need to worry 
about buying new hardware that's RAID arrangment compatible, just throw 
the disks in any old system with a sufficient number of attachment 
points, boot to Linux, load the old RAIDs, and get back to work. =:^)

SATA was really a boon in that regard, since the master/slave setup of IDE 
was significantly inferior to SCSI, but SCSI was so much more expensive.  
SATA was thus the great RAID equalizer, bringing what had been expensive 
corporate raid solutions down to where ordinary humans could afford to 
run RAID on their otherwise reasonably ordinary home systems or even 
laptops.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

