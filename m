Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60722 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbdKUIEO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 03:04:14 -0500
Subject: Re: [PATCH 2/2] btrfs: extent-tree: Ensure btrfs_trim_fs can trim the
 whole fs
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lists@colorremedies.com
References: <20171121072145.24413-1-wqu@suse.com>
 <20171121072145.24413-2-wqu@suse.com>
 <8b64b5b9-4316-0fcb-2369-568e07c2c2cd@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cd122924-3a36-c5d9-4b29-036f26379be2@gmx.com>
Date: Tue, 21 Nov 2017 16:03:56 +0800
MIME-Version: 1.0
In-Reply-To: <8b64b5b9-4316-0fcb-2369-568e07c2c2cd@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QTg7tHgvbxrNOVVV8QDch99WHND9OKxOU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QTg7tHgvbxrNOVVV8QDch99WHND9OKxOU
Content-Type: multipart/mixed; boundary="nPPOmRvu4WIhJH3GRuAodVOrQW68hvDIq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lists@colorremedies.com
Message-ID: <cd122924-3a36-c5d9-4b29-036f26379be2@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: extent-tree: Ensure btrfs_trim_fs can trim the
 whole fs
References: <20171121072145.24413-1-wqu@suse.com>
 <20171121072145.24413-2-wqu@suse.com>
 <8b64b5b9-4316-0fcb-2369-568e07c2c2cd@suse.com>
In-Reply-To: <8b64b5b9-4316-0fcb-2369-568e07c2c2cd@suse.com>

--nPPOmRvu4WIhJH3GRuAodVOrQW68hvDIq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 15:41, Nikolay Borisov wrote:
>=20
>=20
> On 21.11.2017 09:21, Qu Wenruo wrote:
>> [BUG]
>> fstrim on some btrfs only trims the unallocated space, not trimming an=
y
>> space in existing block groups.
>>
>> [CAUSE]
>> fstrim_range passed in by default fstrim will be:
>>
>> range->start =3D 0
>> range->len =3D fs_size (which equals with super->total_bytes)
>> range->min_len =3D 512
>>
>> However btrfs_trim_fs() following above parameter to search block grou=
ps
>> to trim.
>>
>> While it's quite possible that all chunks start beyond
>> super->total_bytes if the fs is balanced several times.
>>
>> In that case, btrfs will skip trimming block groups and only trim the
>> unallocated space of each device.
>>
>> [FIX]
>> For common full fs trimming range passed in, extent its len to (u64)-1=

>> so we will iterate all block groups.
>>
>> And for custom fs trimming range, due to the fact that the range will
>> always be truncated by range [0, super->total_bytes), making custom fs=

>> trimming range useless.
>>
>> Just return -ENOTTY for custom fs trimming range.
>>
>> Reported-by: Chris Murphy <lists@colorremedies.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> I think we want this tagged for stable ?

Sounds pretty good.

Although I'm a little concerned about the ENOTTY return branch, not sure
if it will break script of some guys.

Thanks,
Qu

>=20
>=20
>> ---
>>  fs/btrfs/extent-tree.c | 29 ++++++++++++++++++++++++-----
>>  1 file changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 3a252d7af158..22bbcc8c4f6c 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -11024,12 +11024,31 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_i=
nfo, struct fstrim_range *range)
>>  	int ret =3D 0;
>> =20
>>  	/*
>> -	 * try to trim all FS space, our block group may start from non-zero=
=2E
>> +	 * NOTE: Btrfs uses its own logical address space, where its first
>> +	 * chunk can start anywhere if it wants.
>> +	 * If we follow common start =3D 0 and len =3D fs_size from @range, =
we
>> +	 * can end up without trimming any block groups, since it's highly
>> +	 * possible all chunks start beyond that range.
>> +	 *
>> +	 * So if we want to trim the whole fs, extent the len to (u64)-1 to =
trim
>> +	 * all block groups.
>> +	 *
>> +	 * Also, since @range will always be truncated to fs size, manually
>> +	 * passing range to trim specified range doesn't make much sense.
>> +	 * (No mean to trim any block group whose bytenr starts beyond
>> +	 *  @total_bytes)
>> +	 * So in that case, return -ENOTTY directly to prevent any custom tr=
im
>> +	 * request.
>>  	 */
>> -	if (range->len =3D=3D total_bytes)
>> -		cache =3D btrfs_lookup_first_block_group(fs_info, range->start);
>> -	else
>> -		cache =3D btrfs_lookup_block_group(fs_info, range->start);
>> +	if (range->start =3D=3D 0 && range->len =3D=3D total_bytes) {
>> +		range->len =3D (u64)-1;
>> +	} else {
>> +		btrfs_info(fs_info,
>> +		"trimming custom range is not supported due to the limitation of fs=
trim_range");
>> +		return -ENOTTY;
>> +	}
>> +
>> +	cache =3D btrfs_lookup_first_block_group(fs_info, range->start);
>> =20
>>  	for (; cache; cache =3D next_block_group(fs_info, cache)) {
>>  		if (cache->key.objectid >=3D (range->start + range->len)) {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--nPPOmRvu4WIhJH3GRuAodVOrQW68hvDIq--

--QTg7tHgvbxrNOVVV8QDch99WHND9OKxOU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloT3ewXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiBfQf+Mtf2U9LP/qA1q6mqEsBum0n2
xdG+b02CM6kKpp0wlja87IZ+U9zU4upAkTmZU9JXEHukxSQKqYxwvWc2ogAR56WX
6Psdb0WT9ZKM/GILP1ZeqFI8MQWKsB1CwYghOdHhtBmWQgyABBXncDv94/RFJT+J
aJE7JJitoY1ikngsuyxkLx8k+9wQqomeZo74Z/EmEVIQizTnzXyqk6YlNq57gGiY
NTkcs4rLYY0pSJJdZXhFRY+32jYKEjSuhQVZTWTxqOUFytmWWxCOauFRZl8kDZkE
+T3LdDdRcMnO/Wskn/YD9fm8GLvqszxEK21XlFIJ39J1yKNaMzIkJS3jkv0Aog==
=aIDp
-----END PGP SIGNATURE-----

--QTg7tHgvbxrNOVVV8QDch99WHND9OKxOU--
