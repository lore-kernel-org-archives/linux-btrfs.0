Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41163 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdFTPoz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 11:44:55 -0400
Date: Tue, 20 Jun 2017 08:44:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170620154429.GC22987@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
In-Reply-To: <20170620153601.GE7140@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2017 at 03:36:01PM +0000, Hugo Mills wrote:
> > Thanks for having a look. Is it a bug, or is it a problem with my stora=
ge
> > subsystem?
>=20
>    Well, I'd say it's probably a problem with some inconsistent data
> on the disk. How that data got there is another matter -- it may be
> due to a bug which wrote the inconsistent data some time ago, and has
> only now been found out.
=20
Understood.

> > "space cache will be invalidated " =3D> doesn't that mean that my cache=
 was
> > already cleared by check --repair, or are you saying I need to clear it
> > again?
>=20
>    I'm never quite sure about that one. :)
>=20
>    It can't hurt to clear it manually as well.

Sounds good, done.

In the meantime, I ran into this again:
https://bugzilla.kernel.org/show_bug.cgi?id=3D195863
btrfs check of a big filesystem kills the kernel due to OOM (but btrfs user=
space is not OOM killed)

Is it achievable at all for btrfs check to realize that it's taking all the
available RAM in kernel space, is about to crash the system, and cancel the
check before the system crashes?
I've already confirmed that it doesn't use swap. I've just had to order new
RAM to upgrade my machine from 24GB to 32GB, but 32GB is max for that
hardware, so hopefully the lowmem repair stuff will work before I hit the
32GB limit next time.

In the meantime, though, it really shouldn't crash your system (potentially
causing more damage in the process because you end up with an unclean
shutdown).
Can anyone look at this?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQCVAwUBWUlC3X4xUKZ2O+kBAQLzDAQAzLZd9QS96Tdnm0SKgarind+hnWUB3YyY
fmeOyIKkeEs1w6hIN1XRIBwwn04bQodVLIRJeoiWy9/i49W43qqFLwMku0OfxJ1q
JeQoZ1bD3ccXx0nlam3ju6ACVuLrJaLLXYvYLtLs4p3SWzuj8HCotvVMeicUkZ1s
60SV7hnjJHY=
=wZyn
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
