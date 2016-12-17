Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50627 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751965AbcLQJEH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 04:04:07 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0Lg0wl-1cyb181gbb-00pbre for
 <linux-btrfs@vger.kernel.org>; Sat, 17 Dec 2016 10:04:03 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-check finds file extent holes
Date: Sat, 17 Dec 2016 10:03:51 +0100
Message-ID: <2080492.0Ca6ckHrMZ@thetick>
In-Reply-To: <6935146.pedKUuRHNK@thetick>
References: <6935146.pedKUuRHNK@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1889854.mUd62f3TLF"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1889854.mUd62f3TLF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

OK, btrfs-check finished about an hour after I sent this, here's the co=
mplete=20
output:

# btrfs check /dev/sdd2      =20
Checking filesystem on /dev/sdd2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents
checking free space cache
checking fs roots
root 30634 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30635 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30636 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30657 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30746 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30747 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30764 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30834 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30835 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30915 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30916 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 30942 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31038 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31053 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31366 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31367 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31368 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31385 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31425 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31473 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31499 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31554 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31572 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31606 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31653 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 31680 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
found 904425616176 bytes used err is 1
total csum bytes: 873691128
total tree bytes: 11120295936
total fs tree bytes: 8620965888
total extent tree bytes: 1368756224
btree space waste bytes: 2415249740
file data blocks allocated: 19427350777856
 referenced 1003936649216

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1889854.mUd62f3TLF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYVP93AAoJEL/Q5oYsiHj04k4P/A1EV+7Ji7rmPzT/FSb4iHB5
dKb0KwySDz2/isEDtSO8CoXT6XMy1EZF9Fga171V/bx1uuO8HP5Wkb0OdoqPPXFc
Nnxf5eBGPzGKuPeQCFEkVEnjiyJ5Uf2iWodvKRmXqhK0Le+V93mytPqAwcd9wXu1
mJBYRUakaFE9uEQdWacdOncIMNrKRs8LHlEx/XFeC1Z0j3/QDt6f/pqph9WKV1mZ
R18m+deegzOVfrRMrodcKRbQIWNkAcaNTwoDdQwewrUxkB+KLhALSb2A9l7layVA
zvLDgfz7dfKJQvDDIllCUNHU5TkGaAEn174NKDTE29HUcvohJxT/amQGnuyVangK
dUVt0QJp51Pw3WZtFYKMf76fCQsaB8udKOf/skgSnhNpBGOKPkNGTHm83ae000VQ
oejeYsYWEzgqGqLrSY6yaGebTV3yp9gtUTr/5sn0Zsp7qFjL+Ww1i0ipPgAqTdoq
zRW6tSHjT5kQmhgxe4pxW+avojf+JDzqOE1Kwok3KGTechmmLPZbjzV9iCKgrNcx
03xJ1c+H7k21jqlpWDXS2bKkh5vmow9CPsYrTConWeBRJ0tdTErj42TUI/incsRV
OjBS9/ZjqCOkzuI9tF/gQOCiaVeAf53X/0YS+BA3iFEdMKK0ZeqMUiYSXH7lCBM/
gfFhu/fPhf58bZ+yp3bR
=grhV
-----END PGP SIGNATURE-----

--nextPart1889854.mUd62f3TLF--

