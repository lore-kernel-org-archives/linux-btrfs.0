Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49182 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaDEWDJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 18:03:09 -0400
Date: Sat, 5 Apr 2014 23:02:53 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: cwillu <cwillu@cwillu.com>
Cc: Marc MERLIN <marc@merlins.org>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Message-ID: <20140405220253.GU7442@carfax.org.uk>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com>
 <20140404184620.GA12124@merlins.org>
 <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yRXsXhSYq7voLSEz"
In-Reply-To: <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yRXsXhSYq7voLSEz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2014 at 04:00:27PM -0600, cwillu wrote:
> On Fri, Apr 4, 2014 at 12:46 PM, Marc MERLIN <marc@merlins.org> wrote:
> > On Wed, Apr 02, 2014 at 04:29:35PM +0800, Qu Wenruo wrote:
> >> Convert man page for btrfs-zero-log
> >>
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >> ---
> >>  Documentation/Makefile           |  2 +-
> >>  Documentation/btrfs-zero-log.txt | 39 +++++++++++++++++++++++++++++++=
++++++++
> >>  2 files changed, 40 insertions(+), 1 deletion(-)
> >>  create mode 100644 Documentation/btrfs-zero-log.txt
> >>
> >> diff --git a/Documentation/Makefile b/Documentation/Makefile
> >> index e002d53..de06629 100644
> >> --- a/Documentation/Makefile
> >> +++ b/Documentation/Makefile
> >> @@ -11,7 +11,7 @@ MAN8_TXT +=3D btrfs-image.txt
> >>  MAN8_TXT +=3D btrfs-map-logical.txt
> >>  MAN8_TXT +=3D btrfs-show-super.txt
> >>  MAN8_TXT +=3D btrfstune.txt
> >> -#MAN8_TXT +=3D btrfs-zero-log.txt
> >> +MAN8_TXT +=3D btrfs-zero-log.txt
> >>  #MAN8_TXT +=3D fsck.btrfs.txt
> >>  #MAN8_TXT +=3D mkfs.btrfs.txt
> >>
> >> diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-ze=
ro-log.txt
> >> new file mode 100644
> >> index 0000000..e3041fa
> >> --- /dev/null
> >> +++ b/Documentation/btrfs-zero-log.txt
> >> @@ -0,0 +1,39 @@
> >> +btrfs-zero-log(8)
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +NAME
> >> +----
> >> +btrfs-zero-log - clear out log tree
> >> +
> >> +SYNOPSIS
> >> +--------
> >> +'btrfs-zero-log' <dev>
> >> +
> >> +DESCRIPTION
> >> +-----------
> >> +'btrfs-zero-log' will remove the log tree if log tree is corrupt, whi=
ch will
> >> +allow you to mount the filesystem again.
> >> +
> >> +The common case where this happens has been fixed a long time ago,
> >> +so it is unlikely that you will see this particular problem.
> >
> > A note on this one: this can happen if your SSD rites things in the
> > wrong order or potentially writes garbage when power is lost, or before
> > locking up.
> > I hit this problem about 10 times and it wasn't a btrfs bug, just the
> > drive doing bad things.
>=20
> And -o recovery didn't work around it?  My understanding is that -o
> recovery will skip reading the log.

   No, I'm pretty sure we've had people with problems with the log
where -orecovery didn't help, but -oro,recovery allowed it to be
mounted, because -ro didn't try to replay the log.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- If the first-ever performance is the premi=E8re,  is the ---    =
=20
                  last-ever performance the derri=E8re?                  =
=20

--yRXsXhSYq7voLSEz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0B9jVheFHXiqx3kAQJmJRAAnCi2GNi1T/k7slYrP5bg9OGFgV4UbTyy
r5YWwkFoiARH7K9wZOJEoXa8JLTgbo31rYT0hrtB1mMUUH7CCQCZfDN2r3ntaCbA
145lIpiO0Ar3GMVNXzRXDWn0e51ooQTx9wd4XGLkHc9qWoKYKrouoWO57aVfwX0a
Eiv2ESY+I6FELSjCwX02SG2dwLXGa5surn5IJoDE1DrZSIace7O6v5AvLhzg5Smv
RP2aFmvvl7cPnfwiPNHTnD34L6PQwLDhS58LghcLud08Wt6k1Fw3Rh/5nuyUM/fX
zJXrbwkUNwqkG5xRM+94SkDDSSQwDEX3E1kc3sw5ECpECZV7biaDQbtdWTlSGBzX
7e3bE4H13LH5QVSAy4NnMtQuBpt1FszQ6VRmN3qfmmNho3O0VHsTEjE6zOpQW8pb
nGpEelZqvn6R7r7mjG85YW5mIOV9Ekj3dQRSdI5U9Kvi2vzx+cZOlX4Vd11zpMsr
00SqnQDgPXW8F5UPEkmJTwBmGCY98giEK9z8ZdMqX0zTu6sbBbIngO5zFZ0f4VJA
UHb40OUJA4nUOlozSMMsJUdoaVPdT4RxSrVj7tL1ECYKhBSWME0GyX1E1XHMmCom
C6uEZ1j+i9sQI6H6SI7Y5JtLr1JsdIjYaGmBCftkiE4TV4URohyTXuFv/IVUX5az
3ZeL+Jp+WAM=
=LnIO
-----END PGP SIGNATURE-----

--yRXsXhSYq7voLSEz--
