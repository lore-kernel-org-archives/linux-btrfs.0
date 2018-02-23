Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:44653 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeBWLW5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 06:22:57 -0500
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: Nikolay Borisov <nborisov@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <bab66d63-620e-1ffd-cd24-6c1a81dab402@suse.com>
 <d8e5c4c8-1c20-6cfb-c34d-59fc8b857264@gmx.com>
 <23c9039f-b574-b7f1-b954-ebb48dea8740@suse.com>
 <50dcc8d5-706b-dc75-5346-3d9e85f3819a@gmx.com>
 <72620a92-ef6a-05af-1dc3-e9fee55e10d7@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e05d54de-ae3e-dab1-e9f4-0ce1b82736d6@gmx.com>
Date: Fri, 23 Feb 2018 19:22:37 +0800
MIME-Version: 1.0
In-Reply-To: <72620a92-ef6a-05af-1dc3-e9fee55e10d7@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ulJJNlx9GhGyg7qRJnx5sOhIQOk9mMpOD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ulJJNlx9GhGyg7qRJnx5sOhIQOk9mMpOD
Content-Type: multipart/mixed; boundary="Ag6cwVZLEK20QIaBz6GdsorpWdmLfn59u";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Jeff Mahoney <jeffm@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <e05d54de-ae3e-dab1-e9f4-0ce1b82736d6@gmx.com>
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <bab66d63-620e-1ffd-cd24-6c1a81dab402@suse.com>
 <d8e5c4c8-1c20-6cfb-c34d-59fc8b857264@gmx.com>
 <23c9039f-b574-b7f1-b954-ebb48dea8740@suse.com>
 <50dcc8d5-706b-dc75-5346-3d9e85f3819a@gmx.com>
 <72620a92-ef6a-05af-1dc3-e9fee55e10d7@suse.com>
In-Reply-To: <72620a92-ef6a-05af-1dc3-e9fee55e10d7@suse.com>

--Ag6cwVZLEK20QIaBz6GdsorpWdmLfn59u
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

[snip]
>>
>> We don't need to do such check at call site.
>>
>> Just do the calculation (which should be really simple, as simple as
>> nodesize * nr_items_to_add), and pass it to btrfs_qgroup_reserve_* API=
s,
>> which would handle the quota enabled check.
>>
>>>
>>> be contained into the block rsv apis. This will ensure lifetime of
>>> blockrsv/qgroups is always consistent. I think this only applies to
>>> qgroup metadata reservations.
>>
>> Yep, and only applies to PREALLOC type metadata reservation.
>> For per-transaction rsv, it's handled by PERTRANS type.
>=20
> And what about the btrfs_qgroup_reserve_meta()-type reservations, this
> function doesn't take a transaction, what kind of reservation is that o=
_O

We only have two functions to reserve metadata:
1) btrfs_qgroup_reserve_meta_pertrans
2) btrfs_qgroup_reserve_meta_prealloc

No 3rd option.
And each function name should explain themselves.

For pertrans rsv, we don't really need @tran parameter in fact.
We only needs to tell qgroup to reserve some meta space for pertrans type=
=2E

And there is only one caller for pertrans, that in transaction.c.

>=20
> To sum it up we have  PERTRANS, PREALLOC and  btrfs_qgroup_reserve_meta=

> and those are 3 distinct type of reservations, correct?

Only 2 in facts.

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> -Jeff
>>>>>
>>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>>> ---
>>>>>>  fs/btrfs/ctree.h       | 18 +++++++++++++++++
>>>>>>  fs/btrfs/extent-tree.c | 55 +++++++++++++++++++++++++++++++++++++=
+++----------
>>>>>>  2 files changed, 62 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>>>> index 0c58f92c2d44..97783ba91e00 100644
>>>>>> --- a/fs/btrfs/ctree.h
>>>>>> +++ b/fs/btrfs/ctree.h
>>>>>> @@ -467,6 +467,24 @@ struct btrfs_block_rsv {
>>>>>>  	unsigned short full;
>>>>>>  	unsigned short type;
>>>>>>  	unsigned short failfast;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Qgroup equivalent for @size @reserved
>>>>>> +	 *
>>>>>> +	 * Unlike normal normal @size/@reserved for inode rsv,
>>>>>> +	 * qgroup doesn't care about things like csum size nor how many =
tree
>>>>>> +	 * blocks it will need to reserve.
>>>>>> +	 *
>>>>>> +	 * Qgroup cares more about *NET* change of extent usage.
>>>>>> +	 * So for ONE newly inserted file extent, in worst case it will =
cause
>>>>>> +	 * leaf split and level increase, nodesize for each file extent
>>>>>> +	 * is already way overkilled.
>>>>>> +	 *
>>>>>> +	 * In short, qgroup_size/reserved is the up limit of possible ne=
eded
>>>>>> +	 * qgroup metadata reservation.
>>>>>> +	 */
>>>>>> +	u64 qgroup_rsv_size;
>>>>>> +	u64 qgroup_rsv_reserved;
>>>>>>  };
>>>>>> =20
>>>>>>  /*
>>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>>> index 986660f301de..9d579c7bcf7f 100644
>>>>>> --- a/fs/btrfs/extent-tree.c
>>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>>> @@ -5565,14 +5565,18 @@ static void space_info_add_new_bytes(struc=
t btrfs_fs_info *fs_info,
>>>>>> =20
>>>>>>  static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,=

>>>>>>  				    struct btrfs_block_rsv *block_rsv,
>>>>>> -				    struct btrfs_block_rsv *dest, u64 num_bytes)
>>>>>> +				    struct btrfs_block_rsv *dest, u64 num_bytes,
>>>>>> +				    u64 *qgroup_to_release_ret)
>>>>>>  {
>>>>>>  	struct btrfs_space_info *space_info =3D block_rsv->space_info;
>>>>>> +	u64 qgroup_to_release =3D 0;
>>>>>>  	u64 ret;
>>>>>> =20
>>>>>>  	spin_lock(&block_rsv->lock);
>>>>>> -	if (num_bytes =3D=3D (u64)-1)
>>>>>> +	if (num_bytes =3D=3D (u64)-1) {
>>>>>>  		num_bytes =3D block_rsv->size;
>>>>>> +		qgroup_to_release =3D block_rsv->qgroup_rsv_size;
>>>>>> +	}
>>>>>>  	block_rsv->size -=3D num_bytes;
>>>>>>  	if (block_rsv->reserved >=3D block_rsv->size) {
>>>>>>  		num_bytes =3D block_rsv->reserved - block_rsv->size;
>>>>>> @@ -5581,6 +5585,12 @@ static u64 block_rsv_release_bytes(struct b=
trfs_fs_info *fs_info,
>>>>>>  	} else {
>>>>>>  		num_bytes =3D 0;
>>>>>>  	}
>>>>>> +	if (block_rsv->qgroup_rsv_reserved >=3D block_rsv->qgroup_rsv_si=
ze) {
>>>>>> +		qgroup_to_release =3D block_rsv->qgroup_rsv_reserved -
>>>>>> +				    block_rsv->qgroup_rsv_size;
>>>>>> +		block_rsv->qgroup_rsv_reserved =3D block_rsv->qgroup_rsv_size;
>>>>>> +	} else
>>>>>> +		qgroup_to_release =3D 0;
>>>>>>  	spin_unlock(&block_rsv->lock);
>>>>>> =20
>>>>>>  	ret =3D num_bytes;
>>>>>> @@ -5603,6 +5613,8 @@ static u64 block_rsv_release_bytes(struct bt=
rfs_fs_info *fs_info,
>>>>>>  			space_info_add_old_bytes(fs_info, space_info,
>>>>>>  						 num_bytes);
>>>>>>  	}
>>>>>> +	if (qgroup_to_release_ret)
>>>>>> +		*qgroup_to_release_ret =3D qgroup_to_release;
>>>>>>  	return ret;
>>>>>>  }
>>>>>> =20
>>>>>> @@ -5744,17 +5756,21 @@ int btrfs_inode_rsv_refill(struct btrfs_in=
ode *inode,
>>>>>>  	struct btrfs_root *root =3D inode->root;
>>>>>>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>>>>>>  	u64 num_bytes =3D 0;
>>>>>> +	u64 qgroup_num_bytes =3D 0;
>>>>>>  	int ret =3D -ENOSPC;
>>>>>> =20
>>>>>>  	spin_lock(&block_rsv->lock);
>>>>>>  	if (block_rsv->reserved < block_rsv->size)
>>>>>>  		num_bytes =3D block_rsv->size - block_rsv->reserved;
>>>>>> +	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)=

>>>>>> +		qgroup_num_bytes =3D block_rsv->qgroup_rsv_size -
>>>>>> +				   block_rsv->qgroup_rsv_reserved;
>>>>>>  	spin_unlock(&block_rsv->lock);
>>>>>> =20
>>>>>>  	if (num_bytes =3D=3D 0)
>>>>>>  		return 0;
>>>>>> =20
>>>>>> -	ret =3D btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true=
);
>>>>>> +	ret =3D btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_byte=
s, true);
>>>>>>  	if (ret)
>>>>>>  		return ret;
>>>>>>  	ret =3D reserve_metadata_bytes(root, block_rsv, num_bytes, flush=
);
>>>>>> @@ -5762,7 +5778,13 @@ int btrfs_inode_rsv_refill(struct btrfs_ino=
de *inode,
>>>>>>  		block_rsv_add_bytes(block_rsv, num_bytes, 0);
>>>>>>  		trace_btrfs_space_reservation(root->fs_info, "delalloc",
>>>>>>  					      btrfs_ino(inode), num_bytes, 1);
>>>>>> -	}
>>>>>> +
>>>>>> +		/* Don't forget to increase qgroup_rsv_reserved */
>>>>>> +		spin_lock(&block_rsv->lock);
>>>>>> +		block_rsv->qgroup_rsv_reserved +=3D qgroup_num_bytes;
>>>>>> +		spin_unlock(&block_rsv->lock);
>>>>>> +	} else
>>>>>> +		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
>>>>>>  	return ret;
>>>>>>  }
>>>>>> =20
>>>>>> @@ -5784,20 +5806,23 @@ void btrfs_inode_rsv_release(struct btrfs_=
inode *inode, bool qgroup_free)
>>>>>>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rs=
v;
>>>>>>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>>>>>>  	u64 released =3D 0;
>>>>>> +	u64 qgroup_to_release =3D 0;
>>>>>> =20
>>>>>>  	/*
>>>>>>  	 * Since we statically set the block_rsv->size we just want to s=
ay we
>>>>>>  	 * are releasing 0 bytes, and then we'll just get the reservatio=
n over
>>>>>>  	 * the size free'd.
>>>>>>  	 */
>>>>>> -	released =3D block_rsv_release_bytes(fs_info, block_rsv, global_=
rsv, 0);
>>>>>> +	released =3D block_rsv_release_bytes(fs_info, block_rsv, global_=
rsv, 0,
>>>>>> +					   &qgroup_to_release);
>>>>>>  	if (released > 0)
>>>>>>  		trace_btrfs_space_reservation(fs_info, "delalloc",
>>>>>>  					      btrfs_ino(inode), released, 0);
>>>>>>  	if (qgroup_free)
>>>>>> -		btrfs_qgroup_free_meta_prealloc(inode->root, released);
>>>>>> +		btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release)=
;
>>>>>>  	else
>>>>>> -		btrfs_qgroup_convert_reserved_meta(inode->root, released);
>>>>>> +		btrfs_qgroup_convert_reserved_meta(inode->root,
>>>>>> +						   qgroup_to_release);
>>>>>>  }
>>>>>> =20
>>>>>>  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
>>>>>> @@ -5809,7 +5834,7 @@ void btrfs_block_rsv_release(struct btrfs_fs=
_info *fs_info,
>>>>>>  	if (global_rsv =3D=3D block_rsv ||
>>>>>>  	    block_rsv->space_info !=3D global_rsv->space_info)
>>>>>>  		global_rsv =3D NULL;
>>>>>> -	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_byte=
s);
>>>>>> +	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_byte=
s, NULL);
>>>>>>  }
>>>>>> =20
>>>>>>  static void update_global_block_rsv(struct btrfs_fs_info *fs_info=
)
>>>>>> @@ -5889,7 +5914,7 @@ static void init_global_block_rsv(struct btr=
fs_fs_info *fs_info)
>>>>>>  static void release_global_block_rsv(struct btrfs_fs_info *fs_inf=
o)
>>>>>>  {
>>>>>>  	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NUL=
L,
>>>>>> -				(u64)-1);
>>>>>> +				(u64)-1, NULL);
>>>>>>  	WARN_ON(fs_info->trans_block_rsv.size > 0);
>>>>>>  	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
>>>>>>  	WARN_ON(fs_info->chunk_block_rsv.size > 0);
>>>>>> @@ -5931,7 +5956,7 @@ void btrfs_trans_release_chunk_metadata(stru=
ct btrfs_trans_handle *trans)
>>>>>>  	WARN_ON_ONCE(!list_empty(&trans->new_bgs));
>>>>>> =20
>>>>>>  	block_rsv_release_bytes(fs_info, &fs_info->chunk_block_rsv, NULL=
,
>>>>>> -				trans->chunk_bytes_reserved);
>>>>>> +				trans->chunk_bytes_reserved, NULL);
>>>>>>  	trans->chunk_bytes_reserved =3D 0;
>>>>>>  }
>>>>>> =20
>>>>>> @@ -6036,6 +6061,7 @@ static void btrfs_calculate_inode_block_rsv_=
size(struct btrfs_fs_info *fs_info,
>>>>>>  {
>>>>>>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>>>>>>  	u64 reserve_size =3D 0;
>>>>>> +	u64 qgroup_rsv_size =3D 0;
>>>>>>  	u64 csum_leaves;
>>>>>>  	unsigned outstanding_extents;
>>>>>> =20
>>>>>> @@ -6048,9 +6074,16 @@ static void btrfs_calculate_inode_block_rsv=
_size(struct btrfs_fs_info *fs_info,
>>>>>>  						 inode->csum_bytes);
>>>>>>  	reserve_size +=3D btrfs_calc_trans_metadata_size(fs_info,
>>>>>>  						       csum_leaves);
>>>>>> +	/*
>>>>>> +	 * For qgroup rsv, the calculation is very simple:
>>>>>> +	 * nodesize for each outstanding extent.
>>>>>> +	 * This is already overkilled under most case.
>>>>>> +	 */
>>>>>> +	qgroup_rsv_size =3D outstanding_extents * fs_info->nodesize;
>>>>>> =20
>>>>>>  	spin_lock(&block_rsv->lock);
>>>>>>  	block_rsv->size =3D reserve_size;
>>>>>> +	block_rsv->qgroup_rsv_size =3D qgroup_rsv_size;
>>>>>>  	spin_unlock(&block_rsv->lock);
>>>>>>  }
>>>>>> =20
>>>>>> @@ -8405,7 +8438,7 @@ static void unuse_block_rsv(struct btrfs_fs_=
info *fs_info,
>>>>>>  			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
>>>>>>  {
>>>>>>  	block_rsv_add_bytes(block_rsv, blocksize, 0);
>>>>>> -	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0);
>>>>>> +	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0, NULL);
>>>>>>  }
>>>>>> =20
>>>>>>  /*
>>>>>>
>>>>>
>>>>>
>>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Ag6cwVZLEK20QIaBz6GdsorpWdmLfn59u--

--ulJJNlx9GhGyg7qRJnx5sOhIQOk9mMpOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqP+X0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhEKAf/crDym5MyGV5wexaF3ybTjh8X
e2YtAfPalNYyUcaoVICUJsLsyCgPwE1egbSMJQ6kqcnJJHHkyiH8xl9K80B05Vrr
W3b62Hywy4zfWwBMjn6wuV2d68cTKlu5mzEHZXhKZarS03v0pRelyyBXru1rJ2TJ
rJDTlToMAuyCYAz1Pbl5C/K66YpZSMDpKrDoYXgs9UruGxqNpOTPXkE369FzaUBa
ux4LuboLJzDcmX+qrSuLKJ+EqNV0m5TRNtCImA4q4N9PfQS3U+mA6kHkFwD+qox1
wuc8x2rGJNeWMpPQKukh1reBp1RaAYU4SywT84dx5ATOVooFbzOfg8GDogZGZA==
=105k
-----END PGP SIGNATURE-----

--ulJJNlx9GhGyg7qRJnx5sOhIQOk9mMpOD--
