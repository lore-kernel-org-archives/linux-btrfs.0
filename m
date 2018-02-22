Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55043 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753121AbeBVJXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 04:23:50 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
 <bc11f64d-5e5a-54d0-79c1-1459f3eb7c68@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4ef8f699-fb40-2116-e640-540b79919412@gmx.com>
Date: Thu, 22 Feb 2018 17:23:30 +0800
MIME-Version: 1.0
In-Reply-To: <bc11f64d-5e5a-54d0-79c1-1459f3eb7c68@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yomAUZq0UZe7RJgVmLzqsVYcBaevRZUH2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yomAUZq0UZe7RJgVmLzqsVYcBaevRZUH2
Content-Type: multipart/mixed; boundary="uthTow03EqwIJYy4VH2vyQ5he8lNN5AqU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
Message-ID: <4ef8f699-fb40-2116-e640-540b79919412@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
References: <20180222045215.16426-1-wqu@suse.com>
 <bc11f64d-5e5a-54d0-79c1-1459f3eb7c68@suse.com>
In-Reply-To: <bc11f64d-5e5a-54d0-79c1-1459f3eb7c68@suse.com>

--uthTow03EqwIJYy4VH2vyQ5he8lNN5AqU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



[snip]
>> -}
>> -
>>  void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
>>  {
>>  	struct btrfs_block_group_cache *block_group;
>> @@ -9988,12 +9934,15 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>>  {
>>  	struct btrfs_path *path;
>>  	int ret;
>> +	struct btrfs_mapping_tree *map_tree =3D &info->mapping_tree;
>> +	struct btrfs_root *extent_root =3D info->extent_root;
>>  	struct btrfs_block_group_cache *cache;
>>  	struct btrfs_space_info *space_info;
>>  	struct btrfs_key key;
>>  	struct btrfs_key found_key;
>>  	struct extent_buffer *leaf;
>>  	int need_clear =3D 0;
>> +	u64 cur =3D 0;
>>  	u64 cache_gen;
>>  	u64 feature;
>>  	int mixed;
>> @@ -10001,13 +9950,9 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>>  	feature =3D btrfs_super_incompat_flags(info->super_copy);
>>  	mixed =3D !!(feature & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS);
>> =20
>> -	key.objectid =3D 0;
>> -	key.offset =3D 0;
>> -	key.type =3D BTRFS_BLOCK_GROUP_ITEM_KEY;
>>  	path =3D btrfs_alloc_path();
>>  	if (!path)
>>  		return -ENOMEM;
>> -	path->reada =3D READA_FORWARD;
>> =20
>>  	cache_gen =3D btrfs_super_cache_generation(info->super_copy);
>>  	if (btrfs_test_opt(info, SPACE_CACHE) &&
>> @@ -10017,10 +9962,30 @@ int btrfs_read_block_groups(struct btrfs_fs_i=
nfo *info)
>>  		need_clear =3D 1;
>> =20
>>  	while (1) {
>> -		ret =3D find_first_block_group(info, path, &key);
>> -		if (ret > 0)
>> +		struct extent_map *em;
>> +
>> +		read_lock(&map_tree->map_tree.lock);
>> +		em =3D lookup_extent_mapping(&map_tree->map_tree, cur,
>> +					   ((u64)-1) - cur);
>> +		read_unlock(&map_tree->map_tree.lock);
>> +		if (!em)
>>  			break;
>> -		if (ret !=3D 0)
>> +
>> +		key.objectid =3D em->start;
>> +		key.offset =3D em->len;
>> +		key.type =3D BTRFS_BLOCK_GROUP_ITEM_KEY;
>> +		cur =3D em->start + em->len;
>> +		free_extent_map(em);
>> +
>> +		ret =3D btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
>> +		if (ret > 0) {
>> +			WARN(1, KERN_ERR
>> +			"chunk [%llu %llu) doesn't has its block group item\n",
>=20
> I'd rephrase this to "chunk [%llu %llu) doesn't have matching block
> group item"

Sounds good.

Sorry for my poor English.

>=20
>> +			     key.objectid, key.objectid + key.offset);
>> +			ret =3D -ENOENT;
>> +			goto error;
>> +		}
>=20
> Looks good, howevr when the time for merging comes I'd rather have this=

> code be part of a function named find_block_group or some such. Let's
> see if this code brings any improvements and then bikeshed on the detai=
ls.

Isn't that the original find_first_block_group() function?

Thanks,
Qu

>=20
>> +		if (ret < 0)
>>  			goto error;
>> =20
>>  		leaf =3D path->nodes[0];
>> @@ -10062,7 +10027,6 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>>  			goto error;
>>  		}
>> =20
>> -		key.objectid =3D found_key.objectid + found_key.offset;
>>  		btrfs_release_path(path);
>> =20
>>  		/*
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--uthTow03EqwIJYy4VH2vyQ5he8lNN5AqU--

--yomAUZq0UZe7RJgVmLzqsVYcBaevRZUH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqOjBIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgHbQf/RGHq1sctKB4PpL0BqCCVdUzH
V3hlaXCbnM6sUvSYc4JP9LOwz+5fvhfma7KHtOpJHinWrvJCCDVjY6wajHPxKNOM
RPIuZv/K97jLesT3QyRRv6kyI6wLvHUv5A3L3cZI7odlVZs2ckboYISzS5etDkti
d6nB+y1ZBIbDyyz6UKyDTzLJBzYwf7micMjhOKDL1rCzVE9XFC2IA2Eb7w9slP6O
2YHLgIZOr47+skHEQnASeVUqVxVV13J9ij19dEapzu+OhjjRN7dJhDYj51HHU7vX
IeyuvrBaWB/45HBcWyZkX5+/nz9kwYDqX1lT1MkbE8X0RwVdhWofbRsiU+epUg==
=s5tr
-----END PGP SIGNATURE-----

--yomAUZq0UZe7RJgVmLzqsVYcBaevRZUH2--
