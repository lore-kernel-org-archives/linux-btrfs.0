Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49303 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753871AbcK1C4q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 21:56:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cBC7T-0006X3-ME
        for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2016 03:56:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount option nodatacow for VMs on SSD?
Date: Mon, 28 Nov 2016 02:56:32 +0000 (UTC)
Message-ID: <pan$1eaab$d4d4facd$e2735d04$2fc4a8e@cox.net>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
        <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
        <20161128003829.GD15348@rus.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ulli Horlacher posted on Mon, 28 Nov 2016 01:38:29 +0100 as excerpted:

> Ok, then next question :-)
> 
> What is better (for a single user workstation): using mount option
> "autodefrag" or call "btrfs filesystem defragment -r" (-t ?) via nightly
> cronjob?
> 
> So far, I use neither.

First point: Be aware that there's a caveat with either method and 
snapshots, tho it's far stronger with manual defrag than with autodefrag: 

At one point manual defrag was made snapshot aware, taking care not to 
deduplicate snapshots and reflinks pointing at the same extents, but the 
performance penalty of all the extra tracking and calculations turned out 
to be far too high to be practical with btrfs code in its then-current 
form (if a defrag run is going to take months, people simply aren't going 
to run it no matter the claimed benefit), so snapshot/reflink awareness 
was disabled and it remains so today.  AFAIK the plan is still to reenable 
it, or perhaps make it optional, at some point, but I believe that point 
remains some distance (years) in the future.

Which means for practical purposes, defragging of either type effectively 
undoes any reflink-based deduplication that may have been done, including 
that of snapshots -- defrag in the presence of snapshots can double your 
data space usage.

The reason the effect isn't as bad for autodefrag is that while manual 
defrag can effectively unreflink the extents for entire files regardless 
of write status, autodefrag only happens in the context of normal file 
writes or rewrites/modification, and for rewrites/modification, which 
would COW the modified/rewritten blocks elsewhere in any case, it simply 
rewrites/relocates rather larger extents, several MiB at a time instead 
of 4 KiB at a time, than would be the case without autodefrag.  So 
several GiB files that have been snapshotted/reflinked and then modified 
would have the modified blocks rewritten elsewhere anyway, and autodefrag 
simply ensures that a large enough new extent (MiB not KiB) is created 
and rewritten when a single block within it is modified anyway, to avoid 
the worst fragmentation.  It does NOT rewrite and unreflink the entire 
multi-gig file every time a single block gets modified and written back 
to the filesystem, as manual defrag can do and in practice often does if 
there have been modifications since the last snapshot or reflink copy/
dedup of the same file.  (Thanks to Hugo for making the point, then 
checking the actual code and then explaining how autodefrag differs from 
manual defrag on this point.)


So manual recursive defrag of the entire filesystem (as opposed to 
specific files) is definitely not recommended in btrfs snapshot context, 
unless you know you have enough space for the snapshot-reflink dedup that 
the defrag is likely to trigger.

But autodefrag should be far more space-conserving in the btrfs 
snapshotting context, as it'll be far more conservative in what it 
unreflinks size-wise, and will only unreflink at all when a COW-based 
modification/rewrite is happening in the first place.  Files that remain 
unchanged will remain safely reflinked to the same extents as those the 
snapshots hold reflinks to.


OTOH, if you're starting out with a highly fragmented existing 
filesystem, autodefrag can take some time to work its effects, because it 
*is* far more conservative in what it rewrites and thus defrags.  
Autodefrag really works best if you handle it as I do here, creating the 
new filesystem and setting up the mount options to always mount it with 
autodefrag, before there's any content at all on the filesystem.  That 
way, all files are originally written with autodefrag on, and the 
filesystem never has a chance to get seriously fragmented in the first 
place.  =:^)

It should still be worth turning on autodefrag on an existing somewhat 
fragmented filesystem.  It just might take some time to defrag files you 
do modify, and won't touch those you don't, which in some cases might 
make it worth defragging those manually.  Or simply create new 
filesystems, mount them with autodefrag, and copy everything over so 
you're starting fresh, as I do.

(It should be mentioned that in the context of a single write thread on a 
clean filesystem with lots of free space, a newly written file should 
always be written in ideal sequential unfragmented form.  However, get 
multiple write threads copying different files at the same time, and even 
on a new filesystem, the individual files can be fragmented as the 
various writes intermingle.  We've had reports on this list of even brand 
new distro installations being highly fragmented, and this would appear 
to be why -- apparently the installer was writing multiple files at once 
as well as possibly modifying some of them after the initial write, 
thereby fragmenting them rather heavily.  If the installer either mounts 
with autodefrag before starting to write its files, or if the user either 
manually creates the filesystem and ensures an autodefrag mount, or 
pauses the installation to remount with autodefrag before the file-copy 
begins, the fragmentation isn't nearly as bad, altho as I explained 
above, autodefrag is somewhat conservative and there will be /some/ 
fragmentation, as compared to doing the install to a temporary filesystem 
and then copying the files over to a permanent one such that they copy 
sequentially, one at a time.)

(Additionally, it's worth noting that btrfs data chunks are nominally 1 
GiB in size tho in some large enough layouts they can reach upto 10 GiB, 
so unlike say ext4, which can have arbitrarily long extents, on btrfs, 
files over a GiB are likely to be listed by filefrag as having several 
extents even at "ideal", as the extents will be be broken into data chunk 
sizes.)

(Finally, in case you decide to enable btrfs compression, it's worth 
noting that filefrag doesn't understand btrfs compression, which breaks 
files into 128 KiB compression blocks, which filefrag in turn lists as 
individual extents even if they're sequential.  Of course you can have a 
good clue this is occurring by dividing the file size by 128 KiB and 
comparing the result to the filefrag-reported number of extents for that 
file.  Or simply manually check the verbose filefrag output and see if 
the extents it lists are sequential, one beginning immediately after the 
previous one ended.)

Bottom line, I'd recommend autodefrag, with the two caveats of being 
aware that (a) it /will/ trigger moderate unreflinking and thus moderate 
data duplication if you're doing snapshotting or dedupeing (but far less 
than manual defrag would), and that (b) autodefrag really works best if 
you use it from the time the filesystem is first created, tho I'd still 
recommend it on existing filesystems, you just won't get quite the same 
effect.


Really, if I had my way autodefrag would be the default mount option, and 
you'd use noautodefrag to turn it off if you had some reason you didn't 
want it.  Because certainly in the generic case anyway, I simply don't 
see why one /wouldn't/ want it, and that would nicely eliminate the whole 
"I started using it on an existing and already fragmented filesystem" 
problem.  =:^)

(Tho I understand why it's not that way, when the option was introduced 
there were some worries about performance in some circumstances, and the 
option was experimental back then, so it made /sense/ not to have it the 
default.  But that was then and this is now, and IMO it should be the 
default, now.  Maybe it will be at some point?  But one of the btrfs devs 
has to care enough about that as the default to code it up and argue the 
case for the change first, and I'm not a dev, just a list regular and 
btrfs user myself, so...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

