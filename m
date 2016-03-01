Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38687 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbcCAUvw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 15:51:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aarGm-00060Z-U5
	for linux-btrfs@vger.kernel.org; Tue, 01 Mar 2016 21:51:49 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 21:51:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 21:51:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Tue, 1 Mar 2016 20:51:32 +0000 (UTC)
Message-ID: <pan$b2129$4febff94$eb9a65a0$72f9d0cf@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<56D3A56A.20809@cn.fujitsu.com>
	<20160229153352.GE2334@torres.zugschlus.de>
	<56D4E621.3010604@cn.fujitsu.com>
	<20160301065448.GJ2334@torres.zugschlus.de>
	<56D54393.8060307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Tue, 01 Mar 2016 15:24:03 +0800 as excerpted:


> 
> Marc Haber wrote on 2016/03/01 07:54 +0100:
>> On Tue, Mar 01, 2016 at 08:45:21AM +0800, Qu Wenruo wrote:
>>> Didn't see the attachment though, seems to be filtered by maillist
>>> police.
>>
>> Trying again.
> 
> OK, I got the attachment.
> 
> And, surprisingly, btrfs balance on data chunk works without problem,
> but it fails on plain btrfs balance command.

There has been something bothering me about this thread that I wasn't 
quite pinning down, but here it is.

If you look at the btrfs fi df/usage numbers, data chunk total vs. used 
are very close to one another (113 GiB total, 112.77 GiB used, single 
profile, assuming GiB data chunks, that's only a fraction of a single 
data chunk unused), so balance would seem to be getting thru them just 
fine.

But there's a /huge/ spread between total vs. used metadata (32 GiB 
total, under 4 GiB used, clearly _many_ empty or nearly empty chunks), 
implying that has not been successfully balanced in quite some time, if 
ever.  So I'd surmise the problem is in metadata, not in data.

Which would explain why balancing data works fine, but a whole-filesystem 
balance doesn't, because it's getting stuck on the metadata, not the data.

Now the balance metadata filters include system as well, by default, and 
the -mprofiles=dup and -sprofiles=dup balances finished, apparently 
without error, which throws a wrench into my theory.

But while we have the btrfs fi df from before the attempt with the 
profiles filters, we don't have the same output from after.

If btrfs fi df still shows more than a GiB spread between metadata total 
and used /after/ the supposedly successful profiles filter runs, then 
obviously they're not balancing what they should be balancing, a bug 
right there, which an educated guess suggests if it's fixed, the metadata 
and possibly system balances will likely fail, due to whatever problem on 
the filesystem is keeping the full balance from completing as well.

Of course, if the post-filtered-balance btrfs fi df shows a metadata 
spread of under a gig (given 256 MiB metadata chunks, but dup, so 
possibly nearly a half-gig free, and the 512 MiB global reserve counts as 
unused metadata as well, adding another half-gig that's going to be 
reported free but is actually accounted for, yielding a spread of upto a 
gig even after successful balance), then the problem is elsewhere, but 
I'm guessing it's still going to be well over a gig and may still be the 
full 28+ gig spread, 32 gig total, under 4 gig used, indicating the 
metadata filtered balance actually didn't actually work at all.

Meanwhile, the metadata filters also include system, so while it's 
possible to balance system specifically, without (other) metadata, to my 
knowledge it's impossible to balance (other) metadata exclusively, 
without balancing system.

Which, now assuming we still have that huge metadata spread, means if the 
on-filesystem bug is in the system chunks, both system and metadata 
filtered balances *should* fail, while if it's in non-system metadata, a 
system filtered balance *should* succeed, while a metadata filtered 
balance *should* fail.

>>>> I now have a kworker and a btfs-transact kernel process taking most
>>>> of one CPU core each, even after the userspace programs have
>>>> terminated. Is there a way to find out what these threads are
>>>> actually doing?
>>>
>>> Did btrfs balance status gives any hint?
>>
>> It says 'No balance found on /mnt/fanbtr'. I do have a second btrfs on
>> the box, which is acting up as well (it has a five digit number of
>> snapshots, and deleting a single snapshot takes about five to ten
>> minutes. I was planning to write another mailing list article once this
>> balance issue is through).
> 
> I assume the large number of snapshots is related to the high CPU usage.
> As so many snapshots will make btrfs take so much time to calculate its
> backref, and the backtrace seems to prove that.
> 
> I'd like to remove unused snapshots and keep the number of them to 4
> digits, as a workaround.


I'll strongly second that recommendation.  Btrfs is known to have 
snapshot scaling issues at 10K snapshots and above.  My strong 
recommendation is to limit snapshots per filesystem to 3000 or less, with 
a target of 2000 per filesystem or less if possible, and an ideal of 1000 
per filesystem or less if it's practical to keep it to that, which it 
should be with thinning, if you're only snapshotting 1-2 subvolumes, but 
may not be if you're snapshotting more.

You can actually do scheduled snapshotting on a pretty tight schedule, 
say twice or 3X per hour (every 20-30 minutes), provided you have a good 
snapshot thinning program in place as well, thinning to say a snapshot an 
hour after 2-12 hours, every other hour after say 25 hours (giving you a 
bit over a day of at least hourly), every six hours after 8 days (so you 
have over a week of every other hour), twice a day after a couple weeks, 
daily after four weeks, weekly after 90 days, by which time you should 
have an off-system backup available to fall back on as well if you're so 
concerned about snapshots, such that after six months or a year you can 
delete all snapshots and finally free the space taken by the old 
snapshots.

Having posted the same suggestion and done the math multiple times, 
that's 250-500 snapshots per subvolume depending primarily on how fast 
you thin down in the early stages, which means 2-4 subvolumes of 
snapshotting per thousand snapshots total per filesystem, which means 
with a strict enough thinning program, you can snapshot upto 8 subvolumes 
per filesystem and stay under the 2000 total snapshots target.

By 3000 snapshots per filesystem, you'll be beginning to notice slowdowns 
in some btrfs maintenance commands if you're sensitive to it, tho it's 
still at least practical to work with, and by 10K, it's generally 
noticeable by all, at least once they thin down to 2K or so, as it's 
suddenly faster again!  Above 100K, some btrfs maintenance commands slow 
to a crawl and doing that sort of maintenance really becomes impractical 
enough that it's generally easier to backup what you need to and blow 
away the filesystem to start again with a new one, than it is to try to 
recover the existing filesystem to a workable state, given that 
maintenance can at that point take days to weeks.

So 5-digits of snapshots on a filesystem is definitely well outside of 
the recommended range, to the point that in some cases, particularly 
approaching 6-digits of snapshots, it'll be more practical to simply 
ditch the filesystem and start over, than to try to work with it any 
longer.  Just don't do it; setup your thinning schedule so your peak is 
3000 snapshots per filesystem or under, and you won't have that problem 
to worry about. =:^)

Oh, and btrfs quota management exacerbates the scaling issues 
dramatically.  If you're using btrfs quotas, either half the max 
snapshots per filesystem recommendations, or reconsider whether you need 
quota functionality and turn it off, eliminating the existing quota data, 
if you don't really need that functionality. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

