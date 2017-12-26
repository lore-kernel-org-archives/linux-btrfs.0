Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51538 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdLZK2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Dec 2017 05:28:42 -0500
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
 <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
 <c70b76c8-61c8-999a-158f-667fa9c86b5f@gmx.com>
 <45d9878a-b6cd-fd0d-5309-05e17c9db51a@cn.fujitsu.com>
 <87e23c3c-73a9-47c6-e68c-b79186678bfa@gmx.com>
 <262f2016-4b63-49db-11d1-83e4ab964957@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <802a5de7-c058-ac24-2ba7-dbe911f858a3@gmx.com>
Date: Tue, 26 Dec 2017 18:28:32 +0800
MIME-Version: 1.0
In-Reply-To: <262f2016-4b63-49db-11d1-83e4ab964957@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AO94OBOvw8KBcZaJ5NFBk6DcqKUmJobte"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AO94OBOvw8KBcZaJ5NFBk6DcqKUmJobte
Content-Type: multipart/mixed; boundary="9YJwR9M9zEy3XfH26GrNvXa9InlnnSYI2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <802a5de7-c058-ac24-2ba7-dbe911f858a3@gmx.com>
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
 <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
 <c70b76c8-61c8-999a-158f-667fa9c86b5f@gmx.com>
 <45d9878a-b6cd-fd0d-5309-05e17c9db51a@cn.fujitsu.com>
 <87e23c3c-73a9-47c6-e68c-b79186678bfa@gmx.com>
 <262f2016-4b63-49db-11d1-83e4ab964957@cn.fujitsu.com>
In-Reply-To: <262f2016-4b63-49db-11d1-83e4ab964957@cn.fujitsu.com>

--9YJwR9M9zEy3XfH26GrNvXa9InlnnSYI2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8826=E6=97=A5 16:17, Su Yue wrote:
>=20
>=20
> On 12/21/2017 03:12 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8821=E6=97=A5 15:09, Su Yue wrote:
>>>
>>>
>>> On 12/21/2017 02:51 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 16:37, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 16:21, Su Yue wrote:
>>>>>>
>>>>>>
>>>>>> On 12/20/2017 01:41 PM, Qu Wenruo wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
>>>>>>>> Introduce create_chunk_and_block_block_group() to allocate new
>>>>>>>> chunk
>>>>>>>> and corresponding block group.
>>>>>>>>
>>>>>>>> The new function force_cow_in_new_chunk() first allocates new ch=
unk
>>>>>>>> and records its start.
>>>>>>>> Then it modifies all metadata block groups cached and full.
>>>>>>>> Finally it marks the new block group uncached and unfree.
>>>>>>>> In the next CoW, extents states will be updated automatically by=

>>>>>>>> cache_block_group().
>>>>>>>>
>>>>>>>> Suggested-by: Qu Wenruo <wqu@suse.com>
>>>>>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>>>>>> ---
>>>>>>>> =C2=A0=C2=A0=C2=A0 cmds-check.c | 80
>>>>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>> =C2=A0=C2=A0=C2=A0 1 file changed, 80 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>>>>>> index d98d4bda7357..311c8a9f45e8 100644
>>>>>>>> --- a/cmds-check.c
>>>>>>>> +++ b/cmds-check.c
>>>>>>>> @@ -10911,6 +10911,86 @@ out:
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>>>>> =C2=A0=C2=A0=C2=A0 }
>>>>>>>> =C2=A0=C2=A0=C2=A0 +static int create_chunk_and_block_group(stru=
ct btrfs_fs_info
>>>>>>>> *fs_info,
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 flags, u64 *start=
, u64 *nbytes)
>>>>>>>> +{
>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D fs_info->extent_=
root;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) =3D=
=3D 0)
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 1);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(tran=
s);
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("error startin=
g transaction %s", strerror(-ret));
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_chunk(trans, fs_info, st=
art, nbytes, flags);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("fail to alloc=
ate new chunk %s", strerror(-ret));
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_make_block_group(trans, fs_inf=
o, 0, flags,
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FIRST_CHUNK_TREE_OBJECTID, *start=
,
>>>>>>>> *nbytes);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("fail to make =
block group for chunk %llu %llu %s",
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 *start, *nbytes, strerror(-ret));
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>>> +out:
>>>>>>>> +=C2=A0=C2=A0=C2=A0 btrfs_commit_transaction(trans, root);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static int force_cow_in_new_chunk(struct btrfs_fs_info *fs_info=
)
>>>>>>>> +{
>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_block_group_cache *bg;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 u64 start;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 u64 nbytes;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 u64 alloc_profile;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 u64 flags;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 alloc_profile =3D (fs_info->avail_metadata_a=
lloc_bits &
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 fs_info->metadata_alloc_profile);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 flags =3D BTRFS_BLOCK_GROUP_METADATA | alloc=
_profile;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_incompat(fs_info, MIXED_GROUPS)=
)
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags |=3D BTRFS_BLO=
CK_GROUP_DATA;
>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D create_chunk_and_block_group(fs_info=
, flags, &start,
>>>>>>>> &nbytes);
>>>>>>>
>>>>>>> Why bother allocating a new chunk by yourself?
>>>>>>>
>>>>>>> Just mark all block groups full and that's all.
>>>>>>>
>>>>>>> Any later tree block allocation like btrfs_search_slot() with
>>>>>>> @cow =3D 1
>>>>>>> will trigger chunk allocation automatically.
>>>>>>>
>>>>>>
>>>>>> Tried to let it happen but BUG_ON with -ENOSPC.
>>>>>
>>>>> Then fix it.
>>>>>
>>>>> It's not a normal behavior in this case.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>
>>>> And I think the fix to allow btrfs_reserve_extent() to allocate new
>>>> chunk will solve a lot of strange BUG_ON().
>>>>
>>>> it just occurred to me that, a lot of use cases relies on the
>>>> assumption
>>>> that btrfs_reserve_extent() will try to allocate new chunks.
>>>>
>>>> Especially for case like convert, certain btrfs check --repair, some=

>>>> rescue tools.
>>>>
>>> Sorry for the previous wrong format mail.
>>>
>>> Yes, it has many dependency so I considered to do chunk allocation
>>> manually in the patchset. If fix is not good enough, many funtions
>>> of btrfs-progs will behave abnormal.
>>> Since you ask it, I will go to fix it.
>>
>> Manually allocation in advance has its advantage, like we can determin=
e
>> if there is enough space for new chunk instead of checking every retur=
n
>> value with ENOSPC.
>>
>>
>> However in current case, your metadata usage is limited to the new chu=
nk
>> only.
>> If there extent tree has quite a lot of problem, and the chunk allocat=
ed
>> is small (if using single profile and small fs), it can easily hit
>> ENOSPC again, since btrfs doesn't allocate new chunk for later metadat=
a
>> write.
>>
> SAD. After I tried to implement above nice idea, infinite recursive
> brings me back to the reality.
>=20
> Here is the reason why btrfs_reserve_extent can not allocate chunk
> by itself if ENOSPC hints:
>=20
> btrfs_cow_block
> ...
> =C2=A0 btrfs_reserve_extent
> =C2=A0=C2=A0=C2=A0 btrfs_alloc_chunk
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_alloc_dev_extent
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_insert_empty_item
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_cow_=
block

The order is just wrong.

We should first check for the new chunk space, not doing the insert
right now.

I'll take over the work if you're OK with it.

Thanks,
Qu

>=20
> Thanks,
> Su
>=20
>> So here, we still need to allow btrfs allocate new meta chunk, even we=

>> pre-allocate one meta chunk in advance.
>>
>> Thanks,
>> Qu
>>>
>>> Thanks,
>>> Su
>>>
>>>> So this would be a quite nice start point for such fix.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>> Do you mean do_chunk_alloc() in btrfs_reserve_extent() which is
>>>>>> called
>>>>>> while doing CoW?> In progs, allocation of new chunk during CoW
>>>>>> depends @root->ref_cows.
>>>>>> However, @root->ref_cows should be set only if @root is root of a =
fs
>>>>>> trees.
>>>>>>
>>>>>> Thanks,
>>>>>> Su
>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (!ret)
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printf("Create new c=
hunk %llu %llu\n", start, nbytes);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 else
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err;
>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 flags =3D BTRFS_BLOCK_GROUP_METADATA;
>>>>>>>> +=C2=A0=C2=A0=C2=A0 /* Mark all metadata block groups cached and=
 full in free
>>>>>>>> space*/
>>>>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D modify_block_groups_cache(fs_info, f=
lags, 1);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto clear_bg_cache;=

>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 bg =3D btrfs_lookup_block_group(fs_info, sta=
rt);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (!bg) {
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("fail to look =
up block group %llu %llu", start,
>>>>>>>> nbytes);
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto clear_bg_cache;=

>>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 /* Clear block group cache just allocated */=

>>>>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D modify_block_group_cache(fs_info, bg=
, 0);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto clear_bg_cache;=

>>>>>>>> +
>>>>>>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>>>>>>> +
>>>>>>>> +clear_bg_cache:
>>>>>>>> +=C2=A0=C2=A0=C2=A0 modify_block_groups_cache(fs_info, flags, 0)=
;
>>>>>>>> +err:
>>>>>>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> =C2=A0=C2=A0=C2=A0 static int check_extent_refs(struct btrfs_roo=
t *root,
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct cache_tree =
*extent_cache)
>>>>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>> --=C2=A0
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>>
>>>>
>>>
>>>
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--9YJwR9M9zEy3XfH26GrNvXa9InlnnSYI2--

--AO94OBOvw8KBcZaJ5NFBk6DcqKUmJobte
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpCJFAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgr7ggAnuXDLk+CS7RDBgL8LNrM5xJ2
Vf92uP0gbuEKjiuZHf2ozhPWoDZbHiiyUB3qCAXlPs0T57YqHs4hk5dQItRjPnHl
6kuAM7louaU9me4pfaW1GG3wLZV6VbI3Miy+4RN3BovT39lXZ+xTk+6Tkqif8JUM
24jUYwI573BObJurXBCbVeew2C5LT9phS1eimAYfT7yB7Tj/Sa3AXrTai6WtVmph
kcthkBnXVawpMpsF7oo/hAGqqkomsgAEzal38mA/mVXreilfv8dVcS38hSIn7GVB
ZUbajcTHPWrkzVII4FaGW7AOUs+sQWfcslM/liojLVpl24MmN+lGu0Ba1Jb43A==
=XJtz
-----END PGP SIGNATURE-----

--AO94OBOvw8KBcZaJ5NFBk6DcqKUmJobte--
