Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48523 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaKWHwm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 02:52:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XsRyK-0000hL-PC
	for linux-btrfs@vger.kernel.org; Sun, 23 Nov 2014 08:52:40 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 08:52:40 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 08:52:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Sun, 23 Nov 2014 07:52:29 +0000 (UTC)
Message-ID: <pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 22 Nov 2014 17:07:42 -0800 as excerpted:

> On Sun, Nov 23, 2014 at 12:05:04AM +0000, Hugo Mills wrote:
>> > Which is correct?
>> 
>>    Less than or equal to 55% full.
>  
> This confuses me. Does that mean that the fullest blocks do not get
> rebalanced?

Yes. =:^)

> I guess I was under the mistaken impression that the more data you had
> the more you could be out of balance.

What you were thinking is a misstatement of the situation, so yes, again, 
that was a mistaken impression. =:^)

>>    A chunk is the part of a block group that lives on one device, so
>> in RAID-1, every block group is precisely two chunks; in RAID-0, every
>> block group is 2 or more chunks, up to the number of devices in the FS.
>> A chunk is usually 1 GiB in size for data and 250 MiB for metadata, but
>> can be smaller under some circumstances.
> 
> Right. So, why would you rebalance empty chunks or near empty chunks?
> Don't you want to rebalance almost full chunks first, and work you way
> to less and less full as needed?

No, the closer to empty a chunk is, the more effect you can get in 
rebalancing it along with others of the same fullness.


Think of it this way.

One goal of a rebalance, the goal we have when data and metadata is 
unbalanced and we're hitting ENOSPC as a result (as opposed to the goal 
of converting or balancing among devices when one has just been added or 
removed), and thus the goal that the usage filter is designed to help 
solve, is this: Free excess chunk-allocated but chunk-empty space back to 
unallocated, so it can be used by the other type, data or metadata.

More specifically, all available space has been allocated to data and 
metadata chunks leaving no space available to allocate more chunks, and 
one of two extremes has been reached, we'll call them D and M:

(

D1: All data chunks are full and more need to be allocated, but they 
can't be as there's no more unallocated space to allocate the new data 
chunks from, 

*AND* 

D2: There's a whole bunch of excess metadata chunks allocated, using up 
all that unallocated space, but they're mostly empty, and need to be 
rebalanced to consolidate usage into fewer but fuller metadata chunks, 
thus freeing the space currently taken by all those mostly empty metadata 
chunks.

)

*OR* the reverse:

(

M1: All metadata chunks are full and more need to be allocated, but they 
can't be as there's no more unallocated space to allocate the new 
metadata chunks from,

*AND*

M2: There's a whole bunch of excess data chunks allocated, using up all 
the unallocated space, but they're mostly empty, and need to be 
rebalanced to consoldidate usage into fewer but fuller data chunks, thus 
freeing the space currently taken by all those mostly empty data chunks.

)


In both cases, the one type is full and needs more allocation, but the 
other type is hogging all the space with mostly empty chunks.  In both 
cases, then, you *DON'T* want to bother with the full type, since it's 
full and rewriting it won't do anything but shuffle the full chunks 
around -- you can't combine any because they're all full.

In both cases, What you *WANT* to do is deal with the EMPTY type, the 
chunks that are hogging all the space but not actually using it.

This is evidently a bit counterintuitive on first glance as you're not 
the first to have problems with it, but it /is/ the case, and once you 
understand what's actually happening and why, it /does/ make sense.

More specifically, in the D case, where all /data/ chunks are full, you 
want to rebalance the mostly empty /metadata/ chunks, combining for 
example 5 near 20% full metadata chunks into a single near 100% full 
metadata chunk, deallocating the other four metadata chunks (instead of 
rewriting empty chunks) once there's nothing in them at all.  Five just 
became one, freeing four to unallocated space, which can now be used to 
allocate new data chunks.

And the reverse in the M case, where all metadata chunks are full.  Here, 
you want to rebalance the mostly empty data chunks, again combining say 
five 20% usage data chunks into a single 100% usage data chunk, 
deallocating the other four data chunks once there's nothing in them at 
all.  Again, five just become one, freeing four to unallocated space, 
which now can be used to allocate new, in this case, metadata chunks.


Thus the goal is to rebalance the nearly /empty/ chunks of the *OPPOSITE* 
type to the one you're running short on, combining multiple nearly empty 
chunks of the type you have too many of, thus freeing that empty space 
back to unallocated, so the type that you're actually short on can 
actually allocate chunks from the just freed to unallocated space.

That being the goal, working with the full chunks won't get you much.  
Suppose you work with the 95% full chunks, 5% empty.  You'll have to 
rewrite *TWENTY* of them to combine all those 5% empties to free just 
*ONE* chunk!  And rewriting 100% full chunks won't get you anything at 
all toward this goal, since they're already full and no more can be 
stuffed into them.  Rewrite 100 chunks 100% full, and you still have 100 
chunks 100% full! =:^(

OTOH, suppose you work with 5% full chunks, 95% empty.  Rewrite just two 
of them, and you've already freed one, with the one left only 10% full.  
Add a third one and free a second, with the one you're left with still 
only 15% full.  Continue until you've rewritten 20 of them, AND YOU FREE 
19 OF THEM! =:^)


So it *CLEARLY* pays to work with the mostly empty ones.  Usage=N, where 
balance only works with the ones with LESS than or equal usage to that, 
lets you do exactly that, work with the mostly EMPTY ones.


*BUT*, the payoff is even HIGHER than that.  Consider, since only the 
actually used blocks in a blockgroup need rewritten, an almost full chunk 
is going to take FAR longer than an almost empty chunk to rewrite.  Now 
there's going to be /some/ overhead, but let's consider that 5% full 
example again.  For chunks only 5% full, you're only writing 5% of the 
data or metadata that you'd be writing for a 100% full chunk, 1/20th as 
much.

So in our example above, where we find and rewrite 20 5% usage chunk into 
a single 100% usage chunk, while there will be /some/ overhead, you might 
well write those 20 5% used chunks into a single 100% used chuck in 
perhaps the same time it'd take you to rewrite just ONE 95% usage chunk.

IOW, rewriting 20 95% usage chunks to 19, freeing just one, is going to 
take you nearly 20 times as long as rewriting 20 5% usage chunks, freeing 
19 of them, since in the latter case you're actually only rewriting one 
full chunk's worth of data or metadata.

So working with 5% usage chunks as opposed to 95% usage chunks, you free 
19 times as much space, using only a bit over a 20th as much time.  Even 
with 100% overhead, you'd still spend a tenth as much time freeing 19 
times as many chunks!


Which is why the usage= filter is such a big deal.  In many cases, it 
allows you *HUGE* bang for the buck!  While I'm pulling numbers out of 
the air for this example, they're well within reason.  Something like 
usage=10 might take you half an hour and free up 70% of the space that a 
full balance would free, while the full balance may well take a whole 24-
hour day!


OK, so what /is/ the effect of a fuller filesystem?  Simply this.  As the 
filesystem fills up, there's less and less fully free unallocated space 
available even after a full balance, meaning that free space can be used 
up with fewer and fewer chunk allocations, so you have to rebalance more 
and more often to keep what's left from getting out of balance and 
running into ENOSPC conditions.

Compounding the problem, as the filesystem fills up, it's less and less 
likely that there will be more than just one mostly free chunk available 
(the one that's actively being written into), with others full or nearly 
so), so it'll be necessary to use higher and higher usage=N balances to 
get anything back, and the bonus payoff we had above will be working in 
reverse as now we WILL be having to do 20 95% full chunks to free just 
one chunk back to unallocated.  Compounding the problem even FURTHER, 
will be the fact that we have ALL THOSE GiB (TiB?) of actual data to 
rewrite, so it'll be a worse and worse slog for fewer and fewer freed 
chunks in payback.

Again, numbers out of thin air, but for illustrative purposes...

When a TiB filesystem is say 10% full, 90% of it could be in almost-empty 
chunks.  Not only will it take a relatively long time to get to that 
point with only 10% usage, but a usage=10 filter will very likely free 
say 80% (leaving 10% that would require a higher usage filter to 
recover), in only a few minutes or a half hour or whatever.  And you do 
it once and could be good for six months or a year before you start 
running low on space again and need to redo it.

When it's 90% full, you're likely to need at least usage=80 to get 
anywhere, and you'll be rewriting a good portion of that 900+ GiB in 
ordered to get just a handful of chunks worth of space recovered, with 
the balance taking say 10-12 hours, perhaps longer.  What's worse, you 
may well find yourself having to do a rebalance like that every week, 
because your total deallocatable free space (even after a full balance) 
is approaching your weekly working set!

Obviously at/before that point it's time to invest in more storage!


But, beware!  Just because your filesystem is say 55% full (number from 
your example earlier), does **NOT** mean usage=55 is the best number to 
use.  That may well be the case, or it may not.  There's simply no 
necessarily direct correlation in that regard, and a recommended N for 
usage=N cannot be determined without a LOT more use-case information than 
simply knowing the filesystem is at 55% capacity.

The most that can be /reliably/ stated is that in general, as usage of 
the filesystem goes up, so will the necessary N for the usage=N balance 
filter -- there's a general correlation, yes, but it's nowhere NEAR 
possible to assume any particular ratio like 1:1, without knowing rather 
more about the use-case.

In particular, with the filesystem at 55% capacity, the extremes are all 
used chunks at 100% capacity except for one (the one that's actively 
being used, this is in theory the case immediately after a full balance, 
and even a full balance wouldn't do anything further here), *OR* all used 
chunks at 56% usage but for one (in this case usage=55 would do nothing, 
since all those 56% used chunks are above the 55% cutoff and the single 
chunk that might be rewritten has nothing to combine with, but a usage=56 
or a usage=60 would be as effective as a full balance), *OR* most chunks 
are actually empty, with the remember but one at 100% usage (nearly the 
same as the first case, except in that case there's no empty chunks 
allocated, in this case all available space is allocated to empty chunks, 
such that a usage=0 would be as effective as a full balance), *OR* all 
used chunks but one are at 54-55% usage (usage=55 would in this case 
just /happen/ to be the magic number that is as effective as a full 
balance, while usage=54 would do nothing).


Another way of looking at that would be the old pick a number between 0 
and 100 game.  So you're using two d10 (10-sided dice, with one marked to 
be the 10s digit thus generating 01-(1)00 as the range) to generate the 
number and know the dice are weighted slightly to favor 5s, you along 
with two friends are picking, and you pick first.

So you pick 55.  But your two friends, not being dummies, pick 54 and 
56.  Unless those d10s are HEAVILY weighted, despite the weighing, your 
odds of being the closest with that 55 aren't very good, are they?

Given no differences in time necessary and no additional knowledge about 
how long it has been since the last full balance (which would have tended 
to cram everything to 100% usage), and no knowledge about usage pattern, 
55 would indeed be arguably the best choice to begin with.  

But given the huge time advantage of lower values of N for usage=N if 
they /do/ happen to do what you need, and thus the chance of usage=20 
either doing the job in MUCH less time, or getting done in even LESS time 
because it couldn't actually do /anything/, there's a good chance I'd try 
something like that first, if only to then have some idea how much higher 
I might want to go, because it'll be done SO much faster and has a /small/
chance of doing all I need anyway!

If usage=20 wasn't enough, I might then try usage=40, hoping that it 
would do the rest, knowing that a rerun at higher but still under 100 
number would at most redo only a single chunk from the previous run, the 
one that didn't get filled up all the way at the end -- all the others 
would either be 100% or would have been deallocated as empty, and knowing 
that the higher the number, the MUCH higher the time required, in general.

So the 55% filesystem capacity would probably inform my choice of jumps, 
say 20% at a time, but I'd still start much lower and jump at that 20% or 
so at a time.

Meanwhile, if the filesystem was only at say 20% capacity, I'd probably 
start with usage=0 and jump by 5% at a time, while if it was at say 80% 
capacity, I might still start at usage=0 to see if I could get lucky, but 
then jump to usage=60, and then usage=98 or 99, because the really high 
number still under 100 would still avoid rewriting all the full chunks 
I'd created with the previous runs as well as all 100% full chunks that 
would yield no benefit toward our goal, but would still recover pretty 
much everything it was possible to recover, which once you reach 80% 
capacity is going to start looking pretty necessary at some point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

