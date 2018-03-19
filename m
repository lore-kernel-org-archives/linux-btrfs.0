Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932616AbeCSLSJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 07:18:09 -0400
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180319102810.24356-1-wqu@suse.com>
 <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>
 <f14d629e-4174-9fea-9440-fd7d9b8dd5d7@gmx.com>
 <168142ff-0b85-463e-c028-6183ae32fd75@suse.com>
 <ace03bb9-2676-e233-37e7-2b8171af779d@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <faa81e35-d3d2-e8e5-7aea-ea5da954bf76@gmx.com>
Date: Mon, 19 Mar 2018 19:17:54 +0800
MIME-Version: 1.0
In-Reply-To: <ace03bb9-2676-e233-37e7-2b8171af779d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gbc0IfISaB8TxXoqkoXSHB7xWlm7OsXrt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gbc0IfISaB8TxXoqkoXSHB7xWlm7OsXrt
Content-Type: multipart/mixed; boundary="VpK1bpAMHIo8iXTG2HthtHMlP50064nHy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <faa81e35-d3d2-e8e5-7aea-ea5da954bf76@gmx.com>
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
References: <20180319102810.24356-1-wqu@suse.com>
 <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>
 <f14d629e-4174-9fea-9440-fd7d9b8dd5d7@gmx.com>
 <168142ff-0b85-463e-c028-6183ae32fd75@suse.com>
 <ace03bb9-2676-e233-37e7-2b8171af779d@suse.com>
In-Reply-To: <ace03bb9-2676-e233-37e7-2b8171af779d@suse.com>

--VpK1bpAMHIo8iXTG2HthtHMlP50064nHy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8819=E6=97=A5 19:15, Nikolay Borisov wrote:
>=20
>=20
> On 19.03.2018 12:54, Nikolay Borisov wrote:
>>
>>
>> On 19.03.2018 12:50, Qu Wenruo wrote:
>>> What about this value?
>>> 18446744073709551607
>>>
>>> It's data reloc tree objectid.
>>> And it's pretty long since it's -9ULL.
>>>
>>> At least this makes 2 objectid more readable.
>>
>> Fair enough.
>>
>=20
> Looking a bit more I wonder if we should use the same print_objectid
> function for the "owner" field of a leaf block.
>=20
> For the data reloc tree we currently get:
>=20
> leaf 30490624 items 2 free space 16061 generation 4 owner
> 18446744073709551607
>=20
>=20
> Or for the leaf belonging to the first fs tree (5):
> leaf 30883840 items 11 free space 15354 generation 10 owner 5

Good idea!

Looks pretty nice to me.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--VpK1bpAMHIo8iXTG2HthtHMlP50064nHy--

--gbc0IfISaB8TxXoqkoXSHB7xWlm7OsXrt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqvnGIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgAdQf9H2PFCrkX0Abor7alc3jj5D8V
eHjnH0UIJRd09yEDXAX9LxsvFYZd3+dIOxUHkxYI/srzzuRwwG7bSYSfbywRMlN/
17trJXJVZlQYs7JiGziVZ01KgEJlFgqEMLpkC/hlmQdTIF9HcWySgFn0jhdY2c9P
7yjKH4kywb1RqfISzuNthYLVCOx+HRjqptSZIun6QODD2Wlb8UxgMsKRx4M3qn6a
2RN6HfcDCw/RBi2Jx5CL2WSzOYxZ1p1T3ywA8a80aRu6PTCuHloknibw9cVkzWYQ
6vynytD5c8/hFBUMgKjY1BclvwSbxx0V7jEAAN7xzuxMK5HNBym/NuFhqaLtJw==
=1ymQ
-----END PGP SIGNATURE-----

--gbc0IfISaB8TxXoqkoXSHB7xWlm7OsXrt--
