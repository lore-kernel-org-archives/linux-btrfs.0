Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46285 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3EUEAR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 00:00:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UedkE-0004lk-7T
	for linux-btrfs@vger.kernel.org; Tue, 21 May 2013 06:00:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 06:00:14 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 06:00:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Virtual Device Support
Date: Tue, 21 May 2013 03:59:58 +0000 (UTC)
Message-ID: <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu>
	<262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com>
	<pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net>
	<519AD943.6060303@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Mitchell posted on Mon, 20 May 2013 19:17:39 -0700 as excerpted:

> Duncan,  The problem affects btrfs volumes that span multiple drive.  If
> you are using btrfs on a single drive that works just fine.  But in a
> multidrive situation, sometimes it works (when umount guesses the right
> device name) and sometimes it fails (when umount guesses the wrong
> device name). Have fun!   - George

Thanks.  I had inferred that but glad to have it confirmed.  My planned 
usage will indeed be multi-device as I'm going to be using btrfs raid1, 
but now that you mention the multi-device trigger explicitly, I 
understand why my tests a year ago didn't run into the problem, as those 
tests were single-device.  (I had inferred the multi-device connection, 
but hadn't made the additional connection between that and my earlier 
tests being single-device until you explicitly mentioned the multi-dev 
trigger, explaining...)


My personal btrfs history is a bit complicated.  Until about a year ago, 
I was running md-raid-1 with four aging 300g "spinning rust" drives
(having earlier experimented with raid-6 and lvm, then ultimately 
deciding raid1 was better for me, but the raid6 experiment was the reason 
for the four).  Because they /were/ aging, I wasn't particularly 
comfortable with the thought of reducing redundancy down to two, and was 
rather dismayed to find out that btrfs' so-called raid1 support wasn't 
raid-1 in the traditional sense of N-way mirroring at all, but was 
limited to two-way-mirroring regardless of the number of physical 
devices.  So I researched but didn't deploy at that time, waiting for the 
raid-6 support (followed by n-way-mirroring) that was then planned for 
the next kernel cycle or two, but as we know now, took several kernel 
cycles to hit, with N-way-mirroring still not available.

Then I ran into hardware issues that turned out to be bad caps on my 8-
year-old mobo (tho it was dual-socket first-gen opteron, which I had 
upgraded to top-of-its-line dual-core Opteron 290s, thus four cores @ 2.8 
GHz, with 8 gigs RAM, so it wasn't as performance-dated as its age might 
otherwise imply).

However, those issues first appeared as storage errors, so knowing the 
drives were aging, I thought it was them, and I replaced, upgrading for 
the first time to 2.5" from the older 3.5" drives.  However, that was 
still the middle of the recession and I had severe budget issues, so I 
decided to try my luck with a single drive (temporarily) in place of the 
four I had been running, fortunately enough, since it didn't turn out to 
be the drive at all.  But not knowing that at the time and having the 
opportunity now with a single drive that was new and thus should be 
reliable, I decided to try btrfs on it, which was where my actual 
deployment and testing time came from.

But meanwhile, the hardware problems continued, and I found the old 
reiserfs was MUCH more stable under those conditions than btrfs, which 
would often be missing entire directory trees after a crash, where 
reiserfs would be missing maybe the last copied file or two.  (I was 
still trying to copy from the old raid1 to the new single device hard 
drive, so was copying entire trees over... all on severely unstable 
motherboard hardware that was frequently timing out SATA commands... 
sometimes to resume after a couple minutes, sometimes not.  Of course at 
the time I was still blaming it on the old drives since that was what I 
was copying from.  It only became apparent that they weren't the issue 
once I had enough on the new drive to try running from it with the others 
detached.)

So under those conditions I decided btrfs was definitely *NOT* 
appropriate, and returned to the long stable reiserfs, which I've 
continued using until now.

Meanwhile, after getting enough on the new drive to run from it, I 
realized it wasn't the old drives that were the problem, and eventually 
realized that I had bulging and even a few popped caps.  So mobo upgrade 
time it was.

Fortunately, bad financial situation tho I was in, I still had good 
enough credit to get an account approved at the local Fry's Electronics, 
and I was able to purchase mobo/cpu/memory/graphics, all upgraded at 
once, mostly even on year-same-as-cash terms.  And fortunately, my 
financial situation has improved dramatically since then, so that's long 
ago paid off and I'm on to new things.

One of those new things is a pair of SSDs, hence my renewed interest in 
btrfs, since reiserfs' journaling is definitely NOT SSD friendly.

Meanwhile, btrfs having a year to mature since my initial tests, and now 
being on new and actually WORKING (!!) hardware, and as I said, needing 
an alternative to the reiserfs I've been using for over a decade now, I'm 
again interested in btrfs.

This time around, I'm still interested in the checksumming and data 
integrity features and in particular the multi-device angle, but the N-
way-mirroring isn't as important now since I'm looking at only two 
devices anyway, and even that's a step up from my current single device.  
In addition, new this time, I'm now interested in the SSD features.

Meanwhile, given the SSDs and the impressive benchmarks I've seen for it, 
I've also looked into f2fs, but decided it's WAAAYYY too immature to 
seriously consider at this point.

I considered ext4 as well, but the ext* filesystems and I have just never 
gotten along very well, one of the reasons I've stuck with reiserfs for 
so long.  Here, time and time again reiserfs has been proven impressively 
stable, especially since ordered-journaling became the default back in 
2.6.16 or whatever, even thru hardware issues like the above that should 
challenge ANY filesystem.  Personally, I think part of the problem with 
ext* is that too many kernel devs think they know it well enough to mess 
with it, when they don't.  I know people who suffered data loss during 
the ext3 defaulting to writeback (as opposed to ordered) journaling 
period, for instance, while I was safe on reiserfs, which most kernel 
devs are scared to touch, so it just continues working as it always has.  
(Personally I'd had enough of a demonstration of the evils of writeback 
journaling with pre-ordered reiserfs to seriously doubt the sanity of the 
ext3 switch to writeback journaling by default from the moment I heard 
about it, and of course had I been running ext3, I'd have switched back 
to ordered immediately, but the person I know that lost data due to that 
wasn't following kernel development closely enough to know why, he just 
knew it was happening.  When I saw he was running ext3 and his kernel 
version, I asked about the journaling option, and sure enough, when he 
switched to ordered, the problem disappeared!)

Also, having run reiserfs for years, I see no reason for a modern fs to 
not have tail-packing (tho f2fs arguably has an excuse due to the 
technology it's targeting).  ext* has never had that, while btrfs has 
equivalent.  I guess it's possible with ext4 and kernel 3.6+ now, but 
there's still serious limitations to it on ext4.

So I'll try btrfs raid1 mode on the SSDs, and get the checksumming and 
data integrity features that the raid1 mode provides. =:^)  Plus I'll 
have btrfs' tail-packing, and the comfort of knowing that the same Chris 
Mason who worked on reiserfs for so long and introduced reiserfs ordered 
journal mode to mainline (IDR whether he originally authored it or not) 
is lead on btrfs now. =:^)

And hopefully, now that btrfs raid5/6 is in, in a few cycles the N-way 
mirrored code will make it as well, and I can add a third SSD and 
rebalance to it.  That time gap should ensure the third device is 
sufficiently separate in lot and possibly model number as well, so I 
don't have all my raid-1 data eggs in the same device lot basket. =:^)

Meanwhile, the old "spinning rust" drive, still with demonstrated 
reliable reiserfs, can continue to serve as a backup, both to the new SSD 
technology and same-lot raid-1 devices, and to the still not fully stable 
btrfs I'll be trying to run on them in "production" mode.

So yes, it's likely I'll have to devise workarounds to the multi-device 
btrfs label= umount problem myself.  I guess I'll find out in a day or 
two, as I actually deploy and my experiment progresses. =:^)

And yes, have fun I expect I will. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

