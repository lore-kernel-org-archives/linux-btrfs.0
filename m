Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41536 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbbKWGaI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 01:30:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a0kdW-00028p-PW
	for linux-btrfs@vger.kernel.org; Mon, 23 Nov 2015 07:30:02 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 07:30:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 07:30:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Mon, 23 Nov 2015 06:29:57 +0000 (UTC)
Message-ID: <pan$eea04$e9596e27$78b44461$c5754723@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Fossen posted on Sun, 22 Nov 2015 19:43:28 -0600 as excerpted:

> Hi all,
> 
> I have a btrfs setup of 4x2TB HDDs for /home in btrfs RAID0 on Ubuntu
> 15.10 (kernel 4.2) and btrfs-progs 4.3.1. Root is on a separate SSD also
> running btrfs.
> 
> About 6 people use it via ssh and run simulations. One of these
> simulations generates a lot of intermediate data that can be discarded
> after it is run, it usually ends up being around 100GB to 300GB spread
> across dozens of files 500M to 5GB apiece.
> 
> The problem is that, when it comes time to do a "rm -rf
> ~/working_directory" the entire machine locks up and sporadically allows
> other IO requests to go through, with a 5 to 10 minute delay before
> other requests seem to be served. It can end up taking half an hour or
> more to fully remove the offending directory, with the hangs happening
> frequently enough to be frustrating. This didn't seem to happen when the
> system was using ext4 on LVM.
> 
> Is there a way to fix this performance issue or at least mitigate it?
> Would using ionice and the CFQ scheduler help? As far as I know Ubuntu
> uses deadline by default which ignores ionice values.
> 
> Alternatively, would balancing and defragging data more often help? The
> current mount options are compress=lzo and space_cache, and I will try
> it with autodefrag enabled as well to see if that helps.
> 
> For now I think I'll recommend that everyone use subvolumes for these
> runs and then enable user_subvol_rm_allowed.

Using subvolumes was the first recommendation I was going to make, too, 
so you're on the right track. =:^)

Also, in case you are using it (you didn't say, but this has been 
demonstrated to solve similar issues for others so it's worth 
mentioning), try turning btrfs quota functionality off.  While the devs 
are working very hard on that feature for btrfs, the fact is that it's 
simply still buggy and doesn't work reliably anyway, in addition to 
triggering scaling issues before they'd otherwise occur.  So my 
recommendation has been, and remains, unless you're working directly with 
the devs to fix quota issues (in which case, thanks!), if you actually 
NEED quota functionality, use a filesystem where it works reliably, while 
if you don't, just turn it off and avoid the scaling and other issues 
that currently still come with it.


As for defrag, that's quite a topic of its own, with complications 
related to snapshots and the nocow file attribute.  Very briefly, if you 
haven't been running it regularly or using the autodefrag mount option by 
default, chances are your available free space is rather fragmented as 
well, and while defrag may help, it may not reduce fragmentation to the 
degree you'd like.  (I'd suggest using filefrag to check fragmentation, 
but it doesn't know how to deal with btrfs compression, and will report 
heavy fragmentation for compressed files even if they're fine.  Since you 
use compression, that kind of eliminates using filefrag to actually see 
what your fragmentation is.)

Additionally, defrag isn't snapshot aware (they tried it for a few 
kernels a couple years ago but it simply didn't scale), so if you're 
using snapshots (as I believe Ubuntu does by default on btrfs, at least 
taking snapshots for upgrade-in-place), so using defrag on files that 
exist in the snapshots as well can dramatically increase space usage, 
since defrag will break the reflinks to the snapshotted extents and 
create new extents for defragged files.

Meanwhile, the absolute worst-case fragmentation on btrfs occurs with  
random-internal-rewrite-pattern files (as opposed to never changed, or 
append-only).  Common examples are database files and VM images.  For 
/relatively/ small files, to say 256 MiB, the autodefrag mount option is 
a reasonably effective solution, but it tends to have scaling issues with 
files over half a GiB so you can call this a negative recommendation for 
trying that option with half-gig-plus internal-random-rewrite-pattern 
files.  There are other mitigation strategies that can be used, but here 
the subject gets complex so I'll not detail them.  Suffice it to say that 
if the filesystem in question is used with large VM images or database 
files and you haven't taken specific fragmentation avoidance measures, 
that's very likely a good part of your problem right there, and you can 
call this a hint that further research is called for.

If your half-gig-plus files are mostly write-once, for example most media 
files unless you're doing heavy media editing, however, then autodefrag 
could be a good option in general, as it deals well with such files and 
with random-internal-rewrite-pattern files under a quarter gig or so.  Be 
aware, however, that if it's enabled on an already heavily fragmented 
filesystem (as yours likely is), it's likely to actually make performance 
worse until it gets things under control.  Your best bet in that case, if 
you have spare devices available to do so, is probably to create a fresh 
btrfs and consistently use autodefrag as you populate it from the 
existing heavily fragmented btrfs.  That way, it'll never have a chance 
for the fragmentation to build up in the first place, and autodefrag used 
as a routine mount option should keep it from getting bad in normal use.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

