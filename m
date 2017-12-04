Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57289 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752856AbdLDMWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 07:22:00 -0500
Subject: Re: command to get quota limit
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1512389667.1707.109.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d06860e1-f905-30ff-941a-92ed61355483@gmx.com>
Date: Mon, 4 Dec 2017 20:21:53 +0800
MIME-Version: 1.0
In-Reply-To: <1512389667.1707.109.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JA4rB7nCQ0H7HfFWhp1J3QaDBRPBBivXX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JA4rB7nCQ0H7HfFWhp1J3QaDBRPBBivXX
Content-Type: multipart/mixed; boundary="aOABlOStAWxni8NSEIkPDWhJeBqijnNOX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <d06860e1-f905-30ff-941a-92ed61355483@gmx.com>
Subject: Re: command to get quota limit
References: <1512389667.1707.109.camel@gmail.com>
In-Reply-To: <1512389667.1707.109.camel@gmail.com>

--aOABlOStAWxni8NSEIkPDWhJeBqijnNOX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8804=E6=97=A5 20:14, ST wrote:
> Hello,
>=20
> what is the command to get btrfs quota limit on certain subvolume?

btrfs qgroup show -re

The result is for all subvolumes, then just find the subvolume you need.

Thanks,
Qu

>=20
> Thank you!
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--aOABlOStAWxni8NSEIkPDWhJeBqijnNOX--

--JA4rB7nCQ0H7HfFWhp1J3QaDBRPBBivXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlolPeEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qguMgf8Dec7B9Fj6pi2gjA4Yv99Ncg9
IzwLbqT1P6SCbfN1i9m1ydfQd2FZDijPt3wEn7aZR/RYL99xNU0uUAcT3twf3PGo
+ySZcEaoXQGssazfOw+g911F09lju8ZOgGA3Nj5ru1TzeC1rsGYO6BffxU7E1IhU
npJMORw3jiuWFFFGoB6Krgka9f8MbJZH0M19mPQAC25Tm2Htoo8EsimTxeQwQCQ3
xy+6qTON3GQE37MTz69nDbDDdWqBUc46u7Gt7yswSUYGSf3qeFfvMmIFvfL21APa
SwWTNsxnHNU56QArH27mVd2SwoliIdoT0cdNKbFxkvFdTssqvC3hzi3eaqiKMg==
=OW2i
-----END PGP SIGNATURE-----

--JA4rB7nCQ0H7HfFWhp1J3QaDBRPBBivXX--
