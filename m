Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:35837 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbbI1JzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 05:55:17 -0400
Subject: Re: btrfs fi defrag interfering (maybe) with Ceph OSD operation
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <56080C9A.6030102@bouton.name>
 <pan$be4b9$74318552$9c70286d$e18abb29@cox.net>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56090E83.4030708@bouton.name>
Date: Mon, 28 Sep 2015 11:55:15 +0200
MIME-Version: 1.0
In-Reply-To: <pan$be4b9$74318552$9c70286d$e18abb29@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

thanks for your answer, here is additional information.

Le 28/09/2015 02:18, Duncan a écrit :
> [...]
>> I decided to disable it and develop our own
>> defragmentation scheduler. It is based on both a slow walk through the
>> filesystem (which acts as a safety net over one week period) and a
>> fatrace pipe (used to detect recent fragmentation). Fragmentation is
>> computed from filefrag detailed outputs and it learns how much it can
>> defragment files with calls to filefrag after defragmentation (we
>> learned compressed files and uncompressed files don't behave the same
>> way in the process so we ended up treating them separately).
> Note that unless this has very recently changed, filefrag doesn't know 
> how to calculate btrfs-compressed file fragmentation correctly.  Btrfs 
> uses (IIRC) 128 KiB compression blocks, which filefrag will see (I'm not 
> actually sure if it's 100% consistent or if it's conditional on something 
> else) as separate extents.
>
> Bottom line, there's no easily accessible reliable way to get the 
> fragmentation level of a btrfs-compressed file. =:^(  (Presumably
> btrfs-debug-tree with the -e option to print extents info, with the 
> output fed to some parsing script, could do it, but that's not what I'd 
> call easily accessible, at least at a non-programmer admin level.)
>
> Again, there has been some discussion around teaching filefrag about 
> btrfs compression, and it may well eventually happen, but I'm not aware 
> of an e2fsprogs release doing it yet, nor of whether there's even actual 
> patches for it yet, let alone merge status.

>From what I understood, filefrag doesn't known the length of each extent
on disk but should have its position. This is enough to have a rough
estimation of how badly fragmented the file is : it doesn't change the
result much when computing what a rotating disk must do (especially how
many head movements) to access the whole file.

>
>> Simply excluding the journal from defragmentation and using some basic
>> heuristics (don't defragment recently written files but keep them in a
>> pool then queue them and don't defragment files below a given
>> fragmentation "cost" were defragmentation becomes ineffective) gave us
>> usable performance in the long run. Then we successively moved the
>> journal to NoCoW files and SSDs and disabled Ceph's use of BTRFS
>> snapshots which were too costly (removing snapshots generated 120MB of
>> writes to the disks and this was done every 30s on our configuration).
> It can be noted that there's an negative interaction between btrfs 
> snapshots and nocow, sometimes called cow1.  The btrfs snapshot feature 
> is predicated on cow, with a snapshot locking in place existing file 
> extents, normally no big deal as ordinary cow files will have rewrites 
> cowed elsewhere in any case.  Obviously, then, snapshots must by 
> definition play havoc with nocow.  What actually happens is that with 
> existing extents locked in place, the first post-snapshot change to a 
> block must then be cowed into a new extent.  The nocow attribute remains 
> on the file, however, and further writes to that block... until the next 
> snapshot anyway... will be written in-place, to the (first-post-snapshot-
> cowed) current extent.  When one list poster referred to that as cow1, I 
> found the term so nicely descriptive that I adopted it for myself, altho 
> for obvious reasons I have to explain it first in many posts.
>
> It should now be obvious why 30-second snapshots weren't working well on 
> your nocow files, and why they seemed to become fragmented anyway, the 30-
> second snapshots were effectively disabling nocow!
>
> In general, for nocow files, snapshotting should be disabled (as you 
> ultimately did), or as low frequency as is practically possible.  Some 
> list posters have, however, reported a good experience with a combination 
> of lower frequency snapshotting (say daily, or maybe every six hours, but 
> DEFINITELY not more frequent than half-hour), and periodic defrag, on the 
> order of the weekly period you implied in a bit I snipped, to perhaps 
> monthly.

In the case of Ceph OSD, this isn't what causes the performance problem:
the journal is on the main subvolume and snapshots are done on another
subvolume.

> [...]
>> Given that the defragmentation scheduler treats file accesses the same
>> on all replicas to decide when triggering a call to "btrfs fi defrag
>> <file>", I suspect this manual call to defragment could have happened on
>> the 2 OSDs affected for the same file at nearly the same time and caused
>> the near simultaneous crashes.
> ...  While what I /do/ know of ceph suggests that it should be protected 
> against this sort of thing, perhaps there's a bug, because...
>
> I know for sure that btrfs itself is not intended for distributed access, 
> from more than one system/kernel at a time.  Which assuming my ceph 
> illiteracy isn't negatively affecting my reading of the above, seems to 
> be more or less what you're suggesting happened, and I do know that *if* 
> it *did* happen, it could indeed trigger all sorts of havoc!

No: Ceph OSDs are normal local processes using a filesystem for storage
(and optionally a dedicated journal out of the filesystem) as are the
btrfs fi defrag commands run on the same host. What I'm interested in is
how the btrfs fi defrag <file> command could interfere with any other
process accessing <file> simultaneously. The answer could very well be
"it never will" (for example because it doesn't use any operation that
can before calling the defrag ioctl which is guaranteed to not interfere
with other file operations too). I just need to know if there's a
possibility so I can decide if these defragmentations are an operational
risk or not in my context and if I found the cause for my slightly
frightening morning.

>> It's not clear to me that "btrfs fi defrag <file>" can't interfere with
>> another process trying to use the file. I assume basic reading and
>> writing is OK but there might be restrictions on unlinking/locking/using
>> other ioctls... Are there any I should be aware of and should look for
>> in Ceph OSDs? This is on a 3.8.19 kernel (with Gentoo patches which
>> don't touch BTRFS sources) with btrfs-progs 4.0.1. We have 5 servers on
>> our storage network : 2 are running a 4.0.5 kernel and 3 are running
>> 3.8.19. The 3.8.19 servers are waiting for an opportunity to reboot on
>> 4.0.5 (or better if we have the time to test a more recent kernel before
>> rebooting : 4.1.8 and 4.2.1 are our candidates for testing right now).
> It's worth keeping in mind that the explicit warnings about btrfs being 
> experimental weren't removed until 3.12, and while current status is no 
> longer experimental or entirely unstable, it remains, as I characterize 
> it, as "maturing and stabilizing, not yet entirely stable and mature."
>
> So 3.8 is very much still in btrfs-experimental land!  And so many bugs 
> have been fixed since then that... well, just get off of it ASAP, which 
> it seems you're already doing.

Oops, that was a typo : I meant 3.18.9, sorry :-(

> [...]
>
>
> Tying up a couple loose ends...
>
> Regarding nocow...
>
> Given that you had apparently missed much of the general list and wiki 
> wisdom above (while at the same time eventually coming to the many of the 
> same conclusions on your own),

In fact I was initially aware of (no)CoW/defragmentation/snapshots
performance gotchas (I already used BTRFS for PostgreSQL slaves hosting
for example...).
But Ceph is filesystem aware: its OSDs detect if they are running on
XFS/BTRFS and activate automatically some filesystem features. So even
though I was aware of the problems that can happen on a CoW filesystem,
I preferred to do actual testing with the default Ceph settings and
filesystem mount options before tuning.

Best regards,

Lionel Bouton
