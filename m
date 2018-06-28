Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:47649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752063AbeF1B60 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 21:58:26 -0400
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Remi Gauvin <remi@georgianit.com>, linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
Date: Thu, 28 Jun 2018 09:58:17 +0800
MIME-Version: 1.0
In-Reply-To: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o1NTmZNA6J1wmHDSOilgbxgyS8U4rXC1O"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o1NTmZNA6J1wmHDSOilgbxgyS8U4rXC1O
Content-Type: multipart/mixed; boundary="niX0XzMy8Hfk74pBhSCwVkBOUXr3lLI4D";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Remi Gauvin <remi@georgianit.com>, linux-btrfs@vger.kernel.org
Message-ID: <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
In-Reply-To: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>

--niX0XzMy8Hfk74pBhSCwVkBOUXr3lLI4D
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 09:42, Remi Gauvin wrote:
> There seems to be a major design flaw with BTRFS that needs to be bette=
r
> documented, to avoid massive data loss.
>=20
> Tested with Raid 1 on Ubuntu Kernel 4.15
>=20
> The use case being tested was a Virtualbox VDI file created with
> NODATACOW attribute, (as is often suggested, due to the painful
> performance penalty of COW on these files.)

NODATACOW implies NODATASUM.

=46rom btrfs(5):
---
Enable data copy-on-write for newly created files.  Nodatacow
implies nodatasum, and disables compression. All files created
under nodatacow are also set the NOCOW file attribute (see
chattr(1)).
---

Although it's talking about the mount option, it also applies to
per-inode options.

Thanks,
Qu

>=20
> However, if a device is temporarily dropped (this in case, tested by
> disconnecting drives.) and re-connects automatically next boot, BTRFS
> does not in any way synchronize the VDI file, or have any means to know=

> that one of copy is out of date and bad.
>=20
> The result of trying to use said VDI file is.... interestingly insane.
> Scrub did not do anything to rectify the situation.
>=20
>=20


--niX0XzMy8Hfk74pBhSCwVkBOUXr3lLI4D--

--o1NTmZNA6J1wmHDSOilgbxgyS8U4rXC1O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0QLkACgkQwj2R86El
/qhXpQf/ZNKuU9TDGh4/g6kMAwvvfNB52PlmQQwIuwV3+nokTMQiaY9UI4lLKUCJ
qFpO7RVzh+vlTxpaB8RJvTd+uot3cgBwvax0shalvpAJjyY6262ii7YLiw5pjoUr
FV12arNvWCbWMPK31h7g3yptfWoqajkTT2TqcbNsrnyt7k3/vmYtXb5yYT52sutt
JQjdfdm0YcpUzGhAcB/4aqvw/Wcb1WB65YIl0jOIrTbP8iGfAOS8tCBiqeRKTBHZ
SGnhofN1PuPslkjVCyxMk0tg72INesimStIuNsaBUtIcSL6xcs/bg+TK41C5qxrm
NZnw5J01I9oMzM7EuT9fGg/jS2VjGg==
=n0pw
-----END PGP SIGNATURE-----

--o1NTmZNA6J1wmHDSOilgbxgyS8U4rXC1O--
