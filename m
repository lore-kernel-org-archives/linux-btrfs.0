Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36544 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752491AbeDBFpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Apr 2018 01:45:40 -0400
Date: Mon, 2 Apr 2018 01:45:37 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180402054521.GC28769@hungrycats.org>
References: <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
In-Reply-To: <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 01, 2018 at 03:11:04PM -0600, Chris Murphy wrote:
> (I hate it when my palm rubs the trackpad and hits send prematurely...)
>=20
>=20
> On Sun, Apr 1, 2018 at 2:51 PM, Chris Murphy <lists@colorremedies.com> wr=
ote:
>=20
> >> Users can run scrub immediately after _every_ unclean shutdown to
> >> reduce the risk of inconsistent parity and unrecoverable data should
> >> a disk fail later, but this can only prevent future write hole events,
> >> not recover data lost during past events.
> >
> > Problem is, Btrfs assumes a leaf is correct if it passes checksum. And
> > such a leaf containing EXTENT_CSUM means that EXTENT_CSUM
>=20
> means that EXTENT_CSUM is assumed to be correct. But in fact it could
> be stale. It's just as possible the metadata and superblock update is
> what's missing due to the interruption, while both data and parity
> strip writes succeeded. The window for either the data or parity write
> to fail is way shorter of a time interval, than that of the numerous
> metadata writes, followed by superblock update.=20

csums cannot be wrong due to write interruption.  The data and metadata
blocks are written first, then barrier, then superblock updates pointing
to the data and csums previously written in the same transaction.
Unflushed data is not included in the metadata.  If there is a write
interruption then the superblock update doesn't occur and btrfs reverts
to the previous unmodified data+csum trees.

This works on non-raid5/6 because all the writes that make up a
single transaction are ordered and independent, and no data from older
transactions is modified during any tree update.

On raid5/6 every RMW operation modifies data from old transactions
by creating data/parity inconsistency.  If there was no data in the
stripe from an old transaction, the operation would be just a write,
no read and modify.  In the write hole case, the csum *is* correct,
it is the data that is wrong.

> In such a case, the
> old metadata is what's pointed to, including EXTENT_CSUM. Therefore
> your scrub would always show csum error, even if both data and parity
> are correct. You'd have to init-csum in this case, I suppose.

No, the csums are correct.  The data does not match the csum because the
data is corrupted.  Assuming barriers work on your disk, and you're not
having some kind of direct IO data consistency bug, and you can read the
csum tree at all, then the csums are correct, even with write hole.

When write holes and other write interruption patterns affect the csum
tree itself, this results in parent transid verify failures, csum tree
page csum failures, or both.  This forces the filesystem read-only so
it's easy to spot when it happens.

Note that the data blocks with wrong csum from raid5/6 reconstruction
after a write hole event always belong to _old_ transactions damaged
by the write hole.  If the writes are interrupted, the new data blocks
in a RMW stripe will not be committed and will have no csums to verify,
so they can't have _wrong_ csums.  The old data blocks do not have their
csum changed by the write hole (the csum is stored on a separate tree
in a different block group) so the csums are intact.  When a write hole
event corrupts the data reconstruction on a degraded array, the csum
doesn't match because the csum is correct and the data is not.

> Pretty much it's RMW with a (partial) stripe overwrite upending COW,
> and therefore upending the atomicity, and thus consistency of Btrfs in
> the raid56 case where any portion of the transaction is interrupted.

Not any portion, only the RMW stripe update can produce data loss due
to write interruption (well, that, and fsync() log-tree replay bugs).

If any other part of the transaction is interrupted then btrfs recovers
just fine with its COW tree update algorithm and write barriers.

> And this is amplified if metadata is also raid56.

Data and metadata are mangled the same way.  The difference is the impact.

btrfs tolerates exactly 0 bits of damaged metadata after RAID recovery,
and enforces this intolerance with metadata transids and csums, so write
hole on metadata _always_ breaks the filesystem.

> ZFS avoids the problem at the expense of probably a ton of
> fragmentation, by taking e.g. 4KiB RMW and writing a full length
> stripe of 8KiB fully COW, rather than doing stripe modification with
> an overwrite. And that's because it has dynamic stripe lengths.=20

I think that's technically correct but could be clearer.

ZFS never does RMW.  It doesn't need to.  Parity blocks are allocated
at the extent level and RAID stripes are built *inside* the extents (or
"groups of contiguous blocks written in a single transaction" which
seems to be the closest ZFS equivalent of the btrfs extent concept).

Since every ZFS RAID stripe is bespoke sized to exactly fit a single
write operation, no two ZFS transactions can ever share a RAID stripe.
No transactions sharing a stripe means no write hole.

There is no impact on fragmentation on ZFS--space is allocated and
deallocated contiguously on ZFS the same way in the RAID-Z and other
profiles.  The _amount_ of space allocated is different but it is the
same number of file fragments and free space holes created.

The tradeoff is that short writes consume more space in ZFS because
the stripe width depends on contiguous write size.  There is an impact
on the data:parity ratio because every short write reduces the average
ratio across the filesystem.  Really short writes degenerate to RAID1
(1:1 data and parity blocks).

> For
> Btrfs to always do COW would mean that 4KiB change goes into a new
> full stripe, 64KiB * num devices, assuming no other changes are ready
> at commit time.

In btrfs the higher layers know nothing about block group structure.
btrfs extents are allocated in virtual address space with the RAID5/6
layer underneath.  This was a straight copy of the mdadm approach and
has all the same pitfalls and workarounds.

It is possible to combine writes from a single transaction into full
RMW stripes, but this *does* have an impact on fragmentation in btrfs.
Any partially-filled stripe is effectively read-only and the space within
it is inaccessible until all data within the stripe is overwritten,
deleted, or relocated by balance.

btrfs could do a mini-balance on one RAID stripe instead of a RMW stripe
update, but that has a significant write magnification effect (and before
kernel 4.14, non-trivial CPU load as well).

btrfs could also just allocate the full stripe to an extent, but emit
only extent ref items for the blocks that are in use.  No fragmentation
but lots of extra disk space used.  Also doesn't quite work the same
way for metadata pages.

If btrfs adopted the ZFS approach, the extent allocator and all higher
layers of the filesystem would have to know about--and skip over--the
parity blocks embedded inside extents.  Making this change would mean
that some btrfs RAID profiles start interacting with stuff like balance
and compression which they currently do not.  It would create a new
block group type and require an incompatible on-disk format change for
both reads and writes.

So the current front-runner compromise seems to be RMW stripe update
logging, which is slow and requires an incompatible on-disk format change,
but minimizes code churn within btrfs.  Stripe update logs also handle
nodatacow files which none of the other proposals do.

> So yeah, avoiding the problem is best. But if it's going to be a
> journal, it's going to make things pretty damn slow I'd think, unless
> the journal can be explicitly placed something faster than the array,
> like an SSD/NVMe device. And that's what mdadm allows and expects.

The journal isn't required for full stripe writes, so it should only
cause overhead on short writes (i.e. 4K followed by fsync(), or any
leftover blocks before a transaction commit, or writes to a nearly full
filesystem with free space fragmentation).  Those are already slow due to
the seeks that are required to implement these.  The stripe log can be
combined with the fsync log and transaction commit, so the extra IO may
not cause a significant drop in performance (making a lot of assumptions
about how it gets implemented).

>=20
>=20
> --=20
> Chris Murphy
>=20

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsHDawAKCRCB+YsaVrMb
nAfiAKDT3PahKYS5AG1B1bLn8OlP5SdLMgCfUuVt9mYACVW+VrKFSNjOTwPYhek=
=Ciq2
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
