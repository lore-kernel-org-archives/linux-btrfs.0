Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45857 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdLCBqE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Dec 2017 20:46:04 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eLJLs-0007b7-4g
        for linux-btrfs@vger.kernel.org; Sun, 03 Dec 2017 02:45:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: exclusive subvolume space missing
Date: Sun, 3 Dec 2017 01:45:45 +0000 (UTC)
Message-ID: <pan$4b81d$3ba1cf57$e9dd4e05$8cf6db12@cox.net>
References: <20171201161555.GA11892@polanet.pl>
        <20171201213614.GE29898@carfax.org.uk> <20171202005338.GA20205@polanet.pl>
        <20171202162812.GA5324@polanet.pl> <20171202171819.GA4629@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Sat, 02 Dec 2017 18:18:19 +0100 as excerpted:

> On Sat, Dec 02, 2017 at 17:28:12 +0100, Tomasz Pala wrote:
> 
>>> Suppose you start with a 100 MiB file (I'm adjusting the sizes down from
>> [...]
>>> Now make various small changes to the file, say under 16 KiB each.  These
>>> will each be COWed elsewhere as one might expect. by default 16 KiB at
>>> a time I believe (might be 4 KiB, as it was back when the default leaf
>> 
>> I got ~500 small files (100-500 kB) updated partially in regular
>> intervals:
>> 
>> # du -Lc **/*.rrd | tail -n1
>> 105M    total

FWIW, I've no idea what rrd files, or rrdcached (from the grandparent post)
are (other than that a quick google suggests that it's...
round-robin-database... and the database bit alone sounds bad in this context
as database-file rewrites are known to be a worst-case for cow-based
filesystems), but it sounds like you suspect that they have this
rewrite-most pattern that could explain your problem...

>>> But here's the kicker.  Even without a snapshot locking that original 100
>>> MiB extent in place, if even one of the original 16 KiB blocks isn't
>>> rewritten, that entire 100 MiB extent will remain locked in place, as the
>>> original 16 KiB blocks that have been changed and thus COWed elsewhere
>>> aren't freed one at a time, the full 100 MiB extent only gets freed, all
>>> at once, once no references to it remain, which means once that last
>>> block of the extent gets rewritten.
> 
> OTOH - should this happen with nodatacow files? As I mentioned before,
> these files are chattred +C (however this was not their initial state
> due to https://bugzilla.kernel.org/show_bug.cgi?id=189671 ).
> Am I wrong thinking, that in such case they should occupy twice their
> size maximum? Or maybe there is some tool that could show me the real
> space wasted by file, including extents count etc?

Nodatacow... isn't as simple as the name might suggest.

For one thing, snapshots depend on COW and lock the extents they reference
in-place, so while a file might be set nocow and that setting is retained,
the first write to a block after a snapshot *MUST* cow that block... because
the snapshot has the existing version referenced and it can't change without
changing the snapshot as well, and that would of course defeat the purpose
of snapshots.

Tho the attribute is retained and further writes to the same already cowed
block won't cow it again.

FWIW, on this list that behavior is often referred to as cow1, cow only the
first time that a block is written after a snapshot locks the previous
version in place.

The effect of cow1 depends on the frequency and extent of block rewrites vs.
the frequency of snapshots of the subvolume they're on.  As should be
obvious if you think about it, once you've done the cow1, further rewrites
to the same block before further snapshots won't cow further, so if only
a few blocks are repeatedly rewritten multiple times between snapshots, the
effect should be relatively small.  Similarly if snapshots happen far more
frequently than block rewrites, since in that case most of the snapshots
won't have anything changed (for that file anyway) since the last one.

However, if most of the file gets rewritten between snapshots and the
snapshot frequency is often enough to be a major factor, the effect can be
practically as bad as if the file weren't nocow in the first place.

If I knew a bit more about rrd's rewrite pattern... and your snapshot
pattern...


Second, as you alluded, for btrfs files must be set nocow before anything
is written to them.  Quoting the chattr (1) manpage:  "If it is set on a
file which already has data blocks, it is undefined when the blocks
assigned to the file will be fully stable."

Not being a dev I don't read the code to know what that means in practice,
but it could well be effectively cow1, which would yield the maximum 2X
size you assumed.

But I think it's best to take "undefined" at its meaning, and assume
worst-case "no effect at all", for size calculation purposes, unless you
really /did/ set it at file creation, before the file had content.

And the easiest way to do /that/, and something that might be worthwhile
doing anyway if you think unreclaimed still referenced extents are your
problem, is to set the nocow flag on the /directory/, then copy the
files into it, taking care to actually create them new, that is, use
--reflink=never or copy the files to a different filesystem, perhaps
tmpfs, and back, so they /have/ to be created new.  Of course with the
rewriter (rrdcached, apparently) shut down for the process.

Then, once the files are safely back in place and the filesystem synced
so the data is actually on disk, you can delete the old copies (which
will continue to serve as backups until then), and sync the filesystem
again.

While snapshots will of course continue to keep extents they reference
locked, for unsnapshotted files at least, this process should clear up
any still referenced but partially unused extents for those files, thus
clearing up the problem if this is it.  After deleting the original
copies to free the space and syncing, you can check to see.


Meanwhile, /because/ nocow has these complexities along with others (nocow
automatically turns off data checksumming and compression for the files
too), and the fact that they nullify some of the big reasons people might
choose btrfs in the first place, I actually don't recommend setting
nocow in the first place -- if usage is such than a file needs nocow,
my thinking is that btrfs isn't a particularly good hosting choice for
that file in the first place, a more traditional rewrite-in-place
filesystem is likely to be a better fit.

OTOH, it's also quite possible that people chose btrfs at least partly
for other reasons, say the "storage pool" qualities, and would rather
just shove everything on a single btrfs "pool" and not have to worry
about it, however much that sets off my own "all eggs in one basket"
risk alert alarms. [shrug]  For them, having to separate all their
nocow stuff into a different non-btrfs filesystem would defeat their
purpose, and they'd rather just deal with all the complexities of
nocow.

For this sort of usage, we actually have reports that first setting up
the nocow dirs and ensuring that files inherit the nocow at creating,
so they /are/ actually nocow, then setting up snapshotting at a sane
schedule, /and/ setting up a periodic (perhaps weekly or monthly)
defrag of their nocow files to eliminate the fragmentation caused
by the snapshot-triggered cow1, actually works reasonably well.

Of course if snapshots are being kept effectively "forever", that'll
make space usage even /worse/, because defrag breaks reflinks and
unshares the data, but arguably, that's doing it wrong, because
snapshots are /not/ backups, and what might be temporarily snapshotted
should eventually be real-backed-up, allowing one to delete those
snapshots, thus freeing the space they took.  Of course if you're
using btrfs send/receive to do those backups, keeping around
selected "parent" snapshots to reference with send is useful,
but choosing a new "send parent" at least every quarter, say, and
deleting the old ones, does at least put a reasonable limit on
the time such snapshots need to be kept on the operational filesystem.

And since more than double-digits snapshots of the same subvolume creates
scaling issues for btrfs balance, snapshot deletion, etc, a regular
snapshot thinning schedule combined with a cap on the age of the oldest
one nicely helps there as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

