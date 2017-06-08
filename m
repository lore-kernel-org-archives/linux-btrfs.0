Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45105 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdFHD6F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 23:58:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dIoa5-0001vI-Hq
        for linux-btrfs@vger.kernel.org; Thu, 08 Jun 2017 05:57:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount gets stuck -  BUG: soft lockup
Date: Thu, 8 Jun 2017 03:57:52 +0000 (UTC)
Message-ID: <pan$913f2$7a061a9c$53734ddc$4bb718e9@cox.net>
References: <650563aa7eda4f3c9c55cac60f476e45@ais.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Mischke posted on Wed, 07 Jun 2017 09:44:41 +0000 as excerpted:

> i tried to convert a JBOD BTRFS consisting of 5 disks (6TB each) to
> raid10 (converting from an earlier configuration).
> All disk were backed by bcache.
> 
> Because a rebalance takes very long I had to pause the balance for a
> required reboot.

Sorry, not a direct answer here, but rather a point made in a continuing 
discussion... which may or may not be something you can use, but even if 
you can, it'll be when you redo your current layout...

Great case-in-point for the point I often make about (where possible[1]) 
keeping a filesystem small enough so that maintenance on it is doable 
within a reasonable/tolerable amount of time.

If the same amount of data were split into multiple independent smaller 
filesystems, only one of them would have been affected as being rebalanced 
at the time, and the smaller filesystem would have ideally been small 
enough that the rebalance could be completed without the need to reboot 
in the middle.

As I said, where possible... It's not always possible, and people's 
definition of tolerable maintenance times will certainly differ in any 
case[2], but where it is possible, it sure does help in managing the 
administration headache level. =:^)

Of course your system, your choice.  If you prefer the hassle of multi-
hour or even multi-day scrubs/balances/checks in ordered to keep the 
ability to maintain it all as a single btrfs pool, great!  I prefer the 
sub-hour maintenance, even if it means a bit more hassle splitting up the 
layout up front.

---
[1] Where possible:  Obviously, if you're dealing with multi-TB files, a 
filesystem smaller than one of them isn't practical/possible.  But if 
necessary due to such extreme file sizes, it can be one file per 
filesystem.

[2] Tolerable maintenance times:  I'm an admitted small-case extreme.  
I'm on ssd, with all btrfs under 100 GiB each, under 50 GiB per device 
partition, paired btrfs raid1 partitions on two physical ssds, and scrubs/
balances/checks typically take a minute or less, short enough I tell 
scrub not to background (-B) and can easily sit and wait for completion.  
Scrubbing the sub-GB log filesystem is done effectively as fast as I hit 
enter.

Lesson learned from running mdraid before it had write-intent bitmaps and 
well before ssds dropped into affordability so on spinning rust, when I 
ended up splitting two huge mdraids, working and backup, into multiple 
individual raids on parallel partitions across physical devices, because 
raid-rebuild after a crash would take hours.  Afterward, individual 
rebuilds took 5-20 minutes each and I might have to rebuild three smaller 
raids that were active and had write-mounted filesystems at the time of 
the crash, but many of the raids wouldn't have been at risk as they were 
either not active or their filesystems were mounted read-only.  So I was 
done in under an hour, and under 15 minutes for the critical root 
filesystem raid, compared to the multiple hours it took for a rebuild 
when it was one big single working raid.

15 minutes for root and under an hour for all affected raids/filesystems 
was acceptable.  Multiple hours for everything at once, wasn't, not when 
it was within my power to change it with a few raid splits and a 
different layout between them.

Of course now I'm spoiled by the SSDs and find that 15 minutes for root 
and an hour for all affected, unacceptable, as it's now under a minute 
for each btrfs and under 10 minutes for all affected.  (It's actually 
more like 2 minutes for the minimal operational set, home and log, with 
root mounted read-only by default and thus unaffected. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

