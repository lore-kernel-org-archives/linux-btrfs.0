Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46334 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755880AbcJLTVS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 15:21:18 -0400
Date: Wed, 12 Oct 2016 15:19:16 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012191915.GF26140@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <20161012122551.27d949ee@natsu>
 <20161012173141.GX21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
In-Reply-To: <20161012173141.GX21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 01:31:41PM -0400, Zygo Blaxell wrote:
> On Wed, Oct 12, 2016 at 12:25:51PM +0500, Roman Mamedov wrote:
> > Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
> >=20
> > > A btrfs -dsingle -mdup array on a mdadm raid[56] device might have a
> > > snowball's chance in hell of surviving a disk failure on a live array
> > > with only data losses.  This would work if mdadm and btrfs successful=
ly
> > > arrange to have each dup copy of metadata updated separately, and one
> > > of the copies survives the raid5 write hole.  I've never tested this
> > > configuration, and I'd test the heck out of it before considering
> > > using it.
> >=20
> > Not sure what you mean here, a non-fatal disk failure (i.e. within being
> > compensated by redundancy) is invisible to the upper layers on mdadm ar=
rays.
> > They do not need to "arrange" anything, on such failure from the point =
of view
> > of Btrfs nothing whatsoever has happened to the /dev/mdX block device, =
it's
> > still perfectly and correctly readable and writable.
>=20
> btrfs hurls a bunch of writes for one metadata copy to mdadm, mdadm
> forwards those writes to the disks.  btrfs sends a barrier to mdadm,
> mdadm must properly forward that barrier to all the disks and wait until
> they're all done.  Repeat the above for the other metadata copy.

I'm not even sure btrfs does this--I haven't checked precisely what
it does in dup mode.  It could send both copies of metadata to the
disks with a single barrier to separate both metadata updates from
the superblock updates.  That would be bad in this particular case.

> If that's all implemented correctly in mdadm, all is well; otherwise,
> mdadm and btrfs fail to arrange to have each dup copy of metadata
> updated separately.

To be clearer about the consequences of this:

If both copies of metadata are updated at the same time (because btrfs
and mdadm failed to get the barriers right), it's possible to have both
copies of metadata in an inconsistent (unreadable) state at the same time,
ending the filesystem.

In degraded RAID5/6 mode, all writes temporarily corrupt data, so if there
is an interruption (system crash, a disk times out, etc) in degraded mode,
one of the metadata copies will be damaged.  The damage may not be limited
to the current commit, so we need the second copy of the metadata intact
to recover from broken changes to the first copy.  Usually metadata chunks
are larger than RAID5 stripes, so this works out for btrfs on mdadm RAID5
(maybe not if two metadata chunks are adjacent and not stripe-aligned,
but that's a rare case, and one that only affects array sizes that are
not a power of 2 + 1 disk for RAID5, or power of 2 + 2 disks for RAID6).

> The present state of the disks is irrelevant.  The array could go
> degraded due to a disk failure at any time, so for practical failure
> analysis purposes, only the behavior in degraded mode is relevant.
>=20
> >=20
> > --=20
> > With respect,
> > Roman
>=20
>=20



--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf+jLMACgkQgfmLGlazG5wMtACfWYz5Jsc7ibgM2PGGbERTJ5w6
sAgAn2EZtqmIZdbQijGqI2u6DkIJLEqQ
=8USU
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
