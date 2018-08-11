Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38432 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727088AbeHKIW1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 04:22:27 -0400
Date: Sat, 11 Aug 2018 01:49:27 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: erenthetitan@mail.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Message-ID: <20180811054927.GE26989@hungrycats.org>
References: <20180811021835.D223C8038C@smtp03.mail.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
In-Reply-To: <20180811021835.D223C8038C@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 11, 2018 at 04:18:35AM +0200, erenthetitan@mail.de wrote:
> Write hole:
>=20
>=20
> > The data will be readable until one of the data blocks becomes
> > inaccessible (bad sector or failed disk). This is because it is only the
> > parity block that is corrupted (old data blocks are still not modified
> > due to btrfs CoW), and the parity block is only required when recovering
> > from a disk failure.
>=20
> I am unsure about your meaning.=20
> Assuming you perform an unclean shutdown (eg. crash), and after restart
> perform a scrub, with no additional error (bad sector, bit-rot) before
> or after the crash:
> will you loose data?=20

No, the parity blocks will be ignored and RAID5 will act like slow RAID0
if no other errors occur.

> Will you be able to mount the filesystem like normal?=20

Yes.

> Additionaly, will the crash create additional errors like bad
> sectors and or bit-rot aside from the parity-block corruption?

No, only parity-block corruptions should occur.

> Its actually part of my first mail, where the btrfs Raid5/6 page
> assumes no data damage while the spinics comment implies the opposite.

The above assumes no drive failures or data corruption; however, if this
were the case, you could use RAID0 instead of RAID5.

The only reason to use RAID5 is to handle cases where at least one block
(or an entire disk) fails, so the behavior of RAID5 when all disks are
working is almost irrelevant.

A drive failure could occur at any time, so even if you mount successfully,
if a disk fails immediately after, any stripes affected by write hole will
be unrecoverably corrupted.

> The write hole does not seem as dangerous if you could simply scrub
> to repair damage (On smaller discs that is, where scrub doesnt take
> enough time for additional errors to occur)

Scrub can repair parity damage on normal data and metadata--it recomputes
parity from data if the data passes a CRC check.

No repair is possible for data in nodatasum files--the parity can be
recomputed, but there is no way to determine if the result is correct.

Metadata is always checksummed and transid verified; alas, there isn't
an easy way to get btrfs to perform an urgent scrub on metadata only.

> > Put another way: if all disks are online then RAID5/6 behaves like a sl=
ow
> > RAID0, and RAID0 does not have the partial stripe update problem because
> > all of the data blocks in RAID0 are independent. It is only when a disk
> > fails in RAID5/6 that the parity block is combined with data blocks, so
> > it is only in this case that the write hole bug can result in lost data.
>=20
> So data will not be lost if no drive has failed?

Correct, but the array will have reduced failure tolerance, and RAID5
only matters when a drive has failed.  It is effectively operating in
degraded mode on parts of the array affected by write hole, and no single
disk failure can be tolerated there.

It is possible to recover the parity by performing an immediate scrub
after reboot, but this cannot be as effective as a proper RAID5 update
journal which avoids making the parity bad in the first place.

> > > > If the filesystem is -draid5 -mraid1 then the metadata is not vulne=
rable
> > > > to the write hole, but data is. In this configuration you can deter=
mine
> > > > with high confidence which files you need to restore from backup, a=
nd
> > > > the filesystem will remain writable to replace the restored data, b=
ecause
> > > > raid1 does not have the write hole bug.
>=20
> In regards to my earlier questions, what would change if i do -draid5 -mr=
aid1?

Metadata would be using RAID1 which is not subject to the RAID5 write
hole issue.  It is much more tolerant of unclean shutdowns especially
in degraded mode.

Data in RAID5 may be damaged when the array is in degraded mode and
a write hole occurs (in either order as long as both occur).  Due to
RAID1 metadata, the filesystem will continue to operate properly,
allowing the damaged data to be overwritten or deleted.

> Lost Writes:
>=20
> > Hotplugging causes an effect (lost writes) which can behave similarly
> > to the write hole bug in some instances. The similarity ends there.
>=20
> Are we speaking about the same problem that is causing transid mismatch?=
=20

Transid mismatch is usually caused by lost writes, by any mechanism
that prevents a write from being completed after the disk reports that
it was completed.

Drives may report that data is "in stable storage", i.e. the drive
believes it can complete the write in the future even if power is lost
now because the drive or controller has capacitors or NVRAM or similar.
If the drive is reset by the SATA host because of a cable disconnect
event, the drive may forget that it has promised to do writes in the
future.  Drives may simply lie, and claim that data has been written to
disk when the data is actually in volatile RAM and will disappear in a
power failure.

btrfs uses a transaction mechanism and CoW metadata to handle lost writes
within an interrupted transaction.  Incomplete data is simply discarded on
next mount.  A transid mismatch is caused by a write that was lost _after_
the transaction commit write is reported completed by the disk firmware.

Transid mismatch is a serious problem as it means that disks or other
lower layers of the storage stack are injecting errors and violating
the data integrity requirements of the filesystem.  It is worse than
a csum error as csum errors are usually caused by random media faults
(with low correlated failure probability) while transid mismatches are
usually caused by firmware or controller problems (with high correlated
failure probability).  If you have multiple identical disks and the
transid mismatches are caused by a firmware bug, then each identical disk
may inject an identical error causing unrecoverable filesystem errors.

> > They are really two distinct categories of problem. Temporary connection
> > loss can do bad things to all RAID profiles on btrfs (not just RAID5/6)
> > and the btrfs requirements for handling connection loss and write holes
> > are very different.
>=20
> What kind of bad things? Will scrub (1/10, 5/6) detect and repair it?

Scrub does not handle all the cases.  Scrub relies on CRC to detect data
errors, which causes two problems:  scrub cannot handle nodatasum files
because those have no CRC, and CRC32 has a non-zero false acceptance rate.

Lost writes should be fixed by performing a replace operation on the
disconnected disk (i.e. it should be treated like the drive failed and
was replaced with a new blank disk).  The replace operation informs btrfs
which version of a nodatasum file it can consider to be correct (i.e. the
one stored on disks that did not disconnect).  Scrub can only detect that
two copies of a nodatasum file are different, it has no way to choose one.

Mature RAID implementations like mdadm have optimizations for this
case that rebuild only areas of the disk that were modified just before
disconnection.  btrfs has no such optimization so it can only replace
the entire disk at once.

> > > > Hot-unplugging a device can cause many lost write events at once, a=
nd
> > > > each lost write event is very bad.
>=20
> > Transid mismatch is btrfs detecting data
> > that was previously silently corrupted by some component outside of btr=
fs.
> >=20
> > btrfs can't prevent disks from silently corrupting data. It can only
> > try to detect and repair the damage after the damage has occurred.
>=20
> Aside from the chance that all copies of data are corrupted, is there any=
 way scrubbing could fail?

There is a small chance of undetected errors due to the limitations
of CRC32.

> > Normally RAID1/5/6/10 or DUP profiles are used for btrfs metadata, so a=
ny
> > transid mismatches can be recovered by reading up-to-date data from the
> > other mirror copy of the metadata, or by reconstructing the data with
> > parity blocks in the RAID 5/6 case. It is only after this recovery
> > mechanism fails (i.e. too many disks have a failure or corruption at
> > the same time on the same sectors) that the filesystem is ended.
>=20
> Does this mean that transid mismatch is harmless unless both copys
> are hit at once (And in case of Raid 6 all three)?

It's not entirely harmless because it is a form of data corruption error.
A disk failure could occur before the corrupted data is recovered,
and should that occur it would be a multiple failure that breaks the
filesystem.

If you find that a disk in your array produces multiple transid
failures, you should treat it like any other failing disk, and replace
it immediately to avoid risk of future data loss.

> Old hardware:
>=20
> > > > It's fun and/or scary to put known good and bad hardware in the same
> > > > RAID1 array and watch btrfs autocorrecting the bad data after every
> > > > other power failure; however, the bad hardware is clearly not suffi=
cient
> > > > to implement any sort of reliable data persistence, and arrays with=
 bad
> > > > hardware in them will eventually fail.
>=20
> I am having a hard time wrapping my head around this statement.
> If Btrfs can repair corrupted data and Raid  6 allows two disc failures
> at once without data loss, is using old discs even with high average
> error count not still pretty much safe?
> You would simply have to repeat the scrubbing process more often to
> make sure that not enough data is corrupted to break redundancy.

Old disks and disks that have bad firmware behave differently.  An old
disk fails in multiple random and unpredictable ways, while a disk with
bad firwmare always fails the same way every time (until it eventually
becomes an old disk, and starts failing in random ways as well).

This kind of array has an elevated probability of failure and is not
"safe".  A small error rate is enough to make the probability of
concurrent failure so high that you would not be able to scrub often
enough even if you were running scrubs continuously.

Such devices should only be used for development and testing of failure
recovery algorithms.

> > > > I have one test case where I write millions of errors into a raid5/=
6 and
> > > > the filesystem recovers every single one transparently while verify=
ing
> > > > SHA1 hashes of test data. After years of rebuilding busted ext3 on
> > > > mdadm-raid5 filesystems, watching btrfs do it all automatically is
> > > > just...beautiful.
>=20
> Once again, if Btrfs is THIS good at repairing data, then is old
> hardware,

I make arrays that combine hardware of different ages.  The failure rates
increase as hardware ages, so you don't want an array of all old drives.
e.g. in a 5-disk array replace the oldest disk every year.

Once disks have been in service for many years, they become very fragile
and can be broken by simply turning them sideways.  You can have at
most one such disk in a RAID5 array (or two in RAID6, but that seems
unnecessarily risky).

> hotplugging and maybe even (depending on whether i understood
> your point) write hole really dangerous? Are there bugs that could
> destroy the data or filesystem whitout corrupting all copies of data
> (Or all copies at once)?=20

There are always bugs, but they get harder and harder to trigger over
time.  At some point the probability of hitting a kernel bug becomes
lower than the probability of failures due to other causes, at which
point improving the reliability of the software has no further impact
on the reliability of the overall system.

Are there still bugs?  Probably, but except for write hole they are
getting harder to hit.  Which will happen first:  you hit one of of the
bugs, or you get a bad batch of drives that all fail in the same hour,
or your RAM goes bad and corrupts everything your CPU touches?

> Assuming Raid 6, corrupted data would not
> break redundancy and repeated scrubbing would fix any upcoming issue.

If a drive is allowed to continually inject small errors into the array,
it introduces a higher risk of data loss over time than if that drive is
immediately replaced with a properly functioning unit.  You can never
make the failure rate zero, but you can keep it as low as possible by
proactively eliminating misbehaving hardware.

If a drive is replaced with all disks online and reasonably healthy then
btrfs can recover data from read errors that occur during replacement.
If you wait for a drive to fail completely before replacement, the
replaced disk will be reconstructed while the array is in degraded mode,
and any other errors that occur during that process are not recoverable.

Old disks can also do nasty things, e.g. run 99% slower than normal,
or lock up the IO bus during read errors.  These events may not corrupt
any data, but an unexpected watchdog reboot or random performance issues
can still ruin your day.

> -------------------------------------------------------------------------=
------------------------
> FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSIT=C4T UND KOMFORT
>=20

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW2544wAKCRCB+YsaVrMb
nK6uAKCQpKXwSwkMvo4NzEFRtchbZUishgCfYmlunyX9a+5MSsdXwo92PzlDmaE=
=1nj4
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
