Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34679 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbeDYTbA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 15:31:00 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fBQ5t-0007kp-SY
        for linux-btrfs@vger.kernel.org; Wed, 25 Apr 2018 21:28:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: status page
Date: Wed, 25 Apr 2018 19:28:39 +0000 (UTC)
Message-ID: <pan$17a2d$2d9be827$f0b4abc4$150bc9a1@cox.net>
References: <CAJH6TXhQA-yx1kE2CJLboxMyay+54qb9DxiRZkNrGhsPP8LkXw@mail.gmail.com>
        <20180423151618.GY21272@twin.jikos.cz>
        <CAJH6TXiAUi2yWYKQ6gPbGkxG1aZ=DL+99H53VRM_LQsKF6Cm=g@mail.gmail.com>
        <4ca73e54-85d2-3ba7-48b1-8f9983daac06@gmail.com>
        <CAJH6TXg3+j5g8Wk7jo5YM2dvTjvmp8Ddu2u0_v-u8r6agjRnLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gandalf Corvotempesta posted on Wed, 25 Apr 2018 14:30:42 +0200 as
excerpted:

> For me, RAID56 is mandatory. Any ETA for a stable RAID56 ?
> Is something we should expect this year, next year, next 10 years, ....
> ?

It's complicated... is the best short answer to that.  Here's my take at 
a somewhat longer, admin/user-oriented (as I'm not a dev, just a btrfs 
user and list regular), answer.

AFAIK, current status of raid56/parity-raid is "no known major bugs left 
in the current code, but one major caveat, the common to parity-raid 
unless worked around some other way 'degraded-mode parity-raid write 
hole'", which arguably has somewhat more significance in btrfs than other 
parity-raid implications because the current raid56 implementation 
doesn't checksum the parity itself, thus losing some of the data 
integrity safeguards people normally choose btrfs for in the first 
place.  The implications are particularly disturbing with regard to 
metadata because due to parity-raid's read-modify-write cycle, it's not 
just newly written/changed data/metadata that's put at risk, but 
potentially otherwise old and stable data as well.

Again, this is a known issue with parity-raid in general, that simply has 
additional implications on btrfs.  But because it's a generally well 
known issue, there are generally well accepted mitigations available.  
*If* your storage plans account for that with sufficient safeguards such 
as a good (tested) backup routine that ensures that you are actually 
defining as appropriately valuable your data by the number and frequency 
of backups you have of it...  (Data without a backup is simply being 
defined as of less value than the time/trouble/resources necessary to do 
that backup, because if it were more valuable, there'd *BE* that backup.)

... Then AFAIK at this point the only thing btrfs raid56 mode lacks, 
stability-wise, is the testing of time, since until recently there *were* 
severe known bugs, and altho they've now been fixed, the fixes are recent 
enough that it's quite possible that other bugs still remain to show 
themselves, now that the older bugs have been fixed.

My own suggestion for such time-testing is a year, five kernel cycles, 
after the last known severe bug has been fixed.  If there's no hint of 
further reset-the-clock level bugs in that time, then it's reasonable to 
consider, still with some caution and additional safeguards, deployment 
beyond testing.


Meanwhile, as others have mentioned, there are a number of proposals out 
there for write-hole mitigation.

The theoretically cleanest but also the most intensive, since it requires 
rewriting and retesting much of the existing raid56 mode, would be 
rewriting raid56 mode to COW and checksum parity as well.  If this 
happens, it's almost certainly least five years out to well tested and 
could well be a decade out.

Another possibility is taking a technique from zfs, doing stripes of 
varying size (varying number of strips less than the total number of 
devices) depending on how much data is being written.  Btrfs raid56 mode 
can already deal with this to some extent, and does so when some devices 
are smaller than others and thus run out of space, so stripes written 
after that don't include them.  A similar situation occurs when devices 
are added, until a balance redoes existing stripes to take into account 
the new device.  What btrfs raid56 mode /could/ do is extend this and 
handle small writes much as zfs does, deliberately writing less than full-
width stripes when there's less data, thus avoiding read-modify-write of 
existing data/metadata.  A balance could then be scheduled periodically 
to restripe these "short stripes" to full width.

A variant of the above would simply write full-width, but partially 
empty, stripes.  Both of these should be less work to code than the first/
cleanest solution above since they to a large extent simply repurpose 
existing code, but they're somewhat more complicated and thus potentially 
more bug prone, and they both would require periodic rebalancing of the 
short or partially empty stripes to full width for full efficiency.

Finally, there's the possibility of logging partial-width writes before 
actually writing them.  This would be an extension to existing code, and 
would require writing small writes twice, once to the log and then 
rewriting to the main storage at full stripe width with parity.  As a 
result, it'd slow things down (tho only for less than full-width stripe 
writes, full width would be written as normal as they don't involve the 
risky read-modify-write cycle), but people don't choose parity-raid for 
write speed anyway, /because/ of the read-modify-write penalty it imposes.

This last solution should involve the least change to existing code, and 
thus should be the fastest to implement, with the least chance of 
introducing new bugs so the testing and bugfixing cycle should be shorter 
as well, but ouch, that logged-write penalty on top of the read-modify-
write penalty that short-stripe-writes on parity-raid already incurs, 
will really do a number to performance!  But it /should/ finally fix the 
write hole risk, and it'd be the fastest way to do it on top of existing 
code, with the least risk of additional bugs because it's the least new 
code to write.


What I personally suspect will happen is this last solution in the 
shorter term, tho it'll still take some years to be written and tested to 
stability, with the possibility of someone undertaking a btrfs parity-
raid-g2 project implementing the first/cleanest possibility in the longer 
term, say a decade out (which effectively means "whenever someone with 
the skills and motivation decides to try it, could be 5 years out if they 
start today and devote the time to it, could be 15 years out, or never, 
if nobody ever decides to do it).  I honestly don't see the intermediate 
possibilities as worth the trouble, as they'd take too long for not 
enough payback compared to the solutions at either end, but of course, 
someone might just come along that likes and actually implements that 
angle instead.  As always with FLOSS, the one actually doing the 
implementation is the one who decides (subject to maintainer veto, of 
course, and possible distro and ultimate mainlining of the de facto 
situation override of the maintainer, as well).


A single paragraph summary answer?

Current raid56 status-quo is semi-stable, and subject to testing over 
time, is likely to remain there for some time, with the known parity-raid 
write-hole caveat as the biggest issue.  There's discussion of attempts 
to mitigate the write-hole, but the final form such mitigation will take 
remains to be settled, and the shortest-to-stability alternative, logged 
partial-stripe-writes, has serious performance negatives, but that might 
be acceptable given that parity-raid already has read-modify-write 
performance issues so people don't choose it for write performance in any 
case.  That'd be probably 3 years out to stability at the earliest.  
There's a cleaner alternative but it'd be /much/ farther out as it'd 
involve a pretty heavy rewrite along with the long testing and bugfix 
cycle that implies, so ~10 years out if ever, for that.  And there's a 
couple intermediate alternatives as well, but unless something changes I 
don't really see them going anywhere.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

