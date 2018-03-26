Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:47911 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbeCZH52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 03:57:28 -0400
Subject: Re: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
References: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
 <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
 <e3a82fc6-2649-4d47-1893-9277130e6a1c@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a90d3f5c-835d-d610-d819-9e33f4d3d874@gmx.com>
Date: Mon, 26 Mar 2018 15:57:09 +0800
MIME-Version: 1.0
In-Reply-To: <e3a82fc6-2649-4d47-1893-9277130e6a1c@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KHUp3PTVBkO0kDUWrJ2pOC61JT2njigOl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KHUp3PTVBkO0kDUWrJ2pOC61JT2njigOl
Content-Type: multipart/mixed; boundary="prd8DxGO2vs92emRA98OFvmFVj3nNdNXs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Message-ID: <a90d3f5c-835d-d610-d819-9e33f4d3d874@gmx.com>
Subject: Re: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
References: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
 <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
 <e3a82fc6-2649-4d47-1893-9277130e6a1c@jp.fujitsu.com>
In-Reply-To: <e3a82fc6-2649-4d47-1893-9277130e6a1c@jp.fujitsu.com>

--prd8DxGO2vs92emRA98OFvmFVj3nNdNXs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8826=E6=97=A5 08:54, Misono Tomohiro wrote:
> On 2018/03/23 18:14, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8823=E6=97=A5 16:20, Misono Tomohiro wrote:
>>> The kernel code no longer has BTRFS_CRC32_SIZE and only uses
>>> btrfs_csum_sizes[]. So, update the progs code as well.
>>>
>>> Suggested-by: Qu Wenruo <wqu@suse.com>
>>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>>  convert/common.c |  2 +-
>>>  convert/main.c   |  2 +-
>>>  ctree.h          |  3 +--
>>>  image/main.c     |  4 ++--
>>>  mkfs/common.c    | 14 +++++++-------
>>>  5 files changed, 12 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/convert/common.c b/convert/common.c
>>> index 3860f3b9..2b944fd8 100644
>>> --- a/convert/common.c
>>> +++ b/convert/common.c
>>> @@ -219,7 +219,7 @@ static inline int write_temp_extent_buffer(int fd=
, struct extent_buffer *buf,
>>>  {
>>>  	int ret;
>>> =20
>>> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
>>> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], =
0);
>>
>> I'd say the normal kernel way to do this is like this, other than usin=
g
>> BTRFS_CSUM_TYPE_CRC32:
>> 	u16 csum_size =3D btrfs_super_csum_size(fs_info->super_copy);
>>
>> Thanks,
>> Qu
>=20
>=20
> Thanks, but we cannot access fs_info or struct btrfs_super_block here (=
and others in this diff).
> Should we pass the csum type parameter as an argument? Since currently =
the only
> supported type is crc32, I'm not sure if we should write the code so ge=
neric at this time.

Fair enough.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--prd8DxGO2vs92emRA98OFvmFVj3nNdNXs--

--KHUp3PTVBkO0kDUWrJ2pOC61JT2njigOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq4p9UACgkQwj2R86El
/qg1+Af9EyimevUNp15Y3jeSQ4i4tx/HxIvd9qc+EvPYAxR57rSLmFMorApwMU9p
WyZOaAUpm/msfgRH0Cjj8FKXrZ/ByvqFwFpFX1XkPlG0agTly0iwGtkX3T5xuueM
TI96rnKhR2NMkP4JvNThLzNN1BHUnEV9ZJP0Df+z+GLQcjQ9hlbJ9hBJqgE6GnOn
jzhThfkQYaNeXfPNk1L/cXEeR3xOm4TuxDoG9KqLc/HmjXbaBQAUNg3sikNnvfiQ
jHfn/8YcvB+z2Zx7mSq/OE6fB/2y3/kbQsdMBYgY0s3coK8eNsrBvpr4ds5MyScj
KXJqQijmiVDPIBAlL296l4DffrjIzQ==
=kc2M
-----END PGP SIGNATURE-----

--KHUp3PTVBkO0kDUWrJ2pOC61JT2njigOl--
