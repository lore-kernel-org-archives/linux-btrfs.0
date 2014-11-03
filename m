Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40151 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaKCIAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 03:00:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlCZE-0007An-0H
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 09:00:48 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 09:00:47 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 09:00:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 fails to recover chunk tree
Date: Mon, 3 Nov 2014 08:00:36 +0000 (UTC)
Message-ID: <pan$87e7c$a6682da9$37ea679d$69f7389f@cox.net>
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com>
	<54517338.7090606@pobox.com> <54523D86.5040906@gmail.com>
	<58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com>
	<pan$2cd78$85acd913$95d42126$8a9a4137@cox.net>
	<FC480E52-012E-41E7-902E-2EE3ECFFB90B@colorremedies.com>
	<5455B25E.2070703@pobox.com> <20141102134855.33677567@natsu>
	<545610BE.1080508@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Sun, 02 Nov 2014 03:08:46 -0800 as excerpted:

> Confusing bit, for example, from wiki
> 
> [QUOTE]
> If you are getting out of space errors due to metadata being full, try
> 
> btrfs balance start -v -dusage=0 /mnt/btrfs [/QUOTE]
> 
> Combined with "Balances only block groups with usage under the given
> percentage. "
> 
> Which I was reading -dusage=0 means don't bother with data chunks and
> (and so just fix the metadata), otherwise the mention of using a -d
> filter to affect metadata is perverse.
> 
> Blarg... I mean just... blarg...
> 
> But now I know. 8-)

If metadata is full and there's no unallocated space left from which to 
create new metadata chunks, then balancing metadata wouldn't do any good 
anyway.

Which is why you balance data chunks in that case.

The typical scenario is this.  Someone creates a btrfs and starts using 
it, creating files, deleting files, but over time, tending to create more 
files than they delete, so the space starts to fill up.

As they do so, btrfs allocates new data and metadata chunks on demand 
from the unallocated space.  Btrfs allocation and usage happens in two 
steps, unallocated space gets allocated to chunkspace, either data or 
metadata, and then that allocated chunkspace gets actually used for file 
data or metadata, depending on the chunk type.  Data chunks are 1 GiB 
each by default, while metadata chunks default to a quarter GiB each.

The critical bit to understand here is that while btrfs can automatically 
allocate both chunks and actual usage on demand, when it frees space, it 
can only automatically free actual usage, not the allocated chunks.  And 
it can't switch chunks from one type to the other.  To free the chunks 
back to unallocated so they can again be allocated on-demand to data or 
metadata as necessary, one must run a balance, which rewrites the chunks, 
consolidating as it goes, thereby freeing the excess allocated chunks if 
actual usage fits into less chunks than were previously allocated.

Picking up our typical scenario...  Then they delete a bunch of files, 
often the bigger ones, but the data tends to be much bigger than the 
metadata, so deleting these files frees up a lot of data chunk space but 
only a relatively little metadata chunk space.

Then they go writing files again, but on average smaller ones.  These 
smaller files take up less data space but the same amount of metadata 
space, so without a manual balance to reclaim allocated but mostly empty 
chunks, the limited metadata space freed by that big deletion gets filled 
up faster than the data space, and suddenly, people are getting ENOSPC 
errors when df says there's LOTS of space, because all that space is 
taken up by mostly empty data chunks, leaving no room to write new 
metadata chunks.

The scenario is similar to that of ext* running out of inodes (a type of 
metadata, after all) since it preallocates them at mkfs time, except that 
over time, the default number of inodes at a particular ext* filesystem 
size has been bumped up so that this seldom happens in practice any 
more.  But btrfs stores quite a bit more metadata per file, including 
checksums, and for small files, perhaps the entire file including the 
data, in which case it won't actually have a data extent, so oversizing 
btrfs metadata by a similar amount would mean wasting MUCH more space for 
the typical user.  And btrfs can automatically allocate data and metadata 
chunks on demand -- the catch is that it can't automatically unallocate 
chunks on demand[1], a balance is required for that, nor can it switch 
usage types on chunks once allocated.

In that scenario, it's metadata that's out, but to fix it you have to 
balance data, returning unused but allocated data chunks back to the 
unallocated space pool, so they can be allocated as metadata.

Which is why/how the -d (data) filter affects -m (metadata) -- by freeing 
mostly (or with the suggested -dusage=0, entirely[2]) empty data chunks 
back to unallocated so they can be reallocated as metadata chunks.

So call it perverse if you want to, but it's an entirely logical 
perversion![3] =:^)

Meanwhile, it's also possible, altho less common, to run into the 
opposite situation, out of data space, with metadata space left.  That's 
actually rather interesting, as you can create files and sometimes even 
write just a small bit of content into them, since small files are 
entirely stored within the metadata leaf and don't require a data 
allocation.  But as soon as you try to write anything of any significant 
size (a few KiB) to the new file, it'll ENOSPC when it tries to allocate 
a data extent and can't.

---
[1] Yet.  There's patches circulating that once thru discussion and 
merged, should let btrfs automatically handle at least the normal cases 
of data/metadata chunk imbalance.

[2] If there's actual data in a chunk, a balance must have at least 
enough space left in ordered to create at least one more chunk, so as to 
be able to do the rewrite.  But with a bit of luck, there's at least one 
chunk that's entirely empty, in which case usage=0 will free it without 
actually requiring space to create a new chunk to rewrite into, since 
there's nothing to rewrite.  That's why the usage=0.  If you're unlucky 
and there's no entirely empty chunks available for the balance to simply 
delete, then the usage=0 won't help.  That's where the suggestion to 
temporarily add another device of at least a few gigs comes in, the idea 
being to give balance enough room to rewrite a few chunks on the new 
device, thereby freeing the space they would have used on the original 
device(s).  Assuming an over-allocation, the balance should correct the 
problem, leaving enough space on the original device(s) so there's room 
to transfer the chunks back to the original device(s) using btrfs device 
delete <tmp-device>, and hopefully still leave some unallocated space 
left after that.

[3] Sort of like the (in)famous MS Windows perversion of having to hit 
the start button to stop...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

