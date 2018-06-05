Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49273 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbeFEFZC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 01:25:02 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <c0ff94a7-2465-ef57-9aab-09d8adf7c8f1@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d3fa0409-81b0-958d-e0b1-be637cff2c01@gmx.com>
Date: Tue, 5 Jun 2018 13:24:49 +0800
MIME-Version: 1.0
In-Reply-To: <c0ff94a7-2465-ef57-9aab-09d8adf7c8f1@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AiiT1blHP8W75eajmSh4aEHjJ3FWTOEdG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AiiT1blHP8W75eajmSh4aEHjJ3FWTOEdG
Content-Type: multipart/mixed; boundary="SOoO3hZqYpllJe1BVsjirKEG8lmc39nhw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <d3fa0409-81b0-958d-e0b1-be637cff2c01@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <c0ff94a7-2465-ef57-9aab-09d8adf7c8f1@mendix.com>
In-Reply-To: <c0ff94a7-2465-ef57-9aab-09d8adf7c8f1@mendix.com>

--SOoO3hZqYpllJe1BVsjirKEG8lmc39nhw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8830=E6=97=A5 02:49, Hans van Kranenburg wrote:
> On 05/21/2018 03:07 AM, Qu Wenruo wrote:
>>
>> [...]
>>
>> And the problem of wrong "root=3D" output also makes me pretty curious=
=2E
> Yeah, there a bunch of error messages in the kernel with always say
> root=3D1, regardless of the actual root the tree block is in.

I think the problem is already fixed in latest kernel.

The original version is using inode->root, which is always pointing to
root tree.

In my testing VM using 4.17-rc5, it's showing the correct value.

If you still find such problem, feel free to report it.

Thanks,
Qu

>=20
> I think I once tried to find out why, but apparently it wasn't a really=

> obvious error somewhere.
>=20


--SOoO3hZqYpllJe1BVsjirKEG8lmc39nhw--

--AiiT1blHP8W75eajmSh4aEHjJ3FWTOEdG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsWHqEACgkQwj2R86El
/qgJTAgAku+kAR49ifznjmQ5Wve2wEBpmWIqgoomEtnNQv7+l0kU28mIEDBuM6kY
Us8QRn8ZjC882GX4u3D+oESGSpCKLrhwe9Sc8+X/uy2eKban1FNYlW6mKJbb5TyG
KNtdoigufEyg7H9wdESRVMiZNt5qrp+aptAMow4Gxa5DsLIxX6yRaa+08F3ih7h5
1gFpy7Rs/lzEPpd2QXuQbQWCCealbwCWevsgErE4zaKUNW2JzbKIQnUNg9B0dgGU
aZShg/Q5gcWvEtSwG9BRfmAasdaUQM4OPGPmdiDgOb0HxSUDSBWenWsGOinKWdkD
mKbiYxtVCjaRgH7gFzcksI+zAiCLOQ==
=kswd
-----END PGP SIGNATURE-----

--AiiT1blHP8W75eajmSh4aEHjJ3FWTOEdG--
