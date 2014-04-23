Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58801 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaDWTCw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 15:02:52 -0400
Date: Wed, 23 Apr 2014 20:02:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>,
        linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Message-ID: <20140423190236.GA19513@carfax.org.uk>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
 <20140423185413.GF26949@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
In-Reply-To: <20140423185413.GF26949@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 11:54:13AM -0700, Marc MERLIN wrote:
> On Wed, Apr 23, 2014 at 08:30:08PM +0300, =D0=9F=D0=BB=D0=B0=D0=BC=D0=B5=
=D0=BD =D0=9F=D0=B5=D1=82=D1=80=D0=BE=D0=B2 wrote:
> > Can anyone boot a system using btrfs root with linux 3.14 or newer?
> >=20
> > Because I can't.
>=20
> It works fine for me.
>=20
> > I'm trying to move some 3.13.x based systems to 3.14.x and the kernel p=
anics
> > during boot. It says to append a correct root=3DsdaX partition, but the=
 one
> > provided is correct, because if use 3.13.x with the same kernel command=
 line
> > - the system boots fine.
> =20
> My guess is that you have btrfs compiled as a module, it then needs to be=
 in
> an initrd, and you either haven't built it and put it in the right place,=
 or
> grub isn't setup to load that initrd.
>=20
> > #menuentry 0
> > title Linux
> >     root (hd0,0)
> >     kernel /vmlinuz rw root=3D/dev/sda2 vga=3D6 raid=3Dnoautodetect
>=20
> That's missing an initrd. Are you absolutely certain then that btrfs is
> compiled in the kernel and not as a module?

   And the other thing to check here is that if this is a multi-device
filesystem, you need to have your initrd run "btrfs dev scan" before
trying to mount.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The glass is neither half-full nor half-empty; it is twice as --- =20
                        large as it needs to be.                        =20

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1gOS1heFHXiqx3kAQKSvw//aKVRfIeKHClFcYrz3RQj4cldnCRMtu/Z
KfgLxxCwVR/aRd8RHxtaULqkzSewt9UzW9BPXPQyv+EQQUZx4BRxIEU6JpoK3uhT
Hv1QmREJvAPo6r6pigvhrXIFh0BmOkLVwtvepZIi2XseZLLREfp+oTi2eRUVYq/R
bgP7CxfBprhp/I3Nnz5bS+vU4N+Vso4o1yrFeoNpxtPeeLrcatonpM7k/QvnR3/j
HDRvb2BmAO69q0vM8Nd+mKSxq3zvEb2gDM1dDFaI3P+5qTG+Kq3+CupCVqRInFU3
5dZmxsO+uSgBuCa4GZpricAkAUzhbc6frToAoelLHTuDgG2Ld+kACwLpRnZMl/xU
e7duRnco+8yfgYXQMgSY6n3AVOTIiAP9/4wCnV2xEIBRzNctlF7wxzPT0pvkGrPH
iizxI5z4zflQJfg7c7Og7S2gGGo/QpN6+PJSWQf2eYudXrJPjPapKL3/xsM8rmWo
ebg076el1p0NkwTi3ai3S61OGKtMlNUmuMp3RnijyR+nbdTT3GFh9uFZtBwuEdU/
PiUlWDh20UbV5j+Vdlrg6Rzd2151CCVz1Dsj/BXB1koaOWYfMzQx2a3XlFX+O3PL
CoJsod2uJy4nZXIhHu0ifiBee29oNXq3PQPTNCTpYph47MFFF69sR4by06ZjSs8h
DUVh88juKxA=
=Tmf4
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
