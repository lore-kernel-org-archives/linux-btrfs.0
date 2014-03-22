Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42904 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaCVI3M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 04:29:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WRHIk-0003Fu-0s
	for linux-btrfs@vger.kernel.org; Sat, 22 Mar 2014 09:29:10 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 09:29:10 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 09:29:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fresh btrfs filesystem, out of disk space, hundreds of gigs
 free
Date: Sat, 22 Mar 2014 08:28:44 +0000 (UTC)
Message-ID: <pan$54504$c9b05495$fa56905f$67202842@cox.net>
References: <CAKuK5J0LyagDYro6Yq7h-p-VjbwrbeuFf9AdNwRNg0jv3bq9QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jon Nelson posted on Fri, 21 Mar 2014 19:00:51 -0500 as excerpted:

> Using openSUSE 13.1 on x86_64 which - as of this writing - is 3.11.10,
> Would a more recent kernel than 3.11 have done me any good?

[Reordered the kernel question from below to here, where you reported the 
running version.]

As both mkfs.btrfs and the wiki recommend, always use the latest kernel.  
In fact, the kernel config's btrfs option had a pretty strong warning thru 
3.12 that was only toned down in 3.13 as well, so I'd definitely 
recommend at least the latest 3.13.x stable series kernel in any case.

Additionally, the btrfs-progs you're running is a 3.12+ snapshot from 
November so it's relatively current as 3.12 is the latest release there 
(with 3.14 scheduled for released for the 3.14 kernel), but the
btrfs-progs version numbers are synced to the kernel, so a 3.12 btrfs-
progs userspace really indicates you should be running a 3.12 or later 
kernelspace btrfs, as well. 

Since kernel 3.14 is nearing release, that'd mean 3.13.x stable series or 
3.14-rc.  As I said, mkfs.btrfs actually tells you to run a current 
kernel when you create a filesystem...

Tho I don't believe it would have helped here, but there was an easy 
enough fix.  See below.

> I tried to copy a bunch of files over to a btrfs filesystem (which was
> mounted as /, in fact).
> 
> After some time, things ground to a halt and I got out of disk space
> errors. btrfs fi df /   showed about 1TB of *data* free, and 500MB
> of metadata free.

It's the metadata, plus no space left to allocate more.  See below.

> Below are the btrfs fi df /  and  btrfs fi show.
> 
> 
> turnip:~ # btrfs fi df /
> Data, single: total=1.80TiB, used=832.22GiB
> System, DUP: total=8.00MiB, used=204.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=5.50GiB, used=5.00GiB
> Metadata, single: total=8.00MiB, used=0.00

FWIW, the system and metadata single chunks reported there are an 
artifact from mkfs.btrfs and aren't used (used=0.00).  At some point it 
should be updated to remove them automatically, but meanwhile, a balance 
should remove them from the listing.  If you do that balance immediately 
after filesystem creation, at the first mount, you'll be rid of them when 
there's not a whole lot of other data on the filesystem to balance as 
well.  That would leave:

> Data, single: total=1.80TiB, used=832.22GiB
> System, DUP: total=8.00MiB, used=204.00KiB
> Metadata, DUP: total=5.50GiB, used=5.00GiB

Metadata is the red-flag here.  Metadata chunks are 256 MiB in size, but 
in default DUP mode, two are allocated at once, thus 512 MiB at a time.  
And you're under 512 MiB free so you're running on the last pair of 
metadata chunks, which means depending on the operation, you may need to 
allocate metadata pretty quickly.  You can probably copy a few files 
before that, but a big copy operation with many files at a time would 
likely need to allocate more metadata.

But for a complete picture you need the filesystem show output, below, as 
well...

> turnip:~ # btrfs fi show
> Label: none  uuid: 9379c138-b309-4556-8835-0f156b863d29
>         Total devices 1 FS bytes used 837.22GiB
>         devid    1 size 1.81TiB used 1.81TiB path /dev/sda3
> 
> Btrfs v3.12+20131125

OK.  Here we see the root problem.  Size 1.81 TiB, used 1.81 TiB.  No 
unallocated space at all.  Whichever runs out of space first, data or 
metadata, you'll be stuck.

And as was discussed above, you're going to need another pair of metadata 
chunks allocated pretty quickly, but there's no unallocated space 
available to allocate to them, so no surprise at all you got free-space 
errors! =:^(

Conversely, you have all sorts of free data space.  Data space is 
allocated in gig-size chunks, and you have nearly a TiB of free data-
space, which means there's quite a few nearly empty data chunks available.

To correct that imbalance and free the extra data space to the pool so 
more metadata can be allocated, you run a balance.

Here, you probably want a balance of the data only, since it's what's 
unbalanced, and on slow spinning rust (as opposed to fast SSD) rewriting
/everything/, as balance does by default, will take some time.  To do 
data only, use the -d option:

# btrfs balance start -d /

(You said it was mounted on root, so that's what I used.)

But balance will try to allocate a new chunk to copy all the used data 
from several used chunks at once, since they're near-empty, and won't be 
able to do it, since all your space is allocated.  To get around that, we 
use balance filters, as described on the wiki.

# btrfs balance start -dusage=0 /

The usage=0 filter says only rebalance entirely empty chunks, effectively 
simply reclaiming them to the unallocated pool.  If you're lucky, you 
have some of these and the above should reclaim them and return them to 
the unallocated pool.  That will give you a bit of unallocated space to 
allocate further chunks from.

Then, depending on how much space that reclaimed to unallocated, you can 
bump the usage=<max-percent> up until you're satisfied.  One at a time, 
or simply try skipping to 50% or just -d, if you like:

-dusage=5, -dusage=20, -dusage=50 -d

Usage=5 says only do chunks that are less than 5% used.  Usage=50 thus 
obviously means only those that are less than 50% used.  And a simple -d 
without the usage= filter is equivalent to -dusage=100.

As the usage bumps up, you'll be rewriting chunks with more actual data 
in them, which will take longer per chunk, tho how long overall will 
depend on how many chunks actually had that much data in them.  Given 
that you're on spinning rust with 800+ gig of data, you may not actually 
want to rewrite ALL data chunks (a plain -d), but that's not likely to be 
necessary anyway.  Stopping at say 20% or 50% usage will likely reclaim 
most of the unused data chunks you'd reclaim with a full -d, and in fact, 
even the 5% filter might well be good enough.

While we're at it, you might as well reclaim those empty single metadata 
and system chunks too, that the mkfs.btrfs left you with as mentioned 
above.

# btrfs balance start -musage=0 -susage=0 

(For the -s/system you might also need the -f/force option.  I didn't 
need it here and in fact -m implies -s as well, so in theory -musage=0 
should clear out both as it did for me, but one list poster indicated 
that didn't work for him, and he had to specifically do -susage=0 -f, 
which worked fine, clearing the unused system single from his btrfs 
filesystem df listing.  YMMV.)

That should get you back in business.  After that, simply learn to keep 
an eye on the btrfs filesystem show results and do a rebalance whenever 
unallocated space seems to be dropping too low, say when used space 
reaches 1.5 or 1.7 TiB out of the 1.81 TiB, depending on how full you 
actually eventually fill the filesystem.  (Obviously if data+metadata
+system used is say 1.65 TiB, doing a balance because allocated is 1.7 TiB 
isn't going to get you much back.  OTOH, if you end up with only say 1.2 
TiB of data+metadata+system used, rebalancing if total allocated usage 
exceeds 1.5 TiB could still make sense and get you a couple hundred gig 
back.)

Meanwhile, I strongly urge you to read up on the btrfs wiki.  The 
following is easy to remember and bookmark:

https://btrfs.wiki.kernel.org

Here's the documentation link (alternate bookmarking candidate):

https://btrfs.wiki.kernel.org/index.php/Main_Page#Documentation

Here's the discussion that would have gotten you out of this specific 
bind (long link, watch the wrap):

https://btrfs.wiki.kernel.org/index.php/
FAQ#if_your_device_is_large_.28.3E16GiB.29

And here's the balance-filters page, which can be a bit hard to find altho 
it's linked on the FAQ page under the balance discussion:

https://btrfs.wiki.kernel.org/index.php/Balance_Filters

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

