Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:43835 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbeHBIwR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 04:52:17 -0400
Subject: Re: BTRFS and databases
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
Date: Thu, 2 Aug 2018 15:02:26 +0800
MIME-Version: 1.0
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RYjzS7kCKz7pbu9Xep85IbNqjkcvkbtu6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RYjzS7kCKz7pbu9Xep85IbNqjkcvkbtu6
Content-Type: multipart/mixed; boundary="bvQ1KLIBwH5Ce3N0joSNLAWNbauGH3la4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: MegaBrutal <megabrutal@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
Subject: Re: BTRFS and databases
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>

--bvQ1KLIBwH5Ce3N0joSNLAWNbauGH3la4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8801=E6=97=A5 11:45, MegaBrutal wrote:
> Hi all,
>=20
> I know it's a decade-old question, but I'd like to hear your thoughts
> of today. By now, I became a heavy BTRFS user. Almost everywhere I use
> BTRFS, except in situations when it is obvious there is no benefit
> (e.g. /var/log, /boot). At home, all my desktop, laptop and server
> computers are mainly running on BTRFS with only a few file systems on
> ext4. I even installed BTRFS in corporate productive systems (in those
> cases, the systems were mainly on ext4; but there were some specific
> file systems those exploited BTRFS features).
>=20
> But there is still one question that I can't get over: if you store a
> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
> with nodatacow, or would you just simply use ext4?
>=20
> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance =E2=80=93 the exact Co=
W
> nature that is elsewhere a blessing, with databases it's a drawback).
> But are there any advantages of still sticking to BTRFS for a database
> albeit CoW is disabled, or should I just return to the old and
> reliable ext4 for those applications?

Since I'm not a expert in database, so I can totally be wrong, but what
about completely disabling database write-ahead-log (WAL), and let
btrfs' data CoW to handle data consistency completely?

If there is some concern about the commit interval, it could be tuned by
commit=3D mount option.

It may either lead to super unexpected fast behavior, or some unknown
disaster. (And for latter, we at least could get some interesting
feedback and bugs to fix)

Thanks,
Qu

>=20
>=20
> Kind regards,
> MegaBrutal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--bvQ1KLIBwH5Ce3N0joSNLAWNbauGH3la4--

--RYjzS7kCKz7pbu9Xep85IbNqjkcvkbtu6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltirIMACgkQwj2R86El
/qiw7Af/bTb1gEnFhib9mgUXLta8b49voUQL1QTmBl6ppYBFjT2lVIm3AO4u1YLk
Fm+hz5LdlRHzE7bv/Qtp5/55E15DxpYpMlu9vjRPpPpbVWfPQZMk65deFP4H4jos
5Dp3Acdm3ZTUvjh5v139rp0QCrFzBuzOua2OL23PMiymj29LtKPZs7FO/vfinmNA
GY7kVbvzhcNXK8NwEvuiuvgUNmU7sivNRSTTlzAyoIUjb6jF7i5YLHAfOLf64D9G
ysWzLi7gkoLLHF+hsoT4SPfwgwDOgxp0mN+bKIR+/eN1MdTOTnjfb8bOXP122bW7
Zu2mJhChEGCZ88ZBNeYMvSHNljHr/Q==
=XJfX
-----END PGP SIGNATURE-----

--RYjzS7kCKz7pbu9Xep85IbNqjkcvkbtu6--
