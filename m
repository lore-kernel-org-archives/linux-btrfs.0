Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45360 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaABIis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 03:38:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vydni-0006pm-FT
	for linux-btrfs@vger.kernel.org; Thu, 02 Jan 2014 09:38:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 09:38:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 09:38:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Thu, 2 Jan 2014 08:38:22 +0000 (UTC)
Message-ID: <pan$d8c7$6644fca2$fe85bee2$cc84b5d0@cox.net>
References: <52C2AE7C.5020601@gmx.at>
	<pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
	<loom.20140101T204832-543@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sulla posted on Wed, 01 Jan 2014 20:08:21 +0000 as excerpted:

> Dear Duncan!
> 
> Thanks very much for your exhaustive answer.
> 
> Hm, I also thought of fragmentation. Alhtough I don't think this is
> really very likely, as my server doesn't serve things that likely cause
> fragmentation.
> It is a mailserver (but only maildir-format), fileserver for windows
> clients (huge files that hardly don't get rewritten), a server for
> TV-records (but only copy recordings from a sat receiver after they have
> been recorded, so no heavy rewriting here), a tiny webserver and all
> kinds of such things, but not a storage for huge databases, virtual
> machines or a target for filesharing clients.
> It however serves as a target for a hardlink-based backupprogram run on
> windows PCs, but only once per month or so, so that shouldn't bee too
> much.

One thing I didn't mention originally, was how to check for fragmentation.
filefrag is part of e2fsprogs, and does the trick -- with one caveat.  
filefrag currently doesn't know about btrfs compression, and interprets 
each 128 KiB block as a separate extent.  So if you have btrfs 
compression turned on and check a (larger than 128 KiB) file that btrfs 
has compressed, filefrag will falsely report fragmentation.

If in doubt, you can always try defragging that individual file and see 
if filefrag reports fewer extents or not.  If it has fewer extents you 
know it was fragmented, if not...

With that you should actually be able to check some of those big files 
that you don't think are fragmented, to see.

> The problem must lie somewhere on the root partition itslef, because the
> system is already slow before mounting the fat data-partitions.
> 
> I'll give the defragmentation a try. But
> # sudo btrfs filesystem defrag -r
> doesn't work, because "-r" is an unknown option (I'm running Btrfs
> v0.20-rc1 on an Ubuntu 3.11.0-14-generic kernel).

The -r option was added quite recently.

As the wiki (at https://btrfs.wiki.kernel.org ) urges, btrfs is a 
development filesystem and people choosing to test it should really try 
to keep current, both because you're unnecessarily putting the data 
you're testing on btrfs at risk when running old versions with bugs 
patched in newer versions (that part's mostly for the kernel, tho), and 
because as a tester, when things /do/ go wrong and you report it, the 
reports are far more useful if you're running a current version.

Kernal 3.11.0 is old.  3.12 has been out for well over a month now.  And 
the btrfs-progs userspace recently switched to kernel-synced versioning 
as well, with version 3.12 the latest version, which also happens to be 
the first kernel-version-synced version.

That's assuming you don't choose to run the latest git version of the 
userspace, and the Linus kernel RCs, which many btrfs testers do.  (Tho 
last I updated btrfs-progs, about a week ago, the last git commit was 
still the version bump to 3.12, but I'm running a git kernel at version 
3.13.0-rc5 plus 69 commits.)

So you are encouraged to update. =:^)

However, if you don't choose to upgrade ... (see next)

> I'm doing a # sudo btrfs filesystem defrag / &
> on the root directory at the moment.

...  Before the -r option was added, btrfs filesystem defrag would only 
defrag the specific file it was pointed at.  If pointed at a directory, 
it would defrag the directory metadata, but not files or subdirs below it.

The way to defrag the entire system then, involved a rather more 
complicated command using find to output a list of everything on the 
system, and run defrag individually on each item listed.  It's on the 
wiki.  Let's see if I can find it... (yes, but note the wrapped link):

https://btrfs.wiki.kernel.org/index.php/
UseCases#How_do_I_defragment_many_files.3F

sudo find [subvol [subvol]…] -xdev -type f -exec btrfs filesystem 
defragment -- {} +

As the wiki warns, that doesn't recurse into subvolumes (the -xdev keeps 
it from going onto non-btrfs filesystems but also keeps it from going 
into subvolumes), but you can list them as paths where noted.

> Question: will this defragment everything or just the root-fs and will I
> need to run a defragment on /home as well, as /home is a separate btrfs
> filesystem?

Well, as noted your command doesn't really defragment that much.  But the 
find command should defragment everything on the named subvolumes.

But of course this is where that bit I mentioned in the original post 
about possibly taking hours with multiple terabytes on spinning rust 
comes in too.  It could take awhile, and when it gets to really 
fragmented files, it'll probably trigger the same sort of stalls that has 
us discussing the whole thing in the first place, so the system may not 
be exactly usable. =:^(

> I've also added autodefrag mountoptions and will do a "mount -a" after
> the defragmentation.
> 
> I've considered a # sudo btrfs balance start as well, would this do any
> good? How close should I let the data fill the partition? The large data
> partitions are 85% used, root is 70% used. Is this safe or should I add
> space?

!! Be careful!!  You mentioned running 3.11.  Both early versions of 3.11 
and 3.12 had a bug where if you tried to run a balance and a defrag at 
the same time, bad things could happen (lockups or even corrupted data)!

Running just one at a time and letting it finish, then the other, should 
be fine.  And later stable kernels of both 3.11 and 3.12 have that bug 
fixed (as does 3.13).  But 3.11.0 is almost certainly still bugged in 
that regard, unless ubuntu backported the fix and didn't bump the kernel 
version.

But because a full balance rewrites everything anyway, it'll effectively 
defrag too.  So if you're going to do a balance, you can skip the 
defrag.  =:^) And since it's likely to take hours at the terabyte scale 
on spinning rust, that's just as well.


As for the space question, that's a whole different subject with its own 
convolutions.  =:^\

Very briefly, the rule of thumb I use is that for partitions of 
sufficient size (several GiB low end), you always want btrfs filesystem 
show to have at LEAST enough unallocated space left to allocate one each 
data and metadata chunk.  Data chunks default to 1 GiB, while metadata 
chunks default to 256 MiB, but because single-device metadata defaults to 
DUP mode, metadata chunks are normally allocated in pairs and that 
doubles to half a GiB.

So you need at LEAST 1.5 GiB unallocated, in ordered to be sure balance 
can work, since it allocates a new chunk and writes into it from the old 
chunks, until it can free up the old chunks.

Assuming you have large enough filesystems, I'd try to keep twice that, 3 
GiB unallocated according to btrfs filesystem show, and would definitely 
recommend doing a rebalance any time it starts getting close to that.

If you tend to have many multi-gig files, you'll probably want to keep 
enough unallocated space (rounded up to a whole gig, plus the 3 gig 
minimum I suggested above) around to handle at least one of those as 
well, just so you know you always have space available to move at least 
one of those if necessary, without using up your 3 gig safety margin.

Beyond that, take a look at your btrfs filesystem df output.  I already 
mentioned that data chunk size is 1 GiB, metadata 256 MiB (doubled to 512 
MiB for default dup mode for a single device btrfs).  So if data says 
something like total=248.00GiB, used=123.24GiB (example picked out of 
thin air), you know you're running a whole bunch of half empty chunks, 
and a balance should trim that down dramatically, to probably 
total=124.00GiB altho it's possible it might be 125.00GiB or something, 
but in any case it should be FAR closer to used than the twice-used 
figure in my example above.  Any time total is more than a GiB above 
used, a balance is likely to be able to reduce it and return the extra to 
the unallocated pool.

Of course the same applies to metadata, keeping in mind its default-dup, 
so you're effectively allocating in 512 MiB chunks for it.  But any time 
total is more than 512 MiB above used, a balance will probably reduce it, 
returning the extra space to the unallocated pool.

Of course single vs. dup on single devices, and multiple devices with all 
the different btrfs raid modes, throw various curves into the numbers 
given above.  While it's reasonably straightforward to figure an 
individual case, explaining all the permutations gets quite complex.  And 
while it's not supported yet, eventually btrfs is supposed to support 
different raid levels, etc, for different subvolumes, which will throw 
even MORE complexity into the thing!   And obviously for small single-
digit GiB partitions the rules must be adjusted, even more so for mixed-
blockgroup, which is the default below 1 GiB but makes some sense in the 
single-digit GiB size range as well.  But the reasonably large single-
device default isn't /too/ bad, even if it takes a bit to explain, as I 
did here.

Meanwhile, especially on spinning rust at terabyte sizes, those balances 
are going to take awhile, so you probably don't want to run them daily.

And on SSDs, balances (and defrags and anything else for that matter) 
should go MUCH faster, but SSDs are limited-write-cycle, and any time you 
balance you're rewriting all that data and metadata, thus using up 
limited write cycles on all those gigs worth of blocks in one fell swoop!

So either way, doing balances without any clear return probably isn't a 
good idea.  But when the allocated space gets within a few gigs of total 
as shown by btrfs filesystem show, or when total gets multiple gigs above 
used as shown by btrfs filesystem df, it's time to consider a balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

