Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:35623 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbeHFCym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 22:54:42 -0400
Subject: Re: BUG: scheduling while atomic
To: James Courtier-Dutton <james.dutton@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com>
Date: Mon, 6 Aug 2018 08:48:04 +0800
MIME-Version: 1.0
In-Reply-To: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VlrmXI4VTDpum5pTUwaZWiXJ7vquNFOMv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VlrmXI4VTDpum5pTUwaZWiXJ7vquNFOMv
Content-Type: multipart/mixed; boundary="QU55mkc7uu7bxar1bvCBuJsTAFCTsH38b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: James Courtier-Dutton <james.dutton@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com>
Subject: Re: BUG: scheduling while atomic
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
In-Reply-To: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>

--QU55mkc7uu7bxar1bvCBuJsTAFCTsH38b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8805=E6=97=A5 22:09, James Courtier-Dutton wrote=
:
> I am seeing a server halt and require a manual restart that I think
> might be related to btrfs.
> I attach the kernel log from it, in the hope that someone will
> understand it better than me.
> Any clues?
>=20
> https://paste.fedoraproject.org/paste/xSblK1RKANiwhKHQj31Cdw

When checking the dmesg, we should check for the first backtrace other
than later backtraces, which are normally caused by the first problem.

In your case, it's general protection happens at timerqueue_add(), which
is unrelated to btrfs at all.

Thanks,
Qu
>=20
>=20
> Kind Regards
>=20
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--QU55mkc7uu7bxar1bvCBuJsTAFCTsH38b--

--VlrmXI4VTDpum5pTUwaZWiXJ7vquNFOMv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltnmsQACgkQwj2R86El
/qjX/AgAhpAbQTmvKlRuvH3kM0DH2xdeTwr41HQpPGjSbfITSzIUiQSb5gA1/rTu
o6gYqIm36X+l5BmgkSsH6gNjlOVJ0vPoa87x6Dwk8VaY1wM0HKWK170jkg+8J3iV
NSReJmoiwL08if8iorueEyBitLOmMhpWVLxX/oNayZu41rsSHNKAC5NUTRZt3WWS
H3Yx2aAiWZ1i+dSrFwt1LXMG8gBrVT5NcKSLeW3RvAmo60/q2QbEQwzQ9OlAyog3
Nr0RnAVXykcsEa7iLx/NtrZqAb2rsHcDuvqIUjVFwnlywNIPYkFTJb5KtAqgVfed
cvygA9ETL2B4/mJh5AUUqEJfM2VYHw==
=1tEa
-----END PGP SIGNATURE-----

--VlrmXI4VTDpum5pTUwaZWiXJ7vquNFOMv--
