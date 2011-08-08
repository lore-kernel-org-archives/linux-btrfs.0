From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: =?utf-8?Q?=E2=80=9Cbio?= too =?utf-8?Q?big=E2=80=9D?= regression
 and silent data corruption in 3.0
Date: Sun, 07 Aug 2011 22:00:24 -0300
Message-ID: <orwreobtuf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

tl;dr version: 3.0 produces =E2=80=9Cbio too big=E2=80=9D dmesg entries=
 and silently
corrupts data in =E2=80=9Cmeta-raid1/data-single=E2=80=9D configuration=
s on disks with
different max_hw_sectors, where 2.6.38 worked fine.

tl;dr side-issue: on-line removal of partitions holding =E2=80=9Csingle=
=E2=80=9D data
attempts to create raid0 (rather than single) block groups.  If it can'=
t
get enough room for raid0 over all remaining disks, it fails, leaving
the available space incorrect (even underflowed).  If it succeeds, it
creates raid0 block groups and permanently (?) switches the FS to raid0=
=2E


I've been (more or less) happily using btrfs on various machines with
internal and external disks combined into raid1(m/d) and
raid1(m)/single(d) -o compress filesystems, using Freed-ora
2.6.38.8-libre.35.fc15.

Once I upgraded to 2.6.40(AKA 3.0)-libre.4.fc15 and created a ceph OSD
on one of those machines, I hit some I/O errors that turned out to be
related with writing out updates to the ceph journal to the external
USB-connected disk (an odd choice, considering the internal disk has
more I/O bandwidth, though much less space; it seems that 3.0 changed
the block group allocation heuristics to avoid filling up disks too
soon, I suppose, but that's another issue).  So far so good.  I could
split out the filesystem, or just refrain from using a journal, but at
least I knew I'd get hard errors should I keep on with the split
filesystem.

Except that I couldn't count on getting hard errors, as I learned the
hard way yesterday.  I decided to shuffle some data around on an old
server with several internal SATA and PATA disks, plus one larger
external USB disk I decided to install on that server to give me enough
room for the shuffling.  That was an unfortunate decision of mine for a
few reasons:

1. Copying (rsync) the first few hundred GBs of data from one
internal-only (fast) filesystem to the internal/external filesystem was
very fast, which was not unexpected given that I thought it was copying
to the internal disk.  But it wasn't: it ended up choosing the larger
external disk for most writes, and *discarding* nearly all of the big
writes with no more than =E2=80=9Cbio too big=E2=80=9D warnings logged =
to dmesg, noticed
only after the fact.  No hard errors, just (nearly)-silent data
corruption, detected by data checksums that didn't match when trying to
use the newly-created copy.  Oops ;-) That's Bad (TM)

A bit of investigation showed that max_hw_sectors for the USB disk was
120, much lower than the internal SATA and PATA disks.  Unfortunately,
by just looking at the code in fs/btrfs, I couldn't tell how a bio that
exceeds max_hw_sectors size could possibly be created, but it was the
first time I even looked at the btrfs kernel code, or any in-kernel
filesystem code, so it doesn't surprise me that I couldn't figure it ou=
t
on my own ;-) Anyway, I couldn't see changes between 2.6.38 and 3.0 tha=
t
might be related with that either, so I'm at a loss as to how this
extremely serious regression might have come about.

2. Removing a partition from the filesystem (say, the external disk)
didn't relocate =E2=80=9Csingle=E2=80=9D block groups as such to other =
disks, as
expected.  Raid0 block groups were created to hold data from single
block groups and, if it couldn't create big-enough raid0 blocks because
*any* of the other disks was nearly-full, removal would fail.  This can
make it tricky to remove any partition from a filesystem that has two o=
r
more partition members nearly full.  I suppose rebalancing might do the
trick, though it adds an unnecessary step.

Worse: after the failure, the available space, as reported by /bin/df,
remains lower than before the request for removal.  The difference
appears to be the amount of space that would have been made unavailable
by the removal of the requested partition.  Repeating the request for
removal doesn't make it go lower, but asking for *another* member
partition to be removed (and failing in just the same way) does make it
go lower.  Asking for one large partition to be removed, after the firs=
t
failure, caused the amount of available space to underflow!  Wheee,
nearly-infinite storage ;-)  At least until the next reboot, that would
fix the reported available space.

3. Sometimes failure is better than success.  In this case, successful
removal of a partition meant the filesystem would no longer allocate
single block groups: it would only allocate raid0 groups, a very
unfortunate choice for a filesystem containing disks of very different
sizes.  I haven't tried to fill it up to check that it wouldn't revert
to single blocks after exhausting all the space that could be devoted t=
o
creating raid0 block groups, but the reported available space got me th=
e
impression that it would only create block groups while it could get an
equal number of blocks from each of the remaining disks.

I could reduce the space taken up by RAID0 block groups by asking for
removal of partitions holding such raid0 block groups; the blocks would
be happily relocated to available space in other pre-existing single
groups.  However, once it got to single groups, it would allocate raid0
groups, and any further block group allocations on that filesystem woul=
d
get raid0 block groups, rather than single.  I couldn't find a way to g=
o
back, in very much the same way that it appears to be impossible to go
back from RAID1 to DUP metadata once you temporarily add a second disk,
and any metadata block group happens to be allocated before you remove
it (why couldn't it go back to DUP, rather than refusing the removal
outright, which prevents even single block groups from being moved?)

4. I ended up re-creating the filesystem with single data, as intended,
and using 2.6.38.8 to safely use the external disk for the copying.  I
decided to keep it in for the time being, in part because I'm scared of
attempting a removal and ending up with raid0 block groups and
highly-reduced available disk space.  Instead of the large external
disk, however, 2.6.38.8 preferred the faster but smaller internal disks=
,
and it would happily fill them up with the large, long-term storage dat=
a
that was meant to remain mostly in the external disk (as 3.0 would have
done), leaving no room for raid1 metadata allocations.  I'd get
-ENOSPACE errors every now and again while copying data onto this
filesystem, even though there was plenty of available space, and even
plenty of available space in already-allocated metadata block groups.
So much so that retrying the same copies after a few seconds would
succeed.  Oh well...  That's a 2.6.38 issue that's AFAICT heuristically
fixed in 3.0.  Too bad I can't really take advantage of this fix becaus=
e
of the =E2=80=9Cbio too big=E2=80=9D problem.

5. This long message reminded me that another machine that has been
running 3.0 seems to have got *much* slower recently.  I thought it had
to do with the 98% full filesystem (though 40GB available for new block
group allocations would seem to be plenty), and the constant metadata
activity caused by ceph creating and removing snapshots all the time.
It seems that the removals lagged behind for a long time and kept the
disk in constant activity in spite of very little actual ceph activity.
I had decided to shuffle disks around precisely to make more disk space
available for that one machine.  However, once I switched back to
2.6.38, the machine seems to have gotten much faster again, in spite of
the larger ceph activity due to resyncing data to a re-created OSD.
This suggests some large inefficiency in 3.0's btrfs, at least for such
nearly-full disks, and/or for such frequent snapshot creation and
removal as done by ceph.  Indeed, I had noticed a significant slow down
of the ceph cluster, which I had associated with the nearly-full disk
under constant metadata activity, but after I switched back to 2.6.38,
the speed of the cluster was back to normal.  I'm afraid I don't have
enough data to be any more specific about this issue.


6. On a more positive note, I was totally amazed by btrfs's ability to
recover from a goof of mine.  While shuffling disks, removing them from
one filesystem and adding to another, I accidentally added to one of th=
e
data filesystems a partition that was in use by the btrfs raid1
filesystem containing my root (I mean the stuff mounted in /, including
usr, bin, lib, etc).  Oops.  I promptly noticed the mistake and removed
it from the data filesystem and rebooted, already reaching for the
recovery disk.  I didn't need it.  The root filesystem mounted
successfully, reporting a bunch of checksum errors and using the other
raid1 copy of the data.  Wow!  I removed the partition I had double-use=
d
and it again reported lots of errors, but succeeded, and then I added i=
t
back, and everything was fine.  I even compared the root filesystem
image with a recent backup, and all the data was correct, and the
filesystem was consistent.  Great stuff, thanks!

I wonder, why can't btrfs mark at least mounted partitions as busy, in
much the same way that swap, md and various filesystems do, to avoid
such accidental reuses?  I recall another occasion in which I attempted
to add a live swap partition to a btrfs filesystem (@&@#$@&@# disks tha=
t
get assigned different /dev/sd* names on each reboot!), and it refused,
because the swap partition was busy.  Couldn't btrfs use the same
mechanisms to protect its own mounted partitions from accidents?


Thanks in advance for any advice, fixes, or improvements,

--=20
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
=46ree Software Evangelist      Red Hat Brazil Compiler Engineer
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
