Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63998 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753760AbdLTIhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 03:37:25 -0500
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
Date: Wed, 20 Dec 2017 16:37:16 +0800
MIME-Version: 1.0
In-Reply-To: <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="M7lCcQtXl0Ohqeuf0YY4FELsE2xJVJTgA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M7lCcQtXl0Ohqeuf0YY4FELsE2xJVJTgA
Content-Type: multipart/mixed; boundary="BjloBa4fSlVPZsnuEzJgbFzIPFphHoGII";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
In-Reply-To: <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>

--BjloBa4fSlVPZsnuEzJgbFzIPFphHoGII
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 16:21, Su Yue wrote:
>=20
>=20
> On 12/20/2017 01:41 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
>>> Introduce create_chunk_and_block_block_group() to allocate new chunk
>>> and corresponding block group.
>>>
>>> The new function force_cow_in_new_chunk() first allocates new chunk
>>> and records its start.
>>> Then it modifies all metadata block groups cached and full.
>>> Finally it marks the new block group uncached and unfree.
>>> In the next CoW, extents states will be updated automatically by
>>> cache_block_group().
>>>
>>> Suggested-by: Qu Wenruo <wqu@suse.com>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> =C2=A0 cmds-check.c | 80
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> =C2=A0 1 file changed, 80 insertions(+)
>>>
>>> diff --git a/cmds-check.c b/cmds-check.c
>>> index d98d4bda7357..311c8a9f45e8 100644
>>> --- a/cmds-check.c
>>> +++ b/cmds-check.c
>>> @@ -10911,6 +10911,86 @@ out:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> =C2=A0 }
>>> =C2=A0 +static int create_chunk_and_block_group(struct btrfs_fs_info
>>> *fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 flags, u64 *start, u64 =
*nbytes)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D fs_info->extent_root;=

>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) =3D=3D =
0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 1);
>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(trans);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("error starting tra=
nsaction %s", strerror(-ret));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_chunk(trans, fs_info, start, =
nbytes, flags);
>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("fail to allocate n=
ew chunk %s", strerror(-ret));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_make_block_group(trans, fs_info, 0,=
 flags,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FIRST_CHUNK_TREE_OBJECTID, *start, *nby=
tes);
>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("fail to make block=
 group for chunk %llu %llu %s",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 *start, *nbytes, strerror(-ret));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 btrfs_commit_transaction(trans, root);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +static int force_cow_in_new_chunk(struct btrfs_fs_info *fs_info)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_block_group_cache *bg;
>>> +=C2=A0=C2=A0=C2=A0 u64 start;
>>> +=C2=A0=C2=A0=C2=A0 u64 nbytes;
>>> +=C2=A0=C2=A0=C2=A0 u64 alloc_profile;
>>> +=C2=A0=C2=A0=C2=A0 u64 flags;
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 alloc_profile =3D (fs_info->avail_metadata_alloc_=
bits &
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 fs_info->metadata_alloc_profile);
>>> +=C2=A0=C2=A0=C2=A0 flags =3D BTRFS_BLOCK_GROUP_METADATA | alloc_prof=
ile;
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_incompat(fs_info, MIXED_GROUPS))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags |=3D BTRFS_BLOCK_GR=
OUP_DATA;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D create_chunk_and_block_group(fs_info, fla=
gs, &start,
>>> &nbytes);
>>
>> Why bother allocating a new chunk by yourself?
>>
>> Just mark all block groups full and that's all.
>>
>> Any later tree block allocation like btrfs_search_slot() with @cow =3D=
 1
>> will trigger chunk allocation automatically.
>>
>=20
> Tried to let it happen but BUG_ON with -ENOSPC.

Then fix it.

It's not a normal behavior in this case.

Thanks,
Qu

> Do you mean do_chunk_alloc() in btrfs_reserve_extent() which is called
> while doing CoW?> In progs, allocation of new chunk during CoW depends =
@root->ref_cows.
> However, @root->ref_cows should be set only if @root is root of a fs
> trees.
>=20
> Thanks,
> Su
>=20
>> Thanks,
>> Qu
>>
>>> +=C2=A0=C2=A0=C2=A0 if (!ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printf("Create new chunk =
%llu %llu\n", start, nbytes);
>>> +=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 flags =3D BTRFS_BLOCK_GROUP_METADATA;
>>> +=C2=A0=C2=A0=C2=A0 /* Mark all metadata block groups cached and full=
 in free space*/
>>> +=C2=A0=C2=A0=C2=A0 ret =3D modify_block_groups_cache(fs_info, flags,=
 1);
>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto clear_bg_cache;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 bg =3D btrfs_lookup_block_group(fs_info, start);
>>> +=C2=A0=C2=A0=C2=A0 if (!bg) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("fail to look up bl=
ock group %llu %llu", start, nbytes);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto clear_bg_cache;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Clear block group cache just allocated */
>>> +=C2=A0=C2=A0=C2=A0 ret =3D modify_block_group_cache(fs_info, bg, 0);=

>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto clear_bg_cache;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +
>>> +clear_bg_cache:
>>> +=C2=A0=C2=A0=C2=A0 modify_block_groups_cache(fs_info, flags, 0);
>>> +err:
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> =C2=A0 static int check_extent_refs(struct btrfs_root *root,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct cache_tree *extent_cache)
>>> =C2=A0 {
>>>
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--BjloBa4fSlVPZsnuEzJgbFzIPFphHoGII--

--M7lCcQtXl0Ohqeuf0YY4FELsE2xJVJTgA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo6ITwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgj+AgAp/3oqRA9DLo8VpjRM1MCdDI+
n5xL49u5asbqPySPlvri+HLZVHEbNsKE8KevNkvzPIcn+ukB9+wYrZwVNZNiAF9s
/pxYog6X0I4afyKlNaKUS7vzCegmBl9azwnpyYlv8VyPtrWFGNnpCKwmXAjMGPar
qvzy9BjiAjCe6QamERV/Wn++5c15GmV1ruMqrWNHdup4+hV9GIQ8hDUp+hX0JTpT
m/vOJFyDdzmpvZFxbBek0AF5VsoJ0blEu34bGhCex2YIR6jyoFNgImAMMWl5SGwI
qI5Yur8QQdPV+Oh9HFk0Axawoqd5Iv5bB7CSzP1KN3UOQudwxinIFYVpB3Zs3w==
=mtf8
-----END PGP SIGNATURE-----

--M7lCcQtXl0Ohqeuf0YY4FELsE2xJVJTgA--
