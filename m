Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37279 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1031975AbeBNX10 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 18:27:26 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1em6Q8-0001X7-LE
        for linux-btrfs@vger.kernel.org; Thu, 15 Feb 2018 00:25:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Status of FST and mount times
Date: Wed, 14 Feb 2018 23:24:47 +0000 (UTC)
Message-ID: <pan$1e47d$b81e6870$8ea78200$5b24ec4@cox.net>
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ellis H. Wilson III posted on Wed, 14 Feb 2018 11:00:29 -0500 as
excerpted:

> Hi again -- back with a few more questions:
> 
> Frame-of-reference here: RAID0.  Around 70TB raw capacity.  No
> compression.  No quotas enabled.  Many (potentially tens to hundreds) of
> subvolumes, each with tens of snapshots.  No control over size or number
> of files, but directory tree (entries per dir and general tree depth)
> can be controlled in case that's helpful).

??  How can you control both breadth (entries per dir) AND depth of 
directory tree without ultimately limiting your number of files?

Or do you mean you can control breadth XOR depth of tree as needed, 
allowing the other to expand as necessary to accommodate the uncontrolled 
number of files?

Anyway, AFAIK the only performance issue there would be the (IIRC) ~65535 
limit on directory hard links before additional ones are out-of-lined 
into a secondary node, with the entailing performance implications.

> 1. I've been reading up about the space cache, and it appears there is a
> v2 of it called the free space tree that is much friendlier to large
> filesystems such as the one I am designing for.  It is listed as OK/OK
> on the wiki status page, but there is a note that btrfs progs treats it
> as read only (i.e., btrfs check repair cannot help me without a full
> space cache rebuild is my biggest concern) and the last status update on
> this I can find was circa fall 2016.  Can anybody give me an updated
> status on this feature?  From what I read, v1 and tens of TB filesystems
> will not play well together, so I'm inclined to dig into this.

At tens of TB, yes, the free-space-cache (v1) has issues that the free-
space-tree (aka free-space-cache-v2) are designed to solve.  And v2 
should be very well tested in large enterprise installations by now, 
given facebook's usage and intimate involvement with btrfs.

But I have an arguably more basic concern...  Pardon me for reviewing the 
basics as I feel rather like a pupil attempting to lecture a teacher on 
the point and you could very likely teach /me/ about them, but they setup 
the point...

Raid0, particularly at the 10s-of-TB scale, has some implications that 
don't particularly well match your specified concerns above.

Of course "raid0" is a convenient misnomer, as there's nothing 
"redundant" about the "array of independent devices" in a raid0 
configuration, it's simply done for the space and speed features, with 
the sacrificial tradeoff being reliability.  It's only called raid0 as a 
convenience, allowing it to be grouped with the other raid configurations 
where "redundant" /is/ a feature, with the more important grouping 
commonality being they're all multi-device.

Because reliability /is/ the sacrificial tradeoff for raid0, it's 
relatively safe to make the assumption that reliability either isn't 
needed at all because the data literally is "throw-away" value (cache, 
say, where refilling the cache isn't a big cost or time factor), or 
reliability is assured by other mechanisms, backups being the most basic 
but there are others like multi-layered raid, etc, which in practice 
makes at least the particular instance of the data on the raid0 "throw-
away" value, even if the data as a whole is not.

So far, so good.  But then above you mention concern about btrfs-progs 
treating the free-space-tree (free-space-cache-v2) as read-only, and the 
time cost of having to clear and rebuild it after a btrfs check --repair.

Which is what triggered the mismatch warning I mentioned above.  Either 
that raid0 data is of throw-away value appropriate to placement on a 
raid0, and btrfs check --repair is of little concern as the benefits are 
questionable (no guarantees it'll work and the data is either directly 
throw-away value anyway, or there's a backup at hand that /does/ have a 
tested guarantee of viability, or it's not worthy of being called a 
backup in the first place), or it's not.

It's that concern about the viability of btrfs check --repair on what 
you're defining as throw-away data by placing it on raid0 in the first 
place, that's raising all those red warning flags for me!  And the fact 
that you didn't even bother to explain it with a side note to the effect 
that the reliability is addressed some other way, but you still need to 
worry about btrfs check --repair viability because $REASONS, is turning 
those red flags into flashing red lights accompanied by blaring sirens!

OK, so let's assume you /do/ have a tested backup, ready to go.  Then the 
viability of btrfs check --repair is of less concern, but remains 
something you might still be interested in for trivial cases, because 
let's face it, transferring tens of TB of data, even if ready at hand, 
does take time, and if you can avoid it because the btrfs check --repair 
fix is trivial, it's worth doing so.

Valid case, but there's nothing in your post indicating it's valid as 
/your/ case.

Of course the other possibility is live-failover, which is sure to be 
facebook's use-case.  But with live-failover, the viability of btrfs 
check --repair more or less ceases to be of interest, because the failover 
happens (relative to the offline check or restore time) instantly, and 
once the failed devices/machine is taken out of service it's far more 
effective to simply blow away the filesystem (if not replacing the 
device(s) entirely) and restore "at leisure" from backup, a relatively 
guaranteed procedure compared to the "no guarantees" of attempting to 
check --repair the filesystem out of trouble.

Which is very likely why the free-space-tree still isn't well supported 
by btrfs-progs, including btrfs check, several kernel (and thus -progs) 
development cycles later.  The people who really need the one (whichever 
one of the two)... don't tend to (or at least /shouldn't/) make use of 
the other so much.

It's also worth mentioning that btrfs raid0 mode, as well as single mode, 
hobbles the btrfs data and metadata integrity feature, because while 
checksums can and are still generated, stored and checked by default, and 
integrity problems can still be detected, because raid0 (and single) 
includes no redundancy, there's no second copy (raid1/10) or parity 
redundancy (raid5/6) to rebuild the bad data from, so it's simply gone.  
(Well, for data you can try btrfs restore of the otherwise inaccessible 
file and hope for the best, and for metadata, you can try check --repair 
and again hope for the best, but...)  If you're using that feature of 
btrfs and want/need more than just detection of a problem that can't be 
fixed due to lack of redundancy, there's a good chance you want a real 
redundancy raid mode on multi-device, or dup mode on single device.

So bottom line... given the sacrificial lack of redundancy and 
reliability of raid0, btrfs or not, in an enterprise setting with tens of 
TB of data, why are you worrying about the viability of btrfs check --
repair on what the placement on raid0 decrees to be throw-away data 
anyway?  At first glance anyway, one or the other, either the raid0 mode 
and thus declared throw-away value of tens of TB of data, or the 
viability of btrfs check --repair, indicating you don't consider the data 
you just declared to be of throw-away value by placing it on raid0, to be 
of throw-away value after all, must be wrong.  Which one is wrong is your 
call, and there's certainly individual cases (one of which I even named) 
where concern about the viability of btrfs check --repair on raid0 might 
be valid, but your post has no real indication that your case is such a 
case, and honestly, that worries me!

> 2. There's another thread on-going about mount delays.  I've been
> completely blind to this specific problem until it caught my eye.  Does
> anyone have ballpark estimates for how long very large HDD-based
> filesystems will take to mount?  Yes, I know it will depend on the
> dataset.  I'm looking for O() worst-case approximations for
> enterprise-grade large drives (12/14TB), as I expect it should scale
> with multiple drives so approximating for a single drive should be good
> enough.

No input on that question here (my own use-case couldn't be more 
different, multiple small sub-half-TB independent btrfs raid1s on 
partitioned ssds), but another concern, based on real-world reports I've 
seen on-list:

12-14 TB individual drives?

While you /did/ say enterprise grade so this probably doesn't apply to 
you, it might apply to others that will read this.

Be careful that you're not trying to use the "archive application" 
targeted SMR drives for general purpose use.  Occasionally people will 
try to buy and use such drives in general purpose use due to their 
cheaper per-TB cost, and it just doesn't go well.  We've had a number of 
reports of that. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

