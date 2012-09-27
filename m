Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44378 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2I0LKC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:02 -0400
Date: Thu, 27 Sep 2012 12:09:57 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRF - Storage Usage
Message-ID: <20120927110957.GC6136@carfax.org.uk>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
In-Reply-To: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bAmEntskrkuBymla
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 12:44:27PM +0200, S=E9bastien Maury wrote:
> I've installed a new server using btrfs for my root partition ("/").
>=20
> It uses snapper for snapshots management and all seems to work pretty fin=
e.
>=20
> My problem is to be able to know the remaining REAL free space in my =20
> partition.

   This is in the FAQ: https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_=
there_so_many_ways_to_check_the_amount_of_free_space.3F

   Short answer: you can't know in general.

   Longer answer -- see below.

> Using different commands, i have different results, and i don't know =20
> how to interpret them correctly :

> poivron:~ # btrfs filesystem show /dev/sda3
> Label: none  uuid: 9e68b667-f9f9-490f-9da1-ae4e91558212
>          Total devices 1 FS bytes used 2.58GB
>          devid    1 size 131.64GB used 10.04GB path /dev/sda3

   You have 131.64 GiB of raw storage in your filesystem. Of that,
10.04 GiB is currently allocated for use by the FS (and it will take
more as it needs it).

> poivron:~ # btrfs filesystem df /
> Data: total=3D4.01GB, used=3D2.16GB

   4.01 GiB of the 10.04 GiB allocation is assigned for use by data,
and 2.16 GiB of that allocation actually contains data.

> System, DUP: total=3D8.00MB, used=3D4.00KB

   16 MiB (=3D2*8.00 MiB) of the 10.04 GiB allocation is assigned for
use as two copies of the system data. There is 4 KiB of system data
actually used.

> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D3.00GB, used=3D429.16MB

   6 GiB (=3D2*3.00 GiB) of your 10.04 GiB allocation is assigned for
use as metadata, with two copies (DUP) being kept. 429.16 MiB of the
3.00 GiB is currently in use.

> Metadata: total=3D8.00MB, used=3D0.00

> poivron:~ #  df -hP /
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda3       132G  3.0G  124G   3% /

   Plain old df can't handle the truth, so this is at best only a hint
at what's actually happening. When "Avail" reaches zero, your FS is
probably full. Other than that, you can't necessarily say very much.

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Please help me understand and interpret those information to know the =20
> most accurately as possible what is my real remaining space, and what =20
> space is used by what.
>=20
> Although, i don't really understand the output of the command "btrfs =20
> filesystem df /" : what are exactly "Data", "System DUP", "System =20
> total", "Metadata DUP" and "Metadata total" ?

   This should all be covered in the glossary on the website:
https://btrfs.wiki.kernel.org/index.php/Glossary

   Data is the contents of your files. Metadata is all the other stuff
that the FS needs in order to store your files -- directory
structures, permissions, locations of the file data, that kind of
thing. System is a particular bit of the metadata (the chunk tree)
which governs an internal physical/virtual mapping, and which needs to
be read before anything else can make any kind of sense.

   DUP is a bit like RAID-1: anything stored in a DUP chunk is
actually written to two different places on the disk, and can help
recovery in the case of physical disk corruption (e.g. bad blocks,
head crash).

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Here are some complementary informations :
> poivron:~ # uname -a
> Linux poivron 3.0.26-0.7-default #1 SMP Tue Apr 17 10:27:57 UTC 2012 =20
> (3829766) x86_64 x86_64 x86_64 GNU/Linux

   You [probably(*)] need to upgrade your kernel as soon as possible.
btrfs code moves very fast, and 3.0 has significant bugs in it. You
should be running the latest released kernel -- right now, that's 3.5,
or 3.6-rc7. Next week, it will probably change to 3.6 when Linus makes
the next release. Most distributions have a repository somewhere which
will give you access to new kernels without too much trouble.

   Hugo.

(*) Some of the enterprise distributions do have backported btrfs
fixes in their apparently older kernels.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       ---   __(_'>  Squeak!   ---                      =20

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGQ0BL9z9OVl50rAAQLM0A/+M1kQEZrIE46u8U0m8ORE/IGz7OISYEm8
kd/PnMdpUtSaArnNdx0q18hlXQ+52hsTaR9Ekr6cg/YYB65uDaDpjdm06XOhx7lo
zzuAbPLtT35x8GUX2fXo3yLn9gMvJa+OeYUxQN+fOCrICk+BpgioPNDIw5Zz4x7g
ds71gtWp3UQLwRkF+2SRKCBSjTjUthwDMeBaMmQA2UE68IzxtsHPig33ajfVBBkl
qklCdAidg5V6CEPmi4CsAxnyURnKqhxtAxfIue4ZAs85NevwuiAwOarm89+FnLqa
wUMssNKq8LC92c/I7668dogc433teMqFsbh7zLcwH+IpwDlpxzcnh/7WfcSqnhBd
U3IBPG1RArLHVnpw9elzxHPAQZqBLNEtwY7T6/X/SB/vrfOjdVXtHYxI2puM1DsO
jNal+/mR4XhYnxY4ANHvdAFGYXhYRZ1TRGInonWdQHgm2nYw1SMOvrcLTOHjurFA
xtd1xFQg7Lza9jGLT766qgjSD0jZCLlH9ebj1szrdJoIQ1Oxn2O0UM0F6z8tsgM9
z1FX2paW+BHkMOq0NAvtUE9+Lt5SFsTAPu8vGOkCYM6kgnzxFSTx8tFE2ay8ViTH
OxPBne27hqQKUIWtfWQdngJ9pHT2ZwltMjcEAslCKlrUtML5J/v33uGRnwxUwVhR
Fl3kMGeAVho=
=QlGv
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
