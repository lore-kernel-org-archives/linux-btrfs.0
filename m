Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63237 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbdKALRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 07:17:17 -0400
Subject: Re: Reasonable amount of snapshots
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1509534294.1662.91.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
Date: Wed, 1 Nov 2017 19:17:10 +0800
MIME-Version: 1.0
In-Reply-To: <1509534294.1662.91.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5nT6xml0dt80u02Ebv0kTNtMMnOW939KF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5nT6xml0dt80u02Ebv0kTNtMMnOW939KF
Content-Type: multipart/mixed; boundary="nMO9WJuRNI20rJeXpx7RpgArKHHH9VifD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
Subject: Re: Reasonable amount of snapshots
References: <1509534294.1662.91.camel@gmail.com>
In-Reply-To: <1509534294.1662.91.camel@gmail.com>

--nMO9WJuRNI20rJeXpx7RpgArKHHH9VifD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8801=E6=97=A5 19:04, ST wrote:
> Hello,
>=20
> I read in different places that one should keep amount of snapshots low=

> - around 15-20. My question - is this limitation on total number of
> snapshots on the system or only on related (parent<->child) chain of
> snapshots?

Independent subvolume doesn't count, and it's filesystem based.

So only snapshots (with source exists, and still shares a lot of trees
with source) counts.

And if you have multiple btrfs fses, then the count should be based on
each fs.

> What I want to do is the following: create (and then rotate) last 7
> daily snapshots (and maybe 4 weekly) for each user in his /home dir.
> For
> around 100 users. So if limitation is only on related snapshots then I'=
m
> OK since only each 7 (or maybe 7+4) of them are related which is well
> under the 15-20 limit. However in total there could be 700 snapshots. S=
o
> what is true?

You're OK since independent subvolumes won't cause too much stress for
backref walk.

The only thing you may need to consider is to limit the ability to
reflink data between subvolumes.
Like cp --reflink or even offline dedupe.

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


--nMO9WJuRNI20rJeXpx7RpgArKHHH9VifD--

--5nT6xml0dt80u02Ebv0kTNtMMnOW939KF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln5rTYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiImQf/Qtm8NsqPlc1v7fisF37+z6nd
uHfeknZ4oc2bQ2nJfNvRhGtzdkfNRbsMGNAZjAul+R3z+dM3yM8aDjbdA3+iFW1s
nKFff7N2OiTVWjgsCcSZmuqwZx1X+e0Kj58VyQ4NJKlP2ZGx+WDFubGqszxscGSH
kgQKeUv5tOwOBfOpFkxNpLs4eN0H/1v514RIoy6Qm4cEfouOWxDiy4JGIewe2Atl
O4LmqOc5wwmQTB7pbDpX9kmuLoziWwB/LDBzv0HBGGX9UwRZmkHQIqhXh2T0ntWD
FfCPuAE/x3PzqTHXpqr6Z1MOTIz3DVItFYbDLErR1+0E3Snm22WwWVvOz2mcEw==
=HYaq
-----END PGP SIGNATURE-----

--5nT6xml0dt80u02Ebv0kTNtMMnOW939KF--
