Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:44639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbeBVXiQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 18:38:16 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: "Ellis H. Wilson III" <ellisw@panasas.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180222045215.16426-1-wqu@suse.com>
 <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
 <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <24fd39fb-459b-b562-1ff6-9324462a448b@gmx.com>
Date: Fri, 23 Feb 2018 07:37:58 +0800
MIME-Version: 1.0
In-Reply-To: <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FA1d2FvfggsWOzjwljcXGcgkgQ1PmUwfy"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FA1d2FvfggsWOzjwljcXGcgkgQ1PmUwfy
Content-Type: multipart/mixed; boundary="mAUIANWcEIGhuOHHUhZbzGBihaHlaWHTl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Ellis H. Wilson III" <ellisw@panasas.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <24fd39fb-459b-b562-1ff6-9324462a448b@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
References: <20180222045215.16426-1-wqu@suse.com>
 <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
 <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
In-Reply-To: <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>

--mAUIANWcEIGhuOHHUhZbzGBihaHlaWHTl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8823=E6=97=A5 00:31, Ellis H. Wilson III wrote:
> On 02/21/2018 11:56 PM, Qu Wenruo wrote:
>> On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 12:52, Qu Wenruo wrote:
>>> btrfs_read_block_groups() is used to build up the block group cache f=
or
>>> all block groups, so it will iterate all block group items in extent
>>> tree.
>>>
>>> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
>>> thousands times, which is the most time consuming part of mounting
>>> btrfs.
>>>
>>> So this patch will try to speed it up by:
>>>
>>> 1) Avoid unnecessary readahead
>>> =C2=A0=C2=A0=C2=A0 We were using READA_FORWARD to search for block gr=
oup item.
>>> =C2=A0=C2=A0=C2=A0 However block group items are in fact scattered ac=
ross quite a
>>> lot of
>>> =C2=A0=C2=A0=C2=A0 leaves. Doing readahead will just waste our IO (es=
pecially important
>>> =C2=A0=C2=A0=C2=A0 for HDD).
>>>
>>> =C2=A0=C2=A0=C2=A0 In real world case, for a filesystem with 3T used =
space, it would
>>> =C2=A0=C2=A0=C2=A0 have about 50K extent tree leaves, but only have 3=
K block group
>>> =C2=A0=C2=A0=C2=A0 items. Meaning we need to iterate 16 leaves to mee=
t one block group
>>> =C2=A0=C2=A0=C2=A0 on average.
>>>
>>> =C2=A0=C2=A0=C2=A0 So readahead won't help but waste slow HDD seeks.
>>>
>>> 2) Use chunk mapping to locate block group items
>>> =C2=A0=C2=A0=C2=A0 Since one block group item always has one correspo=
nding chunk item,
>>> =C2=A0=C2=A0=C2=A0 we could use chunk mapping to get the block group =
item size.
>>>
>>> =C2=A0=C2=A0=C2=A0 With block group item size, we can do a pinpoint t=
ree search,
>>> instead
>>> =C2=A0=C2=A0=C2=A0 of searching with some uncertain value and do forw=
ard search.
>>>
>>> =C2=A0=C2=A0=C2=A0 In some case, like next BLOCK_GROUP_ITEM is in the=
 next leaf of
>>> =C2=A0=C2=A0=C2=A0 current path, we could save such unnecessary tree =
block read.
>>>
>>> Cc: Ellis H. Wilson III <ellisw@panasas.com>
>>
>> Hi Ellis,
>>
>> Would you please try this patch to see if it helps to speedup the moun=
t
>> of your large filesystem?
>=20
> I will try either tomorrow or over the weekend.=C2=A0 I'm waiting on ha=
rdware
> to be able to build and load a custom kernel on.

If you're using Archlinux, I could build the package for you.

(For other distributions, unfortunately I'm not that familiar with)

Thanks,
Qu
>=20
> Thanks so much for taking a stab at this!
>=20
> ellis


--mAUIANWcEIGhuOHHUhZbzGBihaHlaWHTl--

--FA1d2FvfggsWOzjwljcXGcgkgQ1PmUwfy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqPVFcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qinFggAgcl0nvPJRu+ii5IKNCysacai
xLLfxfmfMse7ZgCA4IIdRBb6EGChuptBua9dU39LxbYhJ3sb4sBsPB5L7X2Soz+G
2YUh4jHfXtj0zSYXEJ1Ej/sWihQ1a7FTt9gsulDIugfc7sIKyQ0jgBnEwzQT1qaZ
sM1tPzs1yGpl9jNXj/bgG1xe8jEtOFvCv9ExFquUgwEoBdu/kK/JDXylNqExsiID
C1hIr/U0a8ixC2yvdZakEacXHOuPpJJsh9F5tvgjZWRaBtuVbpb0Ri5CVcRHsphE
srcl0RnlGSTy37UqXllkxomHcGgpXtsHGF5VQ2SDz0LVdInSmxcKvYxt7yglSw==
=xLxf
-----END PGP SIGNATURE-----

--FA1d2FvfggsWOzjwljcXGcgkgQ1PmUwfy--
