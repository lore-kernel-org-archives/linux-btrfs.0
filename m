Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47666 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750979AbeC2VuO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 17:50:14 -0400
Date: Thu, 29 Mar 2018 17:50:12 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Status of RAID5/6
Message-ID: <20180329215011.GC2446@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
In-Reply-To: <1521662556.4312.39.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2018 at 09:02:36PM +0100, Christoph Anton Mitterer wrote:
> Hey.
>=20
> Some things would IMO be nice to get done/clarified (i.e. documented in
> the Wiki and manpages) from users'/admin's  POV:
>=20
> Some basic questions:

I can answer some easy ones:

>   - compression+raid?

There is no interaction between compression and raid.  They happen on
different data trees at different levels of the stack.  So if the raid
works, compression does too.

>   - rebuild / replace of devices?

"replace" needs raid-level-specific support.  If the raid level doesn't
support replace, then users have to do device add followed by device
delete, which is considerably (orders of magnitude) slower.

>   - changing raid lvls?

btrfs uses a brute-force RAID conversion algorithm which always works, but
takes zero short cuts.  e.g. there is no speed optimization implemented
for cases like "convert 2-disk raid1 to 1-disk single" which can be
very fast in theory.  The worst-case running time is the only running
time available in btrfs.

Also, users have to understand how the different raid allocators work
to understand their behavior in specific situations.  Without this
understanding, the set of restrictions that pop up in practice can seem
capricious and arbitrary.  e.g. after adding 1 disk to a nearly-full
raid1, full balance is required to make the new space available, but
adding 2 disks makes all the free space available immediately.

Generally it always works if you repeatedly run full-balances in a loop
until you stop running out of space, but again, this is the worst case.

>   - anything to consider with raid when doing snapshots, send/receive
>     or defrag?

Snapshot deletes cannot run at the same time as RAID convert/device
delete/device shrink/resize.  If one is started while the other is
running, it will be blocked until the other finishes.  Internally these
operations block each other on a mutex.

I don't know if snapshot deletes interact with device replace (the case
has never come up for me).  I wouldn't expect it to as device replace
is more similar to scrub than balance, and scrub has no such interaction.

Also note you can only run one balance, device shrink, or device delete
at a time.  If you start one of these three operations while another is
already running, the new request is rejected immediately.

As far as I know there are no other restrictions.

>   =3D> and for each of these: for which raid levels?

Most of those features don't interact with anything specific to a raid
layer, so they work on all raid levels.

Device replace is the exception: all RAID levels in use on the filesystem
must support it, or the user must use device add and device delete instead.

[Aside:  I don't know if any RAID levels that do not support device
replace still exist, which makes my answer longer than it otherwise
would be]

>   Perhaps also confirmation for previous issues:
>   - I vaguely remember there were issues with either device delete or
>     replace.... and that one of them was possibly super-slow?

Device replace is faster than device delete.  Replace does not modify
any metadata, while delete rewrites all the metadata referring to the
removed device.

Delete can be orders of magnitude slower than expected because of the
metadata modifications required.

>   - I also remember there were cases in which a fs could end up in
>     permanent read-only state?

Any unrecovered metadata error 1 bit or larger will do that.  RAID level
is relevant only in terms of how well it can recover corrupted or
unreadable metadata blocks.

> - Clarifying questions on what is expected to work and how things are
>   expected to behave, e.g.:
>   - Can one plug a device (without deleting/removing it first) just
>     under operation and will btrfs survive it?

On raid1 and raid10, yes.  On raid5/6 you will be at risk of write hole
problems if the filesystem is modified while the device is unplugged.

If the device is later reconnected, you should immediately scrub to
bring the metadata on the devices back in sync.  Data written to the
filesystem while the device was offline will be corrected if the csum
is different on the removed device.  If there is no csum data will be
silently corrupted.  If the csum is correct, but the data is not (this
occurs with 2^-32 probability on random data where the CRC happens to
be identical) then the data will be silently corrupted.

A full replace of the removed device would be better than a scrub,
as that will get a known good copy of the data.

If the device is offline for a long time, it should be wiped before being
reintroduced to the rest of the array to avoid data integrity issues.

It may be necessary to specify a different device name when mounting
a filesystem that has had a disk removed and later reinserted until
the scrub or replace action above is completed.

btrfs has no optimization like mdadm write-intent bitmaps; recovery
is always a full-device operation.  In theory btrfs could track
modifications at the chunk level but this isn't even specified in the
on-disk format, much less implemented.

>   - If an error is found (e.g. silent data corruption based on csums),
>     when will it repair&fix (fix =3D write the repaired data) the data?
>     On the read that finds the bad data?
>     Only on scrub (i.e. do users need to regularly run scrubs)?=20

Both cases.  All RAID levels with redundancy are supposed to support it.

I'm not sure if current raid5/6 do (but I think they do as of 4.15?).

>   - What happens if error cannot be repaired, e.g. no csum information
>     or all blocks bad?
>     EIO? Or are there cases where it gives no EIO (I guess at least in
>     nodatacow case)

If the operation can be completed with redundant devices, then btrfs
continues without reporting the error to userspace.  Device statistics
counters are incremented and kernel log messages are emitted.

If the operation cannot be completed (no redundancy or all redundant
disks also fail), then the following happens:

If there's no csum, the data is not checked, so it can be corrupted
without detection.  If there's a read error it's EIO regardless of csums.

If the unreadable block is data, userspace gets EIO.  If it's metadata,
userspace gets EIO on reads, and the FS goes read-only on writes.

Note that metadata writes usually imply dependent metadata reads (e.g.
to find free space to perform a write), so a metadata read error can
also make the filesystem go read-only if it occurs during a userspace
write operation.

>     And if the repaired block is written, will it be immediately
>     checked again (to find cases of blocks that give different results
>     again)?

No, just one write.  The write error is not reported to userspace in the
repair case (only to kernel log and device stats counters).  The repair
write would be expected to fail in some cases (e.g. total disk failure)
and the original read/write operation can continue with the other device.

>   - Will a scrub check only the data on "one" device... or will it
>     check all the copies (or parity blocks) on all devices in the raid?

Scrub checks all devices if you give it a mount point.  If you give
scrub a device it checks only that device.

>   - Does a balance implicitly contain a scrub?

No, balance and scrub are separate tools with separate purposes.

Balance would read only enough drives to be able to read all data, and
also writes all blocks and does metadata updates.  This makes it orders
of magnitude slower than a scrub, and also puts heavy write and seek
stress on the devices.  Balance also aborts on the first unrecoverable
read error.

Scrub reads data from every drive and doesn't write anything except as
required to repair.  Scrub continues until all data is processed and gives
statistics on failure counts.  Scrub runs at close to hardware speeds
because it read data sequentially and writes minimally.  Scrub is also
well-behaved wrt ionice.

Balance may be equivalent to "resilvering" except that balance moves
data around the disk while resilvering just overwrites the data in the
original location.

>   - If a rebuild/repair/reshape is performed... can these be
>     interrupted? What if they are forcibly interrupted (power loss)?

Device delete and device shrink can only be interrupted by rebooting.
They do not restart on reboot, and the filesystem size will revert to
its original value on reboot.  If the operation is restarted manually,
it will not have to repeat data relocation work that was already done.

RAID conversion by balance will resume automatically on boot unless
skip_balance mount option is used.

If the balance is not resumed, or it is cancelled part way through a RAID
conversion, the RAID profile used to write new data will be one of the
existing RAID profiles on the disk chosen at random.  e.g. if you convert
data from raid5 to raid0 and metadata from raid1 to dup, and cancel the
balance part way through, future data will be either raid5 or raid0,
and future metadata will be either raid1 or dup.  If the conversion is
completed (i.e. there is only one RAID level present on the filesystem)
then only one profile is used.

Device replace is aborted by reboots and you have to start over (I
think...I've never interrupted one myself, so I'm not sure on this point).

All of these will make the next mount take some extra minutes to complete
if they were interrupted by a reboot.  Exception:  'balance' can be
'paused' before reboot, and does not trigger the extra delay on the
next mount.

>   - Best practices, like: should one do regular balances (and if so, as
>     asked above, do these include the scrubs, so basically: is it
>     enough to do one of them)

Both need to be done on different schedules.

Balance needs to be done when unallocated space gets low on the minimum
number of disks for the raid profile (e.g. for raid6, you need unallocated
space on at least 3 disks).  Once unallocated space is available (at least
1GB per disk, possibly more if the filesystem is very active), the balance
can be cancelled, or a script can loop with a small value of 'limit'
and simply stop looping when unallocated space is available.

Normally it is not necessary to balance metadata, only data.  Any space
that becomes allocated to metadata should be left alone and not reclaimed.
If the filesystem runs out of metadata space _and_ there is no unallocated
space available, the filesystem will become read-only.

If you are using the 'ssd_spread' option, and you don't have a very good
reason why, stop using the ssd_spread option.  If you do have a good
reason, you'll need to run balances much more often, and possibly balance
metadata as well as data.

Unallocated space is not free space.  Free space is space in the
filesystem you can write data to.  Unallocated space is space on a disk
you can make RAID block groups out of.

Scrub needs to be done after every unclean shutdown and also at periodic
intervals to detect latent faults.  The exact schedule depends on the
fault detection latency required (once a month is a good start, once a
week is paranoid, once a day is overkill).

>   - How to grow/shrink raid btrfs... and if this is done... how to
>     replicate the data already on the fs to the newly added disks (or
>     is this done automatically - and if so, how to see that it's
>     finished)?

btrfs dev add/del to add or remove entire devices.

btrfs fi resize grows or shrinks individual devices ('device delete'
is really 'resize <dev>:0' followed by 'remove empty device' internally).

I generally run resize with small negative increments in a loop until
the device I want to delete has only a few GB of data left, then run
delete, rather than running delete on a full device.  This presents more
opportunities to abort without rebooting.

btrfs balance 'convert' option changes RAID levels.

btrfs fi usage and btrfs dev usage will indirectly report on the progress
of deletes and resizes (in that they will show the amount of space still
occupied on the deleted disks).  They report how much data is stored at
each RAID level so they effectively report on the progress of RAID
level conversions too.

btrfs balance status will report on the progress of raid conversions.

>   - What will actually trigger repairs? (i.e. one wants to get silent
>     block errors fixed ASAP and not only when the data is read - and
>     when it's possibly to late)

Reading bad blocks triggers repairs.  Scrub is an efficient way to read
all the blocks on all devices in the filesystem.

>   - Is there anything to notice when btrfs raid is placed above dm-
>     crypt from a security PoV?
>     With MD raid that wasn't much of a problem as it's typically placed
>     below dm-crypt... but btrfs raid would need to be placed above it.
>     So maybe there are some known attacks against crypto modes, if
>     equal (RAID 1 / 10) or similar/equal (RAID 5/6) data is written
>     above multiple crypto devices? (Probably something one would need
>     to ask their experts).

It's probably OK (i.e. no more or less vulnerable than a single dm-crypt
filesystem) to set up N dm-crypt devices with the same passphrase but
different LUKS master keys, i.e. run luksFormat N times, then run btrfs
raid on top of that.

Setting up one dm-crypt device and replicating its header (so the master
key is the same) is probably vulnerable to attacks that a single-disk
filesystem is not.

> - Maintenance tools
>   - How to get the status of the RAID? (Querying kernel logs is IMO
>     rather a bad way for this)
>     This includes:
>     - Is the raid degraded or not?

Various tools will report "missing" drives.

You can't mount a degraded array without a special mount option.
The option is ignored for non-degraded arrays, so you can use the option
for root filesystems while not using it for data filesystems with a
higher standard of integrity required.

An array with broken drives will likely have an extremely high number
of errors reported in 'btrfs dev stats.'

>     - Are scrubs/repairs/rebuilds/reshapes in progress and how far are
>       they? (Reshape would be: if the raid level is changed or the raid
>       grown/shrinked: has all data been replicated enough to be
>       "complete" for the desired raid lvl/number of devices/size?

scrub and balance have detailed status subcommands.

device delete and filesystem resize do not.  The progress can be inferred
by examining per-device space usage.

>    - What should one regularly do? scrubs? balance? How often?

Scrub frequency depends on your site's fault detection latency
requirements.  If you don't have those, do a scrub every month on
NAS/enterprise drives, every week on desktop/green/cheap drives.

See above for balance recommendation.

Read 'btrfs dev stats' output regularly and assess the health of the
hardware when any counter changes.

>      Do we get any automatic (but configurable) tools for this?

'cron' is sufficient in most cases.

[questions I can't answer removed]
>=20
> Cheers,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWr1fkAAKCRCB+YsaVrMb
nFZvAJ4mTEAbR09mg1e0viZpBb00Y1/eGwCeNoML3rBC4F2WNdMkiSAf2oPRFYM=
=6sMG
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
