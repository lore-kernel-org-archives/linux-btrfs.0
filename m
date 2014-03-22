Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59695 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaCVXcn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 19:32:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WRVP7-0000ob-CN
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 00:32:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 00:32:41 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 00:32:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: free space inode generation (0) did not match free space cache
 generation
Date: Sat, 22 Mar 2014 23:32:16 +0000 (UTC)
Message-ID: <pan$b7ff$285d59f6$2419371$b3946ebe@cox.net>
References: <532DF38B.40409@friedels.name> <532DFDAB.7000600@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel posted on Sat, 22 Mar 2014 22:16:27 +0100 as excerpted:

> I read through the FAQ you mentioned, but I must admit, that I do not
> fully understand.

My experience is that it takes a bit of time to soak in.  Between time, 
previous Linux experience, and reading this list for awhile, things do 
make more sense now, but my understanding has definitely changed and 
deepened over time.

> What I am wondering about is, what caused this problem to arise. The
> filesystem was hardly a week old, never mistreated (powered down without
> unmounting or so) and not even half full. So what caused the data chunks
> all being allocated?

I can't really say, but it's worth noting that btrfs can normally 
allocate chunks, but doesn't (yet?) automatically deallocate them.  To 
deallocate, you balance.  Btrfs can reuse areas that have been deleted as 
the same thing, data or metadata, but it can't switch between them 
without a balance.

So the most obvious thing is that if you copy a bunch of stuff around so 
the filesystem is nearing full, then delete a bunch of it, consider 
checking your btrfs filesystem df/show stats and see whether you need a 
balance.  But like I said, that's obvious.

> The only thing that I could think of is that I created hourly snapshots
> with snapper.
> In fact in order to be able to do the balance, I had to delete something
> -so I deleted the snapshots.

One possibility off the top of my head:  Do you have noatime set in your 
mount options?  That's definitely recommended with snapshotting, since 
otherwise, atime updates will be changes to the filesystem metadata since 
the last snapshot, and thus will add to the difference between snapshots 
that must be stored.  If you're doing hourly snapshots and are accessing 
much of the filesystem each hour, that'll add up!

Additionally, I recommend snapshot thinning.  Hourly snapshots are nice 
but after some time, they just become noise.  Will you really know or 
care which specific hour it was if you're having to retrieve a snapshot 
from a month ago?

So hourly snapshots, but after say a day, delete two out of three, 
leaving three-hourly snapshots.  After two days, delete another half, 
leaving six-hourly snapshots (four a day).  After a week, delete three of 
the four, leaving daily snapshots.  After a quarter (13 weeks) delete six 
of seven (or 4 of five if it's weekdays only), leaving weekly snapshots.  
After a year, delete 12 of the 13, leaving quarterly snapshots.  ...  Or 
something like that.  You get the idea.  Obviously script it, just like 
the snapshotting itself is scripted.

That will solve another problem too.  When btrfs gets into the thousands 
of snapshots, at it will pretty fast with unthinned hourly, certain 
operations slow down dramatically.  The problem was much worse at one 
point, but the snapshot aware defrag was disabled for the time being, as 
it simply didn't scale and people with thousands of snapshots were seeing 
balances or defrags go days with little visible progress.  But, few 
people really /need/ thousands of snapshots.  With a bit of reasonable 
thinning down to one a quarter, you end up with 200-300 snapshots and 
that's it.

Also, it may or may not apply to you, but internal-rewrite (as opposed to 
simply appended) files are bad news for COW-based filesystems such as 
btrfs.  The autodefrag mount option can help with this for smaller files 
(say to several hundred megabytes in size), but for larger (from say half 
a gig) actively rewritten files such as databases, VM images, and pre-
allocated torrent downloads until they're fully downloaded, setting the 
NOCOW attribute (chattr +C, change in-place, instead of using the normal 
copy-on-write) is strongly recommended.  But the catch is that the 
attribute needs to be set while the file is still zero-size, before it 
actually has any content.  The easiest way to do that is to create a 
dedicated directory for such files and to set the attribute on the 
directory, after which it'll automatically be inherited by any newly 
created files or subdirs in that directory.

But, there's a catch with snapshots.  The first change to a block after a 
snapshot forces a COW anyway, since the data has changed from that of the 
snapshot.  So for those making heavy use of snapshots, creating dedicated 
subvolumes for these NOCOW directories is a good idea, since snapshots 
are per subvolume and thus these dedicated subvolumes will be excluded 
from the general snapshots (just don't snapshot the dedicated subvolumes).

Of course that does limit the value of snapshots to some degree, but it's 
worth keeping in mind that most filesystems don't even offer the snapshot 
feature at all, so...

> Can you tell me where I can read about the causes for this problem?

The above wisdom is mostly from reading the list for awhile.  Like I 
said, it takes awhile to soak in, and my thinking on the subject has 
changed somewhat over time.  The fact that NOCOW wasn't NOCOW on the 
first change after a snapshot was a rather big epiphany to me, but AFAIK, 
that's not on the wiki or elsewhere yet.  It makes sense if you think 
about it, but someone specifically asked, and the devs confirmed it.  
Before that I had no idea, and was left wondering at some of the behavior 
being reported, even with nocow properly set.  (That was back when the 
broken snapshot aware defrag was still in place, as it simply didn't 
scale with snapshots and such files, and I couldn't figure out why NOCOW 
wasn't working to avoid the problem, until a dev confirmed that the first 
change after a snapshot was COW anyway, and it all dropped into place... 
continuously rewritten VM images, even if set NOCOW, would still be 
continuously fragmented, if people were doing regular snapshots on them.)

> Besides this:
> You recommend monitoring the output of btrfs fi show and to do a
> balance, whenever unallocated space drops too low. I can monitor this
> and let monit send me a message once that happens. Still, I'd like to
> know how to make this less likely.

I haven't had a problem with it here, but then I haven't been doing much 
snapshotting (and always manual when I do it), I don't run any VMs or 
large databases, I mounted with the autodefrag option from the beginning, 
and I've used noatime for nearing a decade now as it was also recommended 
for my previous filesystem, reiserfs.

But regardless of my experience with my own usage pattern, I suspect that 
with reasonable monitoring, you'll eventually become familiar with how 
fast the chunks are allocated and possibly with what sort of actions 
beyond the obvious active moving stuff around on the filesystem triggers 
those allocations, for your specific usage pattern, and can then adapt as 
necessary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

