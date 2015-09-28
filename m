Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33945 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbbI1ASU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 20:18:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZgM94-0003he-11
	for linux-btrfs@vger.kernel.org; Mon, 28 Sep 2015 02:18:18 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 02:18:18 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 02:18:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi defrag interfering (maybe) with Ceph OSD operation
Date: Mon, 28 Sep 2015 00:18:12 +0000 (UTC)
Message-ID: <pan$be4b9$74318552$9c70286d$e18abb29@cox.net>
References: <56080C9A.6030102@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lionel Bouton posted on Sun, 27 Sep 2015 17:34:50 +0200 as excerpted:

> Hi,
> 
> we use BTRFS for Ceph filestores (after much tuning and testing over
> more than a year). One of the problem we've had to face was the slow
> decrease in performance caused by fragmentation.

While I'm a regular user/admin (not dev) on the btrfs lists, my ceph 
knowledge is essentially zero, so this is intended to address the btrfs 
side ONLY.

> Here's a small recap of the history for context.
> Initially we used internal journals on the few OSDs where we tested
> BTRFS, which meant constantly overwriting 10GB files (which is obviously
> bad for CoW). Before using NoCoW and eventually moving the journals to
> raw SSD partitions, we understood autodefrag was not being effective :
> the initial performance on a fresh, recently populated OSD was great and
> slowly degraded over time without access patterns and filesystem sizes
> changing significantly.

Yes.  Autodefrag works most effectively on (relatively) small files, 
generally for performance reasons, as it detects fragmentation and queues 
up a a defragmenting rewrite by a separate defragmentation worker 
thread.  As file sizes increase, that defragmenting rewrite will take 
longer, until at some point, particularly on actively rewritten files, 
change-writes will be coming in faster than file rewrite speeds...

Generally speaking, therefore, it's great for small database files upto a 
quarter gig or so, think firefox sqlite database files on the desktop, 
with people starting to see issues somewhere between a quarter gig and a 
gig on spinning rust, depending on disk speed as well as active rewrite 
load on the file in question.

So constantly rewritten 10-gig journal files... Entirely inappropriate 
for autodefrag. =:^(

There has been discussion and a general plan for some sort of larger-file 
autodefrag optimization, but btrfs continues to be rather "idea and 
opportunity rich" and "implementation coder poor", so realistically we're 
looking at years to implementation.

Meanwhile, other measures should be taken for multigig files, as you're 
already doing. =:^)

> I couldn't find any description of the algorithms/heuristics used by
> autodefrag [...]

This is in general documented on the wiki, tho not with the level of 
explanation I included above.

https://btrfs.wiki.kernel.org


> I decided to disable it and develop our own
> defragmentation scheduler. It is based on both a slow walk through the
> filesystem (which acts as a safety net over one week period) and a
> fatrace pipe (used to detect recent fragmentation). Fragmentation is
> computed from filefrag detailed outputs and it learns how much it can
> defragment files with calls to filefrag after defragmentation (we
> learned compressed files and uncompressed files don't behave the same
> way in the process so we ended up treating them separately).

Note that unless this has very recently changed, filefrag doesn't know 
how to calculate btrfs-compressed file fragmentation correctly.  Btrfs 
uses (IIRC) 128 KiB compression blocks, which filefrag will see (I'm not 
actually sure if it's 100% consistent or if it's conditional on something 
else) as separate extents.

Bottom line, there's no easily accessible reliable way to get the 
fragmentation level of a btrfs-compressed file. =:^(  (Presumably
btrfs-debug-tree with the -e option to print extents info, with the 
output fed to some parsing script, could do it, but that's not what I'd 
call easily accessible, at least at a non-programmer admin level.)

Again, there has been some discussion around teaching filefrag about 
btrfs compression, and it may well eventually happen, but I'm not aware 
of an e2fsprogs release doing it yet, nor of whether there's even actual 
patches for it yet, let alone merge status.

> Simply excluding the journal from defragmentation and using some basic
> heuristics (don't defragment recently written files but keep them in a
> pool then queue them and don't defragment files below a given
> fragmentation "cost" were defragmentation becomes ineffective) gave us
> usable performance in the long run. Then we successively moved the
> journal to NoCoW files and SSDs and disabled Ceph's use of BTRFS
> snapshots which were too costly (removing snapshots generated 120MB of
> writes to the disks and this was done every 30s on our configuration).

It can be noted that there's an negative interaction between btrfs 
snapshots and nocow, sometimes called cow1.  The btrfs snapshot feature 
is predicated on cow, with a snapshot locking in place existing file 
extents, normally no big deal as ordinary cow files will have rewrites 
cowed elsewhere in any case.  Obviously, then, snapshots must by 
definition play havoc with nocow.  What actually happens is that with 
existing extents locked in place, the first post-snapshot change to a 
block must then be cowed into a new extent.  The nocow attribute remains 
on the file, however, and further writes to that block... until the next 
snapshot anyway... will be written in-place, to the (first-post-snapshot-
cowed) current extent.  When one list poster referred to that as cow1, I 
found the term so nicely descriptive that I adopted it for myself, altho 
for obvious reasons I have to explain it first in many posts.

It should now be obvious why 30-second snapshots weren't working well on 
your nocow files, and why they seemed to become fragmented anyway, the 30-
second snapshots were effectively disabling nocow!

In general, for nocow files, snapshotting should be disabled (as you 
ultimately did), or as low frequency as is practically possible.  Some 
list posters have, however, reported a good experience with a combination 
of lower frequency snapshotting (say daily, or maybe every six hours, but 
DEFINITELY not more frequent than half-hour), and periodic defrag, on the 
order of the weekly period you implied in a bit I snipped, to perhaps 
monthly.

> In the end we had a very successful experience, migrated everything to
> BTRFS filestores that were noticeably faster than XFS (according to Ceph
> metrics), detected silent corruption and compressed data. Everything
> worked well [...]

=:^)

> [...] until this morning.

=:^(


> I woke up to a text message signalling VM freezes all over our platform.
> 2 Ceph OSDs died at the same time on two of our servers (20s appart)
> which for durability reason freezes writes on the data chunks shared by
> these two OSDs.
> The errors we got in the OSD logs seem to point to an IO error (at least
> IIRC we got a similar crash on an OSD where we had invalid csum errors
> logged by the kernel) but we couldn't find any kernel error and btrfs
> scrubs finished on the filesystems without finding any corruption.

Snipping some of the ceph stuff since as I said I've essentially zero 
knowledge there, but...

> Given that the defragmentation scheduler treats file accesses the same
> on all replicas to decide when triggering a call to "btrfs fi defrag
> <file>", I suspect this manual call to defragment could have happened on
> the 2 OSDs affected for the same file at nearly the same time and caused
> the near simultaneous crashes.

...  While what I /do/ know of ceph suggests that it should be protected 
against this sort of thing, perhaps there's a bug, because...

I know for sure that btrfs itself is not intended for distributed access, 
from more than one system/kernel at a time.  Which assuming my ceph 
illiteracy isn't negatively affecting my reading of the above, seems to 
be more or less what you're suggesting happened, and I do know that *if* 
it *did* happen, it could indeed trigger all sorts of havoc!

> It's not clear to me that "btrfs fi defrag <file>" can't interfere with
> another process trying to use the file. I assume basic reading and
> writing is OK but there might be restrictions on unlinking/locking/using
> other ioctls... Are there any I should be aware of and should look for
> in Ceph OSDs? This is on a 3.8.19 kernel (with Gentoo patches which
> don't touch BTRFS sources) with btrfs-progs 4.0.1. We have 5 servers on
> our storage network : 2 are running a 4.0.5 kernel and 3 are running
> 3.8.19. The 3.8.19 servers are waiting for an opportunity to reboot on
> 4.0.5 (or better if we have the time to test a more recent kernel before
> rebooting : 4.1.8 and 4.2.1 are our candidates for testing right now).

It's worth keeping in mind that the explicit warnings about btrfs being 
experimental weren't removed until 3.12, and while current status is no 
longer experimental or entirely unstable, it remains, as I characterize 
it, as "maturing and stabilizing, not yet entirely stable and mature."

So 3.8 is very much still in btrfs-experimental land!  And so many bugs 
have been fixed since then that... well, just get off of it ASAP, which 
it seems you're already doing.

While it's no longer absolutely necessary to stay current to the latest 
non-long-term-support kernel (unless you're running say raid56 mode, 
which is still new enough not to be as stable as the rest of btrfs and 
where running the latest kernel continues to be critical, and while I'm 
discussing exceptions, btrfs quota code continues to be a problem even 
with the newest kernels, so I recommend it remain off unless you're 
specifically working with the devs to debug and test it), list consensus 
seems to be that where stability is a prime consideration, sticking to 
long-term-support kernel series, no later than one LTS series behind the 
latest and upgrading to the latest LTS series some reasonable time after 
the LTS announcement, after deployment-specific testing as appropriate of 
course, is recommended best-practice.

With kernel 4.1 series now blessed as the latest long-term-stable, and 
3.18 the latest before that, the above suggests targeting them, and 
indeed, list reports for the 3.18 series as it has matured have been very 
good, with 4.1 still new enough that the stability-cautious are still 
testing or just deployed, so there's not many reports on it yet.

Meanwhile, while latest (or second-latest until latest is site-tested) LTS 
kernel is recommended for stable deployment, when encountering specific 
bugs, be prepared to upgrade to latest stable at least for testing, 
possibly with cherry-picked not-yet-mainlined patches if appropriate for 
individual bugs.

But definitely, anything pre-3.12, get off of, as that really is when the 
experimental label came off, and you don't want to be running kernel 
btrfs of that age in production.  Again, 3.18 is well tested and rated so 
targeting it for ASAP deployment is good, with 4.1 targeted for testing 
and deployment "soon" also recommended.

And once again, that's purely from the btrfs side.  I know absolutely 
nothing about ceph stability in any of these kernels, tho obviously for 
you that's going to be a consideration as well.


Tying up a couple loose ends...

Regarding nocow...

Given that you had apparently missed much of the general list and wiki 
wisdom above (while at the same time eventually coming to the many of the 
same conclusions on your own), it's worth mentioning the following 
additional nocow caveat and recommended procedure, in case you missed it 
as well:

On btrfs, setting nocow on an existing file with existing content, leaves 
undefined when exactly the nocow attribute will take effect.  (FWIW, this 
is mentioned in the chattr (1) manpage as well.)  Recommended procedure 
is therefore to set the nocow attribute on the directory, such that newly 
created files (and subdirs) will inherit it.  (There's no effect on the 
directory itself, just this inheritance.)  Then, for existing files, copy 
them into the new location, preferably from a different filesystem in 
ordered to guarantee that the file is actually newly created and thus 
gets nocow applied appropriately.

(cp behavior currently copies the file in unless the reflink option is 
set anyway, but there has been discussion of changing that to reflink by 
default for speed and space usage reasons, and that would play havoc with 
nocow on file creation, but btrfs doesn't support cross-filesystem 
reflinks so copying in from a different filesystem should always force 
creation of a new file, with nocow inherited from its directory as 
intended.)

What about btrfs-progs versions?

In general, in normal online operation the btrfs command simply tells the 
kernel what to do and the kernel takes care of the details, so it's the 
kernel code that's critical.  However, various recovery operations, btrfs 
check, btrfs restore, btrfs rescue, etc (I'm not actually sure about 
mkfs.btrfs, whether that's primarily userspace code or calls into the 
kernel, tho I suspect the former), operate on an unmounted btrfs using 
primarily userspace code, and it's here where the latest userspace code, 
updated to deal with the latest known problems, becomes critical.

So in general, it's kernel code age and stability that's critical for a 
deployed and operation filesystem, but userspace code that's critical if 
you run into problems.  For that reason, unless you have backups and 
intend to simply blow away filesystems with problems and recreate them 
fresh, restoring from backups, a reasonably current btrfs userspace is 
critical as well, even if it's not critical in normal operation.

And of course you need current userspace as well as kernelspace to best 
support the newest features, but that's a given. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

