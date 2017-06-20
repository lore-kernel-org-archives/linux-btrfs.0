Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40793 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFTP1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 11:27:04 -0400
Date: Tue, 20 Jun 2017 08:26:48 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170620152648.GB22987@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
In-Reply-To: <20170620152354.GD7140@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2017 at 03:23:54PM +0000, Hugo Mills wrote:
> On Tue, Jun 20, 2017 at 07:39:16AM -0700, Marc MERLIN wrote:
> > My filesystem got remounted read only, and yet after a lengthy
> > btrfs check --repair, it ran clean.
> >=20
> > Any idea what went wrong?
> > [846332.992285] WARNING: CPU: 4 PID: 4095 at fs/btrfs/free-space-cache.=
c:1476 tree_insert_offset+0x78/0xb1
> > [846333.744721] BTRFS critical (device dm-1): unable to add free space =
:-17
> > [847312.529660] BTRFS: Transaction aborted (error -17)
> > [847313.218391] BTRFS: error (device dm-1) in btrfs_run_delayed_refs:29=
61: errno=3D-17 Object already exists
>=20
>    Error 17 is EEXIST, so I'd guess (and it is a guess) that it's
> trying to add a free space cache record for some space that already
> has such a record. This might also match with:
=20
Thanks for having a look. Is it a bug, or is it a problem with my storage
subsystem?

> [...]
> > gargamel:~# btrfs check --repair /dev/mapper/dshelf2
> [...]
> > cache and super generation don't match, space cache will be invalidated
> [...]
>=20
>    I'd try clearing the cache (mount with -o clear_cache, once), and
> then letting it rebuild.

"space cache will be invalidated " =3D> doesn't that mean that my cache was
already cleared by check --repair, or are you saying I need to clear it
again?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQCVAwUBWUk+uH4xUKZ2O+kBAQKxUQP/fGC2hmGYUbLkEvXfbIi5B5FhhXz1uDd6
O8J9CR9kn5PshArASHMhzF+rOLYfOxUhiNbjZOsmgkCI6Hb/pO/H/pbugs1j4/jo
5M1oaZsZy0mQArGklen2fSZQD31MlHzdoU1QBoyQ4WakRibsjrggwPXFLJHjNkbw
wrChZZ+0yHY=
=ae8r
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
