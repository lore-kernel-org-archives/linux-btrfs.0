Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45940 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752984AbeDADps (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 23:45:48 -0400
Date: Sat, 31 Mar 2018 23:45:46 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180401034544.GA28769@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 31, 2018 at 04:34:58PM -0600, Chris Murphy wrote:
> On Sat, Mar 31, 2018 at 12:57 AM, Goffredo Baroncelli
> <kreijack@inwind.it> wrote:
> > On 03/31/2018 07:03 AM, Zygo Blaxell wrote:
> >>>> btrfs has no optimization like mdadm write-intent bitmaps; recovery
> >>>> is always a full-device operation.  In theory btrfs could track
> >>>> modifications at the chunk level but this isn't even specified in the
> >>>> on-disk format, much less implemented.
> >>> It could go even further; it would be sufficient to track which
> >>> *partial* stripes update will be performed before a commit, in one
> >>> of the btrfs logs. Then in case of a mount of an unclean filesystem,
> >>> a scrub on these stripes would be sufficient.
> >
> >> A scrub cannot fix a raid56 write hole--the data is already lost.
> >> The damaged stripe updates must be replayed from the log.
> >
> > Your statement is correct, but you doesn't consider the COW nature of b=
trfs.
> >
> > The key is that if a data write is interrupted, all the transaction is =
interrupted and aborted. And due to the COW nature of btrfs, the "old state=
" is restored at the next reboot.
> >
> > What is needed in any case is rebuild of parity to avoid the "write-hol=
e" bug.
>=20
> Write hole happens on disk in Btrfs, but the ensuing corruption on
> rebuild is detected. Corrupt data never propagates.=20

Data written with nodatasum or nodatacow is corrupted without detection
(same as running ext3/ext4/xfs on top of mdadm raid5 without a parity
journal device).

Metadata always has csums, and files have checksums if they are created
with default attributes and mount options.  Those cases are covered,
any corrupted data will give EIO on reads (except once per 4 billion
blocks, where the corrupted CRC matches at random).

> The problem is that Btrfs gives up when it's detected.

Before recent kernels (4.14 or 4.15) btrfs would not attempt all possible
combinations of recovery blocks for raid6, and earlier kernels than
those would not recover correctly for raid5 either.  I think this has
all been fixed in recent kernels but I haven't tested these myself so
don't quote me on that.

Other than that, btrfs doesn't give up in the write hole case.
It rebuilds the data according to the raid5/6 parity algorithm, but
the algorithm doesn't produce correct data for interrupted RMW writes
when there is no stripe update journal.  There is nothing else to try
at that point.  By the time the error is detected the opportunity to
recover the data has long passed.

The data that comes out of the recovery algorithm is a mixture of old
and new data from the filesystem.  The "new" data is something that
was written just before a failure, but the "old" data could be data
of any age, even a block of free space, that previously existed on the
filesystem.  If you bypass the EIO from the failing csums (e.g. by using
btrfs rescue) it will appear as though someone took the XOR of pairs of
random blocks from the disk and wrote it over one of the data blocks
at random.  When this happens to btrfs metadata, it is effectively a
fuzz tester for tools like 'btrfs check' which will often splat after
a write hole failure happens.

> If it assumes just a bit flip - not always a correct assumption but
> might be reasonable most of the time, it could iterate very quickly.

That is not how write hole works (or csum recovery for that matter).
Write hole producing a single bit flip would occur extremely rarely
outside of contrived test cases.

Recall that in a write hole, one or more 4K blocks are updated on some
of the disks in a stripe, but other blocks retain their original values
=66rom prior to the update.  This is OK as long as all disks are online,
since the parity can be ignored or recomputed from the data blocks.  It is
also OK if the writes on all disks are completed without interruption,
since the data and parity eventually become consistent when all writes
complete as intended.  It is also OK if the entire stripe is written at
once, since then there is only one transaction referring to the stripe,
and if that transaction is not committed then the content of the stripe
is irrelevant.

The write hole error event is when all of the following occur:

	- a stripe containing committed data from one or more btrfs
	transactions is modified by raid5/6 RMW update in a new
	transaction.  This is the usual case on a btrfs filesystem
	with the default, 'nossd' or 'ssd' mount options.

	- the write is not completed (due to crash, power failure, disk
	failure, bad sector, SCSI timeout, bad cable, firmware bug, etc),
	so the parity block is out of sync with modified data blocks
	(before or after, order doesn't matter).

	- the array is alredy degraded, or later becomes degraded before
	the parity block can be recomputed by a scrub.

Users can run scrub immediately after _every_ unclean shutdown to
reduce the risk of inconsistent parity and unrecoverable data should
a disk fail later, but this can only prevent future write hole events,
not recover data lost during past events.

If one of the data blocks is not available, its content cannot be
recomputed from parity due to the inconsistency within the stripe.
This will likely be detected as a csum failure (unless the data block
is part of a nodatacow/nodatasum file, in which case corruption occurs
but is not detected) except for the one time out of 4 billion when
two CRC32s on random data match at random.

If a damaged block contains btrfs metadata, the filesystem will be
severely affected:  read-only, up to 100% of data inaccessible, only
recovery methods involving brute force search will work.

> Flip bit, and recompute and compare checksum. It doesn't have to
> iterate across 64KiB times the number of devices. It really only has
> to iterate bit flips on the particular 4KiB block that has failed csum
> (or in the case of metadata, 16KiB for the default leaf size, up to a
> max of 64KiB).

Write hole is effectively 32768 possible bit flips in a 4K block--assuming
only one block is affected, which is not very likely.  Each disk in an
array can have dozens of block updates in flight when an interruption
occurs, so there can be millions of bits corrupted in a single write
interruption event (and dozens of opportunities to encounter the nominally
rare write hole itself).

An experienced forensic analyst armed with specialized tools, a database
of file formats, and a recent backup of the filesystem might be able to
recover the damaged data or deduce what it was.  btrfs, being only mere
software running in the kernel, cannot.

There are two ways to solve the write hole problem and this is not one
of them.

> That's a maximum of 4096 iterations and comparisons. It'd be quite
> fast. And going for two bit flips while a lot slower is probably not
> all that bad either.

You could use that approach to fix a corrupted parity or data block
on a degraded array, but not a stripe that has data blocks destroyed
by an update with a write hole event.  Also this approach assumes that
whatever is flipping bits in RAM is not in and of itself corrupting data
or damaging the filesystem in unrecoverable ways, but most RAM-corrupting
agents in the real world do not limit themselves only to detectable and
recoverable mischief.

Aside:  As a best practice, if you see one-bit corruptions on your
btrfs filesystem, it is time to start replacing hardware, possibly also
finding a new hardware vendor or model (assuming the corruption is coming
=66rom hardware, not a kernel memory corruption bug in some random device
driver).  Healthy hardware doesn't do bit flips.  So many things can go
wrong on unhealthy hardware, and they aren't all detectable or fixable.
It's one of the few IT risks that can be mitigated by merely spending
money until the problem goes away.

> Now if it's the kind of corruption you get from a torn or misdirected
> write, there's enough corruption that now you're trying to find a
> collision on crc32c with a partial match as a guide. That'd take a
> while and who knows you might actually get corrupted data anyway since
> crc32c isn't cryptographically secure.

All the CRC32 does is reduce the search space to for data recovery
=66rom 32768 bits to 32736 bits per 4K block.  It is not possible to
brute-force search a 32736-bit space (that's two to the power of 32736
possible combinations), and even if it was, there would be no way to
distinguish which of billions of billions of billions of billions...[over
4000 "billions of" deleted]...of billions of possible data blocks that
have a matching CRC is the right one.  A SHA256 as block csum would only
reduce the search space to 32512 bits.

Our forensic analyst above could reduce the search space to a manageable
size for a data-specific recovery tool, but we can't put one of those
in the kernel.

Getting corrupted data out of a brute force search of multiple bit
flips against a checksum is not just likely--it's certain, if you can
even run the search long enough to get a result.  The number of corrupt
4K blocks with correct CRC outnumbers the number of correct blocks by=20
ten thousand orders of magnitude.

It would work with a small number of bit flips because of the properties
of the CRC32 function is that it reliably detects errors with length
shorter than the polynomial.

>=20
> --=20
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsBV5AAKCRCB+YsaVrMb
nKpuAJ99Bk9n9coMmwUHRDghNsDNNqM8MACgjpWVZVMfODsTTz3yDxhHtMbsxsE=
=mkxX
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
