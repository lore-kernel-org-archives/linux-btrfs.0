Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39223 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbeHCHAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 03:00:35 -0400
Subject: Re: btrfs check --repair questions
To: Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAEEhgEtHSH2XezqBr_TRmOCDdjq2VdVizMOBmJ2GtHz8FGRnyw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a5ed098d-5dfd-2c89-6884-56ddc9a24c7a@gmx.com>
Date: Fri, 3 Aug 2018 13:06:00 +0800
MIME-Version: 1.0
In-Reply-To: <CAEEhgEtHSH2XezqBr_TRmOCDdjq2VdVizMOBmJ2GtHz8FGRnyw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2WxwVo8zTH9hF2ONE1RFrmcuSm8rtUJOa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2WxwVo8zTH9hF2ONE1RFrmcuSm8rtUJOa
Content-Type: multipart/mixed; boundary="5sz6jRX0YpGwyzZAhL9w8ZHu9Dr7bLAfP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <a5ed098d-5dfd-2c89-6884-56ddc9a24c7a@gmx.com>
Subject: Re: btrfs check --repair questions
References: <CAEEhgEtHSH2XezqBr_TRmOCDdjq2VdVizMOBmJ2GtHz8FGRnyw@mail.gmail.com>
In-Reply-To: <CAEEhgEtHSH2XezqBr_TRmOCDdjq2VdVizMOBmJ2GtHz8FGRnyw@mail.gmail.com>

--5sz6jRX0YpGwyzZAhL9w8ZHu9Dr7bLAfP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8803=E6=97=A5 12:55, Nathan Dehnel wrote:
> Question 1: The command has been running for a couple days on a 10TB
> array with no visible change in output. Is it actually fixing anything?=

>=20
> enabling repair mode
> Checking filesystem on
> /dev/disk/by-uuid/e1ee5980-c54b-4b6e-82e2-3dbdcee1dd24
> UUID: e1ee5980-c54b-4b6e-82e2-3dbdcee1dd24
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots
> root 5 inode 5043370 errors 100, file extent discount
> Found file extent holes:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648

If none of above numbers changes, it's a dead loop.

[snip]
>=20
> Question 2: I accidentally interrupted the command by logging out. How
> dangerous is this? Should I be worried?

Not more dangerous than --repair itself.
As normally we do repair following metadata CoW, so it should be OK to
interrupt.

You should worry the first time you run --repair, other than worrying
about interruption.

Thanks,
Qu



--5sz6jRX0YpGwyzZAhL9w8ZHu9Dr7bLAfP--

--2WxwVo8zTH9hF2ONE1RFrmcuSm8rtUJOa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltj4rgACgkQwj2R86El
/qid6Af6As9LlYNMgPiZD8Ss9cncJrkaSGkk0MCFgsQ+o8c+KjTjXuhXaB4+dIBS
R4IP6uBjVe8+BJ2xPSuh3UAq8bIMcwyNReOIHau5I+b3pLYYREDfeuPcwB7I5fdA
Zn/x5AxibvybOIqp9c/VW11lqJMNyfjlQRksp++wVATsxZ9wpXZFxB+hfZFqBPKA
TeMvfOlnivpkfcKYAhfMZPeTOUrssztv5qm3WH8m72gnr3luadY2rJVv3js4pkIr
tAnZXGhciQlqlH+8qfgbLi+tjWWY6s1XkiMguR6TnXXSDD0DVLyd+fCS2j95gmFu
YbP6pOzLI4rus7N3meDlbj4jgc283g==
=DRPk
-----END PGP SIGNATURE-----

--2WxwVo8zTH9hF2ONE1RFrmcuSm8rtUJOa--
