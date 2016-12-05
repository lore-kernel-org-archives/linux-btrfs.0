Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63768 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbcLEOnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 09:43:19 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MVN0w-1cB1ty0166-00YlGK for
 <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 15:43:16 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: [SOLVED] Re: system hangs due to qgroups
Date: Mon, 05 Dec 2016 15:43:07 +0100
Message-ID: <4448819.RKs36le3Tk@thetick>
In-Reply-To: <29619565.vvZbx4DoIQ@thetick>
References: <1776088.42rHLKPlSp@thetick> <5f35cc2d-4c3d-b14c-01f6-4bfb0f22823b@cn.fujitsu.com> <29619565.vvZbx4DoIQ@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1864353.K2cZk1cxfk"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1864353.K2cZk1cxfk
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday 05 December 2016 12:01:28 Marc Joliet wrote:
> > This seems to be a NULL pointer bug in qgroup relocation fix.
> >
> >=20
> >
> > The latest fix (not merged yet) should address it.
> >
> >=20
> >
> > You could try the for-next-20161125 branch from David to fix it:
> > https://github.com/kdave/btrfs-devel/tree/for-next-20161125
>=20
> OK, I'll try that, thanks!  I just have to wait for it to finish clon=
ing...
>=20
[...]
> > And for your recovery, I'd suggest to install an Archlinux into a U=
SB
> > HDD or USB stick, and compile David's branch and install it into th=
e USB
> > HDD.
> >
> >=20
> >
> > Then use the USB storage as rescue tool to mount the fs, which shou=
ld do
> > RW mount with or without skip_balance mount option.
> > So you could disable quota then.
>=20
> OK, I'll try that, thanks!

Excellent, thank you, that worked!  My laptop is working normally again=
.  I'll=20
keep an eye on it, but so far two balance operations ran normally (that=
 is,=20
they completed within a few minutes and without hanging the system).

(Specifically, since I didn't find out how to get a different kernel on=
to the=20
Arch USB stick, I simply installed the kernel on my desktop, then did=20=

everything from an initramfs emergency shell, then moved the SSD back i=
nto the=20
laptop.)

Thanks, everyone!
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1864353.K2cZk1cxfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRXz7AAoJEL/Q5oYsiHj09X4P/14RuHc/WEXs8eqbKpPGb4N4
nIATTgLI2ymjYW7LDrlwdsZw/0A1alJrGsM3iBvGTouJWWTynDyQfSbjgraIzuJu
C0qbU+Mtf8YQQlpHbsx8XDYFCCHwhCN5ePd98xusQe42Fn31Bwt+yGtXJ67DNZEG
9pz2uqE3mshIx9D9zZlrTPUr+QKemj7262HOOyNWCljmhE2uh3h6ISBTghxvKKZz
sY+c1xllaG8k9Ygk+83wsfdtpY2beg7Ca7xYeY6DrtiOwG/Fiqjenmh+dNUm2283
nlzGNKTfilz1p75R9J2LOz6Zh9G1UzH+r9OdaGo+ocVpB2KR+FwwujO0fxp4ZXAn
ISbarIxRBZTwZtnGpfwQkqOMchEI/QWjBm0Fp5mttACGIGeToA4xTnZLwPTUN5l6
Zo7DJhg4mpiuAmXo9NUYTo3FE3bzukcy0yqgj+eGsXC6ItIe36zCkGrqBVhFm/Ac
Gq+NobCkT3x7buAadQSYjHF7/3a98ZJDAhDSAxDIw4oCZOLO02oCFdpmsko/zNQr
ddMTzcW4RhWJJunA7XOcfXA9Ly1aE7ZTinfIRpJAfhiZvqU6DEaZkFzB4L0F1osv
G2Tf92ZSuCKJ/DNm/cpHveyCSayycX/noB9Q+n8lCysKX6eTq4qVVCIUP0IkiZ7o
SNsqBDZTuuLcUExbnoaa
=aQQw
-----END PGP SIGNATURE-----

--nextPart1864353.K2cZk1cxfk--

