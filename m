Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51761 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbbGKPYv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 11:24:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZDwe1-0007Is-3I
	for linux-btrfs@vger.kernel.org; Sat, 11 Jul 2015 17:24:49 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 17:24:49 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 17:24:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Did btrfs filesystem defrag just make things worse?
Date: Sat, 11 Jul 2015 15:24:44 +0000 (UTC)
Message-ID: <pan$a54a$19bc33f8$104eb18a$cf97db25@cox.net>
References: <CAC=t97A0eR34GyMLC_XhdWMVAf1YaCgX=qrXGkip991znH5N9A@mail.gmail.com>
	<pan$e3829$abc1de8c$4dc42856$7192e92@cox.net>
	<CAC=t97Cr6W5qU_LuEqXXNqUUizfFKAeA_febaiwfArZvX9UsKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Sat, 11 Jul 2015 07:18:00 -0500 as excerpted:

> The nocow attribute was set on the folder prior to any data being
> written.  So based on your understanding the files are truly nocow and
> must therefore be not compressed (an inherited attribute from the
> subvolume).
> 
> I think it's safe to say the file wasn't skipped if the number of
> extents changed?

True, but individual extents within the file may have been.  Obviously 
the whole file wasn't skipped, tho.  And if the file is 60 gig, even the 
higher number of extents filefrag is reporting isn't what it should be if 
it's compressed and filefrag is mistaking compression blocks for 
extents.  So it's unlikely to be compressed.

> So if it isn't really compressed, and it wasn't skipped, is there any
> reason to still think filefrag is confused about the results?
> 
> Total used space is about 1T and free space is approximately 9t.
> Training-flat.vmdk is 60g

Replying either in-line/in-context, or under the quote, makes further
replies in context far easier...

If the file isn't compressed, then filefrag is likely correct.  However, 
if you're not either running with autodefrag set at mount, or regularly 
defragging the entire filesystem, it's quite possible that defrag can't 
find unfragmented space -- see the (possible) explanation below.

I'm not a coder, only a list regular and btrfs user, and I'm not sure on 
this, but there have been several reports of this nature on the list 
recently, and I have a theory.  Maybe the devs can step in and either 
confirm or shoot it down.

The theory is this.  

Background: Btrfs allocates space in two stages, first allocating big 
chunks (nominally 1 GiB for data, 256 MiB for metadata, of course it's 
data chunks we're talking here) from unallocated space, then placing 
files in those chunks until they are full and more chunks need allocated.

These 1 GiB data chunks, BTW, mean that the best-case for a 60 GiB file 
is likely to be 60 or 61 extents with each one taking a full chunk, 
possibly with the first and/or the last not being a full chunk.

Of course during normal use, files get deleted as well, thereby clearing 
space in existing chunks.  But this space will be fragmented, with a mix 
of unallocated extents and still remaining files.  The allocator will I 
/believe/ (this is where people who can actually read the code come in) 
try to use up space in existing chunks before allocating additional 
space, possibly subject to some reasonable extent minimum size, below 
which btrfs will simply allocate another chunk.

Obviously, if you always mount with autodefrag, both the file and space 
fragmentation should be kept reasonably low, as files will be rewritten 
if autodefrag detects too much fragmentation as they are written.  
(Actually, autodefrag doesn't rewrite directly, it schedules the file for 
rewrite by a separate cleanup task that follows behind.)  But with normal 
filesystem activity, file deletion, partial copy-on-write file-rewrite, 
space fragmentation, and therefore file fragmentation, is still going to 
happen to some extent over time, it'll simply take longer.

Extremely regular overall filesystem scheduled defrag should similarly 
help with the problem, tho I don't think it likely to be quite as good as 
autodefrag, as the time between fragmentation and rewrite will be longer, 
thus allowing more time for space fragmentation as well.

Then we have defrag itself.  In theory, it can prioritize one of two 
things:

1) Prioritize reduced fragmentation, at the expense of higher data chunk 
allocation.  In the extreme, this would mean always choosing to allocate 
a new chunk and use it if the file (or remainder of the file not yet 
defragged) was larger than the largest free extent in existing data 
chunks.

The problem with this is that over time, the number of partially used 
data chunks goes up as new ones are allocated to defrag into, but sub-1 
GiB files that are already defragged are left where they are.  Of course 
a balance can help here, by combining multiple partial chunks into fewer 
full chunks, but unless a balance is run...

2) Prioritize chunk utilization, at the expense of leaving some 
fragmentation, despite massive amounts of unallocated space.

This is what I've begun to suspect defrag does.  With a bunch of free but 
fragmented space in existing chunks, defrag could actually increase 
fragmentation, as the space in existing chunks is so fragmented a rewrite 
is forced to use more, smaller extents, because that's all there is free, 
until another chunk is allocated.

As I mentioned above for normal file allocation, it's quite possible that 
there's some minimum extent size (greater than the bare minimum 4 KiB  
block size) where the allocator will give up and allocate a new data 
chunk, but if so, perhaps this size needs bumped upward, as it seems a 
bit low, today.


Meanwhile, there's a number of exacerbating factors to consider as well.

* Snapshots and other shared references lock extents in place.

Defrag doesn't touch anything but the subvolume it's actually pointed at 
for the defrag.  Other subvolumes and shared-reference files will 
continue to keep the extents they reference locked in place.  And COW 
will rewrite blocks of a file, but the old reference extent remains 
locked, until all references to it are cleared -- the entire file (or at 
least all blocks that were in that extent) must be rewritten, and no 
snapshots or other references to it remain, before it can be freed.

For a few kernel cycles btrfs had snapshot-aware-defrag, but that 
implementation didn't scale well at all, so it was disabled until it 
could be rewritten, and that rewrite hasn't occurred yet.  So snapshot-
aware-defrag remains disabled, and defrag only works on the subvolume 
it's actually pointed at.

As a result, if defrag rewrites a snapshotted file, it actually doubles 
the space that file takes, as it makes a new copy, breaking the reference 
link between it and the copy in the snapshot.

Of course, with the space not freed up, this will, over time, tend to 
fragment space that is freed even more heavily.

* Chunk reclamation.  

This is the relatively new development that I think is triggering the 
surge in defrag not defragging reports we're seeing now.

Until quite recently, btrfs could allocate new chunks, but it couldn't, 
on its own, deallocate empty chunks.  What tended to happen over time was 
that people would find all the filesystem space taken up by empty or 
mostly empty data chunks, and btrfs would start spitting ENOSPC errors 
when it needed to allocate new metadata chunks but couldn't, as all the 
space was in empty data chunks.  A balance could fix it, often relatively 
quickly with a -dusage=0 or -dusage-10 filter or the like, but it was a 
manual process, btrfs wouldn't do it on its own.

Recently the devs (mostly) fixed that, and btrfs will automatically 
reclaim entirely empty chunks on its own now.  It still doesn't reclaim 
partially empty chunks automatically; a manual rebalance must still be 
used to combine multiple partially empty chunks into fewer full chunks; 
but it does well enough to make the previous problem pretty rare -- we 
don't see the hundreds of GiB of empty data chunks allocated any more, 
like we used to.

Which fixed the one problem, but if my theory is correct, it exacerbated 
the defrag issue, which I think was there before but seldom triggered so 
it generally wasn't noticed.

What I believe is happening now compared to before, based on the rash of 
reports we're seeing, is that before, space fragmentation in allocated 
data chunks seldom became an issue, because people tended to accumulate 
all these extra empty data chunks, leaving defrag all that unfragmented 
empty space to rewrite the new extents into as it did the defrag.

But now, all those empty data chunks are reclaimed, leaving defrag only 
the heavily space-fragmented partially used chunks.  So now we're getting 
all these reports of defrag actually making the problem worse, not better!


Again, I'm not a dev and thus can't simply look at the code to see.  But 
to my sysadmin's troubleshooting eye the theory fits the observed 
behavior.

If this theory is correct, now that btrf does chunk reclaim, defrag needs 
to be rewritten to more heavily prioritize actual defrag, at the expense 
of allocating additional data chunks when necessary.

Tho it's likely going to always-allocate extreme isn't ideal either, and 
that either adding or adjusting upward a minimum extent size, which if it 
can't satisfy in existing chunks, will allocate a new chunk to write the 
defragged extent into (provided there's unallocated space from which to 
allocate it, of course).

Devs?  Impossible hogwash based on the code, or actually plausible?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

