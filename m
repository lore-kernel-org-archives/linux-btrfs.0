Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44812 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755699AbcJLRbn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 13:31:43 -0400
Date: Wed, 12 Oct 2016 13:31:41 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012173141.GX21290@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <20161012122551.27d949ee@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NJ5+aVN4Egd/eJfU"
In-Reply-To: <20161012122551.27d949ee@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NJ5+aVN4Egd/eJfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 12:25:51PM +0500, Roman Mamedov wrote:
> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>=20
> > A btrfs -dsingle -mdup array on a mdadm raid[56] device might have a
> > snowball's chance in hell of surviving a disk failure on a live array
> > with only data losses.  This would work if mdadm and btrfs successfully
> > arrange to have each dup copy of metadata updated separately, and one
> > of the copies survives the raid5 write hole.  I've never tested this
> > configuration, and I'd test the heck out of it before considering
> > using it.
>=20
> Not sure what you mean here, a non-fatal disk failure (i.e. within being
> compensated by redundancy) is invisible to the upper layers on mdadm arra=
ys.
> They do not need to "arrange" anything, on such failure from the point of=
 view
> of Btrfs nothing whatsoever has happened to the /dev/mdX block device, it=
's
> still perfectly and correctly readable and writable.

btrfs hurls a bunch of writes for one metadata copy to mdadm, mdadm
forwards those writes to the disks.  btrfs sends a barrier to mdadm,
mdadm must properly forward that barrier to all the disks and wait until
they're all done.  Repeat the above for the other metadata copy.

If that's all implemented correctly in mdadm, all is well; otherwise,
mdadm and btrfs fail to arrange to have each dup copy of metadata
updated separately.

The present state of the disks is irrelevant.  The array could go
degraded due to a disk failure at any time, so for practical failure
analysis purposes, only the behavior in degraded mode is relevant.

>=20
> --=20
> With respect,
> Roman



--NJ5+aVN4Egd/eJfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf+c30ACgkQgfmLGlazG5zwhACgps0Dm15NWJkz4e6QhM+RvUFS
3KwAoL7juH3R9mo7Q9Z4qknK3n+IOa+L
=O1oL
-----END PGP SIGNATURE-----

--NJ5+aVN4Egd/eJfU--
