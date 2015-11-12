Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44029 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbbKLEbW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 23:31:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZwjXY-0002zT-WA
	for linux-btrfs@vger.kernel.org; Thu, 12 Nov 2015 05:31:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 05:31:16 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 05:31:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
Date: Thu, 12 Nov 2015 04:31:11 +0000 (UTC)
Message-ID: <pan$3ff1d$612bcdd$f9fb0bf6$5a136ec0@cox.net>
References: <55E6CF72.5070005@netcologne.de>
	<20150902113021.GD11358@carfax.org.uk> <55E6F51B.3000007@netcologne.de>
	<pan$45a25$fd021e31$91d1cbe2$220454a1@cox.net>
	<55E95625.2030406@netcologne.de>
	<pan$11297$845af192$4bee50bd$587fb5f7@cox.net>
	<56434DEF.9070807@netcologne.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Rohmann posted on Wed, 11 Nov 2015 15:17:19 +0100 as excerpted:

> Sorry for the late reply to this list regarding this topic ...
> 
> On 09/04/2015 01:04 PM, Duncan wrote:
>> And of course, only with 4.1 (nominally 3.19 but there were initial
>> problems) was raid6 mode fully code-complete and functional -- before
>> that, runtime worked, it calculated and wrote the parity stripes as it
>> should, but the code to recover from problems wasn't complete, so you
>> were effectively running a slow raid0 in terms of recovery ability, but
>> one that got "magically" updated to raid6 once the recovery code was
>> actually there and working.
> 
> As other who write to this ML, I run into crashes when trying to do a
> balance of my filesystem.
> I moved through the different kernel versions and btrfs-tools and am
> currently running Kernel 4.3 + 4.3rc1 of the tools but still after like
> an hour of balancing (and actually moving chunks) the machine crashes
> horribly without giving any good stack trace or anything in the kernel
> log which I could report here :(
> 
> Any ideas on how I could proceed to get some usable debug info for the
> devs to look at?

I'm not a dev so my view into the real deep technical side is limited, 
but what I can say is this...

Generally, crashes during balance indicate not so much bugs in the way 
the kernel handles existing balance (tho those sometimes occur as well, 
but the chances are relatively lower), but rather, a filesystem screwed 
up in a way that balance hasn't been taught to deal with yet.

Of course there's two immediate points that can be made from that:
1) Newer kernels have been taught to deal with more bugs, so if you're 
not on current (which you are now), consider upgrading to current at 
least long enough to see if it already knows how to deal with it.
2) If a balance is crashing with a particular kernel, it's unlikely the 
problem will simply go away on its own, without either a kernel upgrade 
to one that knows how to deal with that problem, or in some cases, a 
filesystem change that unpins whatever was bad and lets it be deleted.  
Filesystem changes likely to do that sort of thing are removing your 
oldest snapshots, thereby freeing anything that had changed in newer 
snapshots and the working version, that was still being pinned by the old 
snapshots, or in the absence of snapshot pinning, removal of whatever 
often large possibly repeatedly edited file happened to be locking down 
whatever balance was choking on.

Another point (based on a different factor) can be added in addition:
3) Raid56 mode is still relatively new, and it seems a number of users of 
the raid56 mode feature seem to be reporting what appears to me at least 
(considering my read of tracedumps is extremely limited) to be the same 
sort of balance bug, often with the same couldn't-get-a-trace pattern.  
This very likely indicates a remaining bug embedded deeply enough in the 
raid56 code that it has taken until now to trigger enough times to even 
begin to appear on the radar.  Of course the fact that it so often no-
traces doesn't help finding it, but the reports are getting common enough 
that at least to the informed non-dev list regular like me, there does 
seem to be a pattern emerging.

This is a bit worrying, but it's /exactly/ the reason that I had 
suggested that people wait for at least two entirely "clean" kernel 
cycles without raid56 bugs before considering it as stable as is the rest 
of btrfs, and predicted that would likely be at least five kernel cycles 
(a year) after initial nominal-full-code release, putting it at 4.4 at 
the earliest.  Since the last big raid56 bug was fixed fairly early in 
the 4.1 cycle, two clean series would be 4.2 and 4.3, which would again 
point to 4.4.  But we now have this late-appearing bug just coming up on 
the radar, which if it does indeed end up raid56 related, both validates 
my earlier caution, and at least conservatively speaking, should reset 
that two-clean-kernel-cycles clock.  However, given that the feature in 
general has been maturing in the mean time, I'd say reset it with only 
one clean kernel cycle this time, so again assuming the problem is indeed 
found to be in raid56 and that it's fixed before 4.4 release, I'd want 
4.5 to be raid56 uneventful, and would then consider 4.6 raid56 maturity/
stability-comparable to btrfs in general, assuming no further raid56 bugs 
have appeared by its release.

As to ideas for getting a trace, the best I can do is repeat what I've 
seen others suggest here, that will obviously take a bit more resources 
than some have available but that apparently has the best chance of 
working if it can be done in such instances, that being...

Configure the test machine with a network-attached tty, and set it as 
your system console, so debug traces will dump to it.  The kernel will 
try its best to dump traces to system-console as it considers that safe 
even after it considers itself too scrambled to trust writing anything to 
disk, so this sort of network system console arrangement can often get at 
least /some/ of a debug trace before the kernel entirely loses coherency.

The specifics I don't know as I don't tend to have the network resources 
to log to, here, and thus, have no personal experience with it at all.  
But I might remember seeing a text file in the kernel docs dir that had 
instructions.  But you could look that up as easy as I, so there's no 
point in me double-checking on that.

The other side of it would be enabling the various btrfs and general 
kernel debug and tracing apparatus, but you'd need a dev to give you the 
details there.

>> So I'm guessing you have some 8-strip-stripe chunks at say 20% full or
>> some such.  There's 19.19 data TiB used of 22.85 TiB allocated, a
>> spread of over 3 TiB.  A full nominal-size data stripe allocation,
>> given 12 devices in raid6, will be 10x1GiB data plus 2x1GiB parity, so
>> there's about 3.5 TiB / 10 GiB extra stripes worth of chunks, 350
>> stripes or so,
>> that should be freeable, roughly (the fact that you probably have 8-
>> strip, 12-strip, and 4-strip stripes, on the same filesystem, will of
>> course change that a bit, as will the fact that four devices are much
>> smaller than the other eight).
> 
> The new devices have been in place for while (> 2 months) now, and are
> barely used. Why is there not more data being put onto the new disks?
> Even without a balance new data should spread evenly across all devices
> right? From the IOPs I can see that only the 8 disks which always have
> been in the box are doing any heavy lifting and the new disks are mostly
> idle.

That isn't surprising.  New extent allocations will be made from existing 
data chunks, where they can be (that being, where there's empty space 
within them), and most of those will be across only the original 8 
devices.  Only if that space in existing data chunks is used up will new 
chunk allocations be made.  And as it appeared you had over 3 TiB of 
space within the existing chunks...

Of course balance is supposed to be the tool that helps you fix this, but 
with it bugging out on... something... as discussed above, that's not 
really helping you either.

Personally, what I'd probably do here would be decide if the data was 
worth the trouble or not, given the time it's obviously going to take 
even with good backups to simply copy nearly 20 gig of data from one 
place to another.  Then I'd blow away and recreate, as the only sure way 
to a clean filesystem, and copy back if I did consider it worth the 
trouble.  Of course that's easy for /me/ to say, with my multiple 
separate but rather small (nothing even 3-digit GiB, let alone TiB scale) 
btrfs filesystems, all on ssd, such that a full balance/scrub/check on a 
single filesystem is only minutes at the longest, and often under a 
minute, to completion.  But it /is/ what I'd do.

But then again, as should be clear from the above discussion, I wouldn't 
have trusted non-throw-away data to btrfs raid56 until I considered it 
roughly as stable as the rest of btrfs, which for me would have been at 
least 4.4 and is now beginning to look like at least 4.6, in the first 
place.  Neither at this point would I be at all confident that were you 
to use the same sort of raid56 layout, at its current maturity, that 
you'd not end up with the exact same bug and thus no workable balance, 
tho at least you'd have full-width-stripes as you'd have been using all 
the devices from the get-go, so maybe you'd not /need/ to balance for 
awhile.

> Anything I could do to narrow down where a certain file is stored across
> the devices?

The other possibility (this one both narrowing down where the problem is 
and hopefully helping to eliminate it at the same time) would be, 
assuming no snapshots locking down old data, to start rewriting that 20 
TiB of data say a TiB or two at a time, removing the old copy, thereby 
freeing the extents and tracking metadata it took, and trying the balance 
again, until you find the bit causing all the trouble and rewrite it, 
presumably to a form less troublesome to balance.  If you have a gut 
feeling as to where in your data the problem might be, start with it; 
otherwise, just cover the whole nearly 20 TiB systematically.

If at some point you can now complete a balance, that demonstrates that 
the problem was indeed a defect in the filesystem that a rewrite 
eventually overcame.  If you still can't balance after a full rewrite of 
everything, that demonstrates a more fundamental bug, likely somewhere 
within the guts of the raid56 code itself, such that rewriting everything 
only rewrites the same problem once again.

That one might actually be practical enough to do, and has a good chance 
of working, tho due note that you need to verify that your method of 
rewriting the files isn't simply using reflink (which AFAIK is what a 
current mv with src and dest on the same btrfs, will now do), since 
reflink won't actually rewrite the data, only some metadata.  The easiest 
way to be /sure/ a file is actually rewritten, is to do a cross-
filesystem copy/move, perhaps using tmpfs if your memory is large enough 
for the file(s) in question, in which case you'd /copy/ it off btrfs to 
tmpfs, then /move/ it back, into a different location.  When the round 
trip is completed, sync, and delete the old copy.

(Tmpfs being memory-only, thus as fast as possible but not crash-safe 
should the only copy be in tmpfs at the time, this procedure ensures that 
a valid copy is always on permanent storage.  The first copy leaves the 
old version in place, where it remains until the new version from tmpfs 
is safely moved into the new location, with the sync ensuring it all 
actually hits permanent storage, after which it should be safe to remove 
the old copy since the new one is now safely on disk.)


As for knowing specifically where a file is stored, yes, that's possible, 
using btrfs debug commands.  As the saying goes, however, the details 
"are left as an exercise for the reader", since I've never actually had 
to do it myself.  So check the various btrfs-* manpages and (carefully!) 
experiment a bit. =:^)  Or just check back thru the list archive as I'm 
sure I've seen it posted, but without a bit more to go on than that, the 
manpages method is likely faster. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

