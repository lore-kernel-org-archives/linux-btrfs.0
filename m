Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46116 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750890AbeDDGCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 02:02:23 -0400
Date: Wed, 4 Apr 2018 02:01:02 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180404060101.GK2446@hungrycats.org>
References: <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org>
 <20180403003102.GI2446@hungrycats.org>
 <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
 <20180403225742.GJ2446@hungrycats.org>
 <cfae662a-d64d-6fd8-9ca3-9892fc349747@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
In-Reply-To: <cfae662a-d64d-6fd8-9ca3-9892fc349747@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2018 at 07:15:54AM +0200, Goffredo Baroncelli wrote:
> On 04/04/2018 12:57 AM, Zygo Blaxell wrote:
> >> I have to point out that in any case the extent is physically
> >> interrupted at the disk-stripe size. Assuming disk-stripe=3D64KB, if
> >> you want to write 128KB, the first half is written in the first disk,
> >> the other in the 2nd disk.  If you want to write 96kb, the first 64
> >> are written in the first disk, the last part in the 2nd, only on a
> >> different BG.
> > The "only on a different BG" part implies something expensive, either
> > a seek or a new erase page depending on the hardware.  Without that,
> > nearby logical blocks are nearby physical blocks as well.
>=20
> In any case it happens on a different disk

No it doesn't.  The small-BG could be on the same disk(s) as the big-BG.

> >> So yes there is a fragmentation from a logical point of view; from a
> >> physical point of view the data is spread on the disks in any case.
>=20
> > What matters is the extent-tree point of view.  There is (currently)
> > no fragmentation there, even for RAID5/6.  The extent tree is unaware
> > of RAID5/6 (to its peril).
>=20
> Before you pointed out that the non-contiguous block written has
> an impact on performance. I am replaying  that the switching from a
> different BG happens at the stripe-disk boundary, so in any case the
> block is physically interrupted and switched to another disk

The difference is that the write is switched to a different local address
on the disk.

It's not "another" disk if it's a different BG.  Recall in this plan
there is a full-width BG that is on _every_ disk, which means every
small-width BG shares a disk with the full-width BG.  Every extent tail
write requires a seek on a minimum of two disks in the array for raid5,
three disks for raid6.  A tail that is strip-width minus one will hit
N - 1 disks twice in an N-disk array.

> However yes: from an extent-tree point of view there will be an increase
> of number extents, because the end of the writing is allocated to
> another BG (if the size is not stripe-boundary)
>=20
> > If an application does a loop writing 68K then fsync(), the multiple-BG
> > solution adds two seeks to read every 68K.  That's expensive if sequent=
ial
> > read bandwidth is more scarce than free space.
>=20
> Why you talk about an additional seeks? In any case (even without the
> additional BG) the read happens from another disks

See above:  not another disk, usually a different location on two or
more of the same disks.

> >> * c),d),e) are applied only for the tail of the extent, in case the
> > size is less than the stripe size.
> >=20
> > It's only necessary to split an extent if there are no other writes
> > in the same transaction that could be combined with the extent tail
> > into a single RAID stripe.  As long as everything in the RAID stripe
> > belongs to a single transaction, there is no write hole
>=20
> May be that a more "simpler" optimization would be close the transaction
> when the data reach the stripe boundary... But I suspect that it is
> not so simple to implement.

Transactions exist in btrfs to batch up writes into big contiguous extents
already.  The trick is to _not_ do that when one transaction ends and
the next begins, i.e. leave a space at the end of the partially-filled
stripe so that the next transaction begins in an empty stripe.

This does mean that there will only be extra seeks during transaction
commit and fsync()--which were already very seeky to begin with.  It's
not necessary to write a partial stripe when there are other extents to
combine.

So there will be double the amount of seeking, but depending on the
workload, it could double a very small percentage of writes.

> > Not for d.  Balance doesn't know how to get rid of unreachable blocks
> > in extents (it just moves the entire extent around) so after a balance
> > the writes would still be rounded up to the stripe size.  Balance would
> > never be able to free the rounded-up space.  That space would just be
> > gone until the file was overwritten, deleted, or defragged.
>=20
> If balance is capable to move the extent, why not place one near the
> other during a balance ? The goal is not to limit the the writing of
> the end of a extent, but avoid writing the end of an extent without
> further data (e.g. the gap to the stripe has to be filled in the
> same transaction)

That's plan f (leave gaps in RAID stripes empty).  Balance will repack
short extents into RAID stripes nicely.

Plan d can't do that because plan d overallocates the extent so that
the extent fills the stripe (only some of the extent is used for data).
Small but important difference.

> BR
> G.Baroncelli
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsRqGQAKCRCB+YsaVrMb
nK58AJ9ZZUY/t1RfLzADm9xcmgHnc1h8lwCgiLAI8fIMYkh8fzYmRmaqTfxMcpU=
=lSSN
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--
