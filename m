Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:46173 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750939AbeBIKBj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 05:01:39 -0500
Subject: Re: [PATCH v2 10/10] btrfs-progs: Refactor btrfs_alloc_chunk to mimic
 kernel structure and behavior
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-12-wqu@suse.com>
 <e157d979-5468-4b73-5f7b-fcea872f6c93@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <490e2c16-5a24-e478-c2b8-214b523c482a@gmx.com>
Date: Fri, 9 Feb 2018 18:01:27 +0800
MIME-Version: 1.0
In-Reply-To: <e157d979-5468-4b73-5f7b-fcea872f6c93@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uCLWFUOn4Wu4a8qCUS9pMBstRRfbEVav0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uCLWFUOn4Wu4a8qCUS9pMBstRRfbEVav0
Content-Type: multipart/mixed; boundary="tzgGs5EnFEzw5Ygf0ZzQrTZmsp7Rt1TPK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <490e2c16-5a24-e478-c2b8-214b523c482a@gmx.com>
Subject: Re: [PATCH v2 10/10] btrfs-progs: Refactor btrfs_alloc_chunk to mimic
 kernel structure and behavior
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-12-wqu@suse.com>
 <e157d979-5468-4b73-5f7b-fcea872f6c93@suse.com>
In-Reply-To: <e157d979-5468-4b73-5f7b-fcea872f6c93@suse.com>

--tzgGs5EnFEzw5Ygf0ZzQrTZmsp7Rt1TPK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8809=E6=97=A5 16:17, Nikolay Borisov wrote:
>=20
>=20
> On  9.02.2018 09:44, Qu Wenruo wrote:
>> Kernel uses a delayed chunk allocation behavior for metadata chunks
>>
>> KERNEL:
>> btrfs_alloc_chunk()
>> |- __btrfs_alloc_chunk():	Only allocate chunk mapping
>>    |- btrfs_make_block_group():	Add corresponding bg to fs_info->new_b=
gs
>>
>> Then at transaction commit time, it finishes the remaining work:
>> btrfs_start_dirty_block_groups():
>> |- btrfs_create_pending_block_groups()
>>    |- btrfs_insert_item():	To insert block group item
>>    |- btrfs_finish_chunk_alloc(): Insert chunk items/dev extents
>>
>> Although btrfs-progs btrfs_alloc_chunk() does all the work in one
>> function, it can still benefit from function refactor like:
>> btrfs-progs:
>> btrfs_alloc_chunk():	Wrapper for both normal and convert chunks
>> |- __btrfs_alloc_chunk():	Only alloc chunk mapping
>> |  |- btrfs_make_block_group(): <<Insert bg items into extent tree>>
>> |- btrfs_finish_chunk_alloc():  Insert chunk items/dev extents
>>
>> With such refactor, the following functions can share most of its code=

>> with kernel now:
>> __btrfs_alloc_chunk()
>> btrfs_finish_chunk_alloc()
>> btrfs_alloc_dev_extent()
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  volumes.c | 421 ++++++++++++++++++++++++++++++++++++++---------------=
---------
>>  1 file changed, 260 insertions(+), 161 deletions(-)
>>
>> diff --git a/volumes.c b/volumes.c
>> index cff54c612872..e89520326314 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -523,55 +523,40 @@ static int find_free_dev_extent(struct btrfs_dev=
ice *device, u64 num_bytes,
>>  	return find_free_dev_extent_start(device, num_bytes, 0, start, len);=

>>  }
>> =20
>> -static int btrfs_insert_dev_extents(struct btrfs_trans_handle *trans,=

>> -				    struct btrfs_fs_info *fs_info,
>> -				    struct map_lookup *map, u64 stripe_size)
>> +static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>> +				  struct btrfs_device *device,
>> +				  u64 chunk_offset, u64 physical,
>> +				  u64 stripe_size)
>>  {
>> -	int ret =3D 0;
>> -	struct btrfs_path path;
>> +	int ret;
>> +	struct btrfs_path *path;
>> +	struct btrfs_fs_info *fs_info =3D device->fs_info;
>>  	struct btrfs_root *root =3D fs_info->dev_root;
>>  	struct btrfs_dev_extent *extent;
>>  	struct extent_buffer *leaf;
>>  	struct btrfs_key key;
>> -	int i;
>> =20
>> -	btrfs_init_path(&path);
>> -
>> -	for (i =3D 0; i < map->num_stripes; i++) {
>> -		struct btrfs_device *device =3D map->stripes[i].dev;
>> -
>> -		key.objectid =3D device->devid;
>> -		key.offset =3D map->stripes[i].physical;
>> -		key.type =3D BTRFS_DEV_EXTENT_KEY;
>> +	path =3D btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> =20
>> -		ret =3D btrfs_insert_empty_item(trans, root, &path, &key,
>> -					      sizeof(*extent));
>> -		if (ret < 0)
>> -			goto out;
>> -		leaf =3D path.nodes[0];
>> -		extent =3D btrfs_item_ptr(leaf, path.slots[0],
>> -					struct btrfs_dev_extent);
>> -		btrfs_set_dev_extent_chunk_tree(leaf, extent,
>> +	key.objectid =3D device->devid;
>> +	key.offset =3D physical;
>> +	key.type =3D BTRFS_DEV_EXTENT_KEY;
>> +	ret =3D btrfs_insert_empty_item(trans, root, path, &key, sizeof(*ext=
ent));
>> +	if (ret)
>> +		goto out;
>> +	leaf =3D path->nodes[0];
>> +	extent =3D btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dev_ext=
ent);
>> +	btrfs_set_dev_extent_chunk_tree(leaf, extent,
>>  					BTRFS_CHUNK_TREE_OBJECTID);
>> -		btrfs_set_dev_extent_chunk_objectid(leaf, extent,
>> -					BTRFS_FIRST_CHUNK_TREE_OBJECTID);
>> -		btrfs_set_dev_extent_chunk_offset(leaf, extent, map->ce.start);
>> -
>> -		write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
>> -			(unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
>> -			BTRFS_UUID_SIZE);
>> -
>> -		btrfs_set_dev_extent_length(leaf, extent, stripe_size);
>> -		btrfs_mark_buffer_dirty(leaf);
>> -		btrfs_release_path(&path);
>> -
>> -		device->bytes_used +=3D stripe_size;
>> -		ret =3D btrfs_update_device(trans, device);
>> -		if (ret < 0)
>> -			goto out;
>> -	}
>> +	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
>> +					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
>> +	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
>> +	btrfs_set_dev_extent_length(leaf, extent, stripe_size);
>> +	btrfs_mark_buffer_dirty(leaf);
>>  out:
>> -	btrfs_release_path(&path);
>> +	btrfs_free_path(path);
>>  	return ret;
>>  }
>> =20
>> @@ -813,28 +798,28 @@ static int btrfs_cmp_device_info(const void *a, =
const void *b)
>>  				/ sizeof(struct btrfs_stripe) + 1)
>> =20
>>  /*
>> - * Alloc a chunk, will insert dev extents, chunk item, and insert new=

>> - * block group and update space info (so that extent allocator can us=
e
>> - * newly allocated chunk).
>> + * Alloc a chunk mapping.
>> + * Will do chunk size calculation and free dev extent search, and ins=
ert
>> + * chunk mapping into chunk mapping tree.
>> + *
>> + * NOTE: This function doesn't handle any chunk item/dev extent inser=
t.
>> + * chunk item/dev extent insert is handled by later btrfs_finish_chun=
k_alloc().
>> + * And for convert chunk (1:1 mapped, more flex chunk location), it's=

>> + * handled by __btrfs_alloc_convert_chunk().
>> + *
>> + * Qu: Block group item is still inserted in this function by
>> + * btrfs_make_block_group(), this still differs from kernel.
>>   *
>=20
> If it still differs does that mean this function should undergo further=

> refactoring to unify it with the kernel or it means it will never be th=
e
> same as the kernel's code? I thought the idea of unifying the
> userspace/kernel code is to have only 1 set of functions which work bot=
h
> in kernel and userspace?

One (temporary) solution here is, make btrfs_make_block_group() virtual.
So btrfs-progs and kernel has their own version of btrfs_make_block_group=
().

And the unification is a progressive work, leaving
btrfs_make_block_group() different is acceptable at this point, since
the objective of this patchset is just to unify chunk allocator.

BTW, the real unification needs both kernel and progs side to be
modified, so this patchset is still "preparation".

Thanks,
Qu


--tzgGs5EnFEzw5Ygf0ZzQrTZmsp7Rt1TPK--

--uCLWFUOn4Wu4a8qCUS9pMBstRRfbEVav0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp9cXcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjgcwf+NNLewMH55AR3OMQi1S2eZxMK
DG3EMwfLBtZxB3O4pL1gwXD6DCKXyJyXP6Z5/2DRnUqTrFNRUDd0tfF0a85BDUmc
vcGiGEYeAfpAVazlvJr1d4UJYfCNBWse7qWGTbf9ZbxcYFzbGkAQBSAC8MQvislP
P4rChDaxUW/94sXp8Y3ydYPlMgiJ6xRDyJTCwRN1lFe3dztFF033ubedElmqDePw
izEZDUeUcMpiCKGI6YzdPl+voCB30AncKE/bi50tGOadyT7r/6FvrWV3+tBHopWo
ghr6q/2Bq4LO1EK/xZS2lR+ZJjvsiaiico5GgOEKsR3yLgwosF6qUi54/aFVxQ==
=O5mP
-----END PGP SIGNATURE-----

--uCLWFUOn4Wu4a8qCUS9pMBstRRfbEVav0--
