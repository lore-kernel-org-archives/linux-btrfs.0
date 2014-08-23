Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58837 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHWOOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 10:14:38 -0400
Message-ID: <53F8A1CC.80906@floga.de>
Date: Sat, 23 Aug 2014 16:14:36 +0200
From: =?UTF-8?B?RmxvcmlhbiBHYW1iw7Zjaw==?= <mail@floga.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: superblock checksum mismatch after crash, cannot mount
References: <53F7BD8E.10308@floga.de>	<pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de> <pan$16219$d960b649$52ed1e6$33540704@cox.net>
In-Reply-To: <pan$16219$d960b649$52ed1e6$33540704@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.08.2014 11:34, schrieb Duncan:
>> Afterwards, as I said, none of the partitions were recognized anymore. Not even btrfs recognized the third partition.
> That is strange.  Was the partition table still recognized?  Had you used
> mbr or gpt partitioning (I'm presuming the pi handles them, of course, I
> don't know a lot about pi/arm).

I haven't run any tests on that, so to be safe, I use a MBR table. And 
yes, the table was still in order, all three partitions were there, but 
none of the filesystems were recognized. Sorry if I confused you. But 
still I think it's a big deal if a rescue on partition 3 breaks the 
filesystems on each partition of the device. It's like every single 
superblock was deleted.

> FWIW these days I use gpt because it keeps one checksummed copy at each
> end of the device for better reliability, and of course also because it
> does away with primary/secondary/logical partition worries and allows
> partition names/labels (as distinct from filesystem labels), but I have
> literally /no/ idea whether pi supports it as I've never worked with a pi.

This sounds interesting. Maybe that will be my next project to stress 
little Pi.

> I can't think of any scenario that would screw up all the partitions
> unless the partition table was damaged and/or unless the firmware was
> buggy and basically scrambled things.  It's almost as if the superblock
> fix landed in the middle of the partition table (maybe 64 KiB into the
> entire SD card, is that still partition table?) instead of at the 64 KiB
> mark into what would have been partition 3, the btrfs partition, but if
> it was reading the second one as good, it must have gotten the right
> partition to do that, in which case it couldn't be that you simply typoed
> and didn't include the digit.

So, I am almost absolutely sure that the table is in order, since there 
are no other problems regarding that. And like you said, rescue showed 
me the right superblocks and also here I am sure that I didn't forget 
the 3 when typing in the command.

> I can't personally rule out a bug in btrfs rescue as I've never used that
> tool myself, but one this severe?  Hard to imagine, yet /something/
> screwed up.

I don't want to believe that the SD firmware or the driver or whatever 
would redirect calls on certain partitions to the main device. So it 
seems more plausible to think that there is something wrong in the 
rescue command, like the calculation of the offset or something.

> Anyway, were it me, I'd consider that sdcard suspect (bad firmware) until
> I could pin down what it did a bit better, because something implausible
> just happened, and that's as plausible an explanation as anything else
> we've got.

These corruptions (although I can't say for sure that the problems were 
identical) happened both on a cheap class 4 SDHC and on my current class 
10 microSDHC, the first one on a Raspberry B, the latter on a Raspberry 
B+. You are right, at the moment we can only guess what the cause of the 
errors was, but it's hard to believe that both Pis and both SD cards 
share the same bugs. At least I don't want to believe that.

> At that point, that's what I would have done too, with the caveat about
> considering the card suspect for the time being, and being sure it's
> /regularly/ backed up in case it scrambles again.

I create btrfs snapshots every 6 hours on the same card and send them to 
an external flash drive every 24 hours. If I've done much work, then 
these intervals will be shorter, of course. I always work in a way that 
nothing will be lost, even if the Pi explodes. ;-)

> There's some recent research at how poor certain solid state devices are at handling power cuts. Someone here probably has a link or google it. Having work on one partition scramble others certainly seems like bad firmware to me, tho I'm no expert. But btrfs' write patterns are surely about as far from the fat many of these devices were designed for as it gets, so btrfs may well be stressing it quite a bit as well.

Yes, but that's exactly why we test and experiment. I try several mount 
options, I tried several SD cards and maybe some lucky day I can track 
down and reproduce the problems and can say for sure whether the card or 
btrfs was at fault.

> I'd also try to compare notes with other pi users and see if they're
> noting problems with the pi and btrfs as well.  I'm entirely clueless in
> that regard, but I read enough about them to at least know they have a
> rather large and active user community, so you can't be the first to have
> tried it.  Someone's gotta have some experience to share.

Regarding that, most times I just read posts like "just don't do that", 
"just use raspbian's default" and the like. No more explanations. So I'd 
rather go on my own journey, keep on using Gentoo, adjust my kernel, and 
stress btrfs to its limits. I like to experiment new things, after all.

But thanks again for your advice, it helps me to poke at the right 
edges. :-)

-- 
Best wishes

FloGa

