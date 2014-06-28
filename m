Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46252 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaF1E1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 00:27:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X0kE7-0006v6-Fg
	for linux-btrfs@vger.kernel.org; Sat, 28 Jun 2014 06:26:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 06:26:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 06:26:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 3+ drives
Date: Sat, 28 Jun 2014 04:26:43 +0000 (UTC)
Message-ID: <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
	<10572318.CAuhDIAMDU@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sat, 28 Jun 2014 10:51:00 +1000 as excerpted:

> On Fri, 27 Jun 2014 20:30:32 Zack Coffey wrote:
>> Can I get more protection by using more than 2 drives?
>> 
>> I had an onboard RAID a few years back that would let me use RAID1
>> across up to 4 drives.
>> 
> Currently the only RAID level that fully works in BTRFS is RAID-1 with
> data on 2 disks.

Not /quite/ correct.  Raid0 works, but of course that isn't exactly 
"RAID" as it's not "redundant".  And raid10 works.  But that's simply 
raid0 over raid1.  So depending on whether you consider raid0 actually 
"RAID" or not, which in turn depends on how strict you are with the 
"redundant" part, there is or is not more than btrfs raid1 working.

> If you have 4 disks in the array then each block will
> be on 2 of the disks.

Correct.

FWIW I'm told that the paper that laid out the original definition of 
RAID (which was linked on this list in a similar discussion some months 
ago) defined RAID-1 as paired redundancy, no matter the number of 
devices.  Various implementations (including Linux' own mdraid soft-raid, 
and I believe dmraid as well) feature multi-way-mirroring aka N-way-
mirroring such that N devices equals N way mirroring, but that's an 
implementation extension and isn't actually necessary to claim RAID-1 
support.

So look for N-way-mirroring when you go RAID shopping, and no, btrfs does 
not have it at this time, altho it is roadmapped for implementation after 
completion of the raid5/6 code.

FWIW, N-way-mirroring is my #1 btrfs wish-list item too, not just for 
device redundancy, but to take full advantage of btrfs data integrity 
features, allowing to "scrub" a checksum-mismatch copy with the content 
of a checksum-validated copy if available.  That's currently possible, 
but due to the pair-mirroring-only restriction, there's only one 
additional copy, and if it happens to be bad as well, there's no 
possibility of a third copy to scrub from.  As it happens my personal 
sweet-spot between cost/performance and reliability would be 3-way 
mirroring, but once they code beyond N=2, N should go unlimited, so N=3, 
N=4, N=50 if you have a way to hook them all up... should all be possible.

But...

> RAID-5/6 code mostly works but the last report I
> read indicated that some situations for recovery and disk replacement
> didn't work - presumably anyone who's afraid of multiple disks failing
> isn't going to want to trust BTRFS RAID-6 code at the moment.

The raid5/6 code was on the list to be introduced in the next kernel or 
two something like two years ago, when I originally looked into it, and 
likely before that.  Like many of the btrfs features, it actually took 
rather longer to cook than was in the original plan -- it's actually 
rather more complicated than anticipated, and additionally it has been 
put off a few times to work on bugfixing currently supported feature 
bugs.  An incomplete raid56 implementation, normal runtime but not scrub 
or recovery, was introduced several kernels ago now, but it's still not 
complete.

So N-way-mirroring, which is supposed to build on several bits of the 
raid5/6 implementation and therefore is roadmapped for after it, 
continues to look about the same 3-5 kernels off, after raid5/6, as it 
did two years ago.  Except, having seen the raid5/6 timing, and having 
looked back at btrfs feature history going back rather longer, even if 
raid5/6 was declared finished for kernel 3.17 (since 3.16 is past the 
commit window), I'd guess it'd probably take another five kernels (a 
year's worth) or so, at /least/, for N-way-mirroring to properly cook.

So in actuality I'd be surprised to see any N-way-mirroring code at all 
before next spring, and would /not/ be surprised at all to see it take 
all of next year to fully cook to "completion".

Not that I'm complaining /too/ much.  We work with what we have and btrfs 
as it is is quite beyond the features of most filesystems (just the data 
integrity and multi-device filesystem stuff at all, is great to work 
with, besides the stuff like subvolumes and snapshotting that doesn't fit 
my use-case that well =:^), even if it /is/ all presently limited to two-
way-mirroring! =:^\ ).  But it will sure be nice when I /can/ count on 
that third copy to scrub two bad copies, if two copies /do/ happen to be 
bad.

> If you want to have 4 disks in a fully redundant configuration (IE you
> could lose 3 disks without losing any data) then the thing to do is to
> have 2 RAID-1 arrays with Linux software RAID and then run BTRFS RAID-1
> on top of that.

The caveat with that is that at least mdraid1/dmraid1 has no verified 
data integrity, and while mdraid5/6 does have 1/2-way-parity calculation, 
it's only used in recovery, NOT cross-verified in ordinary use.

So it's not a proper substitute, tho I guess some big-money hardware 
raids might do it.

In fact, with md/dmraid and its reasonable possibility of silent 
corruption since at that level any of the copies could be returned and 
there's no data integrity checking, if whatever md/dmraid level copy /is/ 
returned ends up being bad, then btrfs will consider that side of the 
pair bad, without any way to check additional copies at the underlying md/
dmraid level.  Effectively you only have two verified copies no matter 
how many ways the dm/mdraid level is mirrored, since there's no 
verification at the dm/mdraid level at all.

Tho if you ran a md/dmraid level scrub often enough, and then ran a btrfs 
scrub on top, one could be /reasonably/ assured of freedom from lower 
level corruption.  But with both levels of scrub together very possibly 
taking a couple days, and various ongoing write activity in the mean 
time, by the time one run was done it'd be time to start the next one, so 
you'd effectively be running scrub at one level or the other *ALL* the 
time!

So... I'd suggest either forgetting about data integrity for the time 
being and just running md/dmraid without worrying about it, or just 
running btrfs with pairs, and backing up to another btrfs of pairs.  
Btrfs send/receive could even be used as the primary syncing method 
between the main and backup set, altho I'd suggest having a fallback such 
as rsync setup and tested to work as well, in case there's a bug in send/
receive that stalls that method for awhile.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

