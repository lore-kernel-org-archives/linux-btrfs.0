Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41074 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3IEPa1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 11:30:27 -0400
Date: Thu, 5 Sep 2013 16:30:23 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: =?utf-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on
 /dev/sdb1
Message-ID: <20130905153023.GB25694@carfax.org.uk>
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
 <20130905145407.GA25694@carfax.org.uk>
 <20130905210619.65e52e23@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
In-Reply-To: <20130905210619.65e52e23@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2013 at 09:06:19PM +0600, Roman Mamedov wrote:
> On Thu, 5 Sep 2013 15:54:07 +0100
> Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
> > On Thu, Sep 05, 2013 at 05:43:27PM +0300, =D0=A2=D0=B8=D0=BC=D0=BE=D1=
=84=D0=B5=D0=B9 =D0=A2=D0=B8=D1=82=D0=BE=D0=B2=D0=B5=D1=86 wrote:
> > > Hello guys, i try to convert ext4 volume, but btrfs-convert show me e=
rror:
> > > "No valid Btrfs found on file
> > > unable to open ctree
> > > conversion aborted."
> > > Ubuntu 13.04
> > > Kernel: 3.11
> > > btrfs-progs git version 0.20-git20130822~194aa4a13
> > >=20
> > > way to reproduce error:
> > > $ truncate -s 4G file
> > > $ mkfs.ext4 file #say yes to create fs on non block device.
> > > $ btrfs-convert file
> > >  No valid Btrfs found on file
> > >  unable to open ctree
> > >  conversion aborted.
> >=20
> >    I'm guessing here, but I suspect you will need to create a loopback
> > device so that btrfs-convert can look at it as a block device rather
> > than as a file:
> >=20
> > # losetup -f --show file
> > /dev/loop0
> > # btrfs-convert /dev/loop0
> >=20
> >    Hugo.
> >=20
>=20
> Nope, just today I saw someone report the same problem in a blog comment:
> http://popey.com/blog/2013/09/02/fun-with-btrfs-on-ubuntu/#comment-9704

   It's the same person, in fact. I'd not seen that the one on popey's
blog was doing it with block devices. This does indeed look like a
fairly drastic bug...

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Is it true that "last known good" on Windows XP ---        =20
                            boots into CP/M?                            =20

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUiijj1heFHXiqx3kAQKmMRAAmMyEwYyZtu0kHsCes7AM5LMHo2cKuCjq
Q+/LRXfK8AOxA6s3l7wow1isRgwQO1BhMxsTxEbzfXi2xOqTds/5N9Jx6hur8Pqa
2RS10B7LlBJHbg1nj3w6fmc77BnRHsVtOF9gZQKOasWpWEyrSAuXdREJzVLUC0vP
d+Ge3aJw2voeprXlU6gH08FLJwwTxXfCxxf5PIN1sUXeJ1BtNcXSifaXv/wld4Us
x16AdEOIgvxF5ZfTdWiD5tHVME/4YHjIaA0m5NzAO7E6ui91iXJHnWNUZjfYql1g
IucKdmmhAxwTJYELkQEu7FhOATm3ZdGDC0h2AS6qPINJ4Htb5rybqlcPJ937iOfa
AFyP4pREz1eKcAEWlF4HxRwVoSKcV5Di1NbZycA8e8v9p2dr9BkNeThndEWNJR7p
fFAN/tqqnLA9NbAYnvg87u0TPZvT1afSvTbHkxihL3YZYJiqdInWKwXoVQnehuFV
czcNJFSE82NmLC8zAHfu+g/L1VYkaYTG9Bs/yd9hEmht8dq/3i+DmP/ed9vp8yA5
c679aGCFGQVo8cxArl60J3ViYuU0nKqMRhhoMReJPNRcVVInnqPL+PBgx7vtkIb+
uLnASfSELCvOge7jKQ4rP/w3iiJI7iG2vRrlqLzXQnHS9rTes+8rnejdfVWDdlmO
8YaibgIzZv8=
=atsQ
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
