Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37783 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3LKRqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 12:46:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vqnrn-0001o1-L8
	for linux-btrfs@vger.kernel.org; Wed, 11 Dec 2013 18:46:35 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 18:46:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 18:46:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Date: Wed, 11 Dec 2013 17:46:10 +0000 (UTC)
Message-ID: <pan$71ccd$265efd80$bd2ea96b$566b0dd7@cox.net>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
	<CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
	<6FD125A9-7975-4C34-88C7-95B11A39D054@colorremedies.com>
	<20131211080902.GI9738@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 11 Dec 2013 08:09:02 +0000 as excerpted:

> On Tue, Dec 10, 2013 at 09:07:21PM -0700, Chris Murphy wrote:
>> 
>> On Dec 10, 2013, at 8:19 PM, Imran Geriskovan
>> <imran.geriskovan@gmail.com> wrote:
>> > 
>> > Now the question is, is it a good practice to use "-M" for large
>> > filesystems?
>> 
>> Uncertain. man mkfs.btrfs says "Mix data and metadata chunks together
>> for more efficient space utilization.  This feature incurs a
>> performance penalty in larger filesystems.  It is recommended for use
>> with filesystems of 1 GiB or smaller."
> 
> That documentation needs tweaking. You need --mixed/-M for larger
> filesystems than that. It's hard to say exactly where the optimal
> boundary is, but somewhere around 16 GiB seems to be the dividing point
> (8 GiB is in the "mostly going to cause you problems without it"
> area). 16 GiB is what we have on the wiki, I think.

I believe it also depends on the expected filesystem fill percentage and 
how that interacts with chunk sizes.  I posted some thoughts on this in 
another thread a couple weeks(?) ago.  Here's a rehash.

On large enough filesystems with enough unallocated space, data chunks 
are 1 GiB, while metadata chunks are 256 MiB, but I /think/ dup-mode 
means that'll double as they'll allocate in pairs.  For balance to do its 
thing and to avoid unexpected out-of-space errors, you need at least 
enough unallocated space to easily allocate one of each as the need 
arises (assuming file sizes significantly under a gig, so the chances of 
having to allocate two or more data chunks at once is reasonably low), 
which with normal separate data/metadata chunks, means 1.5 GiB 
unallocated, absolute minimum.  (2.5 gig if dup data also, 1.25 gig if 
single data and single metadata, or on each of two devices in raid1 data 
and metadata mode.)

Based on the above, it shouldn't be unobvious (hmm... double negative,
/should/ be /obvious/, but that's not /quite/ the nuance I want... the 
double negative stays) that with separate data/metadata, once the 
unallocated-free-space goes below the level required to allocate one of 
each, things get WAAYYY more complex and any latent corner-case bugs are 
far more likely to trigger.

And it's equally if not even more obvious (no negatives this time) that 
this 1.5 GiB "minimum safe reserve" space is going to be a MUCH larger 
share of say a 4 or 8 GiB filesystem, than it will of say a 32 GiB or 
larger filesystem.


However, I've had no issues with my root filesystems, 8 GiB each on two 
separate devices in btrfs raid1 (both data and metadata) mode, but I 
believe that's in large part because actual data usage according to btrfs 
fi df is 1.64 GiB (4 gig allocated), metadata 274 MiB (512 meg 
allocated).  There's plenty of space left unallocated, well more than the 
minimum-safe 1.25 gigs on each of two devices (1.25 gigs each not 1.5 
gigs each since there's only one metadata copy on each, not the default 
two of single-device dup mode).  And I'm on ssd with small filesystems, 
so a full balance takes about 2 minutes on that filesystem, not the hours 
to days often reported for multi-terabyte filesystems on spinning rust.  
So it's easy to full-balance any time allocated usage (as reported by 
btrfs filesystem show) starts to climb too far beyond actual used bytes 
within that allocation (as reported by btrfs filesystem df).

That means the filesystem says healthy, with lots of unallocated freespace 
in reserve, should it be needed.  And even in the event something goes 
hog wild and uses all that space (logs, the usual culprits, are on a 
separate filesystem, as is /home, so it'd have to be a core system 
"something" going hog-wild!), at 8 gigs, I can easily do a temporary 
btrfs device add if I have to, to get the space necessary for a proper 
balance to do its thing.

I'm actually much more worried about my 24 gig, 21.5 gigs used, packages-
cache filesystem, tho it's only my cached gentoo packages tree, cached 
sources, etc, so it's easily restored direct from the net if it comes to 
that.  Before the rebalance I just did while writing this post, above, 
btrfs fi show reported it using 22.53 of 24.00 gigs (on each of the two 
devices in btrfs raid1), /waaayyy/ too close to that magic 1.25 GiB to be 
comfortable!  And after the balance it's still 21.5 gig used out of 24, 
so as it is, it's a DEFINITE candidate for an out-of-space error at some 
point.  I guess I need to clean up old sources and binpkgs, before I 
actually get that out-of-space and can't balance to fix it due to too 
much stale binpkg/sources cache.  I did recently update to kde 4.12 
branch live-git from 4.11-branch and I guess cleaning up the old 4.11 
binpkgs should release a few gigs.  That and a few other cleanups should 
bring it safely into line... for now... but the point is, that 24 gig 
filesystem both tends to run much closer to full and has a much more 
dramatic full/empty/full cycle than either my root or home filesystems, 
at 8 gig and 20 gig respectively.  It's the 24-gig where mixed-mode would 
really help; the others are fine as they are.

Meanwhile, I suspect the biggest down sides of mixed-mode to be two-fold, 
first, the size penalty of the implied dup-data-by-default of mixed-mode 
on a single device filesystem.  Typically, data will run an order of 
magnitude larger than its metadata, two orders of magnitude if the files 
are large.  Duping all those extra data bytes can really hurt, space-
wise, compared to just duping metadata, and on a multi-terabyte single-
device filesystem, it can mean the difference between a terabyte of data 
and two terabytes of data.  No filesystem developer wants their 
filesystem to get the reputation of wasting terabytes of space, 
especially for the non-technical folks who can't tell what benefit (scrub 
actually has a second copy to recover from!) they're getting from it, so 
dup data simply isn't a practical default, regardless of whether it's in 
the form of separate dup-data chunks or mixed dup-data/metadata chunks.  
Yet when treated separately, the benefits of dup-metadata clearly 
outweigh the costs, and it'd be a shame to lose that to a single-mode 
mixed-mode default, so mixed-mode remains dup-by-default, even if that 
entails the extra cost of dup-data-by-default.

That's the first big negative of mixed-mode, the huge space cost of the 
implicit dup-data-by-default.

The second major downside of mixed mode surely relates to the performance 
cost of the actual IO of all that extra data, particularly on spinning 
rust.  First, actually writing all that extra data out, especially with 
the extra seeks now necessary to write it to two entirely separate 
chunks, altho that'll be somewhat mitigated by the fact that data and 
metadata will be combined so there's likely less seeking between data and 
metadata.  But on the read side, the shear volume of all that intertwined 
data and metadata must also mean far more seeking in all the directory 
data before the target file can even be accessed in the first place, and 
that's likely to exact a heavy read-side toll indeed, at least until the 
directory cache is warmed up.  Cold-boot times are going to suffer 
something fierce!

In terms of space, a rough calculation demonstrates a default-settings 
large file crossover near 4 GiB.  Consider a two-gigs data case.  With 
separate data/metadata, we'll have two gigs of data in single-mode, plus 
256 megs of metadata, dup mode so doubled to half a gig, so say 2.5 gig 
allocated (it'd actually be a bit more due to the system chunk, doubled 
due to dup).  As above a safe unallocated reserve is one of each, 
metadata again doubled due to dup, so 1.5 gig.  Usage is thus 2.5 gig 
allocated plus 1.5 gig reserved, about 4 gig.

The same two-gigs data in mixed mode ends up taking about 5 gig of 
filesystem space, two-gigs data doubles to four due to mixed-mode-dup.  
Metadata will be mixed in the same chunks, but won't fit in the same four 
gigs as that's all data, so that'll be say another possibly 128 megs 
duped to a quarter gig, or 256 megs duped to a half gig, depending on 
what's being allocated for mixed-mode chunk size.  Then another quarter 
or half gig must be reserved for allocation if needed, and there's the 
system allocation to consider too.  So we're looking at about 4.5 or 5 
gig.

More data means an even higher space cost for the duped mixed-mode data, 
while the separate-mode data/metadata reserved space requirement remains 
nearly constant.  At 4 gigs actual data, we're looking at nearing 9 gigs 
space cost for mixed, while separate will be only 4+.5+1.5, about 6 
gigs.  At 10 gigs actual data, we're looking at 21 gigs mixed-mode, 
perhaps 21.5 if additional mixed chunks need allocated for metadata, only 
10+.5+1.5, about 12 gigs separate mode, perhaps 12.5 or 13 if additional 
metadata chunks need allocated, so as you can see, the size cost for that 
duped data is getting dramatically worse relative to the default-single 
separate data mode.

Of course if you'd run dup separate data if it were an option, that space 
cost zeroes out, and I suspect a lot of the performance cost does too.

Similarly but the other way for a dual-device raid1 both data/metadata, 
since from a single device perspective, it's effectively single-mode to 
each device separately.  Mixed-mode space-cost and I suspect much of the 
performance cost as well thus zeroes out as compared to separate-mode 
raid1-mode for both data/metadata.  Tho due to the metadata being spread 
more widely as it's mixed with the data, I suspect there's very likely 
still the read performance cost of those additional seeks necessary to 
gather the metadata to actually find the target file before it can be 
read, so cold-cache and thus cold-boot performance is still likely to 
suffer quite a bit.

Above 4 gig, it's really use-case dependent, depending particularly on 
single/dup/raid mode chosen and slow-ssd/spinning-rust/fast-ssd physical 
device, how much of the filesystem is expected to actually be used, and 
how actively it's going to be near-empty-to-near-full cycled, but 16 gigs 
would seems to be a reasonable general-case cut-over recommendation, 
perhaps 32 or 64 gigs for single-device single-mode or dual-device raid1 
mode on fast ssd, maybe 8 gigs for high free-space cases lacking a 
definite fill/empty/fill/empty pattern, or on particularly slow-seek 
spinning rust.

As for me, this post has helped convince me that I really should make 
that package-cache filesystem mixed-mode when I next mkfs.btrfs it.  It's 
20 gigs of data on a 24-gig filesystem, which wouldn't fit if I were 
going default data-single to default mixed-dup on a single device, but 
it's raid1 both data and metadata on dual fast ssd devices, so usage 
should stay about the same, while flexibility will go up, and as best I 
can predict, performance shouldn't suffer much either since I'm on fast 
ssds with what amounts to a zero seek time.

But I have little reason to change either rootfs or /home, 8 gigs about 
4.5 used, and 20 gigs about 14 used, respectively, from their current 
separate data/metadata.  Tho doing a fresh mkfs.btrfs on them and copying 
everything back from backup will still be useful, as it'll allow them to 
make use of newer features like the 16 KiB default node size and skinny 
metadata, that they're not using now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

