Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34736 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaC3JEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 05:04:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WUBez-0008Bs-JH
	for linux-btrfs@vger.kernel.org; Sun, 30 Mar 2014 11:04:09 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Mar 2014 11:04:09 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Mar 2014 11:04:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Potential rebalance bug plus some questions
Date: Sun, 30 Mar 2014 09:04:00 +0000 (UTC)
Message-ID: <pan$71f8a$3a67035d$a982f5e3$2f00cb63@cox.net>
References: <53375669.4070605@hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

jon posted on Sat, 29 Mar 2014 13:25:29 -1000 as excerpted:

> Hi all,
> 
> First off I've got a couple of questions that I posed over on the
> fedoraforum http://www.forums.fedoraforum.org/showthread.php?t=298142
> 
> "I'm in the process of building a btrfs storage server (mostly for
> evaluation) and I'm trying to understand the COW system. As I understand
> it no data is over written when file X is changed ot file Y is created,
> but what happens when you get to the end of your disk?
> Say you write files X1, X2, ... Xn which fills up your disk. You then
> delete X1 through Xn-1, does the disk space actually free up?

Well, yes and no.  A barebones answer is that btrfs actually allocates 
space in two stages, but presently only automatically frees one -- the 
other presently requires a rebalance to free.

Putting a bit more flesh on those bones, a new and unused filesystem is 
mostly unallocated free space.  As files are added, btrfs allocates room 
for them a chunk at a time on demand.  As long as there is room, data 
chunks are 1 GiB in size while metadata chunks are 256 MiB (1/4 GiB) in 
size.  However, metadata defaults to dup mode, two copies of all metadata 
are written, so metadata chunks are allocated in pairs, two quarter-GiB 
chunks so half a GiB at a time, while data chunks default to single mode, 
a single 1 GiB chunk at a time.  Btrfs then writes files to those chunks 
until they are full, at which point it allocates additional chunks of 
whichever type it has run out of.

The filesystem is said to be "full" when all previously unallocated space 
is allocated to data or metadata chunks, *AND* one *OR* the other has 
used up all its allocated space and needs to allocate more, but can't as 
it's all allocated already.  (FWIW there's also a very limited bit of 
space, normally a few MiB, allocated as system chunks, but this 
allocation typically doesn't grow much, it's almost all data and metadata 
chunks.  I'm not sure what size system chunks are, but typically they 
total rather less than a single metadata chunk, that is, less than 256 
MiB.)  It's worth noting that normal df (that is, the df command, not 
btrfs filesystem df) will most often still report quite some space left, 
but it's all of the /other/ type.

Absent snapshots, when files are deleted, the space their data and 
metadata took are freed back to their respective data and metadata 
chunks.  That space can then be reused AS THE SAME TYPE, DATA OR 
METADATA, but because the chunks remain allocated, currently the freed 
space cannot be AUTOMATICALLY switched to the other type.  As it happens, 
most of the space used by most files and thus returned to the chunk for 
reuse on deletion is data space -- individual files don't normally take a 
lot of metadata space, tho a bunch of files together do take some.  Thus, 
deletions tend to free more data space than metadata, and over time, 
normal usage patterns tend to accumulate a lot of mostly empty data chunk 
space, with relatively little accumulation of empty metadata chunk 
space.  As a result, after all filesystem space is allocated to either 
data or metadata chunks and there's none left unallocated, most of the 
time people end up running out of metadata space first, with lots of data 
space still left free, but it's all tied up in data chunk allocation, 
with no unallocated space left to allocate further metadata chunks when 
they are needed.

At this point it's worth noting that due to copy-on-write, even DELETING 
files requires SOME free metadata space, and btrfs does reserve some 
metadata space for that sort of thing, so once you're down to writing in 
the last one, which given they're allocated and written in pairs, means 
once you get down under 512 MiB of free metadata space, you're actually 
very close to running out entirely, if there's no additional unallocated 
space to allocate as metadata chunks.

IOW, if you have less than 500 MiB of free metadata reported and no 
unallocated space left, you're effectively out of space!

To solve that problem, you (re)balance using the btrfs balance command.  
This rewrites allocated chunks, freeing their unused space back to the 
unallocated pool in the process, after which they can one again be on-
demand allocated to either data or metadata chunks once again.

Thus the (current) situation outlined in the barebones above: Deleting 
files returns the space they took to the data or metadata chunk it was 
using, but to reclaim the space from those chunks to the unallocated pool 
so they can be used as the OTHER type if needed, requires a rebalance.

Now to wrap up a couple loose ends.

1) For relatively small filesystems, btrfs typically does this 
automatically for filesystems under 1 GiB in size but mkfs.btrfs has an 
option (--mixed) to force it as well, btrfs has a shared/mixed data/
metadata chunk mode.  This must be set at mkfs.btrfs time -- it cannot be 
changed later.  Like standard metadata chunks but in this case with data 
sharing them as well, these chunks are normally 256 MiB in size (smaller 
if there's not enough space left for a full-sized allocation, thus 
allowing full usage) and are by default duplicated -- two chunks 
allocated at a time, with (meta)data duplicated to both.  Shared mode 
does sacrifice some performance, however, which is why it's only the 
default on filesystems under 1 GiB.  Never-the-less, many users find that 
shared mode actually works better for them on filesystems of several GiB 
and it's often recommended on filesystems up to 16 or 32 GiB.  General 
consensus is, however, that as filesystem size nears and passes 64 GiB, 
the better performance of separate data and metadata makes it the better 
choice.

**Due to the default duplication, this shared mode is the only way to 
actually store duplicated data on a single device btrfs.  Ordinarily data 
chunks can only be single or one of the raid modes allocated so 
duplicating data as well requires two devices and raid; only metadata can 
ordinarily be dup mode on a single device btrfs.  But shared mode allows 
treating data as metadata, thus allowing dup mode for data as well.

Duplication does mean you can only fit about half of what you might 
otherwise fit on that filesystem, but it also means there's a second copy 
of the data (not just metadata) for use with btrfs' data integrity 
checksumming and scrubbing features, in case the one copy gets corrupted, 
somehow.  That's actually one of the big reasons I'm using btrfs here, 
altho most of my btrfs are multi-device in raid1 mode for both data and 
metadata, tho I am taking advantage of shared mode on a couple smaller 
single-device filesystems.

2) On a single-device btrfs, data defaults to single mode, metadata (and 
mixed) defaults to dup (except for SSDs, which default to single for 
metadata/mixed as well).  You can of course specify single mode for 
metadata/mixed if you like, or dup mode on ssd where the default would be 
single.  That's normally set at mkfs.btrfs time but it's also possible to 
convert using balance with some of its available options.

On a multi-device btrfs, data still defaults to single, while metadata 
defaults to raid1 mode, two copies of metadata as with dup, but ensuring 
they're on separate devices so a loss of one device with one copy will 
still leave the other copy available.

> How does this affect the 30 second snapshot mechanism and all the
> roll back stuff?

First, it's not *THE* 30-second snapshot mechanism.  Snapshots can be 
taken whenever you wish.  Btrfs builds in the snapshotting mechanism but 
not the timing policy.  There are scripts available that automate the 
snapshotting process, taking one a minute or one an hour or one a day or 
whatever, and apparently on whatever you're looking at, one every 30 
seconds, but that's not btrfs, that's whatever snapshotting script you or 
your distro has chosen to use and configure for 30 second snapshots.

Meanwhile, snapshots would have been another loose end to wrap up above, 
but you asked the questions specifically, so I'll deal with them here.

Background: As you've read, btrfs is in general a copy-on-write (COW) 
based filesystem.  That means as files (well, file blocks, 4096 bytes aka 
4 KiB in size on x86 and amd64 and I /think/ on ARM as well, but not 
always on other archs) are changed, the new version isn't written over-
top of the old one, but to a different location (filesystem block), with 
the file's metadata updated accordingly (and atomically, so either the 
new copy or the old exists, not bits of old and new mixed -- that 
actually being one of the main benefits of COW), pointing to the new 
location for that file block instead of the old one.

Snapshots: Once you have a working COW based filesystem, snapshots are 
reasonably simple to implement since the COW mechanisms are already doing 
most of the work for you.  The concept is simple.  Since changes are 
already written to a different location with the metadata normally simply 
updated to point to the new location and mark the old one free to reuse, 
a snapshot simply stores a copy of all the metadata as it exists at that 
point in time, and when a new version of a file block is written, the old 
one is only actually freed if there's no snapshot with metadata still 
pointing at the old location as part of the file at the time the snapshot 
was taken.

Which answers your snapshot specific question:  If a snapshot still 
points at the file block as part of the file as it was when that snapshot 
was taken, that block cannot be freed when the file is changed and an 
updated block is written elsewhere.  Only once all snapshots pointing at 
that file block are deleted, can the file block itself be marked as free 
once again.

So if you're taking 30-second snapshots (and assuming the files aren't 
being changed at a faster rate than that), basically, no file blocks will 
ever be freed on file change or delete unless/until you delete all the 
snapshots referring to the old file block(s).

Typically, the same automated snapshotting scripts that take per-minute 
or per-hour or whatever snapshots, also provide a configurable mechanism 
for thinning them down, for example from 30 seconds to 1 minute (deleting 
every other snapshot) after an hour, from 1 minute to 5 minutes (deleting 
four of five) after six hours, from 5 minutes to half an hour (deleting 5 
of six) after a day, from half an hour to an hour (deleting every other 
once again) after a second day, from an hour to 6 hours (deleting 5 of 6) 
after a week, from 4 a day to daily after 4 weeks (28 days, deleting 3 of 
4), from daily to weekly after a quarter (13 weeks, deleting 6 of 7), 
with the snapshots transferred to permanent and perhaps off-site backup 
and thus entirely deletable after perhaps 5 quarters (thus a year and a 
quarter, giving an extra quarter's overlap beyond a year).

Using a thinning system such as this, intermediate changes would be 
finally deleted and the blocks tracking them freed when all the snapshots 
containing them were deleted, but gradually thinned out longer term 
snapshot copies would remain around for, in the example above, 15 
months.  Only after final 15-month deletion would the filesystem be able 
to retrieve blocks from the more permanent edits and deletions.

> Second, the raid functionality works at the filesystem block level
> rather than the device block level. Ok cool, so "raid 1" is creating two
> copies of every block and sticking each copy on a different device
> instead of block mirroring over multipul devices. So you can have a
> "raid 1" in 3, 5, or n disks. If I understand that correctly then you
> should be able to lose a single disk out of a raid 1 and still have all
> your data where lossing two disks may kill off data. Is that right? Is
> there a good rundown on "raid" levels in btrfs somewhere?"

You understand correctly.  FWIW, there's an N-way-mirroring (where N>2) 
feature on the roadmap, for people like me that really appreciate btrfs 
data integrity features but really REALLY want that third or fourth or 
whatever copy, just in case, but it has been awhile in coming, as it's 
penciled in to depend on some of the raid5/6 implementing code, and while 
there's a sort-of-working raid5/6 implementation since 3.10 (?) or so, as 
of 3.14 the raid5/6 device-loss recovery and scrubbing code isn't yet 
fully complete, so it could be some time before N-way-mirroring is ready.

Raid-level-rundown?

Maturity:  Single-device single and dup modes were the first implemented 
and are now basically stable, but for the general btrfs bug-fixing still 
going on (mostly features such as send/receive, snapshot-aware-defrag, 
quota-groups, etc, still not entirely bug free, snapshot-aware-defrag 
actually disabled ATM for rewrite as the previous implementation didn't 
scale well at all).  Multi-device single and raid0/1/10 modes were 
implemented soon after and are also close to stable.  Raid5/6 modes are 
working run-time implemented, but lack critical recovery code as well as 
working raid5/6 scrub (attempting a scrub does no damage but returns a 
lot of errors since scrub doesn't understand that mode yet and is 
interpreting what it sees incorrectly).  N-way-mirroring aka true raid1 
is next-up, but could be awhile.  There's also talk of a more generic 
stripe/mirror/parity configuration, but I've not seen enough discussion 
on that to reasonably relay anything.

Device-requirements:  Raid0 and raid1 modes require two devices minimum 
to function properly.  Raid1 is paired-writes and raid0 allocates and 
stripes across all available devices.  To prevent complications from 
dropping below the minimum number of devices, however, raid1 really needs 
three devices, all with unallocated space available, in ordered to stay 
raid1 when a device drops out.  Raid10 is four devices minimum; again 
bump that by one to five minimum, for device-drop-out tolerance.  Raid5/6 
are three and four devices minimum respectively, as one might expect; I'm 
not sure if their implementation needs a device bump to 4/5 devices to 
maintain functionality or not, but since the recovery and scrub code 
isn't complete, consider them effectively really slow raid0 at this point 
in terms of reliability, but already configured so the upgrade to raid5/6 
whenever that code is fully implemented and tested will be automatic and 
"free", since it's effectively calculating and writing the parity already 
-- it simply can't yet properly recover or scrub it.

> Second, I've got a centOS 6 box with the current epel kernel and btrfs
> progs (3.12) on which I'm playing with the raid1 setup.

I'm not sure what the epel kernel version is or its btrfs support status, 
but on this list anyway, btrfs is still considered under heavy 
development, and at least until 3.13, if you were not running the latest 
mainstream stable kernel series or newer (the development kernel or btrfs-
next), you're considered to be running an old kernel with known-fixed 
bugs, and upgrading to something current is highly recommended.

With 3.13, kconfig's btrfs option wording was toned down from dire 
warning to something a bit less dire, and effectively single device and 
multi-device raid0/1/10 are considered semi-stable from there, with 
bugfixes backported to stable kernels from 3.13 forward.  There's effort 
to backport fixes to earlier stable series, but for them the kconfig 
btrfs option warning was still very strongly worded, so there's no 
guarantees... you take what you get.

Meanwhile, at least as of btrfs-progs 3.12 (current latest, but the 
number is kernel release synced and there's a 3.14 planned), mkfs.btrfs 
still has a strong recommendation to use a current kernel as well.

So I'd strongly recommend at least 3.13 or newer stable series going 
forward, and preferably latest stable or even development kernel, tho 
from 3.13 forward, that's at least somewhat more up to you than it has 
been.

> Using four disks, I created an array
> mkfs.btrfs -d raid1 -m raid1 /dev/sd[b-e]

[...]

> Next I did a rebalance of the array [with the missing device] which is
> what I *think* killed it.

> After the rebalance I removed /dev/sdb from the pool, added /dev/sdg and
> rebooted.

> On the reboot the pool failed to mount at all. dmesg showed something
> like "btrfs open_ctree failure" (sorry, don't have access to the box
> atm).

> So tl;dr I think there may be an issue with the balance command when a
> disk is offline.

Standing alone, the btrfs "open_ctree failed" mount-error is 
unfortunately rather generic.  Btrfs uses trees for everything, including 
the space cache, and the severity of that error depends greatly on which 
one of those trees it was as reflected by the surrounding dmesg context 
-- a bad space-cache is easy enough corrected with the clear_cache mount-
option, but the same generic error can also mean it didn't find the main 
root tree with everything under it, so context is everything!

Meanwhile, there are various possibilities for recovery, including btrfs-
find-root and btrfs restore, to roll back to an earlier tree root node 
(btrfs keeps a list of several) if necessary.  (But worth noting, while 
btrfsck aka btrfs check is by default read-only and thus won't do any 
harm, do NOT use it with the --repair option except as a last resort, 
either as instructed by a dev or when you've given up and the next step 
is a new mkfs, since while it can be used to repair certain types of 
damage, there are others it doesn't understand, where attempts to repair 
will instead damage the filesystem further, killing any chance at using 
other tools to at least retrieve some of the files, even if the 
filesystem is otherwise too far gone to restore to usable.)

That said... yes, balance with a device missing isn't a good thing to 
do.  Ideally you btrfs device add if necessary to bring the number of 
devices up to mode-minimum (two devices for raid1), then btrfs device 
delete missing, THEN btrfs balance if necessary.

Oh, and when mounting with a (possibly) missing device, use the degraded 
mount option.  In fact, it's quite possible that would have worked fine 
for you, tho if necessary it would mean the btrfs device delete hadn't 
finished yet,


And one final thing:  If you haven't yet, take some time to read over the 
btrfs wiki at https://btrfs.wiki.kernel.org .  Among other things, that 
would have covered the degraded and clear_cache mount options, various 
recovery options, some stuff about raid modes, snapshots, btrfs space 
issues, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

