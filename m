Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58945 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbeBBJmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 04:42:07 -0500
Subject: Re: [PATCH 2/7] btrfs-progs: Merge btrfs_alloc_data_chunk into
 btrfs_alloc_chunk
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-3-wqu@suse.com>
 <12a99e67-52bf-9b4b-86b7-eee1ee26af16@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dcb65cb4-d7de-8e80-d439-fba35c8d86ac@gmx.com>
Date: Fri, 2 Feb 2018 17:41:43 +0800
MIME-Version: 1.0
In-Reply-To: <12a99e67-52bf-9b4b-86b7-eee1ee26af16@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MbbHEEJZfcaROtve56Jwvz44sowTGuNTL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MbbHEEJZfcaROtve56Jwvz44sowTGuNTL
Content-Type: multipart/mixed; boundary="shyBhSvHgjtENgLMPJNoWawsfwZYj44Z3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <dcb65cb4-d7de-8e80-d439-fba35c8d86ac@gmx.com>
Subject: Re: [PATCH 2/7] btrfs-progs: Merge btrfs_alloc_data_chunk into
 btrfs_alloc_chunk
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-3-wqu@suse.com>
 <12a99e67-52bf-9b4b-86b7-eee1ee26af16@cn.fujitsu.com>
In-Reply-To: <12a99e67-52bf-9b4b-86b7-eee1ee26af16@cn.fujitsu.com>

--shyBhSvHgjtENgLMPJNoWawsfwZYj44Z3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8802=E6=97=A5 17:20, Su Yue wrote:
>=20
>=20
> On 02/02/2018 04:19 PM, Qu Wenruo wrote:
>> We used to have two chunk allocators, btrfs_alloc_chunk() and
>> btrfs_alloc_data_chunk(), the former is the more generic one, while th=
e
>> later is only used in mkfs and convert, to allocate SINGLE data chunk.=

>>
>> Although btrfs_alloc_data_chunk() has some special hacks to cooperate
>> with convert, it's quite simple to integrity it into the generic chunk=

>> allocator.
>>
>> So merge them into one btrfs_alloc_chunk(), with extra @convert
>> parameter and necessary comment, to make code less duplicated and less=

>> thing to maintain.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 convert/main.c |=C2=A0=C2=A0 6 +-
>> =C2=A0 extent-tree.c=C2=A0 |=C2=A0=C2=A0 2 +-
>> =C2=A0 mkfs/main.c=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 8 +--
>> =C2=A0 volumes.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 219
>> ++++++++++++++++++++++-----------------------------------
[snip]
>> diff --git a/volumes.c b/volumes.c
>> index 677d085de96c..9ee4650351c3 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -836,9 +836,23 @@ error:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - 2 * sizeof(struct btrfs_chunk))=C2=A0=C2=
=A0=C2=A0 \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 / sizeof(struct btrfs_stripe) + 1)
>> =C2=A0 +/*
>> + * Alloc a chunk, will insert dev extents, chunk item.
>> + * NOTE: This function will not insert block group item nor mark newl=
y
>> + * allocated chunk available for later allocation.
>> + * Block group item and free space update is handled by
>> btrfs_make_block_group()
>> + *
>> + * @start:=C2=A0=C2=A0=C2=A0 return value of allocated chunk start by=
tenr.
>> + * @num_bytes:=C2=A0=C2=A0=C2=A0 return value of allocated chunk size=

>> + * @type:=C2=A0=C2=A0=C2=A0 chunk type (including both profile and ty=
pe)
>> + * @convert:=C2=A0=C2=A0=C2=A0 if the chunk is allocated for convert =
case.
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If @convert is tru=
e, chunk allocator will skip device extent
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 search, but use *s=
tart and *num_bytes as chunk
>> start/num_bytes
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 and devive offset,=
 to build a 1:1 chunk mapping for convert.
>> + */
>> =C2=A0 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type, bool convert)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 dev_offset;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *extent_root =3D info=
->extent_root;
>> @@ -868,10 +882,38 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle
>> *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 offset;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 if (list_empty(dev_list)) {
>> +=C2=A0=C2=A0=C2=A0 if (list_empty(dev_list))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOSPC;=

>> +
>> +=C2=A0=C2=A0=C2=A0 if (convert) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* For convert, profile mu=
st be SINGLE */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type & BTRFS_BLOCK_GRO=
UP_PROFILE_MASK) {
> Maybe BTRFS_RAID_SINGLE?

Here we're using type and raid index is not introduced yet, so what
we're doing is correct.

Thanks,
Qu

>=20
> Thanks,
> Su
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("convert only suports SINGLE profile");
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(*start, in=
fo->sectorsize)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("chunk start not aligned, start=3D%llu sectorsize=3D%u",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *start, info->sectorsize);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(*num_bytes=
, info->sectorsize)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("chunk size not aligned, size=3D%llu sectorsize=3D%u",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *num_bytes, info->sectorsize);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size =3D *num_bytes;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D *start;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * For convert, we us=
e 1:1 chunk mapping specified by @start and
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * @num_bytes, so the=
re is no need to go through dev_extent
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * searching.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto alloc_chunk;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Chunk size calculation part.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type & BTRFS_BLOCK_GROUP_PROFILE_MA=
SK) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type & BTRF=
S_BLOCK_GROUP_SYSTEM) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 calc_size =3D SZ_8M;
>> @@ -942,6 +984,9 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle
>> *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percent_max =3D
>> div_factor(btrfs_super_total_bytes(info->super_copy), 1);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 max_chunk_size =3D min(percent_max, max=
_chunk_size);
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Reserve space from each device.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0 again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (chunk_bytes_by_type(type, calc_size=
, num_stripes,
>> sub_stripes) >
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 max_chunk_size)=
 {
>> @@ -972,7 +1017,8 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 return ret;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur =3D cur->ne=
xt;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (avail >=3D =
min_free) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_move_tail(&device->dev_list, &private_devs);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_move_tail(&device->dev_list,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &private_=
devs);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 index++;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (type & BTRFS_BLOCK_GROUP_DUP)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index++;
>> @@ -999,9 +1045,16 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOSPC;=

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 ret =3D find_next_chunk(info, &offset);
>> -=C2=A0=C2=A0=C2=A0 if (ret)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Fill chunk mapping and chunk stripes
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +alloc_chunk:
>> +=C2=A0=C2=A0=C2=A0 if (!convert) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_next_chunk(in=
fo, &offset);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3D BTRFS_FIRST_CHUNK_TREE=
_OBJECTID;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_CHUNK_ITEM_KEY;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D offset;
>> @@ -1022,17 +1075,31 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while(index < num_stripes) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_st=
ripe *stripe;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(list_empty(&private=
_devs));
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur =3D private_devs.next;=

>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device =3D list_entry(cur,=
 struct btrfs_device, dev_list);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* loop over this d=
evice again if we're doing a dup group */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(type & BTRFS_BLOCK_G=
ROUP_DUP) ||
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (i=
ndex =3D=3D num_stripes - 1))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_move_tail(&device->dev_list, dev_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!convert) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (list_empty(&private_devs))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -ENODEV;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cu=
r =3D private_devs.next;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
vice =3D list_entry(cur, struct btrfs_device, dev_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (!(type & BTRFS_BLOCK_GROUP_DUP) ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 (index =3D=3D num_stripes - 1)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * loop over this device again if we're doing =
a
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * dup group
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 list_move_tail(&device->dev_list, dev_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Only SINGLE is accepted in convert case */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BU=
G_ON(num_stripes > 1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
vice =3D list_entry(dev_list->next, struct btrfs_device,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev=
_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ke=
y.offset =3D *start;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v_offset =3D *start;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D =
btrfs_alloc_dev_extent(trans, device, key.offset,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size, &dev_offset, 0);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size, &dev_offset, convert);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out_chunk_map;
>> =C2=A0 @@ -1049,7 +1116,7 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(stripe->=
dev_uuid, device->uuid, BTRFS_UUID_SIZE);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index++;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 BUG_ON(!list_empty(&private_devs));
>> +=C2=A0=C2=A0=C2=A0 BUG_ON(!convert && !list_empty(&private_devs));
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* key was set above */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_length(chunk, *nu=
m_bytes);
>> @@ -1069,6 +1136,9 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->num_stripes =3D num_stripes;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->sub_stripes =3D sub_stripes;
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Insert chunk item and chunk mapping.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_insert_item(trans, chunk_=
root, &key, chunk,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_chunk_item_size(num_stripes));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> @@ -1098,125 +1168,6 @@ out_chunk:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> =C2=A0 -/*
>> - * Alloc a DATA chunk with SINGLE profile.
>> - *
>> - * If 'convert' is set, it will alloc a chunk with 1:1 mapping
>> - * (btrfs logical bytenr =3D=3D on-disk bytenr)
>> - * For that case, caller must make sure the chunk and dev_extent are =
not
>> - * occupied.
>> - */
>> -int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 struct btrfs_fs_info *info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u64 num_bytes, u64 type, int convert)
>> -{
>> -=C2=A0=C2=A0=C2=A0 u64 dev_offset;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root *extent_root =3D info->extent_ro=
ot;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root *chunk_root =3D info->chunk_root=
;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_stripe *stripes;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_device *device =3D NULL;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_chunk *chunk;
>> -=C2=A0=C2=A0=C2=A0 struct list_head *dev_list =3D &info->fs_devices->=
devices;
>> -=C2=A0=C2=A0=C2=A0 struct list_head *cur;
>> -=C2=A0=C2=A0=C2=A0 struct map_lookup *map;
>> -=C2=A0=C2=A0=C2=A0 u64 calc_size =3D SZ_8M;
>> -=C2=A0=C2=A0=C2=A0 int num_stripes =3D 1;
>> -=C2=A0=C2=A0=C2=A0 int sub_stripes =3D 0;
>> -=C2=A0=C2=A0=C2=A0 int ret;
>> -=C2=A0=C2=A0=C2=A0 int index;
>> -=C2=A0=C2=A0=C2=A0 int stripe_len =3D BTRFS_STRIPE_LEN;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> -
>> -=C2=A0=C2=A0=C2=A0 key.objectid =3D BTRFS_FIRST_CHUNK_TREE_OBJECTID;
>> -=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_CHUNK_ITEM_KEY;
>> -=C2=A0=C2=A0=C2=A0 if (convert) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (*start !=3D round_down=
(*start, info->sectorsize)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("DATA chunk start not sectorsize aligned: %llu",
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long long)*start)=
;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D *start;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_offset =3D *start;
>> -=C2=A0=C2=A0=C2=A0 } else {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 tmp;
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_next_chunk(in=
fo, &tmp);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D tmp;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 chunk =3D kmalloc(btrfs_chunk_item_size(num_stripe=
s), GFP_NOFS);
>> -=C2=A0=C2=A0=C2=A0 if (!chunk)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> -
>> -=C2=A0=C2=A0=C2=A0 map =3D kmalloc(btrfs_map_lookup_size(num_stripes)=
, GFP_NOFS);
>> -=C2=A0=C2=A0=C2=A0 if (!map) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(chunk);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 stripes =3D &chunk->stripe;
>> -=C2=A0=C2=A0=C2=A0 calc_size =3D num_bytes;
>> -
>> -=C2=A0=C2=A0=C2=A0 index =3D 0;
>> -=C2=A0=C2=A0=C2=A0 cur =3D dev_list->next;
>> -=C2=A0=C2=A0=C2=A0 device =3D list_entry(cur, struct btrfs_device, de=
v_list);
>> -
>> -=C2=A0=C2=A0=C2=A0 while (index < num_stripes) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_stripe *strip=
e;
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_dev_ex=
tent(trans, device, key.offset,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size, &dev_offset, convert);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device->bytes_used +=3D ca=
lc_size;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_update_devic=
e(trans, device);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->stripes[index].dev =3D=
 device;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->stripes[index].physic=
al =3D dev_offset;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe =3D stripes + index=
;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_stack_stripe_dev=
id(stripe, device->devid);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_stack_stripe_off=
set(stripe, dev_offset);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(stripe->dev_uuid, d=
evice->uuid, BTRFS_UUID_SIZE);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index++;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 /* key was set above */
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_length(chunk, num_bytes);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_owner(chunk, extent_root->ro=
ot_key.objectid);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_stripe_len(chunk, stripe_len=
);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_type(chunk, type);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_num_stripes(chunk, num_strip=
es);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_io_align(chunk, stripe_len);=

>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_io_width(chunk, stripe_len);=

>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_sector_size(chunk, info->sec=
torsize);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_sub_stripes(chunk, sub_strip=
es);
>> -=C2=A0=C2=A0=C2=A0 map->sector_size =3D info->sectorsize;
>> -=C2=A0=C2=A0=C2=A0 map->stripe_len =3D stripe_len;
>> -=C2=A0=C2=A0=C2=A0 map->io_align =3D stripe_len;
>> -=C2=A0=C2=A0=C2=A0 map->io_width =3D stripe_len;
>> -=C2=A0=C2=A0=C2=A0 map->type =3D type;
>> -=C2=A0=C2=A0=C2=A0 map->num_stripes =3D num_stripes;
>> -=C2=A0=C2=A0=C2=A0 map->sub_stripes =3D sub_stripes;
>> -
>> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_insert_item(trans, chunk_root, &key,=
 chunk,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_chunk_item_size(num_stripes));
>> -=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -=C2=A0=C2=A0=C2=A0 if (!convert)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *start =3D key.offset;
>> -
>> -=C2=A0=C2=A0=C2=A0 map->ce.start =3D key.offset;
>> -=C2=A0=C2=A0=C2=A0 map->ce.size =3D num_bytes;
>> -
>> -=C2=A0=C2=A0=C2=A0 ret =3D insert_cache_extent(&info->mapping_tree.ca=
che_tree, &map->ce);
>> -=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -
>> -=C2=A0=C2=A0=C2=A0 kfree(chunk);
>> -=C2=A0=C2=A0=C2=A0 return ret;
>> -}
>> -
>> =C2=A0 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical=
, u64
>> len)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_mapping_tree *map_tree =3D=
 &fs_info->mapping_tree;
>> diff --git a/volumes.h b/volumes.h
>> index 11572e78c04f..7bbdf615d31a 100644
>> --- a/volumes.h
>> +++ b/volumes.h
>> @@ -208,10 +208,7 @@ int btrfs_read_sys_array(struct btrfs_fs_info
>> *fs_info);
>> =C2=A0 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
>> =C2=A0 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type);
>> -int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u64 num_bytes, u64 type, int convert);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type, bool convert);
>> =C2=A0 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int flags);
>> =C2=A0 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>>
>=20
>=20


--shyBhSvHgjtENgLMPJNoWawsfwZYj44Z3--

--MbbHEEJZfcaROtve56Jwvz44sowTGuNTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp0MlcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgh4Qf9HbUQtg0xePW6k4L9Qy8uCXVW
mgQFgbJjVHAY/gREC7TBi5a5ZqsbDEkYrigS4BRygotLNKKeRN6bq+IGuCAd5a7C
pOhrAfQrGcywpODACvfjyhKfOve9HvwvExCvDViupiI3l+v02sDNKy1uDYRIBu/b
zBFTJDfrruTAtSGLUXZmPwG8DMr9ZhhbkdvbUWp1BvMnxHplFjLa/vCrDlzLiEw3
0So7KLF23ruVMoF/aF3C2KIXBr2meP10vsbFKI4LBD6o2xZuywhZm6YJTJK5YiFL
wI5Jg3PKKaa9WBF4WHZTK4nixQCzojS9sXzsh3V9EHTpE4Aub1O0dAJKhMfk2A==
=UPvT
-----END PGP SIGNATURE-----

--MbbHEEJZfcaROtve56Jwvz44sowTGuNTL--
