Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35383 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdC0NYG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:24:06 -0400
Date: Mon, 27 Mar 2017 13:24:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Shrinking a device - performance?
Message-ID: <20170327132404.GO11714@carfax.org.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p/1JFEOz/hVXxMAZ"
In-Reply-To: <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p/1JFEOz/hVXxMAZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2017 at 03:20:37PM +0200, Christian Theune wrote:
> Hi,
>=20
> > On Mar 27, 2017, at 3:07 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >=20
> >   On my hardware (consumer HDDs and SATA, RAID-1 over 6 devices), it
> > takes about a minute to move 1 GiB of data. At that rate, it would
> > take 1000 minutes (or about 16 hours) to move 1 TiB of data.
> >=20
> >   However, there are cases where some items of data can take *much*
> > longer to move. The biggest of these is when you have lots of
> > snapshots. When that happens, some (but not all) of the metadata can
> > take a very long time. In my case, with a couple of hundred snapshots,
> > some metadata chunks take 4+ hours to move.

> Thanks for that info. The 1min per 1GiB is what I saw too - the =E2=80=9C=
it
> can take longer=E2=80=9D wasn=E2=80=99t really explainable to me.

> As I=E2=80=99m not using snapshots: would large files (100+gb) with long
> chains of CoW history (specifically reflink copies) also hurt?

   Yes, that's the same issue -- it's to do with the number of times
an extent is shared. Snapshots are one way of creating that sharing,
reflinks are another.

> Something I=E2=80=99d like to verify: does having traffic on the volume h=
ave
> the potential to delay this infinitely? I.e. does the system write
> to any segments that we=E2=80=99re trying to free so it may have to work =
on
> the same chunk over and over again? If not, then this means it=E2=80=99s
> just slow and we=E2=80=99re looking forward to about 2 months worth of ti=
me
> shrinking this volume. (And then again on the next bigger server
> probably about 3-4 months).

   I don't know. I would hope not, but I simply don't know enough
about the internal algorithms for that. Maybe someone else can confirm?

> (Background info: we=E2=80=99re migrating large volumes from btrfs to xfs
> and can only do this step by step: copying some data, shrinking the
> btrfs volume, extending the xfs volume, rinse repeat. If someone
> should have any suggestions to speed this up and not having to think
> in terms of _months_ then I=E2=80=99m all ears.)

   All I can suggest is to move some unused data off the volume and do
it in fewer larger steps. Sorry.

   Hugo.

--=20
Hugo Mills             | Jenkins! Chap with the wings there! Five rounds
hugo@... carfax.org.uk | rapid!
http://carfax.org.uk/  |                 Brigadier Alistair Lethbridge-Stew=
art
PGP: E2AB1DE4          |                                Dr Who and the Daem=
ons

--p/1JFEOz/hVXxMAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY2RJ0AAoJEFheFHXiqx3kliwP/A0iKVaHQVWDmmffSjT9Dp52
EifuiGtLiQuiTyr4veucqwLhhrLmPDeJQSit4p1SQOoR/qC9b3Tfa+rCzxiF6xTR
llh53cucadVZMhTMo64g/JpIdFbUXvmLu00xBIJhWyxpxVU0l+h+f/wEZjsy7/IC
NDzN6AnLLEBPCkI4+PJTHuKKl2w4XaDAwZIX8FfTvhYR+HRRzC2HnkwiDmUodnIl
uAaz/ARv16XQamk/azVz7qyiyUOw1gsgPo9Xkc/1Yh2i9E8doz7mHltvOBBlcDi8
kFAd9MNimI7ceIekrBNlGFSwJgWMNeDLu0fscgd47Q0wbvt0dtD/Ai9cPaYtVu9Y
VvpdtUSFj5hqMkbB5Qtt2MYq/VWVTSDpDQ+vJqMpyasMq5OWVfMT0+lGy6+5xL9A
76c2Luh0ueE5/lVxs6bGk58TdE0/L4/CzkhDZRebgkWhdqEcwp7jnqXLcmbZP+9k
xHiLa7tQTuK+WsWwMIS/7sj2y4Pnk3daacAIQaTnWh3oRRyMVP6AaMIVQ4uuoGRe
HqbpxT8F7YmwAawwvEDFE/a7rntdIuGzO2m2m1madMsPnGcSDk7qFz1yp21v0NoB
lHhy4pJ6CxS3OGGyMEmIiUrcSa6YMTrsA2dCYtQ8M9q3fTTRtJUb59ClhsbZj+rR
L2SDjIQcXsuvbjkcCB25
=e+IV
-----END PGP SIGNATURE-----

--p/1JFEOz/hVXxMAZ--
