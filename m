Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52119 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750727AbdKHISY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Nov 2017 03:18:24 -0500
Subject: Re: [PATCH v2 2/3] btrfs: tree-checker: Add checker for dir item
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-3-wqu@suse.com>
 <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2e930aec-dd1a-60e2-88fc-766014b63cf3@gmx.com>
Date: Wed, 8 Nov 2017 16:17:39 +0800
MIME-Version: 1.0
In-Reply-To: <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mKqo7Jb5M7tn9uhcSN2cSTolx3rux9H0r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mKqo7Jb5M7tn9uhcSN2cSTolx3rux9H0r
Content-Type: multipart/mixed; boundary="cF2Vauue1LjQXrjgED9rDjoMgUlMnLFx6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <2e930aec-dd1a-60e2-88fc-766014b63cf3@gmx.com>
Subject: Re: [PATCH v2 2/3] btrfs: tree-checker: Add checker for dir item
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-3-wqu@suse.com>
 <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>
In-Reply-To: <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>

--cF2Vauue1LjQXrjgED9rDjoMgUlMnLFx6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8808=E6=97=A5 15:59, Nikolay Borisov wrote:
>=20
>=20
> On  8.11.2017 02:54, Qu Wenruo wrote:
>> Add checker for dir item, for key types DIR_ITEM, DIR_INDEX and
>> XATTR_ITEM.
>>
>> This checker does comprehensive check for:
>> 1) dir_item header and its data size
>>    Against item boundary and maximum name/xattr length.
>>    This part is mostly the same as old verify_dir_item().
>>
>> 2) dir_type
>>    Against maximum file types, and against key type.
>>    Since XATTR key should only have FT_XATTR dir item, and normal dir
>>    item type should not have XATTR key.
>>
>>    The check between key->type and dir_type is newly introduced by thi=
s
>>    patch.
>>
>> 3) name hash
>>    For XATTR and DIR_ITEM key, key->offset is name hash (crc32).
>>    Check the hash of name against key to ensure it's correct.
>>
>>    The name hash check is only found in btrfs-progs before this patch.=

>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/tree-checker.c | 141 +++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  1 file changed, 141 insertions(+)
>>
>=20
>=20
> I'm gonna 'hijack' this patch to discuss something  - we do return the
> correct EUCLEAN status from the leaf checker, however the only place
> where it's called is in btree_readpage_end_io_hook and if the check
> fails we only return -EIO. I wonder whether want to propagate the
> EUCLEAN from there, any thoughts?

In this particular case, I think returning -EUCLEAN is *marginally* bette=
r.
Much more detailed info from block layer/csum verifier/tree-checker
makes more sense than just a single return value.

Returning any error to make the reading fail, and cause a graceful error
is good enough.
The returning values between EUCLEAN and EIO makes difference, but less
meaningful than specific output from tree-checker.

On the other hand, if in case where return value is the only meaningful
output to user-space (that's to say no much meaningful extra info like
kernel message), then return value makes sense.

But even in that case, the return value can't give much detailed info.
Here are several common errno:
EIO
ENOSPC
EUCLEAN
ENOMEM
ENOENT

We can only express at most less than 10 error types.
There are tons of places where thing can go wrong.

What we can do is just to try our best to classify these errors, and
hopes it makes sense for end user.
While more meaningful error/warning message will make both developer and
end user happier.

Thanks,
Qu

>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--cF2Vauue1LjQXrjgED9rDjoMgUlMnLFx6--

--mKqo7Jb5M7tn9uhcSN2cSTolx3rux9H0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloCvaMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjX8AgAqIH35k2qqBE3KEEwQqq91oEt
cyQtOExKoOqeeG2fFIi8PxhO2Y1MjEbutEZRUDz1L0zcb6v1Lzc8Z0xgg6dQ5Ulf
rZG0hZa6jY34VEeBN/KeSRWnIFBmdP9cqRt2jxC3W8YYx6R9VMQ408gxcNUTm4pG
uXOjd66pxQYfFYiDCG2LKL/vr6ZOyzQmn1ExdJKHHTSEI1Vay19arf74WMJ5XT1n
xH7YIpOQccOqNK6Ij99w+OmYISsX1gWmYUu1TINsmnRsgdjupcTXZycPkIaGa7UC
7x2M5kChcMbrzBkBergEzMVFv0BKBHRMDCCAqyG3e0uYv3z2kbNbbW4Ssxysug==
=4cD9
-----END PGP SIGNATURE-----

--mKqo7Jb5M7tn9uhcSN2cSTolx3rux9H0r--
