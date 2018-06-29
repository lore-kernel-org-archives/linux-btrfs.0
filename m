Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:41317 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932703AbeF2FH3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 01:07:29 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
Date: Fri, 29 Jun 2018 13:07:20 +0800
MIME-Version: 1.0
In-Reply-To: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QtJI6aDLGl0vO8KTqvjFuizSvKxTCSGxG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QtJI6aDLGl0vO8KTqvjFuizSvKxTCSGxG
Content-Type: multipart/mixed; boundary="lEyGuux9hrgN0zTS6g7uT8Zx1NL9SYlBm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Message-ID: <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
In-Reply-To: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>

--lEyGuux9hrgN0zTS6g7uT8Zx1NL9SYlBm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8829=E6=97=A5 12:27, Marc MERLIN wrote:
> Regular btrfs check --repair has a nice progress option. It wasn't
> perfect, but it showed something.
>=20
> But then it also takes all your memory quicker than the linux kernel ca=
n
> defend itself and reliably completely kills my 32GB server quicker than=

> it can OOM anything.
>=20
> lowmem repair seems to be going still, but it's been days and -p seems
> to do absolutely nothing.

I'm a afraid you hit a bug in lowmem repair code.
By all means, --repair shouldn't really be used unless you're pretty
sure the problem is something btrfs check can handle.

That's also why --repair is still marked as dangerous.
Especially when it's combined with experimental lowmem mode.

>=20
> My filesystem is "only" 10TB or so, albeit with a lot of files.

Unless you have tons of snapshots and reflinked (deduped) files, it
shouldn't take so long.

>=20
> 2 things that come to mind
> 1) can lowmem have some progress working so that I know if I'm looking
> at days, weeks, or even months before it will be done?

It's hard to estimate, especially when every cross check involves a lot
of disk IO.

But at least, we could add such indicator to show we're doing something.

>=20
> 2) non lowmem is more efficient obviously when it doesn't completely
> crash your machine, but could lowmem be given an amount of memory to us=
e
> for caching, or maybe use some heuristics based on RAM free so that it'=
s
> not so excrutiatingly slow?

IIRC recent commit has added the ability.
a5ce5d219822 ("btrfs-progs: extent-cache: actually cache extent buffers")=


That's already included in btrfs-progs v4.13.2.
So it should be a dead loop which lowmem repair code can't handle.

Thanks,
Qu

>=20
> Thanks,
> Marc
>=20


--lEyGuux9hrgN0zTS6g7uT8Zx1NL9SYlBm--

--QtJI6aDLGl0vO8KTqvjFuizSvKxTCSGxG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls1vogACgkQwj2R86El
/qiGWQgAik6Lt5NRgOY3HNTxm19hV2O3adnTEfAhfRUCl3IdooezuE23Ylm6x6Er
3ttN54y2dP3cRBdXQqgiEihlDQgenjwWr5u8KPNd11WWI97fRpLv9GDSMjAJ+VnH
g9ukz1BVADO7gAmQH28oMBXu6vMF/21kTCmLparNPnqO2/XkbWn5QjazZRJLKUxu
OxNr5RndQlX4gOb334JqlgEv0210UeY3dw8y6Twr1nduPuu24xvlqv13ZFUJ9C+y
qexpIKn1CIjFg/pu/742OiQM6mZt40h+JDdolT0PDi+9sAHT57FNWTnvGlFhgrU/
1l4mx0RqZTg3B1bg5Oiv1O0NNAV86A==
=bj/Y
-----END PGP SIGNATURE-----

--QtJI6aDLGl0vO8KTqvjFuizSvKxTCSGxG--
