Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39584 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbeHKDRs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 23:17:48 -0400
Date: Fri, 10 Aug 2018 20:45:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Cc: erenthetitan@mail.de
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Message-ID: <20180811004522.GC26989@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 10, 2018 at 06:55:58PM +0200, erenthetitan@mail.de wrote:
> Did i get you right?
> Please correct me if i am wrong:
>=20
> Scrubbing seems to have been fixed, you only have to run it once.

Yes.

There is one minor bug remaining here:  when scrub detects an error
on any disk in a raid5/6 array, the error counts are garbage (random
numbers on all the disks).  You will need to inspect btrfs dev stats
or the kernel log messages to learn which disks are injecting errors.

This does not impair the scrubbing function, only the detailed statistics
report (scrub status -d).

If there are no errors, scrub correctly reports 0 for all error counts.
Only raid5/6 is affected this way--other RAID profiles produce correct
scrub statistics.

> Hotplugging (temporary connection loss) is affected by the write hole
> bug, and will create undetectable errors every 16 TB (crc32 limitation).

Hotplugging causes an effect (lost writes) which can behave similarly
to the write hole bug in some instances.  The similarity ends there.

They are really two distinct categories of problem.  Temporary connection
loss can do bad things to all RAID profiles on btrfs (not just RAID5/6)
and the btrfs requirements for handling connection loss and write holes
are very different.

> The write Hole Bug can affect both old and new data.=20

Normally, only old data can be affected by the write hole bug.

The "new" data is not committed before the power failure (otherwise we
would call it "old" data), so any corrupted new data will be inaccessible
as a result of the power failure.  The filesytem will roll back to the
last complete committed data tree (discarding all new and modified data
blocks), then replay the fsync log (which repeats and completes some
writes that occurred since the last commit).  This process eliminates
new data from the filesystem whether the new data was corrupted by the
write hole or not.

Only corruptions that affect old data will remain, because old data is
not overwritten by data saved in the fsync log, and old data is not part
of the incomplete data tree that is rolled back after power failure.

Exception:  new data in nodatasum files can also be corrupted, but since
nodatasum disables all data integrity or recovery features it's hard to
define what "corrupted" means for a nodatasum file.

> Reason: BTRFS saves data in fixed size stripes, if the write operation
> fails midway, the stripe is lost.
> This does not matter much for Raid 1/10, data always uses a full stripe,
> and stripes are copied on write. Only new data could be lost.

This is incorrect.  Btrfs saves data in variable-sized extents (between
1 and 32768 4K data blocks) and btrfs has no concept of stripes outside of
its raid layer.  Stripes are never copied.

In RAID 1/10/DUP all data blocks are fully independent of each other,
i.e. writing to any block on these RAID profiles does not corrupt data in
any other block.  As a result these RAID profiles do not allow old data
to be corrupted by partially completed writes of new data.

There is striping in some profiles, but it is only used for performance
in these cases, and has no effect on data recovery.

> However, for some reason Raid 5/6 works with partial stripes, meaning
> that data is stored in stripes not completley filled by prior data,

In RAID 5/6 each data block is related to all other data blocks in the
same stripe with the parity block(s).  If any individual data block in the
stripe is updated, the parity block(s) must also be updated atomically,
or the wrong data will be reconstructed during RAID5/6 recovery.

Because btrfs does nothing to prevent it, some writes will occur
to RAID5/6 stripes that are already partially occupied by old data.
btrfs also does nothing to ensure that parity block updates are atomic,
so btrfs has the write hole bug as a result.

> and stripes are removed on write.

Stripes are never removed...?  A stripe is just a group of disk blocks
divided on 64K boundaries, same as mdadm and many hardware RAID5/6
implementations.

> Result: If the operation fails midway, the stripe is lost as is all
> data previously stored it.

You can only lose as many data blocks in each stripe as there are parity
disks (i.e. raid5 can lose 0 or 1 block, while raid6 can lose 0, 1, or 2
blocks); however, multiple writes can be lost affecting multiple stripes
in a single power loss event.  Losing even 1 block is often too much.  ;)

The data will be readable until one of the data blocks becomes
inaccessible (bad sector or failed disk).  This is because it is only the
parity block that is corrupted (old data blocks are still not modified
due to btrfs CoW), and the parity block is only required when recovering
=66rom a disk failure.

Put another way:  if all disks are online then RAID5/6 behaves like a slow
RAID0, and RAID0 does not have the partial stripe update problem because
all of the data blocks in RAID0 are independent.  It is only when a disk
fails in RAID5/6 that the parity block is combined with data blocks, so
it is only in this case that the write hole bug can result in lost data.

> Transid Mismatch can silently corrupt data.

This is the wrong way around.  Transid mismatch is btrfs detecting data
that was previously silently corrupted by some component outside of btrfs.

btrfs can't prevent disks from silently corrupting data.  It can only
try to detect and repair the damage after the damage has occurred.

> Reason: It is a seperate metadata failure that is trigged by lost or
> incomplete writes, writes that are lost somewhere during transmission.
> It can happen to all BTRFS configurations and is not trigerred by the
> write hole.
> It could happen due to brown out (temporary undersupply of voltage),
> faulty cables, faulty ram, faulty disc cache, faulty discs in general.
>=20
> Both bugs could damage metadata and trigger the following:
> Data will be lost (0 to 100% unreadable), the filesystem will be readonly.
> Reason: BTRFS saves metadata as a tree structure. The closer the error
> to the root, the more data cannot be read.
>=20
> Transid Mismatch can happen up to once every 3 months per device,
> depending on the drive hardware!

It can happen much more often than that on a disk that is truly failing
(as opposed to one that merely has firmware bugs).  I've had RAID1 arrays
where transid failures from one failing disk were repaired thousands of
times over a period of several hours, stopping only when the bad disk
was replaced.

> Question: Does this not make transid mismatch way more dangerous than
> the write hole?=20

*Unrecoverable* transid mismatch is fatal.  A btrfs that uses 'single' or
'raid0' profiles for metadata will be unable to recover from even minor
failures.  A single bit error in metadata could end the filesystem.

Normally RAID1/5/6/10 or DUP profiles are used for btrfs metadata, so any
transid mismatches can be recovered by reading up-to-date data from the
other mirror copy of the metadata, or by reconstructing the data with
parity blocks in the RAID 5/6 case.  It is only after this recovery
mechanism fails (i.e. too many disks have a failure or corruption at
the same time on the same sectors) that the filesystem is ended.

This is the same as any other RAID implementation:  if there are failures
on too many disks, data will be lost.

> What would happen to other filesystems, like ext4?

In the best case ext4 silently corrupts data.  In the worst cases (if
all the ext2/3 legacy features are turned off, so there are no fixed
locations on disk for block group and extent structures), the filesystem
can be severely damaged, possibly beyond the ability of tools to usefully
recover.  "Recovery" by e2fsck may remove bad metadata until there is no
data left on the filesystem, or the entire filesystem becomes nameless
lost+found soup.

ext2 and ext3 and some configurations of ext4 are more resilient to
lost writes because metadata is always overwritten in the same place,
metadata changes slowly over time, and minor inconsistencies in metadata
can often be ignored in practice.  This means that data integrity on
these filesystems relies more on luck than anything else.

btrfs is nothing like that:  metadata is (almost) never written to the
same location on disk twice, all metadata pages have transid stamps and
checksums to detect errors in the disk layer, and btrfs verifies metadata
and refuses to process data that it does not deem to be entirely correct.

> Am 10-Aug-2018 09:12:21 +0200 schrieb ce3g8jdj@umail.furryterror.org:=20
> > On Fri, Aug 10, 2018 at 03:40:23AM +0200, erenthetitan@mail.de wrote:
> > > I am searching for more information regarding possible bugs related to
> > > BTRFS Raid 5/6. All sites i could find are incomplete and information
> > > contradicts itself:
> > >
> > > The Wiki Raid 5/6 Page (https://btrfs.wiki.kernel.org/index.php/RAID5=
6)
> > > warns of the write hole bug, stating that your data remains safe
> > > (except data written during power loss, obviously) upon unclean shutd=
own
> > > unless your data gets corrupted by further issues like bit-rot, drive
> > > failure etc.
> >=20
> > The raid5/6 write hole bug exists on btrfs (as of 4.14-4.16) and there =
are
> > no mitigations to prevent or avoid it in mainline kernels.
> >=20
> > The write hole results from allowing a mixture of old (committed) and
> > new (uncommitted) writes to the same RAID5/6 stripe (i.e. a group of
> > blocks consisting of one related data or parity block from each disk
> > in the array, such that writes to any of the data blocks affect the
> > correctness of the parity block and vice versa). If the writes were
> > not completed and one or more of the data blocks are not online, the
> > data blocks reconstructed by the raid5/6 algorithm will be corrupt.
> >=20
> > If all disks are online, the write hole does not immediately
> > damage user-visible data as the old data blocks can still be read
> > directly; however, should a drive failure occur later, old data may
> > not be recoverable because the parity block will not be correct for
> > reconstructing the missing data block. A scrub can fix write hole
> > errors if all disks are online, and a scrub should be performed after
> > any unclean shutdown to recompute parity data.
> >=20
> > The write hole always puts both old and new data at risk of damage;
> > however, due to btrfs's copy-on-write behavior, only the old damaged
> > data can be observed after power loss. The damaged new data will have
> > no references to it written to the disk due to the power failure, so
> > there is no way to observe the new damaged data using the filesystem.
> > Not every interrupted write causes damage to old data, but some will.
> >=20
> > Two possible mitigations for the write hole are:
> >=20
> > - modify the btrfs allocator to prevent writes to partially filled
> > raid5/6 stripes (similar to what the ssd mount option does, except
> > with the correct parameters to match RAID5/6 stripe boundaries),
> > and advise users to run btrfs balance much more often to reclaim
> > free space in partially occupied raid stripes
> >=20
> > - add a stripe write journal to the raid5/6 layer (either in
> > btrfs itself, or in a lower RAID5 layer).
> >=20
> > There are assorted other ideas (e.g. copy the RAID-Z approach from zfs
> > to btrfs or dramatically increase the btrfs block size) that also solve
> > the write hole problem but are somewhat more invasive and less practical
> > for btrfs.
> >=20
> > Note that the write hole also affects btrfs on top of other similar
> > raid5/6 implementations (e.g. mdadm raid5 without stripe journal).
> > The btrfs CoW layer does not understand how to allocate data to avoid R=
MW
> > raid5 stripe updates without corrupting existing committed data, and th=
is
> > limitation applies to every combination of unjournalled raid5/6 and btr=
fs.
> >=20
> > > The Wiki Gotchas Page (https://btrfs.wiki.kernel.org/index.php/Gotcha=
s)
> > > warns of possible incorrigible "transid" mismatch, not stating which
> > > versions are affected or what transid mismatch means for your data. It
> > > does not mention the write hole at all.
> >=20
> > Neither raid5 nor write hole are required to produce a transid mismatch
> > failure. transid mismatch usually occurs due to a lost write. Write hole
> > is a specific case of lost write, but write hole does not usually produ=
ce
> > transid failures (it produces header or csum failures instead).
> >=20
> > During real disk failure events, multiple distinct failure modes can
> > occur concurrently. i.e. both transid failure and write hole can occur
> > at different places in the same filesystem as a result of attempting to
> > use a failing disk over a long period of time.
> >=20
> > A transid verify failure is metadata damage. It will make the filesystem
> > readonly and make some data inaccessible as described below.
> >=20
> > > This Mail Archive (linux-btrfs@vger.kernel.org/msg55161.html"
> > > target=3D"_blank">linux-btrfs@vger.kernel.org/msg55161.html" target=
=3D"_blank">https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg551=
61.html)
> > > states that scrubbing BTRFS Raid 5/6 will always repair Data Corrupti=
on,
> > > but may corrupt your Metadata while trying to do so - meaning you have
> > > to scrub twice in a row to ensure data integrity.
> >=20
> > Simple corruption (without write hole errors) is fixed by scrubbing
> > as of the last...at least six months? Kernel v4.14.xx and later can
> > definitely do it these days. Both data and metadata.
> >=20
> > If the metadata is damaged in any way (corruption, write hole, or trans=
id
> > verify failure) on btrfs and btrfs cannot use the raid profile for
> > metadata to recover the damaged data, the filesystem is usually forever
> > readonly, and anywhere from 0 to 100% of the filesystem may be readable
> > depending on where in the metadata tree structure the error occurs (the
> > closer to the root, the more data is lost). This is the same for dup,
> > raid1, raid5, raid6, and raid10 profiles. raid0 and single profiles are
> > not a good idea for metadata if you want a filesystem that can persist
> > across reboots (some use cases don't require persistence, so they can
> > use -msingle/-mraid0 btrfs as a large-scale tmpfs).
> >=20
> > For all metadata raid profiles, recovery can fail due to risks including
> > RAM corruption, multiple drives having defects in the same locations,
> > or multiple drives with identically-behaving firmware bugs. For raid5/6
> > metadata there is the *additional* risk of the write hole bug preventing
> > recovery of metadata.
> >=20
> > If the filesystem is -draid5 -mraid1 then the metadata is not vulnerable
> > to the write hole, but data is. In this configuration you can determine
> > with high confidence which files you need to restore from backup, and
> > the filesystem will remain writable to replace the restored data, becau=
se
> > raid1 does not have the write hole bug.
> >=20
> > More than one scrub for a single write hole event won't help (and never
> > did). If the first scrub doesn't fix all the errors then your kernel
> > probably also has a race condition bug or regression that will permanen=
tly
> > corrupt the data (this was true in 2016 when the referenced mailing
> > list post was written).
> >=20
> > Current kernels don't have such bugs--if the first scrub can correct
> > the data, it does, and if the first scrub can't correct the data then
> > all future scrubs will produce identical results.
> >=20
> > Older kernels (2016) had problems reconstructing data during read()
> > operations but could fix data during scrub or balance operations.
> > These bugs, as far as I am able to test, have been fixed by v4.17 and
> > backported to v4.14.
> >=20
> > > The Bugzilla Entry
> > > (https://bugzilla.kernel.org/buglist.cgi?component=3Dbtrfs) contains
> > > mostly unanswered bugs, which may or may not still count (2013 - 2018=
).
> >=20
> > I find that any open bug over three years old on b.k.o can be safely
> > ignored because it has either already been fixed or there is not enough
> > information provided to understand what is going on.
> >=20
> > > This Spinics Discussion
> > > (https://www.spinics.net/lists/linux-btrfs/msg76471.html) states
> > > that the write hole can even damage old data eg. data that was not
> > > accessed during unclean shutdown, the opposite of what the Raid5/6
> > > Status Page states!
> >=20
> > Correct, write hole can *only* damage old data as described above.
> >=20
> > > This Spinics comment
> > > (https://www.spinics.net/lists/linux-btrfs/msg76412.html) informs that
> > > hot-plugging a device will trigger the write hole. Accessed data will
> > > therefore be corrupted. In case the earlier statement about old data
> > > corruption is true, random data could be permamently lost. This is ev=
en
> > > more dangerous if you are connecting your devices via USB, as USB can
> > > unconnect due to external influence, eg. touching the cables, shaking=
=2E..
> >=20
> > Hot-unplugging a device can cause many lost write events at once, and
> > each lost write event is very bad.
> >=20
> > btrfs does not reject and resynchronize a device from a raid array if a
> > write to the device fails (unlike every other working RAID implementati=
on
> > on Earth...). If the device reconnects, btrfs will read a mixture of
> > old and new data and rely on checksums to determine which blocks are
> > out of date (as opposed to treating the departed disk as entirely out
> > of date and initiating a disk replace operation when it reconnects).
> >=20
> > A scrub after a momentary disconnect can reconstruct most missing data,
> > but not all. CRC32 lets one error through per 16 TB of corrupted blocks,
> > and all nodatasum/nodatacow files modified while a drive was offline
> > will be corrupted without detection or recovery by btrfs.
> >=20
> > Device replace is currently the best recovery option from this kind
> > of failure. Ideally btrfs would implement something like mdadm write
> > intent bitmaps so only those block groups that were modified while
> > the device as offline would be replaced, but this is the btrfs we want
> > not the btrfs we have.
> >=20
> > > Lastly, this Superuser question
> > > (https://superuser.com/questions/1325245/btrfs-transid-failure#134449=
4)
> > > assumes that the transid mismatch bug could toggle your system
> > > unmountable. While it might be possible to restore your data using
> > > sudo BTRFS Restore, it is still unknown how the transid mismatch is
> > > even toggled, meaning that your file system could fail at any time!
> >=20
> > Note that transid failure risk applies to all btrfs configurations.
> > It is not specific to raid5/6. The write hole errors from raid5/6 will
> > typically produce a header or csum failure (from reading garbage) not a
> > transid failure (from reading an old, valid, but deleted metadata block=
).
> >=20
> > transid mismatch is pretty simple: one of your disk drives, or some
> > caching or translation layer between btrfs and your disk drives, dropped
> > a write (or, less likely, read from or wrote to the wrong sector addres=
s).
> > btrfs detects this by embedding transids into all data structures where
> > one object points to another object in a different block.
> >=20
> > transid mismatch is also hard: you then have to figure out which layer
> > of your possibly quite complicated RAID setup is doing that, and make
> > it stop. This process almost never involves btrfs. Sometimes it's the
> > bottom layer (i.e. the drives themselves) but the more layers you add,
> > the more candidates need to be eliminated before the cause can be found.
> > Sometimes it's a *power supply* (i.e. the drive controller CPU browns
> > out and forgets it was writing something or corrupts its embedded RAM).
> > Sometimes it's host RAM going bad, corrupting and breaking everything
> > it touches.
> >=20
> > I have a variety of test setups and the correlation between hardware
> > model (especially drive model, but also some SATA controller models)
> > and total filesystem loss due to transid verify failure is very strong.
> > Out of 10 drive models from 5 vendors, 2 models can't keep a filesystem
> > intact for more than a few months, while the other models average 3 yea=
rs
> > old and still hold the first btrfs filesystem they were formatted with.
> >=20
> > Disabling drive write caching sometimes helps, but some hardware eats
> > a filesystem every few months no matter what settings I change. If the
> > problem is a broken SATA controller or cable then changing drive settin=
gs
> > won't help.
> >=20
> > It's fun and/or scary to put known good and bad hardware in the same
> > RAID1 array and watch btrfs autocorrecting the bad data after every
> > other power failure; however, the bad hardware is clearly not sufficient
> > to implement any sort of reliable data persistence, and arrays with bad
> > hardware in them will eventually fail.
> >=20
> > The bad drives can still contribute to society as media cache servers or
> > point-of-sale terminals where the only response to any data integrity
> > issue is a full reformat and image reinstall. This seems to be the
> > target market that low-end consumer drives are aiming for, as they seem
> > to be useless for anything else.
> >=20
> > Adopt a zero-tolerance policy for drive resets after the array is
> > mounted and active. A drive reset means a potential lost write leading
> > to a transid verify failure. Swap out both drive and SATA cable the
> > first time a reset occurs during a read or write operation, and consider
> > swapping out SATA controller, changing drive model, and upgrading power
> > supply if it happens twice.
> >=20
> > > Do you know of any comprehensive and complete Bug list?
> >=20
> > ...related to raid5/6:
> >=20
> > - no write hole mitigation (at least two viable strategies
> > available)
> >=20
> > - no device bouncing mitigation (mdadm had this working 20
> > years ago)
> >=20
> > - probably slower than it could be
> >=20
> > - no recovery strategy other than raid (btrfs check --repair is
> > useless on non-trivial filesytems, and a single-bit uncorrected
> > metadata error makes the filesystem unusable)
> >=20
> > > Do you know more about the stated Bugs?
> > >
> > > Do you know further Bugs that are not addressed in any of these sites?
> >=20
> > My testing on raid5/6 filesystems is producing pretty favorable results
> > these days. There do not seem to be many bugs left.
> >=20
> > I have one test case where I write millions of errors into a raid5/6 and
> > the filesystem recovers every single one transparently while verifying
> > SHA1 hashes of test data. After years of rebuilding busted ext3 on
> > mdadm-raid5 filesystems, watching btrfs do it all automatically is
> > just...beautiful.
> >=20
> > I think once the write hole and device bouncing mitigations are in plac=
e,
> > I'll start looking at migrating -draid1/-mraid1 setups to -draid5/-mrai=
d1,
> > assuming the performance isn't too painful.
>=20
> -------------------------------------------------------------------------=
------------------------
> FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSIT=C4T UND KOMFORT
>=20

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW24xngAKCRCB+YsaVrMb
nAuEAJ9UF49LDCflIw33/81DmHcTTq4W5gCg1MGBBgXJV8XwNUvsaSmkh1s/jUg=
=5InN
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
