Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40887 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3IEOyK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 10:54:10 -0400
Date: Thu, 5 Sep 2013 15:54:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?utf-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on
 /dev/sdb1
Message-ID: <20130905145407.GA25694@carfax.org.uk>
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
In-Reply-To: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2013 at 05:43:27PM +0300, =D0=A2=D0=B8=D0=BC=D0=BE=D1=84=D0=
=B5=D0=B9 =D0=A2=D0=B8=D1=82=D0=BE=D0=B2=D0=B5=D1=86 wrote:
> Hello guys, i try to convert ext4 volume, but btrfs-convert show me error:
> "No valid Btrfs found on file
> unable to open ctree
> conversion aborted."
> Ubuntu 13.04
> Kernel: 3.11
> btrfs-progs git version 0.20-git20130822~194aa4a13
>=20
> way to reproduce error:
> $ truncate -s 4G file
> $ mkfs.ext4 file #say yes to create fs on non block device.
> $ btrfs-convert file
>  No valid Btrfs found on file
>  unable to open ctree
>  conversion aborted.

   I'm guessing here, but I suspect you will need to create a loopback
device so that btrfs-convert can look at it as a block device rather
than as a file:

# losetup -f --show file
/dev/loop0
# btrfs-convert /dev/loop0

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Eighth Army Push Bottles Up Germans -- WWII newspaper ---     =20
                     headline (possibly apocryphal)                     =20

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUiibDlheFHXiqx3kAQKocxAAhpwKwOj5lY7PAEXanv9POPoK+zMsj3cF
ysgsWn5ZgyUf96lFxs/StroZmEMDfcjol1AZqVW6wA2rs5Y8x72pPPwL6lhEctjY
WHWkUUMGEdwqKEkpLfun1+bCg/qpyIihwWsufnSYsKuwHaBxZ+erHH/bg2g+otZC
QlhOVh0butvu43PXnEBPjcHVpIavVYVVG//1nzZcw3SQEMf6Pygg08pJhww+4JkY
P4lz62OXXd/T/flaa7IwmhjW0IJCjUa/8MZXBPGXr32KB24O8r5BfUewJtTU4Xl/
ChyRkz2/JB51QIrry9XfMopBj3u4d3/H8g+bAqxiiD6TCOwbjVu5Bd4kAmuDGZAg
1Qd2N6ap5c0PVBvPwRNTlsihAm9kZbh3OV5R5E6aAhv+3QnF+IIr05SQZ4vcbQYy
DjljjYBhOG89sZGojoBwstpVwhN2/zAaK+xJ30CGgpbvUjz4wa4svuP4JllkxufN
YWtxOhDb6tX6gsHeEqn7EriRBha/Ph9nrmxhhzxvng3sBlvpBsvDrxFcwdFa03zi
d9V8PWm305s2ntfXj0P3R9299FvlmH+Eay3wBortAznxGIxnCYhVzI3ZJzNFRZkL
k2U5xZoCW7pX7D6iQG+N6avbuD1U6JF+RH7mr3+mUZjAjHthD+NulaK3f9XWq+H/
Eb9aaGFrJoc=
=UbSs
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
