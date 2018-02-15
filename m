Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:34507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032245AbeBOBr0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 20:47:26 -0500
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
To: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
Date: Thu, 15 Feb 2018 09:47:15 +0800
MIME-Version: 1.0
In-Reply-To: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ecgkeLpV0gj1lvIABbmUYuRpI1BNDsMHx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ecgkeLpV0gj1lvIABbmUYuRpI1BNDsMHx
Content-Type: multipart/mixed; boundary="dooGDU0ntroaoma9zn6AUnkAtLg79x12D";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Chmielewski <tch@virtall.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
In-Reply-To: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>

--dooGDU0ntroaoma9zn6AUnkAtLg79x12D
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8814=E6=97=A5 22:19, Tomasz Chmielewski wrote:
> Just FYI, how dangerous running btrfs can be - we had a fatal,
> unrecoverable MySQL corruption when btrfs decided to do one of these "I=

> have ~50 GB left, so let's do out of space (and corrupt some files at
> the same time, ha ha!)".

I'm recently looking into unexpected corruption problem of btrfs.

Would you please provide some extra info about how the corruption happene=
d?

1) Is there any power reset?
   Btrfs should be bullet proof, but in fact it's not, so I'm here to
   get some clue.

2) Are MySQL files set with nodatacow?
   If so, data corruption is more or less expected, but should be
   handled by checkpoint of MySQL.

3) Is the filesystem metadata corrupted? (AKA, btrfs check report error)
   If so, that should be the problem I'm looking into.

4) Metadata/data ratio?
   "btrfs fi usage" could have quite good result about it.
   And "btrfs fi df" also helps.

Thanks,
Qu

>=20
> Running btrfs RAID-1 with kernel 4.14.
>=20
>=20
>=20
> Tomasz Chmielewski
> https://lxadm.com
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--dooGDU0ntroaoma9zn6AUnkAtLg79x12D--

--ecgkeLpV0gj1lvIABbmUYuRpI1BNDsMHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqE5qMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhJeAf+MRXEo2kXzIKYm4z7ketQXmel
ocLJs3ztZ52q8GhlAnKKTlbrKBacHRPfYYgqSCTPfeCcZa0c/yFJ0NuyxZbeWZTH
2kmJp1T1yjOi9nzdExVu4fuTx2xtnnmogdkxoimmSccwBUdeni3eq0+6nRyWWvgb
OvhtuTZPK1h5MqCIeDM8GGcDMqnRmlcnPTnetWnALdLfl0AdOCxg50UcLoxD1nOS
XdHjkND1eOHog2TNhLNOfGhhcU3YG6zoNICqtD8zE5M32ih8WuZoAFwIfSCItZQb
cawtJ7ACMEU4mUthJkUfV9E99qvZk+Ksoub61HNeGQAbLjmhzhbUwRYqlzyE4w==
=v0Kp
-----END PGP SIGNATURE-----

--ecgkeLpV0gj1lvIABbmUYuRpI1BNDsMHx--
