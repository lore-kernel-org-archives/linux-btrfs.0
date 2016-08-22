Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756134AbcHVUOb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 16:14:31 -0400
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
To: Tomokhov Alexander <alexoundos@ya.ru>, linux-btrfs@vger.kernel.org
References: <126611471805976@web2j.yandex.ru>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57BB5D1B.8040305@suse.com>
Date: Mon, 22 Aug 2016 16:14:19 -0400
MIME-Version: 1.0
In-Reply-To: <126611471805976@web2j.yandex.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wxBr7AOv4ACE3IE7ajEccweALJIQqAK7s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wxBr7AOv4ACE3IE7ajEccweALJIQqAK7s
Content-Type: multipart/mixed; boundary="i25fgLL7vu9VtoeVmmvGhBh6SaEbgfUeB"
From: Jeff Mahoney <jeffm@suse.com>
To: Tomokhov Alexander <alexoundos@ya.ru>, linux-btrfs@vger.kernel.org
Message-ID: <57BB5D1B.8040305@suse.com>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
References: <126611471805976@web2j.yandex.ru>
In-Reply-To: <126611471805976@web2j.yandex.ru>

--i25fgLL7vu9VtoeVmmvGhBh6SaEbgfUeB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/21/16 2:59 PM, Tomokhov Alexander wrote:
> Btrfs wiki FAQ gives a link to example Python script: https://github.co=
m/stsquad/scripts/blob/master/uncow.py
>=20
> But such a crucial and fundamental tool must exist in stock btrfs-progs=
=2E Filesystem with CoW technology at it's core must provide user suffici=
ent control over CoW aspects. Running 3rd-party or manually written scrip=
ts for filesystem properties/metadata manipulation is not convenient, not=
 safe and definitely not the way it must be done.
>=20
> Also is it possible (at least in theory) to "uncow" files being current=
ly opened in-place? Without the trickery with creation & renaming of file=
s or directories. So that running "chattr +C" on a file would be sufficie=
nt. If possible, is it going to be implemented?

XFS is looking to do this via fallocate using a flag that all file
systems can choose to honor.  Once that lands, it would make sense for
btrfs to use it as well.  The idea is that when you pass the flag in, we
examine the range and CoW anything that has a refcount !=3D 1.

That code hasn't landed yet though.  The last time I saw it posted was
June.  I don't speak with knowledge of the integration plan, but it
might just be queued up for the next merge window now that the reverse
mapping patches have landed in 4.8.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--i25fgLL7vu9VtoeVmmvGhBh6SaEbgfUeB--

--wxBr7AOv4ACE3IE7ajEccweALJIQqAK7s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXu10eAAoJEB57S2MheeWyFE8QAJL54/N1WfKCyEvtRZVY5F25
b8aMQ2WSU0exDur4/0tQTnVErpRZwaSIQgrio86USAZ3NRT2NRymw+4k8HMT97ng
tpg8GooD3S8JBuGCCxipACunxBDbg3oi9ev8CNu9orq2XqgYxReaiuhkizDafJG2
rlesSpMpST634J+D4e7y5xBeCuVpMAIj+UvHPerhkRkLSIGwRlWhgzwI69HYJ3mq
cJzYAEjjvJHVr/Gc8QGK0Em/M9OD/rGG/yeTUUIucBifLUan5ksXMqbUY0Po9RsT
Em7U9ItgnqoAlkEPf4wDOcIY/jeConlUZwvw8GwhmRsr6UBOmLM0vTVfVS9cAzEX
7vr0R99e+aORCrPb+16JRWzLZwZfM8c2y2tGoic+vIRRiT/nOlJdjZgTzAxnYzVv
u73eoTe4ZbIcKErOFIuAejxKFGkLD7KonivTgSwSAqWRywNSPUvmWaT942lWC8rh
UGfz422KiNfavJdqPPddpUm1sCca2NwjujSwcaW9oRSRAEbkQa/ALu/c/VTBUn3q
FkjH4xWN8qqs7JKwoEIpNZCcVAZw4+pdH7qsXN33jhjhW8a10OkK0bAv6HhpQRzB
b1p0tTxua04SfiOIyI3y6rlYVwjNr1Br5pxIuFpDuKbhX25vF4SkFcFhZRP3C4Iu
LoHL1XkOhLNJyJkkhGLU
=E3Ge
-----END PGP SIGNATURE-----

--wxBr7AOv4ACE3IE7ajEccweALJIQqAK7s--
