Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44335 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdENHfH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 03:35:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9o3O-0001VE-GY
        for linux-btrfs@vger.kernel.org; Sun, 14 May 2017 09:34:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
Date: Sun, 14 May 2017 07:34:51 +0000 (UTC)
Message-ID: <pan$b480c$db428619$fae3ce3b$92362eeb@cox.net>
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 13 May 2017 13:54:31 -0700 as excerpted:

> Kernel 4.11, btrfs-progs v4.7.3
> 
> I run scrub and balance every night, been doing this for 1.5 years on
> this filesystem.
> But it has just started failing:

> saruman:~# btrfs balance start -musage=0  /mnt/btrfs_pool1
> Done, had to relocate 0 out of 235 chunks

> saruman:~# btrfs balance start -dusage=0 
> /mnt/btrfs_pool1 Done, had to relocate 0 out of 235 chunks

Those aren't failing (as you likely know, but to explain for others 
following along), there's nothing to do as there's no entirely empty 
chunks.

But...

> saruman:~# btrfs balance start -musage=1  /mnt/btrfs_pool1
> ERROR: error during balancing '/mnt/btrfs_pool1':
> No space left on device

> aruman:~# btrfs balance start -dusage=10  /mnt/btrfs_pool1
> Done, had to relocate 0 out of 235 chunks

> saruman:~# btrfs balance start -dusage=20  /mnt/btrfs_pool1
> ERROR: error during balancing '/mnt/btrfs_pool1':
> No space left on device

... Errors there.  ENOSPC

[from dmesg]
> BTRFS info (device dm-2): 1 enospc errors during balance
> BTRFS info (device dm-2): relocating block group 598566305792 flags data
> BTRFS info (device dm-2): 1 enospc errors during balance
> BTRFS info (device dm-2): 1 enospc errors during balance
> BTRFS info (device dm-2): relocating block group 598566305792 flags data
> BTRFS info (device dm-2): 1 enospc errors during balance

> saruman:~# btrfs fi show /mnt/btrfs_pool1/
> Label: 'btrfs_pool1'  uuid: bc115001-a8d1-445c-9ec9-6050620efd0a
> 	Total devices 1 FS bytes used 169.73GiB
>       devid    1 size 228.67GiB used 228.67GiB path /dev/mapper/pool1

> saruman:~# btrfs fi usage /mnt/btrfs_pool1/
> Overall:
>     Device size:		 228.67GiB
>     Device allocated:		 228.67GiB
>     Device unallocated:	   1.00MiB
>     Device missing:		     0.00B
>     Used:			 171.25GiB
>     Free (estimated):		  55.32GiB	(min: 55.32GiB)
>     Data ratio:		      1.00
>     Metadata ratio:		      1.00
>     Global reserve:     	 512.00MiB	(used: 0.00B)
> 
> Data,single: Size:221.60GiB, Used:166.28GiB
>    /dev/mapper/pool1	 221.60GiB
> 
> Metadata,single: Size:7.03GiB, Used:4.96GiB
>    /dev/mapper/pool1	   7.03GiB
> 
> System,single: Size:32.00MiB, Used:48.00KiB
>    /dev/mapper/pool1	  32.00MiB
> 
> Unallocated:
>    /dev/mapper/pool1	   1.00MiB

So we see it's fully chunk-allocated, no unallocated space, but gigs and 
gigs of empty space withing the chunk allocations, data chunks in 
particular.

> How did I get into such a misbalanced state when I balance every night?
> 
> My filesystem is not full, I can write just fine, but I sure cannot
> rebalance now.

Well, you can write just fine... for now.

After accounting for the global reserve coming out of metadata's reported 
free, there's about 1.5 GiB space in the metadata, and about 55 GiB of 
space in the data, so you should actually be able to write for some time 
before running out of either.

You just can't rebalance to chunk-defrag and reclaim chunks to 
unallocated, so they can be used for the other chunk type if necessary.
You're correct to be worried about this, but it's not immediately urgent.

> Besides adding another device to add space, is there a way around this
> and more generally not getting into that state anymore considering that
> I already rebalance every night?

What you /haven't/ yet said is what your nightly rebalance command, 
presumably scheduled, with -dusage and -musage, actually is.  How did you 
determine the usage amount to feed to the command, and was it dynamic, 
presumably determined by some script and changing based on the amount of 
unutilized space trapped within the data chunks, or static, the same 
usage command given every nite?

The other thing we don't have, and you might not have any idea either if 
it was simply scheduled and you hadn't been specifically checking, is a 
trendline of whether the post-balance unallocated space has been reducing 
over time, while the post-balance unutilized space within the data chunks 
was growing, or whether it happened all of a sudden.


If you've been following current discussion threads here, you may already 
know one possible specific trigger, as discussed, and more generically, 
there could be other specific triggers in the same general category.

In that thread the specific culprit appeared to be btrfs behavior with 
the (autodetected based on device rotational value as reported by sysfs) 
ssd mount option, in particular as it interacted with systemd's journal 
files, but it would apply to anything else with a similar write pattern.

The overall btrfs usage pattern was problematic as much like you 
apparently were getting but didn't catch before full allocation while he 
did, btrfs was continuing to allocate new chunks, even tho there was 
plenty of space left within existing chunks, none of which were entirely 
empty (so they didn't get auto-reclaimed to unallocated), but few of 
which were anything like entirely filled, either.

If you go look at that thread (which I'd specify only I'd have to go look 
for it too, and the OP on that thread is list-active so will likely reply 
on this thread as well), there's some very nice chunk-usage 
visualizations linked of what btrfs was doing.

Well he's the coder I'm not, so he could actually dive into btrfs code, 
and combined with experiments, eventually traced it down to the behavior 
of the (auto-enabled based on rotational, tho it didn't really apply in 
his case) ssd mount option.

It turns out that at a low level, what the ssd mount option actually does 
is force data-block allocations to be 2 MiB at a time.  The idea is to 
match the very often 2-4 MiB ssd erase-block size, so writes ideally 
correspond to erase blocks and if that range in the file is rewritten or 
the file deleted, it'll be a 1:1 erase and (possible) rewrite, at least 
for the data.

While that works well for normal files generally written in reasonably 
large (full-file or MiB at a time) chunks and often not rewritten, it 
turns out systemd's journal files are near worst-case, at least if 
subject to regular snapshotting.

The journal pattern is (IIRC from the thread) to fallocate the file, 
typically several MB, write an index at the front, and then write journal 
entries as they come in from the /back/ /forward/, naturally rewriting 
the index each time as well.

Of course as btrfs users and systemd devs discovered early on, this write 
pattern is worst-case for COW filesystems such as btrfs.  The early 
result was that systemd quickly set the journal directory +C/NOCOW by 
default, ideally making it rewrite-in-place like they were used to on 
other filesystems and (they thought) eliminating the problem.

Except... as we list-regulars at least know by now, nocow doesn't mean 
nocow when a file is both repeatedly rewritten and snapshotted, because 
snapshots lock in the current content so the first write thereafter MUST 
be COW, a phenomenon often referred to as cow1.  While the effect isn't 
so bad with an occasional snapshot and/or rewrite, once the snapshots and 
rewrites are coming fast and regularly enough, the effect is very close 
to standard COW, despite the nominal NOCOW.

The effect of regular snapshots on systemd's journal files, generally 
rewritten a single journal record at a time, except that the records are 
written from the end of the file forward, with the index at the beginning 
also rewritten...

Combined with the effect of the (auto-enabled) ssd mount option forcing 
each of those writes to (what would be) a separate 2-MiB erase-block...

Is **SERIOUSLY** fragmented journal files!!

Now consider what COW in context of regular snapshotting does to those 
seriously fragmented due to regular rewrite files.  The original full-
block allocations can't be released until **NO** references to them 
continue to exist in old snapshots.  So the whole original 8 MiB or 16 
MiB or whatever then near empty journal-file allocation continues to 
remain, until all parts of it have been rewritten.  But because the 
journal records are filled in from the back forward, the last 4-KB block 
won't be rewritten until the file is nearly full and about to be rotated 
out of active use.  By then, it'll have all those single-record entries 
added a record or two at a time, so will be effectively fully fragmented!

And all those snapshots will be locking all those fragments of the file 
in its various snapshotted states in place, including the original intact 
near-empty first write of the whole fallocated file, until all those 
snapshots are deleted!

And with the ssd mount option, all those locked-in-place single journal 
record fragments are going to be 2 MiB each!


Of course many database and VM image file formats have similar rewrite-
triggered problems on COW, exacerbated by snapshotting triggering cow1, 
even if the file is nominally NOCOW.


The observed behavior was that new chunks would be allocated and filled, 
2 MiB at a time.  Eventually snapshot deletion would start clearing 
things out, but with continued write activity of the journal and other 
stuff as well, the chunk would remain partially full, but eventually with 
no continuous spaces left large enough to write 2 MiB at a time into, so 
another chunk would be allocated.

This repeated time after time, with each newly allocated chunk eventually 
eaten into Swiss cheese, as chunk allocations continued to grow, even tho 
actual data usage remained near steady-state.

With code study and eventually the confirmation of experimentation, he 
eventually traced the problem, on the btrfs side at least, down to the 
ssd mount option.  Turning that off allowed the allocator to fill in all 
those previously empty single-4K-block holes in the Swiss cheese, and the 
problem disappeared.  (His rebalance scripts were sophisticated enough to 
use btrfs debugging to pick the worst fragmented chunks and rebalance 
them specifically, just a couple chunks on each call, so as soon as the 2 
MiB write problem disappeared, his scripts gradually filled in the 
existing Swiss cheese, eliminating chunks as they did so.)

Note that this was actually on an enterprise-level storage aggregation 
device, a whole bunch of spinning rust underneath, but not exposing 
physical blocks or rotation information to the kernel and thus to btrfs.  
So all btrfs saw was non-rotational, and it (wrongly in this case) auto-
enabled the ssd mount option based on that.  It wasn't a deliberately 
added mount option, tho it wasn't, at that time, deliberately disabled, 
either.

He fixed that by specifically adding nossd to his mount options.

The other btrfs angled piece of the solution was to put the journal files 
in their own dedicated subvolume, so they didn't get snapshotted with the 
parent.  He decided he didn't need journal snapshots anyway, at least not 
at the cost of the trouble they were causing.


I'm guessing that you have something similar going on.  It may be the ssd 
mount option and journald files.  It might be rewrite-pattern VM images 
instead of or in addition to the journald files.  It might be database 
files.  It might be something else similar.  But they're probably being 
snapshotted, and that's killing the nocow if you have it enabled.


Meanwhile, here, I /am/ on ssds and have the option enabled, but I'm not 
seeing anything similar, despite my running systemd as well.  That's for 
several reasons:

1) No snapshotting at all, here.  I run smallish partitions and btrfs' of 
under 100 GiB each, and simply copy the entire filesystem tree 
(directories and files) to a freshly mkfs-ed backup copy (with multiple 
such backup copies), as my backup method.

2) No systemd journal files on btrfs, here.  journald.conf has 
Storage=volatile set, so it only keeps the tmpfs files (which I've 
reconfigured size-wise to retain a full session).  Meanwhile, I run a 
conventional syslog-ng with systemd passing on journald entries to it 
too, and syslog manages the actually stored logs... in conventional 
greppable text-based append-only files that are much *MUCH* easier for 
btrfs to reasonably handle. =:^)

3) I run the autodefrag mount option.  This rewrites fragmented ranges as 
necessary, so I expect even if I was doing journald files on btrfs, and 
snapshotting them, along with the ssd I do have, I'd not have the same 
sort of issue.

4) The compress=lzo mount option I also run may affect this sort of thing 
too, due to its 128-KiB compression-block size, but I'm not sure what the 
exact effect would be, and with journald writing the index up front in 
the first block that btrfs quick-tests for compressibility, and the fact 
that I don't use compress-force, it may be that btrfs wouldn't compress 
the journal files anyway, thus no effect.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

