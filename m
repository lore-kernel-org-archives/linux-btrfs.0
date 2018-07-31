Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36081 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbeGaJYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 05:24:48 -0400
Subject: Re: [PATCH 1/2] btrfs: Introduce mount time chunk <-> dev extent
 mapping check
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180709064203.32409-1-wqu@suse.com>
 <20180709064203.32409-2-wqu@suse.com> <20180716130617.GG3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2c0011be-f69f-ea09-021e-f7160061f4ae@gmx.com>
Date: Tue, 31 Jul 2018 15:45:18 +0800
MIME-Version: 1.0
In-Reply-To: <20180716130617.GG3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d5r2U2Rsw4yQM4QZMG7anAVdsiSYRlLAL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d5r2U2Rsw4yQM4QZMG7anAVdsiSYRlLAL
Content-Type: multipart/mixed; boundary="E8mG0wi2TLNidARZS5FpE5bjHRVJ9Dljm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <2c0011be-f69f-ea09-021e-f7160061f4ae@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: Introduce mount time chunk <-> dev extent
 mapping check
References: <20180709064203.32409-1-wqu@suse.com>
 <20180709064203.32409-2-wqu@suse.com> <20180716130617.GG3126@twin.jikos.cz>
In-Reply-To: <20180716130617.GG3126@twin.jikos.cz>

--E8mG0wi2TLNidARZS5FpE5bjHRVJ9Dljm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8816=E6=97=A5 21:06, David Sterba wrote:
> On Mon, Jul 09, 2018 at 02:42:02PM +0800, Qu Wenruo wrote:
>> This patch will introduce chunk <-> dev extent mapping check, to prote=
ct
>> us against invalid dev extents or chunks.
>>
>> Since chunk mapping is the fundamental infrastructure of btrfs, extra
>> check at mount time could prevent a lot of unexpected behavior (BUG_ON=
).
>>
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Links: https://bugzilla.kernel.org/show_bug.cgi?id=3D200403
>=20
> Link:
>=20
>> Links: https://bugzilla.kernel.org/show_bug.cgi?id=3D200407
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c |   7 ++
>>  fs/btrfs/volumes.c | 173 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/volumes.h |   2 +
>>  3 files changed, 182 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 205092dc9390..068ca7498e94 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3075,6 +3075,13 @@ int open_ctree(struct super_block *sb,
>>  	fs_info->generation =3D generation;
>>  	fs_info->last_trans_committed =3D generation;
>> =20
>> +	ret =3D btrfs_verify_dev_extents(fs_info);
>> +	if (ret) {
>> +		btrfs_err(fs_info,
>> +			  "failed to verify dev extents against chunks: %d",
>> +			  ret);
>> +		goto fail_block_groups;
>> +	}
>>  	ret =3D btrfs_recover_balance(fs_info);
>>  	if (ret) {
>>  		btrfs_err(fs_info, "failed to recover balance: %d", ret);
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e6a8e4aabc66..05e418cb37f3 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6440,6 +6440,7 @@ static int read_one_chunk(struct btrfs_fs_info *=
fs_info, struct btrfs_key *key,
>>  	map->stripe_len =3D btrfs_chunk_stripe_len(leaf, chunk);
>>  	map->type =3D btrfs_chunk_type(leaf, chunk);
>>  	map->sub_stripes =3D btrfs_chunk_sub_stripes(leaf, chunk);
>> +	map->verified_stripes =3D 0;
>>  	for (i =3D 0; i < num_stripes; i++) {
>>  		map->stripes[i].physical =3D
>>  			btrfs_stripe_offset_nr(leaf, chunk, i);
>> @@ -7295,3 +7296,175 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_i=
nfo *fs_info)
>>  		fs_devices =3D fs_devices->seed;
>>  	}
>>  }
>> +
>> +static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripe=
s)
>> +{
>> +	switch (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
>> +	case BTRFS_BLOCK_GROUP_RAID0:
>> +		return div_u64(chunk_len, num_stripes);
>> +	case BTRFS_BLOCK_GROUP_RAID10:
>> +		return div_u64(chunk_len * 2, num_stripes);
>> +	case BTRFS_BLOCK_GROUP_RAID5:
>> +		return div_u64(chunk_len, num_stripes - 1);
>> +	case BTRFS_BLOCK_GROUP_RAID6:
>> +		return div_u64(chunk_len, num_stripes - 2);
>> +	default:
>> +		return chunk_len;
>> +	}
>> +}
>=20
> There are already too many hardcoded values for the raid profiles,
> please don't add another one unless really necessary and use existing
> predefined constants or helpers (eg. nr_data_stripes or
> btrfs_raid_array).

OK, I'll try to reuse btrfs_raid_array in next version.

Thanks,
Qu

>=20
>> +static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
>> +				 u64 chunk_offset, u64 devid,
>> +				 u64 physical_offset, u64 physical_len)
>> +{
>> +	struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map_tree;=

>> +	struct extent_map *em;
>> +	struct map_lookup *map;
>> +	u64 stripe_len;
>> +	bool found =3D false;
>=20
> This variable is only set and never checked.
>=20
>> +	int ret =3D 0;
>> +	int i;
>> +
>> +	read_lock(&em_tree->lock);
>> +	em =3D lookup_extent_mapping(em_tree, chunk_offset, 1);
>> +	read_unlock(&em_tree->lock);
>> +
>> +	if (!em) {
>> +		ret =3D -EUCLEAN;
>> +		btrfs_err(fs_info,
>> +		"dev extent (%llu, %llu) doesn't have corresponding chunk",
>> +			  devid, physical_offset);
>> +		goto out;
>> +	}
>> +
>> +	map =3D em->map_lookup;
>> +	stripe_len =3D calc_stripe_length(map->type, em->len, map->num_strip=
es);
>> +	if (physical_len !=3D stripe_len) {
>> +		btrfs_err(fs_info,
>> +"dev extent (%llu, %llu) length doesn't match with chunk %llu, have %=
llu expect %llu",
>> +			  devid, physical_offset, em->start, physical_len,
>> +			  stripe_len);
>> +		ret =3D -EUCLEAN;
>> +		goto out;
>> +	}
>> +
>> +	for (i =3D 0; i < map->num_stripes; i++) {
>> +		if (map->stripes[i].dev->devid =3D=3D devid &&
>> +		    map->stripes[i].physical =3D=3D physical_offset) {
>> +			found =3D true;
>=20
> 2nd time set
>=20
>> +			if (map->verified_stripes >=3D map->num_stripes) {
>> +				btrfs_err(fs_info,
>> +			"too many dev extent for chunk %llu is detected",
>> +					  em->start);
>> +				ret =3D -EUCLEAN;
>> +				goto out;
>> +			}
>> +			map->verified_stripes++;
>> +			break;
>> +		}
>> +	}
>> +out:
>> +	free_extent_map(em);
>> +	return ret;
>> +}
>> +
>> +static int verify_chunk_dev_extent_mapping(struct btrfs_fs_info *fs_i=
nfo)
>> +{
>> +	struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map_tree;=

>> +	struct extent_map *em;
>> +	struct rb_node *node;
>> +	int ret =3D 0;
>> +
>> +	read_lock(&em_tree->lock);
>> +	for (node =3D rb_first(&em_tree->map); node; node =3D rb_next(node))=
 {
>> +		em =3D rb_entry(node, struct extent_map, rb_node);
>> +		if (em->map_lookup->num_stripes !=3D
>> +		    em->map_lookup->verified_stripes) {
>> +			btrfs_err(fs_info,
>> +			"chunk %llu has missing dev extent, have %d expect %d",
>> +				  em->start, em->map_lookup->verified_stripes,
>> +				  em->map_lookup->num_stripes);
>> +			ret =3D -EUCLEAN;
>> +			goto out;
>> +		}
>> +	}
>> +out:
>> +	read_unlock(&em_tree->lock);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Ensure all dev extents are mapped to correct chunk.
>> + * Or later chunk allocation/free would cause unexpected behavior.
>> + *
>> + * NOTE: This will iterate through the whole device tree, which shoul=
d be
>> + * at the same size level of chunk tree.
>> + * This would increase mount time by a tiny fraction.
>> + */
>> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_path *path;
>> +	struct btrfs_root *root =3D fs_info->dev_root;
>> +	struct btrfs_key key;
>> +	int ret =3D 0;
>> +
>> +	key.objectid =3D 1;
>> +	key.type =3D BTRFS_DEV_EXTENT_KEY;
>> +	key.offset =3D 0;
>> +
>> +	path =3D btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	path->reada =3D READA_FORWARD;
>> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0])) {
>> +		ret =3D btrfs_next_item(root, path);
>> +		if (ret < 0)
>> +			goto out;
>> +		/* No dev extents at all? Not good */
>> +		if (ret > 0) {
>> +			ret =3D -EUCLEAN;
>> +			goto out;
>> +		}
>> +	}
>> +	while (1) {
>> +		struct extent_buffer *leaf =3D path->nodes[0];
>> +		struct btrfs_dev_extent *dext;
>> +		int slot =3D path->slots[0];
>> +		u64 chunk_offset;
>> +		u64 physical_offset;
>> +		u64 physical_len;
>> +		u64 devid;
>> +
>> +		btrfs_item_key_to_cpu(leaf, &key, slot);
>> +		if (key.type !=3D BTRFS_DEV_EXTENT_KEY)
>> +			break;
>> +		devid =3D key.objectid;
>> +		physical_offset =3D key.offset;
>> +
>> +		dext =3D btrfs_item_ptr(leaf, slot, struct btrfs_dev_extent);
>> +		chunk_offset =3D btrfs_dev_extent_chunk_offset(leaf, dext);
>> +		physical_len =3D btrfs_dev_extent_length(leaf, dext);
>> +
>> +		ret =3D verify_one_dev_extent(fs_info, chunk_offset, devid,
>> +					    physical_offset, physical_len);
>> +		if (ret < 0)
>> +			goto out;
>> +		ret =3D btrfs_next_item(root, path);
>> +		if (ret < 0)
>> +			goto out;
>> +		if (ret > 0) {
>> +			ret =3D 0;
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* Ensure all chunks have corresponding dev extents */
>> +	ret =3D verify_chunk_dev_extent_mapping(fs_info);
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +}
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 6d4f38ad9f5c..4301bf2d0534 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -345,6 +345,7 @@ struct map_lookup {
>>  	u64 stripe_len;
>>  	int num_stripes;
>>  	int sub_stripes;
>> +	int verified_stripes; /* For mount time dev extent verification */
>>  	struct btrfs_bio_stripe stripes[];
>>  };
>> =20
>> @@ -559,5 +560,6 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *f=
s_info);
>>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>  bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
>>  					struct btrfs_device *failing_dev);
>> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
>> =20
>>  #endif
>> --=20
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--E8mG0wi2TLNidARZS5FpE5bjHRVJ9Dljm--

--d5r2U2Rsw4yQM4QZMG7anAVdsiSYRlLAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltgE44ACgkQwj2R86El
/qhmEgf/dAqbyK8UVTlMlrbhpIFNszHBpmWsbqlm9tMG+tEi6Rs1LmNRqYeL+BHJ
dGIkrMAPbIjo0Yq5NksCAz4Df/1xlKN7YxWz4vhydL14CK4SIYe5N4gSuxtCjjPE
3o4DJyIMv9JMw2JR7+GZ0EDj4UHWtFt7kjNQDUSS/2FPDt74Lj2XxDv0466oMA5Q
s7xlaF41nl648157xjNyoKQXyNeOJjIWr6ZYseGwGtt4b5mI4cTEackr9ZZehImA
y0xMvvDO+zH2+CPRT+0kOHN/KVrPDSqfOzPsrRxGv/XI8vwJbjWPoTnSLcOIAZ/e
oNKHGpw6MhfJA9wyxYR9bF1/CkB2og==
=GqrU
-----END PGP SIGNATURE-----

--d5r2U2Rsw4yQM4QZMG7anAVdsiSYRlLAL--
