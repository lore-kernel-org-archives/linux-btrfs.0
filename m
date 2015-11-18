Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59738 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbbKRTI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 14:08:59 -0500
Date: Wed, 18 Nov 2015 19:08:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs.tebulin@xoxy.net
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Message-ID: <20151118190857.GY24333@carfax.org.uk>
References: <564CC90F.3060703@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwlp4HDnqjg7pxzw"
In-Reply-To: <564CC90F.3060703@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rwlp4HDnqjg7pxzw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2015 at 07:53:03PM +0100, linux-btrfs.tebulin@xoxy.net wrot=
e:
> Hello there!
>=20
> I'm stumbling over this regularly. I explicitly upgraded the kernel to
> avoid this, but it still occurs me every few months:
>=20
>   $ touch foo
>   touch: =C2=BBfoo=E2=80=9C kann nicht ber=C3=BChrt werden: Auf dem Ger=
=C3=A4t ist kein
> Speicherplatz mehr verf=C3=BCgbar
>   $ sudo btrfs fi df /
>   Data, single: total=3D101.14GiB, used=3D78.99GiB
>   System, DUP: total=3D32.00MiB, used=3D16.00KiB
>   Metadata, DUP: total=3D9.00GiB, used=3D8.48GiB
>   unknown, single: total=3D512.00MiB, used=3D832.00KiB
>=20
> Whut? Why? WTF?

   Running out of metadata space, probably, although it's impossible
to tell from only this information -- see below.

>   $ uname -a
>   Linux neptun 3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8
> 10:21:08 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>=20
> dmesg is empty. Resolution is to delete a whole bunch of btrfs
> subvolumes which are produced by apt-btrfs-snapshot. I run a
>    sudo btrfs balance start -dusage=3D5 /
> afterwards as part of my regular "i have no clue what the heck is wrong
> with this; maybe it will help & mend my problem" process.
>=20
> This is annoying. Why is even btrfs own "disk free" utility lying to me?

   I't snot lying to you -- you're just not seeing the whole
story. You can't tell everything about disk usage from btrfs fi df.
You need to use btrfs fi show as well to get the full information (or
btrfs fi usage, which combines the output of both). See the FAQ[1] for
how to interpret the output.

> How to fix this? How to avoid this? How to get notified about this?

   Without seeing your btrfs fi show output, I can't say for sure, but
the usual problem in this instance is that you've got all your
available space allocated to either data or metadata, and the FS needs
more metadata space and can't allocate it. The solution is to free up
some of the data allocation, using a filtered balance. See the FAQ[2]
for how to spot the problem, and what to do about it.

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C=
_using_the_original_tools
[2] https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28=
=2E3E16GiB.29

   Hugo.

> - Ben
>=20
> P.S.: Just as user feedback: For /srv I'm using on the very same system
> ZFS since the very first day. With snapshots & all the fancy stuff like
> ZRAID-1, lz4, ... My number of Issues there: 0
>=20

--=20
Hugo Mills             | Close enough for government work.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--rwlp4HDnqjg7pxzw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWTMzIAAoJEFheFHXiqx3kgNMP/0zHDObP0JQdXjgph65kdQAU
caUueCk+r7Lz/ohdGDeG3Lanfu2AA5LwmIOO3wo27Mz5e/Jjrb8qHizB9KDROP2M
HbN2gM/rU2KOil0P2u1aqCMqpagu8p8SM/CuGXOeVqMUwkqJj5L7mgfN4gqAlnkz
1B3l3X2Ztg10IzP6Fr4yn4j2gQg155Tk08+FA8ih3D9biCsc0K8gVV6goIi6O0Al
xKIHj0ZEtn+eXfSGOBhlcr1MJBCFeEvafQAtGRE39xbNE5Z6x+kT3vIGWwbQ5oGq
qnHnAI3CQ+wnp38KfIdCNlnoE2Snt2RiBYWWjCDOj7Pi+16g40qhBoGFpHEjaAM5
ZYDtKNyaF5Seou42v1sc3TA5tlG/aE+C7XsjPdHNEasgXX2m1aYuOc3a9GXnd+0E
0o2RKMQ9Q0DT0cbq+qdjSo1Ws/zc1+sbmfOlr5tC+pH3LCxa7S+AhpmvblvE+aaH
uoWaEnk4KUdOryzcEpBD6DkFGjZnUVebZqZRfCVyQAF3YvYmu/7byhMS2gyIkb+1
virwOi6itVu0JnW/4u74I+DRzAISnOeZkKsPNZX4RdnxOUvBMY9uMwHFGzaaIXnm
TgKxMUqxN3aN9KiHxFVSNgdjk2WjDXLBC+0KRNb8C1rT9GDPNoN2P9Uymu/BYdVI
I7LFZzmBzNtExKqGfHoa
=psyI
-----END PGP SIGNATURE-----

--rwlp4HDnqjg7pxzw--
