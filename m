Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62638 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdLGH7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 02:59:31 -0500
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
 <9aa28872-5a44-5a81-d954-656b2f956033@gmx.com>
 <47becabf-e362-c552-1b19-44d30e5c4e62@rqc.ru>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <09f5b490-e71a-564f-3851-5b18eb53ce5d@gmx.com>
Date: Thu, 7 Dec 2017 15:59:22 +0800
MIME-Version: 1.0
In-Reply-To: <47becabf-e362-c552-1b19-44d30e5c4e62@rqc.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9bD4f1tikCP9lhiDN2CiuRDrMD6srmn8M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9bD4f1tikCP9lhiDN2CiuRDrMD6srmn8M
Content-Type: multipart/mixed; boundary="3kejVPE9VmPIpFtHHiX2PSciWf681KsUq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <09f5b490-e71a-564f-3851-5b18eb53ce5d@gmx.com>
Subject: Re: [RFC] Improve subvolume usability for a normal user
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
 <9aa28872-5a44-5a81-d954-656b2f956033@gmx.com>
 <47becabf-e362-c552-1b19-44d30e5c4e62@rqc.ru>
In-Reply-To: <47becabf-e362-c552-1b19-44d30e5c4e62@rqc.ru>

--3kejVPE9VmPIpFtHHiX2PSciWf681KsUq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8807=E6=97=A5 15:32, Marat Khalili wrote:
> On 07/12/17 08:27, Qu Wenruo wrote:
>> When doing snapshot, btrfs only needs to increase reference of 2nd
>> highest level tree blocks of original snapshot, other than "walking th=
e
>> tree".
>> (If tree root level is 2, then level 2 node is copied, while all
>> reference of level 1 tree blocks get increased)
>=20
> Out of curiosity, how does it interacts with nocow files? Does every
> write to these files involves backref walk?

For details I need to check the code.
But at least, partial backref walk must be done.

For "partial" I mean it doesn't need to get every root referring to the
file extent, it only needs to check if the extent is only referred by
current inode and offset.

If any other inode (or even the same inode with different offset) is
found, then the walk is finished.
(The same walk we do to determine the FIEMAP_EXTENT_SHARED flag)

In contract, for qgroup and balance, the full backref walk is done,
where btrfs needs every root involved (for qgroup) or even every inode
and offset involved (for balance).

Thanks,
Qu

>=20
> --=20
>=20
> With Best Regards,
> Marat Khalili


--3kejVPE9VmPIpFtHHiX2PSciWf681KsUq--

--9bD4f1tikCP9lhiDN2CiuRDrMD6srmn8M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloo9NoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj+vQf+IKoUjVqiGGh9Ql6DC6moytd/
U5yCdbYxKRj2WahJvrxZFopqS7Cm/OBfSYRC6VpZhPkay3vyxLTI6vOg7J7rkXKu
NOD3DRHSBc0r25k0qA8jsEwD7KItqmWNm/hULwaLH6APyki1iLdrvX/149rMmUaj
yRzpBwJDd0a2SrcBiLyGdY80Cg3zQfqJMOM+J85bZf0Y4q3cfuyuLGkO/3/8riH/
tZQVgRW8O2NjKBkKvWSWQcEui7uNPTVHKG1XdpDpoXcHDqK6muus54Sg8fDfZAiX
za2nUbVuCdGfFcGM9q4kTjve+Cpx36u6fc7LZHPNMpLUgmBiv3BTmI/l2A2mDA==
=4wOc
-----END PGP SIGNATURE-----

--9bD4f1tikCP9lhiDN2CiuRDrMD6srmn8M--
