Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56765 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaC3BEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 21:04:22 -0400
Date: Sun, 30 Mar 2014 02:04:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Lists <lists@benjamindsmith.com>, Avi Miller <avi.miller@oracle.com>,
        Johan =?iso-8859-1?Q?Kr=F6ckel?= <johan.kroeckel@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RHEL/CentOS or Debian for stable deployment
Message-ID: <20140330010408.GM7442@carfax.org.uk>
References: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
 <CF9CC748-3700-4D4F-AB96-03F27EA9C32B@oracle.com>
 <533607E1.8060202@benjamindsmith.com>
 <20140328234503.GJ7442@carfax.org.uk>
 <20140330001825.GO22552@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kc9HNjpzOXVc7FFU"
In-Reply-To: <20140330001825.GO22552@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Kc9HNjpzOXVc7FFU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 29, 2014 at 05:18:25PM -0700, Marc MERLIN wrote:
> On Fri, Mar 28, 2014 at 11:45:03PM +0000, Hugo Mills wrote:
> > On Fri, Mar 28, 2014 at 04:38:09PM -0700, Lists wrote:
> > > On 03/28/2014 02:42 PM, Avi Miller wrote:
> > > >Have you considered Oracle Linux? We are continually backporting btr=
fs fixes and enhancements to our Unbreakable Enterprise Kernel releases. On=
 Oracle Linux 6, you would run the UEK Release 3, which is based on 3.8 mai=
nline with upstream fixes. We also provide all security and bug fix errata =
for free viahttp://public-yum.oracle.com, so you don=E2=80=99t need to buy =
support to run Oracle Linux at keep up-to-date.
> > >=20
> > > Can't remember asking if btrfs is supported on 32 bit kernels?
> >=20
> >    I can't speak for Oracle's distribution, but in the general case,
> > yes, btrfs works on 32 bit systems.
> >=20
> >    On the subject of bitness, there's a couple of rough edges with
> > 64-bit kernels and 32-bit userspace. (I think there's still one ioctl
> > that fails on that configuration, but I've not hit it yet on my test
> > machine).
>=20
> btrfs send does not work with 32bit userland and 64bit kernel when I
> last tried it a few weeks ago.

> Thankfully I had debian, so I was able to upgrade just btrfs-tools to
> 64bit without upgrading my entire system, and that solved it.

   That's the one I know about and patched some weeks ago :) (it
should be in btrfs-next by now).

   Hugo.


--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- What do you give the man who has everything? -- Penicillin is --- =20
                             a good start...                            =20

--Kc9HNjpzOXVc7FFU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUzdtiFheFHXiqx3kAQKCzw//amCAQXEK3PAIxZ9o7vgOOklZCRka6rb7
HdjO0eWMMNIijsbZDEupjJGaXvHHowQbq3UUcuMb2ekT4AqCHX++PXtzwmRige9c
+ZYFzWUd8RPBJlVGQfUwx4gn5irrn8eMdPs5dBLURAO2l7BM9iGxfE4UU6Qc2OEu
OFD9bb9+TZy72hzLE8Unq1hwwLbojJyliYxg2CkdMjC01UvNhS90bNGeA4lncsal
lhnobXBKg+fKHAwfuVEYSTTZztDsTjitacvqxrXy0xjroQ3xlRpah70AMdbd/mHX
zWcANpu9B3kB65iPB+tPk+g5LCkbma2l1t3P0dtBXcpA8H70Ts/BiT2WavTmJ6ZU
UiAr5a7dlD0BnTzkqlHYSAUwo6M1f4Aejz1QSY2vZx/U+qzJOof1Wnse/No7irKZ
DQEZWy3PbCpaTPGztgt+XjmSlPMXbeTNtxzX33KpOPNjK+5nBwbIZAggC/zy8EQT
9+QaCJJwj9OLddAfHUZNansZO9O3gMW0kTQStAKri8C6KKfxW89587wyVzsXwKvq
wqLO7WFwFrEMqbNJXqNMo6RKReKth7zRVflcZkMewn14OH8RC/M3xQ332NTuX79Z
hECoH/HLaQ2ewG0h3mAXi8gJ4qBloTrybbfWlFYpYwpkE4VwskpvX6s+GGLthy6O
PlALBMzjH5Q=
=4n6G
-----END PGP SIGNATURE-----

--Kc9HNjpzOXVc7FFU--
