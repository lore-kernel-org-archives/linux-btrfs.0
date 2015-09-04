Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49420 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbbIDLEX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Sep 2015 07:04:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZXon0-0002gL-5E
	for linux-btrfs@vger.kernel.org; Fri, 04 Sep 2015 13:04:14 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2015 13:04:14 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2015 13:04:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
Date: Fri, 4 Sep 2015 11:04:07 +0000 (UTC)
Message-ID: <pan$11297$845af192$4bee50bd$587fb5f7@cox.net>
References: <55E6CF72.5070005@netcologne.de>
	<20150902113021.GD11358@carfax.org.uk> <55E6F51B.3000007@netcologne.de>
	<pan$45a25$fd021e31$91d1cbe2$220454a1@cox.net>
	<55E95625.2030406@netcologne.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Rohmann posted on Fri, 04 Sep 2015 10:28:21 +0200 as excerpted:

> Hello Ducan,
> 
> thanks a million for taking the time an effort to explain all that.
> I understand that all the devices must have been chunk-allocated for
> btrfs to tell me all available "space" was used (read "allocated to data
> chunks").
> 
> The filesystem is quite old already with kernels starting at 3.12 (I
> believe) and now 4.2 with always the most current version of btrfs-progs
> debian has available.

IIRC I wrote the previous reply without knowing the kernel you were on.  
You had posted the userspace version, which was current, but not the 
kernel version, so it's good to see that posted now. 

Since kernel 3.12 was before automatic-empty-chunk-reclaim, empty chunks 
wouldn't have been reclaimed back then, as I guessed.  You're running 
current 4.2 now and they would be, but only if they're totally empty, and 
I'm guessing they're not, particularly if you don't run with the 
autodefrag mount option turned on or do regular manual defrags.  (Defrag 
doesn't directly affect chunks, that's what balance is for, but failing 
to defrag will mean things are more fragmented, which will cause btrfs to 
spread out more in the available chunks as it'll try to put new files in 
as few extents as possible, possibly in empty chunks if they haven't been 
reclaimed and the space in fuller chunks is too small for the full file, 
upto the chunk-size, of course.)

And of course, only with 4.1 (nominally 3.19 but there were initial 
problems) was raid6 mode fully code-complete and functional -- before 
that, runtime worked, it calculated and wrote the parity stripes as it 
should, but the code to recover from problems wasn't complete, so you 
were effectively running a slow raid0 in terms of recovery ability, but 
one that got "magically" updated to raid6 once the recovery code was 
actually there and working.

So I'm guessing you have some 8-strip-stripe chunks at say 20% full or 
some such.  There's 19.19 data TiB used of 22.85 TiB allocated, a spread 
of over 3 TiB.  A full nominal-size data stripe allocation, given 12 
devices in raid6, will be 10x1GiB data plus 2x1GiB parity, so there's 
about 3.5 TiB / 10 GiB extra stripes worth of chunks, 350 stripes or so, 
that should be freeable, roughly (the fact that you probably have 8-
strip, 12-strip, and 4-strip stripes, on the same filesystem, will of 
course change that a bit, as will the fact that four devices are much 
smaller than the other eight).

> On 09/03/2015 04:22 AM, Duncan wrote: [snipped]
> 
> I am running a full balance now, it's at 94% remaining (running for 48
> hrs already ;-) ).
> 
> Is there any way I should / could "scan" for empty data chunks or almost
> empty data chunks which could be freed in order to have more chunks
> available for the actual balancing or new chunks that should be used
> with a 10 drive RAID6? I understand that btrfs NOW does that somewhat
> automagically, but my FS is quite old and used already and there is new
> data coming in all the time, so I wand that properly spread across all
> the drives.

There are balance filters, -dusage=20, for instance, would only rebalance 
data (-d) chunks with usage under 20%.  Of course there's more about 
balance filters in the manpage and on the wiki.

The great thing about -dusage= (and -musage= where appropriate) is that 
it can often free and deallocate large numbers of chunks at a fraction of 
the time it'd take to do a full balance.  Not only are you only dealing 
with a fraction of the chunks, but since the ones it picks are for 
example only 20% full (with usage=20) or less, they take only 20% (or 
less) of the time to balance that a full chunk would.  Additionally, 20% 
full or less means you reclaim chunks 4:1 or better -- five old chunks 
are rewritten into a single new one, freeing four!  So in a scenario with 
a whole bunch of chunks at less than say 2/3 full (usage=67, rewrite 
three into two), this can reclaim a whole lot of chunks in a relatively 
small amount of time, certainly so compared to a full balance, since 
rewriting a 100% full chunk takes the full amount of time and doesn't 
reclaim anything.

But, given that the whole reason you're messing with it is to try to even 
out the stripes across all devices, a full rewrite is eventually in order 
anyway.  However, knowing about the filters would have let you do a
-dusage=20 or possibly -dusage=50 before the full balance, leaving the 
full balance more room to work in and and possibly allowing a more 
effective balance to the widest stripes possible.

Likely above 50 and almost certainly above 67, the returns wouldn't be 
worth it, since the time taken for the filtered balance would be longer, 
and an unfiltered balance was planned afterward anyway.  Here, I'd have 
tried something like 20 first, then 50 if I wasn't happy with the results 
of 20.  The thing is, either 20 would give me good results in a 
reasonably short time, or there'd be so few candidates that it'd be very 
fast to give me the bad results, thus allowing me to try 50.  Same with 
50 and 67, tho I'd definitely be unhappy if 50 didn't give me at least a 
TiB or so freed to unallocated, hopefully some of which would be in the 
first eight devices, ideally giving the full balance room enough to do 
full 12-device-stripes, keeping enough free on the original eight devices 
as it went to go 12-wide until the smaller devices were full, then 8 
wide, eliminating the 4-wide stripes entirely.

Tho as Hugo suggested, having the original larger eight devices all the 
way full and thus a good likelihood of all three stripe widths isn't 
ideal, and it might actually take a couple balances (yes, at a week a 
piece or whatever =:^() to straighten things out.  A good -dusage= 
filtered balance pre-pass would have likely taken under a day and with 
luck would have allowed a single full balance to do the job, but it's a 
bit late for that now...


Meanwhile, FWIW that long maintenance time is one of the reasons I'm a 
strong partitioning advocate.  Between the fact that I use SSDs and the 
fact that my btrfs partitions are all under 50 GiB per partition (which 
probably wouldn't be practical for you, but half to 1 TiB per device 
partition might be...), full scrubs typically take under a minute here, 
and full balances still in the single-digit minutes.  Of course, I have 
other partitions/filesystems too, and to do all of them would take a bit 
longer, say an hour, but with maintenance time under 10 minutes per 
filesystem, doing it is not only not a pain, but is actually trivial, 
where as doing maintenance that's going to take a week is definitely a 
pain, something you're going to avoid if possible, meaning there's a fair 
chance a minor problem will be allowed to get far worse before it's 
addressed, than it would be if the maintenance were a matter of a few 
hours, say a day at most.

But that's just me.  I've fine tuned my partitioning layout over multiple 
multi-year generations and have it setup so I don't have the hassle of 
"oh, I'm out of space on this partition, gotta symlink to a different 
one" that a lot of folks point to as the reason they prefer big storage 
pools like lvm or multi-whole-physical-device btrfs.  And obviously, I'm 
not scaling storage to the double-digit TiB you are, either.  So your 
system, your layout and rules.  I'm simply passing on one reason that I'm 
such a strong partitioning advocate, here. 

Plus I know you'd REALLY like those 10 minute full-balances right about 
now! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

