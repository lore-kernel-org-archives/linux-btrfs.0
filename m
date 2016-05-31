Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:55067 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbcEaSgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 14:36:13 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1b7oWP-0003yu-Vl
	for linux-btrfs@vger.kernel.org; Tue, 31 May 2016 20:36:09 +0200
Received: from localhost ([::1]:49690 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1b7oWP-0004FI-Rl
	for linux-btrfs@vger.kernel.org; Tue, 31 May 2016 20:36:09 +0200
Subject: Re: Runaway SLAB usage by 'bio' during 'device replace'
References: <CAMbyGOMdgMKK=ttSR0NujhdbnitMwU+4+ebH6z5YW4U=zxnxtQ@mail.gmail.com>
 <pan$555d9$34a6c7$c401e1ca$b9b438b8@cox.net>
To: hittingsmoke@gmail.com, linux-btrfs@vger.kernel.org
From: g6094199@freenet.de
Message-ID: <9ad28b58-75a8-c748-3cd6-143deb0d6d8d@chefmail.de>
Date: Tue, 31 May 2016 20:32:32 +0200
MIME-Version: 1.0
In-Reply-To: <pan$555d9$34a6c7$c401e1ca$b9b438b8@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,


since you are using a recent LTS kernel on your centos/rockstor, i guess
the kernel errors might help to find some bugs here.

can you give the devs the errors from your logs?
additionally basic info on your raid settings would be nice to, but
which specific details the devs should ask on demand.


But generally speaking raid5/6 works quiet ok in every day use for less
important data, but there a major bugs when it comes to failing disks or
in general when you try to replace harddrives.
I have a similar problem right now. I added a new drive to an array and
while deleting an older drive the new drive failed :-( So i ended up
rescuing all data (8TB) to an new array with "btrfs restore". This took
over a week, cause there is currently no switch to automaticly cancel
looping while recovering. So you will have to manually apply the cancel
command on every file it starts to loop, which might be a lot.

In general adding a new drive and afterwards removing the old one is
more save than the replace method, at least right now (as of kernel
4.5/4.6). But major bug fixes are in the works and there is hope that
raid5/6 becomes more reliable next year.


so good luck!


Am 30.05.2016 um 22:55 schrieb Duncan:
> Chris Johnson posted on Mon, 30 May 2016 11:48:02 -0700 as excerpted:
>
>> I have a RAID6 array that had a failed HDD. The drive failed completely
>> and has been removed from the system. I'm running a 'device replace'
>> operation with a new disk. The array is ~20TB so this will take a few
>> days.
> This isn't a direct answer to your issue as I'm a user and list regular, 
> not a dev, and that's beyond me, but it's something you need to know, if 
> you don't already...
>
> Btrfs raid56 mode remains for the time being in general negatively-
> recommended, except specifically for testing with throw-away data, due to 
> two critical but not immediately data destroying bugs, one related to 
> serial device replacement, the other to balance restriping.  They may or 
> may not be related to each other, as neither one has been fully traced.
>
> The serial replace bug has to do with replacing multiple devices, one at 
> a time.  The first replace appears to work fine by all visible measures, 
> but apparently doesn't return the array to full working condition after 
> all, because an attempt to replace a second device fails, and can bring 
> down the filesystem.  Unfortunately it doesn't always happen, and due to 
> the size of devices these days, working arrays tend to be multi-TB 
> monsters that take time to get to this point, so all we have at this 
> point is multiple reports of the same issue, but no real way to reproduce 
> it.  I believe but am not sure that the problem can occur regardless of 
> whether btrfs replace or device add/delete was used.
>
> The restriping bug has to do with restriping to a different width, either 
> manually doing a filtered balance after adding devices, or automatically, 
> as triggered by btrfs device delete.  Again, multiple reports but not 
> nailed down to anything specifically reproducible yet.  The problem here 
> is that the restripes, while apparently producing correct results, can 
> inexplicably take an order of magnitude (or worse) longer than they 
> should.  What one might expect to take hours takes over a week, and on 
> the big arrays that might be expected to take 2-3 days, months.
>
> The problem, again, isn't correctness, but the fact that over such long 
> periods, the risk of device loss is increased, and if the array was 
> already being reshaped/rebalanced to repair loss of one device, loss of 
> another device may kill it.
>
> Neither of these bugs affects normal runtime operation, but both are 
> critical enough with regard to what people normally use parity-raid for, 
> so they /can/ take a device (or two with raid6) loss and repair the array 
> to get back to normal operation, that raid56 remains negatively 
> recommended for anything but testing with throw-away data, until after 
> these bugs can be fully traced and fixed.
>
>
> Your particular issue doesn't appear to be directly related to either of 
> the above.  In fact, I know I've seen patches recently having to do with 
> memory leaks that may well fix your problem (tho you'd have to be running 
> 4.6 at least to have them at this point, and perhaps even 4.7-rc1.
>
> But given the situation, either be sure you have backups and are prepared 
> to use them if the array goes south on you due to failed or impractical 
> device replacement, or switch to something other than btrfs raid56 mode.  
> Btrfs redundancy-raid (raid1 and raid10) are more mature and tested, and 
> thus may be options if they fit your filesystem space and device layout 
> needs.  Alternatively, btrfs (or other filesystems) on top of dm/md-raid 
> may be an option, tho you obviously lose some features of btrfs that 
> way.  And of course zfs is the closest btrfs-comparable that's reasonably 
> mature and may be an option, tho there are licensing and hardware issues 
> (it likes lots of memory on linux due to double-caching of some elements 
> as its caching scheme doesn't work well with that of linux, and ecc 
> memory is very strongly recommended) if using it on linux.
>
> I'd suggest giving btrfs raid56 another few kernel releases, six months 
> to a year, and then check back.  I'd hope the bugs can be properly traced 
> and fixed within a couple kernel cycles, so four months or so, but I 
> prefer a few cycles to stabilize with no known critical bugs, before I 
> recommend it (I was getting close to recommending it after the last known 
> critical bug was fixed in 4.1, when these came up), which puts the 
> projected timeframe at 8-12 months, before I could really consider raid56 
> mode as reasonably stable as btrfs in general, which is to say, 
> stabilizing, but not yet fully stable, so even then, the standard admin 
> backup rule that if you don't have backups you consider the data to be 
> worth less than the time/resources/hassle to do those backups, still 
> applies more strongly than it would to a fully mature filesystem.
>

