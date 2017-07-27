Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751452AbdG0Qi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 12:38:59 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: convert: properly handle reserved ranges
 while iterating files
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20170725205443.29874-1-jeffm@suse.com>
 <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <040281e8-680a-561e-1302-771be2eea4e1@suse.com>
Date: Thu, 27 Jul 2017 12:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ww1Rx2rGgIaOnSo3rve8XVo5BlkP54JMj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ww1Rx2rGgIaOnSo3rve8XVo5BlkP54JMj
Content-Type: multipart/mixed; boundary="d5to218KotMx8kXs6lM3LPwSxD3P2iGok";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <040281e8-680a-561e-1302-771be2eea4e1@suse.com>
Subject: Re: [PATCH 1/3] btrfs-progs: convert: properly handle reserved ranges
 while iterating files
References: <20170725205443.29874-1-jeffm@suse.com>
 <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>
In-Reply-To: <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>

--d5to218KotMx8kXs6lM3LPwSxD3P2iGok
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/17 9:35 PM, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B407=E6=9C=8826=E6=97=A5 04:54, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit 522ef705e38 (btrfs-progs: convert: Introduce function to calcul=
ate
>> the available space) changed how we handle migrating file data so that=

>> we never have btrfs space associated with the reserved ranges.  This
>> works pretty well and when we iterate over the file blocks, the
>> associations are redirected to the migrated locations.
>>
>> This commit missed the case in block_iterate_proc where we just check
>> for intersection with a superblock location before looking up a block
>> group.  intersect_with_sb checks to see if the range intersects with
>> a stripe containing a superblock but, in fact, we've reserved the
>> full 0-1MB range at the start of the disk.  So a file block located
>> at e.g. 160kB will fall in the reserved region but won't be excepted
>> in block_iterate_block.  We ultimately hit a BUG_ON when we fail
>> to look up the block group for that location.
>=20
> The description of the problem  is indeed correct.
>=20
>>
>> This is reproducible using convert-tests/003-ext4-basic.
>=20
> Thanks for pointing this out, I also reproduced it.
>=20
> While it would be nicer if you could upload a special crafted image as
> indicated test case.
> IIRC the test passed without problem several versions ago, so there may=

> be some factors preventing the bug from being exposed.
>=20
>>
>> The fix is to have intersect_with_sb and block_iterate_proc understand=

>> the full size of the reserved ranges.  Since we use the range to
>> determine the boundary for the block iterator, let's just return the
>> boundary.  0 isn't a valid boundary and means that we proceed normally=

>> with block group lookup.
>=20
> I'm OK with current fix as it indeed fix the bug and has minimal impact=

> on current code.
>=20
> So feel free to add:
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>=20
> While I think there is a better way to solve it more completely.
>=20
> As when we run into block_iterate_proc(), we have already created
> ext2_save/image.
> So we can use the the image as ext2 <-> btrfs position mapping, just as=

> we have already done in record_file_blocks().
>=20
> That's to say, we don't need too much care about the intersection with
> reserved range, but just letting record_file_blocks() to handle it will=

> be good enough.
>=20
> What do you think about this idea?

I think you're right.  It should do the mapping already so we don't need
to do anything special in block_iterate_proc.  I can test that in a bit.

-Jeff

> Thanks,
> Qu
>=20
>>
>> Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>   convert/source-fs.c | 25 +++++++++++--------------
>>   1 file changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/convert/source-fs.c b/convert/source-fs.c
>> index 80e4e41..09f6995 100644
>> --- a/convert/source-fs.c
>> +++ b/convert/source-fs.c
>> @@ -28,18 +28,16 @@ const struct simple_range btrfs_reserved_ranges[3]=

>> =3D {
>>       { BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
>>   };
>>   -static int intersect_with_sb(u64 bytenr, u64 num_bytes)
>> +static u64 intersect_with_reserved(u64 bytenr, u64 num_bytes)
>>   {
>>       int i;
>> -    u64 offset;
>>   -    for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>> -        offset =3D btrfs_sb_offset(i);
>> -        offset &=3D ~((u64)BTRFS_STRIPE_LEN - 1);
>> +    for (i =3D 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
>> +        const struct simple_range *range =3D &btrfs_reserved_ranges[i=
];
>>   -        if (bytenr < offset + BTRFS_STRIPE_LEN &&
>> -            bytenr + num_bytes > offset)
>> -            return 1;
>> +        if (bytenr < range_end(range) &&
>> +            bytenr + num_bytes >=3D range->start)
>> +            return range_end(range);
>>       }
>>       return 0;
>>   }
>> @@ -64,14 +62,14 @@ int block_iterate_proc(u64 disk_block, u64
>> file_block,
>>                         struct blk_iterate_data *idata)
>>   {
>>       int ret =3D 0;
>> -    int sb_region;
>> +    u64 reserved_boundary;
>>       int do_barrier;
>>       struct btrfs_root *root =3D idata->root;
>>       struct btrfs_block_group_cache *cache;
>>       u64 bytenr =3D disk_block * root->sectorsize;
>>   -    sb_region =3D intersect_with_sb(bytenr, root->sectorsize);
>> -    do_barrier =3D sb_region || disk_block >=3D idata->boundary;
>> +    reserved_boundary =3D intersect_with_reserved(bytenr,
>> root->sectorsize);
>> +    do_barrier =3D reserved_boundary || disk_block >=3D idata->bounda=
ry;
>>       if ((idata->num_blocks > 0 && do_barrier) ||
>>           (file_block > idata->first_block + idata->num_blocks) ||
>>           (disk_block !=3D idata->disk_block + idata->num_blocks)) {
>> @@ -91,9 +89,8 @@ int block_iterate_proc(u64 disk_block, u64 file_bloc=
k,
>>                   goto fail;
>>           }
>>   -        if (sb_region) {
>> -            bytenr +=3D BTRFS_STRIPE_LEN - 1;
>> -            bytenr &=3D ~((u64)BTRFS_STRIPE_LEN - 1);
>> +        if (reserved_boundary) {
>> +            bytenr =3D reserved_boundary;
>>           } else {
>>               cache =3D btrfs_lookup_block_group(root->fs_info, bytenr=
);
>>               BUG_ON(!cache);
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--d5to218KotMx8kXs6lM3LPwSxD3P2iGok--

--ww1Rx2rGgIaOnSo3rve8XVo5BlkP54JMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWXoXHh57S2MheeWyAQhNZBAAk454/7tTlOBtNnc6tSMtquKtAvDWoAfS
QBcCSXnUjc3YgOBWURBOJlhl4U8FK7kkTfZ6myrgmLeXX8qtG7Sy2aShJhSHyRL1
+BSvtX8rYWmtxqDNI7P1KvF6MB554vrghtngQfPsrwLfYuVQoqo9X/yfbGd2s3pk
HiqzxS5XmfwYC9lfJm7WUgv/QfbhLYGvsuWMM6WJsE9o+wuiQuW6IRMaYdmhkutg
3QOmeF9jlSc1AzCAkJ93jY8y+o45CDygpwvwOxnJd2i5Y+yIkAmTevb4KTWNVrMD
VeHpsUespgYx6kstzA6sZnubHkspweVU9i3Qr2eVREmFWDuvnHgTaY92LQ5ODFuO
XFHYjXKJM36KKu2QagMCZfdSjhkFk0h+/Uz/ryRR74bkhJ2BMJYESRBlbcK2U36U
f8A2TgNEd/bf5yg88PaQ6r6t7PV0yNpzfMQP4Zomhqij3u0ByTUbFP8z5NSq7SD6
Onv9KHJpv1qbBw5R1UwRhRwnRyBKeij5bPUgEbXTbEPLVGdv7mzkbrbj5p7La0fE
L7/b1JaNFO8Tyr8RAKqoKzm7+jpboZUAnqhhELmnWrgqo2k+4s70Y/j0D9VXvvWQ
qzb9ld8EJpzwkJPmiaJ+Cu4aXm/G/HOJhtz+ob6/elQulO8GECDaWSPbE7rohJwf
RhOhbf1hFxs=
=EwZS
-----END PGP SIGNATURE-----

--ww1Rx2rGgIaOnSo3rve8XVo5BlkP54JMj--
