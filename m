Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:34223 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751407AbeBWJGb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 04:06:31 -0500
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <50dcc8d5-706b-dc75-5346-3d9e85f3819a@gmx.com>
Date: Fri, 23 Feb 2018 17:06:15 +0800
MIME-Version: 1.0
In-Reply-To: <23c9039f-b574-b7f1-b954-ebb48dea8740@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uVGxEEIx9qAUN0St2FELy9b1uemyDkO91"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uVGxEEIx9qAUN0St2FELy9b1uemyDkO91
Content-Type: multipart/mixed; boundary="5RBs9Yx7ExfeOjVR3qPohalps69ojY7Yg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Jeff Mahoney <jeffm@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <50dcc8d5-706b-dc75-5346-3d9e85f3819a@gmx.com>
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <bab66d63-620e-1ffd-cd24-6c1a81dab402@suse.com>
 <d8e5c4c8-1c20-6cfb-c34d-59fc8b857264@gmx.com>
 <23c9039f-b574-b7f1-b954-ebb48dea8740@suse.com>
In-Reply-To: <23c9039f-b574-b7f1-b954-ebb48dea8740@suse.com>

--5RBs9Yx7ExfeOjVR3qPohalps69ojY7Yg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8823=E6=97=A5 16:14, Nikolay Borisov wrote:
>=20
>=20
> On 23.02.2018 01:34, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8823=E6=97=A5 06:44, Jeff Mahoney wrote:
>>> On 12/22/17 1:18 AM, Qu Wenruo wrote:
>>>> Unlike reservation calculation used in inode rsv for metadata, qgrou=
p
>>>> doesn't really need to care things like csum size or extent usage fo=
r
>>>> whole tree COW.
>>>>
>>>> Qgroup care more about net change of extent usage.
>>>> That's to say, if we're going to insert one file extent, it will mos=
tly
>>>> find its place in CoWed tree block, leaving no change in extent usag=
e.
>>>> Or cause leaf split, result one new net extent, increasing qgroup nu=
mber
>>>> by nodesize.
>>>> (Or even more rare case, increase the tree level, increasing qgroup
>>>> number by 2 * nodesize)
>>>>
>>>> So here instead of using the way overkilled calculation for extent
>>>> allocator, which cares more about accurate and no error, qgroup does=
n't
>>>> need that over-calculated reservation.
>>>>
>>>> This patch will maintain 2 new members in btrfs_block_rsv structure =
for
>>>> qgroup, using much smaller calculation for qgroup rsv, reducing fals=
e
>>>> EDQUOT.
>>>
>>>
>>> I think this is the right idea but, rather than being the last step i=
n a
>>> qgroup rework, it should be the first.
>>
>> That's right.
>>
>> Although putting it as 1st patch needs extra work to co-operate with
>> later type seperation.
>>
>>>  Don't qgroup reservation
>>> lifetimes match the block reservation lifetimes?
>>
>> Also correct, but...
>>
>>>  We wouldn't want a
>>> global reserve and we wouldn't track usage on a per-block basis, but
>>> they should otherwise match.  We already have clear APIs surrounding =
the
>>> use of block reservations, so it seems to me that it'd make sense to
>>> extend those to cover the qgroup cases as well.  Otherwise, the rest =
of
>>> your patchset makes a parallel reservation system with a different AP=
I.
>>> That keeps the current state of qgroups as a bolt-on that always need=
s
>>> to be tracked separately (and which developers need to ensure they ge=
t
>>> right).
>>
>> The problem is, block reservation is designed to ensure every CoW coul=
d
>> be fulfilled without error.
>>
>> That's to say, for case like CoW write with csum, we need to care abou=
t
>> space reservation not only for EXTENT_DATA in fs tree, but also later
>> EXTENT_ITEM for extent tree, and CSUM_ITEM for csum tree.
>>
>> However extent tree and csum tree doesn't contribute to quota at all.
>> If we follow such over-reservation, it would be much much easier to hi=
t
>> false EDQUOTA early.
>>
>> That's the main reason why a separate (and a little simplified) block
>> rsv tracking system.
>>
>> And if there is better solution, I'm all ears.
>=20
> So looking at the code the main hurdles seems to be the fact that the
> btrfs_block_rsv_* API's take a raw byte count, which is derived from
> btrfs_calc_trans_metadata_size, which in turn is passed the number of
> items we want.
>=20
> So what if we extend the block_rsv_* apis to take an additional
> 'quota_bytes' or somesuch argument which would represent the amount we
> would like to be charged to the qgroups. This will force us to revisit
> every call site of block_rsv API's and adjust the code accordingly so
> that callers pass the correct number. This will lead to code such as:
>=20
> if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) { blah }

We don't need to do such check at call site.

Just do the calculation (which should be really simple, as simple as
nodesize * nr_items_to_add), and pass it to btrfs_qgroup_reserve_* APIs,
which would handle the quota enabled check.

>=20
> be contained into the block rsv apis. This will ensure lifetime of
> blockrsv/qgroups is always consistent. I think this only applies to
> qgroup metadata reservations.

Yep, and only applies to PREALLOC type metadata reservation.
For per-transaction rsv, it's handled by PERTRANS type.

Thanks,
Qu

>=20
>=20
>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> -Jeff
>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/ctree.h       | 18 +++++++++++++++++
>>>>  fs/btrfs/extent-tree.c | 55 +++++++++++++++++++++++++++++++++++++++=
+----------
>>>>  2 files changed, 62 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index 0c58f92c2d44..97783ba91e00 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -467,6 +467,24 @@ struct btrfs_block_rsv {
>>>>  	unsigned short full;
>>>>  	unsigned short type;
>>>>  	unsigned short failfast;
>>>> +
>>>> +	/*
>>>> +	 * Qgroup equivalent for @size @reserved
>>>> +	 *
>>>> +	 * Unlike normal normal @size/@reserved for inode rsv,
>>>> +	 * qgroup doesn't care about things like csum size nor how many tr=
ee
>>>> +	 * blocks it will need to reserve.
>>>> +	 *
>>>> +	 * Qgroup cares more about *NET* change of extent usage.
>>>> +	 * So for ONE newly inserted file extent, in worst case it will ca=
use
>>>> +	 * leaf split and level increase, nodesize for each file extent
>>>> +	 * is already way overkilled.
>>>> +	 *
>>>> +	 * In short, qgroup_size/reserved is the up limit of possible need=
ed
>>>> +	 * qgroup metadata reservation.
>>>> +	 */
>>>> +	u64 qgroup_rsv_size;
>>>> +	u64 qgroup_rsv_reserved;
>>>>  };
>>>> =20
>>>>  /*
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 986660f301de..9d579c7bcf7f 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -5565,14 +5565,18 @@ static void space_info_add_new_bytes(struct =
btrfs_fs_info *fs_info,
>>>> =20
>>>>  static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
>>>>  				    struct btrfs_block_rsv *block_rsv,
>>>> -				    struct btrfs_block_rsv *dest, u64 num_bytes)
>>>> +				    struct btrfs_block_rsv *dest, u64 num_bytes,
>>>> +				    u64 *qgroup_to_release_ret)
>>>>  {
>>>>  	struct btrfs_space_info *space_info =3D block_rsv->space_info;
>>>> +	u64 qgroup_to_release =3D 0;
>>>>  	u64 ret;
>>>> =20
>>>>  	spin_lock(&block_rsv->lock);
>>>> -	if (num_bytes =3D=3D (u64)-1)
>>>> +	if (num_bytes =3D=3D (u64)-1) {
>>>>  		num_bytes =3D block_rsv->size;
>>>> +		qgroup_to_release =3D block_rsv->qgroup_rsv_size;
>>>> +	}
>>>>  	block_rsv->size -=3D num_bytes;
>>>>  	if (block_rsv->reserved >=3D block_rsv->size) {
>>>>  		num_bytes =3D block_rsv->reserved - block_rsv->size;
>>>> @@ -5581,6 +5585,12 @@ static u64 block_rsv_release_bytes(struct btr=
fs_fs_info *fs_info,
>>>>  	} else {
>>>>  		num_bytes =3D 0;
>>>>  	}
>>>> +	if (block_rsv->qgroup_rsv_reserved >=3D block_rsv->qgroup_rsv_size=
) {
>>>> +		qgroup_to_release =3D block_rsv->qgroup_rsv_reserved -
>>>> +				    block_rsv->qgroup_rsv_size;
>>>> +		block_rsv->qgroup_rsv_reserved =3D block_rsv->qgroup_rsv_size;
>>>> +	} else
>>>> +		qgroup_to_release =3D 0;
>>>>  	spin_unlock(&block_rsv->lock);
>>>> =20
>>>>  	ret =3D num_bytes;
>>>> @@ -5603,6 +5613,8 @@ static u64 block_rsv_release_bytes(struct btrf=
s_fs_info *fs_info,
>>>>  			space_info_add_old_bytes(fs_info, space_info,
>>>>  						 num_bytes);
>>>>  	}
>>>> +	if (qgroup_to_release_ret)
>>>> +		*qgroup_to_release_ret =3D qgroup_to_release;
>>>>  	return ret;
>>>>  }
>>>> =20
>>>> @@ -5744,17 +5756,21 @@ int btrfs_inode_rsv_refill(struct btrfs_inod=
e *inode,
>>>>  	struct btrfs_root *root =3D inode->root;
>>>>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>>>>  	u64 num_bytes =3D 0;
>>>> +	u64 qgroup_num_bytes =3D 0;
>>>>  	int ret =3D -ENOSPC;
>>>> =20
>>>>  	spin_lock(&block_rsv->lock);
>>>>  	if (block_rsv->reserved < block_rsv->size)
>>>>  		num_bytes =3D block_rsv->size - block_rsv->reserved;
>>>> +	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
>>>> +		qgroup_num_bytes =3D block_rsv->qgroup_rsv_size -
>>>> +				   block_rsv->qgroup_rsv_reserved;
>>>>  	spin_unlock(&block_rsv->lock);
>>>> =20
>>>>  	if (num_bytes =3D=3D 0)
>>>>  		return 0;
>>>> =20
>>>> -	ret =3D btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);=

>>>> +	ret =3D btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes,=
 true);
>>>>  	if (ret)
>>>>  		return ret;
>>>>  	ret =3D reserve_metadata_bytes(root, block_rsv, num_bytes, flush);=

>>>> @@ -5762,7 +5778,13 @@ int btrfs_inode_rsv_refill(struct btrfs_inode=
 *inode,
>>>>  		block_rsv_add_bytes(block_rsv, num_bytes, 0);
>>>>  		trace_btrfs_space_reservation(root->fs_info, "delalloc",
>>>>  					      btrfs_ino(inode), num_bytes, 1);
>>>> -	}
>>>> +
>>>> +		/* Don't forget to increase qgroup_rsv_reserved */
>>>> +		spin_lock(&block_rsv->lock);
>>>> +		block_rsv->qgroup_rsv_reserved +=3D qgroup_num_bytes;
>>>> +		spin_unlock(&block_rsv->lock);
>>>> +	} else
>>>> +		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
>>>>  	return ret;
>>>>  }
>>>> =20
>>>> @@ -5784,20 +5806,23 @@ void btrfs_inode_rsv_release(struct btrfs_in=
ode *inode, bool qgroup_free)
>>>>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;=

>>>>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>>>>  	u64 released =3D 0;
>>>> +	u64 qgroup_to_release =3D 0;
>>>> =20
>>>>  	/*
>>>>  	 * Since we statically set the block_rsv->size we just want to say=
 we
>>>>  	 * are releasing 0 bytes, and then we'll just get the reservation =
over
>>>>  	 * the size free'd.
>>>>  	 */
>>>> -	released =3D block_rsv_release_bytes(fs_info, block_rsv, global_rs=
v, 0);
>>>> +	released =3D block_rsv_release_bytes(fs_info, block_rsv, global_rs=
v, 0,
>>>> +					   &qgroup_to_release);
>>>>  	if (released > 0)
>>>>  		trace_btrfs_space_reservation(fs_info, "delalloc",
>>>>  					      btrfs_ino(inode), released, 0);
>>>>  	if (qgroup_free)
>>>> -		btrfs_qgroup_free_meta_prealloc(inode->root, released);
>>>> +		btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
>>>>  	else
>>>> -		btrfs_qgroup_convert_reserved_meta(inode->root, released);
>>>> +		btrfs_qgroup_convert_reserved_meta(inode->root,
>>>> +						   qgroup_to_release);
>>>>  }
>>>> =20
>>>>  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
>>>> @@ -5809,7 +5834,7 @@ void btrfs_block_rsv_release(struct btrfs_fs_i=
nfo *fs_info,
>>>>  	if (global_rsv =3D=3D block_rsv ||
>>>>  	    block_rsv->space_info !=3D global_rsv->space_info)
>>>>  		global_rsv =3D NULL;
>>>> -	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes)=
;
>>>> +	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes,=
 NULL);
>>>>  }
>>>> =20
>>>>  static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
>>>> @@ -5889,7 +5914,7 @@ static void init_global_block_rsv(struct btrfs=
_fs_info *fs_info)
>>>>  static void release_global_block_rsv(struct btrfs_fs_info *fs_info)=

>>>>  {
>>>>  	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,=

>>>> -				(u64)-1);
>>>> +				(u64)-1, NULL);
>>>>  	WARN_ON(fs_info->trans_block_rsv.size > 0);
>>>>  	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
>>>>  	WARN_ON(fs_info->chunk_block_rsv.size > 0);
>>>> @@ -5931,7 +5956,7 @@ void btrfs_trans_release_chunk_metadata(struct=
 btrfs_trans_handle *trans)
>>>>  	WARN_ON_ONCE(!list_empty(&trans->new_bgs));
>>>> =20
>>>>  	block_rsv_release_bytes(fs_info, &fs_info->chunk_block_rsv, NULL,
>>>> -				trans->chunk_bytes_reserved);
>>>> +				trans->chunk_bytes_reserved, NULL);
>>>>  	trans->chunk_bytes_reserved =3D 0;
>>>>  }
>>>> =20
>>>> @@ -6036,6 +6061,7 @@ static void btrfs_calculate_inode_block_rsv_si=
ze(struct btrfs_fs_info *fs_info,
>>>>  {
>>>>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>>>>  	u64 reserve_size =3D 0;
>>>> +	u64 qgroup_rsv_size =3D 0;
>>>>  	u64 csum_leaves;
>>>>  	unsigned outstanding_extents;
>>>> =20
>>>> @@ -6048,9 +6074,16 @@ static void btrfs_calculate_inode_block_rsv_s=
ize(struct btrfs_fs_info *fs_info,
>>>>  						 inode->csum_bytes);
>>>>  	reserve_size +=3D btrfs_calc_trans_metadata_size(fs_info,
>>>>  						       csum_leaves);
>>>> +	/*
>>>> +	 * For qgroup rsv, the calculation is very simple:
>>>> +	 * nodesize for each outstanding extent.
>>>> +	 * This is already overkilled under most case.
>>>> +	 */
>>>> +	qgroup_rsv_size =3D outstanding_extents * fs_info->nodesize;
>>>> =20
>>>>  	spin_lock(&block_rsv->lock);
>>>>  	block_rsv->size =3D reserve_size;
>>>> +	block_rsv->qgroup_rsv_size =3D qgroup_rsv_size;
>>>>  	spin_unlock(&block_rsv->lock);
>>>>  }
>>>> =20
>>>> @@ -8405,7 +8438,7 @@ static void unuse_block_rsv(struct btrfs_fs_in=
fo *fs_info,
>>>>  			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
>>>>  {
>>>>  	block_rsv_add_bytes(block_rsv, blocksize, 0);
>>>> -	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0);
>>>> +	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0, NULL);
>>>>  }
>>>> =20
>>>>  /*
>>>>
>>>
>>>
>>


--5RBs9Yx7ExfeOjVR3qPohalps69ojY7Yg--

--uVGxEEIx9qAUN0St2FELy9b1uemyDkO91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqP2YcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhFuwf+OPQcPV2AyysKO6R4lxjRdRAG
UbveJWQE1Aod1urxz6phHK1nuSdMuVKckuTvTeTJYUaR4vXWxb1mStH38aNlQ0hJ
A3YnAoikCtH7QobFmSyYVFGy8UHUYDyPsu/hpzTK38xF2kBVpL22PrwyAKqVahDd
bJoIgpFL49wNWH44Zov7fuijMEvxJ2A0dG1gHsrMnDa7M6wLj2ICUYsFJIpiJeke
9EWtFTmUkq5gmJn9+XhO7s/azSdbNPy7Mz7iAo13017IZfOAAW67AJayQ/XSMf/Z
DrD4LSQ9Uju+VCtdilXjX3H2ZKmY3VqWG1J1n41IomujZfoqF8faiP0B65eNKg==
=sCSv
-----END PGP SIGNATURE-----

--uVGxEEIx9qAUN0St2FELy9b1uemyDkO91--
