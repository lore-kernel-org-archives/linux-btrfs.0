Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32902 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdIHQYY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 12:24:24 -0400
Date: Fri, 8 Sep 2017 16:24:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908162423.GE23980@carfax.org.uk>
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk>
 <CABB28Cx4zo1Pr7TbmxYgJAOmms3PrYftxcks8iHCQSx5a2Xq1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T6xhMxlHU34Bk0ad"
In-Reply-To: <CABB28Cx4zo1Pr7TbmxYgJAOmms3PrYftxcks8iHCQSx5a2Xq1g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--T6xhMxlHU34Bk0ad
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 08, 2017 at 05:12:11PM +0100, Tomasz K=C5=82oczko wrote:
> On 8 September 2017 at 16:38, Hugo Mills <hugo@carfax.org.uk> wrote:
> [..]
> >> sometimes I'm really thinking about start rewrite btrfs-progs to make
> >> btrfs basic tools syntax as similar as it is only possible to ZFS zfs,
> >> zpool and zdb commands on using which in +90% cases you can guess how
> >> necessary syntax must look like without looking on man pages.
> >>
> >> Any volunteers want to join to help implement something like this?
> >> Maybe someone already started doing this?
> >
> >    The main complaint that can be directed at the btrfs command is
> > that its output is rarely machine-processable. It would therefore make
> > sense to have a "--table" or "--structured" mode for output, which
> > would be more trivially parsable by shell tools.
>=20
> Output of the btrfs command it is coooooompletely different pair of shoes.
> On making btrfs tools similar to ZFS analogues *obviously* output
> should be as same similar.
> By this would possible to solve complains about unreadable output in one =
go.
>=20
> For example zfs command parseable output is possible to generate by
> add -p switch in those subcommands where it is needed (no --tables or
> --structures .. just one switch).

   --tables _is_ one switch.

> Instead reinventing the wheel just please try to look first how it is

   What in what I said was reinventing a wheel? Literally the *only*
thing I was suggesting was adding some option to make the btrfs tool
output more machine-parsable.

   Call the option whatever you like. However, note that there are
probably very few single-letter options which are not used in at least
one of the btrfs tool subcommands.

   Hugo.

--=20
Hugo Mills             | How do you become King? You stand in the marketpla=
ce
hugo@... carfax.org.uk | and announce you're going to tax everyone. If you
http://carfax.org.uk/  | get out alive, you're King.
PGP: E2AB1DE4          |                                        Harry Harri=
son

--T6xhMxlHU34Bk0ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZssQ3AAoJEFheFHXiqx3kd4kP/AtWZFnSNeuOY66UdV8zkTZd
Z46JaK86MG/3D2iAiulanaQPP7Im3Hdd/2/ENjmxDlwWg2UuYXDFVpKrJAP9CmVi
7riyPYukjh+iwOAeUDeaVX1jruYD8ae7Igt/X+PXtRbiwdDzlKaIGhZraQedPhd6
u8qGJf7HgtKIESES/SCDP8i+XKetgSOQHnMMrNGCo8+6+I1y5afy2WeA+uVUZxPC
5l3swde39dytjHIqBp2qR1DiMM71WzNvSRnaNe8xCU/rSr0sC/sfrva16iUF8FAV
hBULvI5QshTB1T2AhvOzu9olY6ZVpzU1Y/03Z40pCH+KCNg7xpD23t5UvfX+1/H9
aLsm4XnTp8EWPjngAq1U1l6G/iC+MTz4xeJD4yGsoGPimQWx/Q/lJ0aK9Sf6peEk
rwBEMBHPw+Pf6QQdeu7tchwhB8Xh/lZXoiMfiDISHGQjVBbFQiOpelHghSg4r+/D
15KdzR98j0yp8SYN2P6kNC+9RYIES5kgXV1i0Curw8kRvEh/TobMqlABlQw4Vbya
MlF0t1keKgJaqafDvDCSgPBCc05AzmUQnXC27qufeSqHQGCR6v2JOZoA0xWlL6g5
xj/H1aooIyRhL/0h/wUFo9kZFMLzzELa+qJRmeqqTcK/3IUKzFXoCMMp1ST7gMoj
qrNw2QFvPG9UgBEzzV4O
=P/Fg
-----END PGP SIGNATURE-----

--T6xhMxlHU34Bk0ad--
