Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40777 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaKWBHp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 20:07:45 -0500
Date: Sat, 22 Nov 2014 17:07:42 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Message-ID: <20141123010742.GA16599@merlins.org>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com> <20141122222606.GO8916@merlins.org> <CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com> <20141123000503.GQ32735@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <20141123000503.GQ32735@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 23, 2014 at 12:05:04AM +0000, Hugo Mills wrote:
> > Which is correct?
>=20
>    Less than or equal to 55% full.
=20
This confuses me. Does that mean that the fullest blocks do not get
rebalanced?
I guess I was under the mistaken impression that the more data you had the
more you could be out of balance.

>    A chunk is the part of a block group that lives on one device, so
> in RAID-1, every block group is precisely two chunks; in RAID-0, every
> block group is 2 or more chunks, up to the number of devices in the
> FS. A chunk is usually 1 GiB in size for data and 250 MiB for
> metadata, but can be smaller under some circumstances.

Right. So, why would you rebalance empty chunks or near empty chunks?
Don't you want to rebalance almost full chunks first, and work you way to
less and less full as needed?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBVHEzXn4xUKZ2O+kBAQJIHQP+KHWiCEPpjqRJPGjr7HXM6H7fUAa4fMRd
J8/0yKKUxvjDVyM1g7eePAi8TT9m/uwXRMrf7bfLz6qGJksukrKx5sB10dnf3Y13
G/nx7yH1x5Da/7dnYKV/bknIxCe7WS8WgQZea6vTB6WKUUrdPWiq3uDpKdArMkCx
If9SiIp0/Lk=
=Su6+
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
