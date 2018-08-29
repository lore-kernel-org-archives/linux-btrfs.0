Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:47861 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbeH2Qti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 12:49:38 -0400
Subject: Re: How to erase a RAID1 ?
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
Date: Wed, 29 Aug 2018 20:52:42 +0800
MIME-Version: 1.0
In-Reply-To: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xgEDI6xEIKXBjRKdHScslrxf3w0CxqgDj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xgEDI6xEIKXBjRKdHScslrxf3w0CxqgDj
Content-Type: multipart/mixed; boundary="UEkG4HaC38cM8eRPFFGyw8PQPL0ueYiUo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
Message-ID: <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
Subject: Re: How to erase a RAID1 ?
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
In-Reply-To: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>

--UEkG4HaC38cM8eRPFFGyw8PQPL0ueYiUo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/29 =E4=B8=8B=E5=8D=888:49, Pierre Couderc wrote:
> I want to reinstall a RAID1 btrfs system (wchis is now under debian
> stretch, and will be reinstalled in stretch).

If you still want to use btrfs, just umount the original fs, and

# mkfs.btrfs -f <old devices>

Then a completely new btrfs.

>=20
> How to correctly "erase" it ? Not truly hard erase it, but so that old
> data does not appear...

If not planing to use btrfs, umount the fs and then wipefs -fa <old devic=
es>

Thanks,
Qu

>=20
> It is not clear in the wiki.
>=20
> Thanks
>=20
> PC
>=20


--UEkG4HaC38cM8eRPFFGyw8PQPL0ueYiUo--

--xgEDI6xEIKXBjRKdHScslrxf3w0CxqgDj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluGlxoACgkQwj2R86El
/qhU2AgAmJgMBBSjuOi1pJ9CBYhiYSt9rDqqaB8F/TB6wRK513d1ZI/DDNKYEFRB
ChddaA7CzBmH9REyE7ndc7mz+7MKRYXrgDx/vN7Jr2Krfq/vXp0po+UGXmXbLh5S
CXrJ4/g0l80qUeqmiZPBpjdwvpc5bZ6UxoOSRWTYeqVtiAuP2mlChs81SipKpfSc
CESCv2FMOdiE0mC19YQ/CxZL8f74xKT0n9YzRZ+7lNe8ylFgTrdQr2OogNZNNp5Q
gSnDQrblh8rBxLcawvGUW5tLzd5KP0ipIrAsreI3iWwvfZXE5PPNE+Mclao0WKd5
HS37Tu+uR+LzUBsy/AtPvzRXvcu6lQ==
=7LKf
-----END PGP SIGNATURE-----

--xgEDI6xEIKXBjRKdHScslrxf3w0CxqgDj--
