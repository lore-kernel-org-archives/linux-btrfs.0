Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42597 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaHWJeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 05:34:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XL7iJ-0004pb-O0
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 11:34:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 11:34:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 11:34:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: superblock checksum mismatch after crash, cannot mount
Date: Sat, 23 Aug 2014 09:34:10 +0000 (UTC)
Message-ID: <pan$16219$d960b649$52ed1e6$33540704@cox.net>
References: <53F7BD8E.10308@floga.de>
	<pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Florian Gamböck posted on Sat, 23 Aug 2014 10:38:47 +0200 as excerpted:

> Am 23.08.2014 07:27, schrieb Duncan:
>> btrfs-show-super is your tool for inspecting the superblocks.  [...]
>> Then use btrfs rescue super-recover

> Yes, show-super told me, that the first super block did "NOT MATCH", but
> the second one seemed to be in order ("MATCHED"). The SD card is 16 GiB
> big, so there was no third super block.
> 
> Rescue also listed the first one as bad and the second one as good and
> it seemed to run successfully, no errors whatsoever.

Good so far, but...

> However, after "recovering", every single partition on the card broke.
> There were three partitions: 1 = fat32 ("/boot"), 2 = swap, 3 = btrfs
> ("/"). Naturally I ran the rescue command on partition 3, I hope that
> was not a mistake. Afterwards, as I said, none of the partitions were
> recognized anymore. Not even btrfs recognized the third partition.

That is strange.  Was the partition table still recognized?  Had you used 
mbr or gpt partitioning (I'm presuming the pi handles them, of course, I 
don't know a lot about pi/arm).

FWIW these days I use gpt because it keeps one checksummed copy at each 
end of the device for better reliability, and of course also because it 
does away with primary/secondary/logical partition worries and allows 
partition names/labels (as distinct from filesystem labels), but I have 
literally /no/ idea whether pi supports it as I've never worked with a pi.

I can't think of any scenario that would screw up all the partitions  
unless the partition table was damaged and/or unless the firmware was 
buggy and basically scrambled things.  It's almost as if the superblock 
fix landed in the middle of the partition table (maybe 64 KiB into the 
entire SD card, is that still partition table?) instead of at the 64 KiB 
mark into what would have been partition 3, the btrfs partition, but if 
it was reading the second one as good, it must have gotten the right 
partition to do that, in which case it couldn't be that you simply typoed 
and didn't include the digit.

I can't personally rule out a bug in btrfs rescue as I've never used that 
tool myself, but one this severe?  Hard to imagine, yet /something/ 
screwed up. 

Weird.

Anyway, were it me, I'd consider that sdcard suspect (bad firmware) until 
I could pin down what it did a bit better, because something implausible 
just happened, and that's as plausible an explanation as anything else 
we've got.

> Since I've thought I messed up entirely, I just gave up, re-formatted
> the card and let my backups do the job.

At that point, that's what I would have done too, with the caveat about 
considering the card suspect for the time being, and being sure it's 
/regularly/ backed up in case it scrambles again.

> It's quite annoying though, how often I get those problems. May it be
> that the Raspberry Pi is too slow to let btrfs do its background magic,
> may it be that btrfs is not that suitable for SD cards (in my case it's
> a class 10 microSDHC, 16GiB), or may it be that btrfs is still not that
> reliable when it comes to "unclean" shutdowns.

I'd guess a mix of the above.  There's some recent research at how poor 
certain solid state devices are at handling power cuts.  Someone here 
probably has a link or google it.  Having work on one partition scramble 
others certainly seems like bad firmware to me, tho I'm no expert.  But 
btrfs' write patterns are surely about as far from the fat many of these 
devices were designed for as it gets, so btrfs may well be stressing it 
quite a bit as well.

I'd also try to compare notes with other pi users and see if they're 
noting problems with the pi and btrfs as well.  I'm entirely clueless in 
that regard, but I read enough about them to at least know they have a 
rather large and active user community, so you can't be the first to have 
tried it.  Someone's gotta have some experience to share.

The other possibility I guess is to try a different brand and spec of 
card, to see if that makes any difference.  I just don't know at this 
point, so it's all in-play ATM.

> Nevertheless, I will keep your explanations around for future reference,
> they were really helpful! Thanks again!

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

