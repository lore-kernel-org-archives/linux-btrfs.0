Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40727 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbbBMBTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 20:19:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YM4ur-000861-7i
	for linux-btrfs@vger.kernel.org; Fri, 13 Feb 2015 02:19:33 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 02:19:33 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 02:19:33 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Repair broken btrfs raid6?
Date: Fri, 13 Feb 2015 02:12:15 +0100
Message-ID: <fkvvqb-ecc.ln1@hurikhan77.spdns.de>
References: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com> <ntnoqb-jvq.ln1@hurikhan77.spdns.de> <486ed2b2-3c80-4856-8701-bcd71a212b18@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ed Tomlinson <edt@aei.ca> schrieb:

> On Tuesday, February 10, 2015 2:17:43 AM EST, Kai Krakow wrote:
>> Tobias Holst <tobby@tobby.eu> schrieb:
>>
>>> and "btrfs scrub status /[device]" gives me the following output:
>>>> "scrub status for [UUID]
>>>> scrub started at Mon Feb  9 18:16:38 2015 and was aborted after 2008
>>>> seconds total bytes scrubbed: 113.04GiB with 0 errors"
>>
>> Does not look very correct to me:
>>
>> Why should a scrub in a six-drivers btrfs array which is probably multi-
>> terabytes big (as you state a restore from backup would take
>> days) take only
>> ~2000 seconds? And scrub only ~120 GB worth of data. Either your 6
>> devices are really small (then why RAID-6), or your data is very sparse
>> (then way does it take so long), or scrub prematurely aborts and never
>> checks the complete devices (I guess this is it).
>>
>> And that's what it actually says: "aborted after 2008" seconds. I'd
>> expect "finished after XXXX seconds" if I remember my scrub runs
>> correctly (which I
>> currently don't do regularly because it takes long and IO performance
>> sucks during running it).
> 
> IO perfermance does suffer during a scrub.  I use the following:
> 
> ionice -c 3 btrfs scrub start -Bd -n 19 /<target>

Doesn't work for deadline scheduler... Although, when my btrfs was still 
fresh (and already had a lot of data), I hardly noticed a running scrub in 
the background. But since I did one balance, everything sucks IO 
performance-wise.

Off-topic but maybe interesting in this regard:

Meanwhile, I switched away from deadline (which served me better than CFQ at 
that time) and am running with BFQ scheduler. It works really nice though 
booting is slower and application startup is a little bit less snappy. But 
it copes with background IO much better since after the "balance incident".

I went one step further and deployed bcache into the setup and everything is 
really snappy now. So I'm playing with the thought of re-enabling a 
regularly running scrub. But I still need to figure out if it would or 
wouldn't destroy the bcache hit ratio and fill bcache with non-relevant 
data.

And thinking further about it: I'm not sure if btrfs RAID protection and 
scrub make much sense at all with bcache inbetween... Due to the nature of 
bcache, errors may slip through undetected until the bcache LRU forces 
cached good copies out of the cache. If this data isn't dirty, it won't be 
written to cache. In that case there are three possible outcomes: the 
associated blocks on HDD are in perfect shape, one copy is rotten and one is 
good, or both are rotten. In the last case, btrfs can no longer help me 
there... Scrub may not have catched those as the good copies were in bcache 
until shortly before. I wonder if bcache should have a policy for writing 
back even non-dirty blocks if they are evicted from the cache...

> The combo of -n19 and ionice makes it workable here.

Yeah, should work here, too, now that I'm using BFQ. But then again, I am 
not sure: bcache frontend runs on SSD whose block device is working with 
deadline scheduler. My bcache backends are running on HDD with BFQ 
scheduler. The virtual bcache partitions sitting inbetween both are 
magically setting themselves to the noop scheduler (or maybe it even shows 
"none", I'm not sure) - which is intended, I guess.

So kernel access probably goes like this:

---> bcache0-2[noop] <---> phys. SSD [deadline] **
         |
          `---> phys. HDD 1-3 [bfq], mraid-1, draid-0 

So, I guess part of block accesses pass through two schedulers if access to 
both devices is needed (frontend and backend) with bcache acting as a huge 
block-sorting scheduler itself (which is what makes its performance). But 
for scrub, the deadline scheduler may becoming the dominating scheduler 
which brings me back to the situation a had in the start while running 
scrub.

** --> maybe I should put noop here, too

Does my thought experiment make work?

-- 
Replies to list only preferred.

