Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34921 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753587AbdEZRo4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 13:44:56 -0400
Subject: Re: [PATCH 1/6] Btrfs: add a helper to retrive extent inline ref type
To: Nikolay Borisov <nborisov@suse.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-2-bo.li.liu@oracle.com>
 <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9da83037-ee2e-f1fa-f58b-f35785b16aa3@suse.com>
Date: Fri, 26 May 2017 13:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qwM26dNVH5URClmjcmfu0AKb84Hxbxshc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qwM26dNVH5URClmjcmfu0AKb84Hxbxshc
Content-Type: multipart/mixed; boundary="qwqvr3IJnhxUeFlxP30AkItaqopoXOqm1";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, Liu Bo <bo.li.liu@oracle.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <9da83037-ee2e-f1fa-f58b-f35785b16aa3@suse.com>
Subject: Re: [PATCH 1/6] Btrfs: add a helper to retrive extent inline ref type
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-2-bo.li.liu@oracle.com>
 <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>
In-Reply-To: <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>

--qwqvr3IJnhxUeFlxP30AkItaqopoXOqm1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/26/17 3:09 AM, Nikolay Borisov wrote:
>=20
>=20
> On 26.05.2017 03:26, Liu Bo wrote:
>> An invalid value of extent inline ref type may be read from a
>> malicious image which may force btrfs to crash.
>>
>> This adds a helper which does sanity check for the ref type, so we can=

>> know if it's sane, return type if so, otherwise return an error.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>  fs/btrfs/ctree.h       |  4 ++++
>>  fs/btrfs/extent-tree.c | 35 +++++++++++++++++++++++++++++++++++
>>  2 files changed, 39 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index c411590..206ae8c 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -2542,6 +2542,10 @@ static inline gfp_t btrfs_alloc_write_mask(stru=
ct address_space *mapping)
>> =20
>>  /* extent-tree.c */
>> =20
>> +int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
>> +				     struct btrfs_extent_inline_ref *iref,
>> +				     int is_data);
>> +
>>  u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csu=
m_bytes);
>> =20
>>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info=
 *fs_info,
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index be54776..fba8ca0 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -1117,6 +1117,41 @@ static int convert_extent_item_v0(struct btrfs_=
trans_handle *trans,
>>  }
>>  #endif
>> =20
>> +/*
>> + * is_data =3D=3D 0, tree block type is required,
>> + * is_data =3D=3D 1, data type is requried,
>> + * is_data =3D=3D 2, either type is OK.
>> + */
>=20
> Can you change those numbers to either #defines or better an enum type?=

> Looking at one call site the last argument being a number says nothing
> and one has to context switch to the function definition. E.g. from
> patch2 :
>=20
> *out_type =3D btrfs_get_extent_inline_ref_type(eb, *out_eiref, 2);
>=20
> possible names:
>=20
> BTRFS_BLOCK_REF_TYPE
> BTRFS_DATA_REF_TYPE
> BTRFS_ANY_TYPE

Agreed.

-Jeff

>> +int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
>> +				     struct btrfs_extent_inline_ref *iref,
>> +				     int is_data)
>> +{
>> +	int type =3D btrfs_extent_inline_ref_type(eb, iref);
>> +
>> +	if (type =3D=3D BTRFS_TREE_BLOCK_REF_KEY ||
>> +	    type =3D=3D BTRFS_SHARED_BLOCK_REF_KEY ||
>> +	    type =3D=3D BTRFS_SHARED_DATA_REF_KEY ||
>> +	    type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
>> +		if (is_data =3D=3D 2) {
>> +			return type;
>> +		} else if (is_data =3D=3D 1) {
>> +			if (type =3D=3D BTRFS_EXTENT_DATA_REF_KEY ||
>> +			    type =3D=3D BTRFS_SHARED_DATA_REF_KEY)
>> +				return type;
>> +		} else {
>> +			if (type =3D=3D BTRFS_TREE_BLOCK_REF_KEY ||
>> +			    type =3D=3D BTRFS_SHARED_BLOCK_REF_KEY)
>> +				return type;
>> +		}
>> +	}
>> +
>> +	btrfs_print_leaf(eb->fs_info, eb);
>> +	WARN(1, "eb %llu(%s block) invalid extent inline ref type %d\n",
>> +	     eb->start, (is_data) ? "data" : "tree", type);
>> +
>> +	return -EINVAL;
>> +}
>> +
>>  static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 off=
set)
>>  {
>>  	u32 high_crc =3D ~(u32)0;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--qwqvr3IJnhxUeFlxP30AkItaqopoXOqm1--

--qwM26dNVH5URClmjcmfu0AKb84Hxbxshc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWShplB57S2MheeWyAQj5zhAAicNF53YZAPMf8cEIU23/6QSm8JfROcks
GfUA5T6xQUO4AfPebUzlsO2hUyopasCLpdAZOAfyLmBNDXTF2PhynSDyhX+BXy+H
EpFBfbgNhRtHuFeapn+SGuTs4txVnMYhhNi6KjN3+IRX+Ti4SvVo1bwZfCbAQHrN
uEqHBOtjSLFUbV3Hr4C4ATyJ5TCyfII7PccJugzLjB8f941JTf7HrmvitrALIaVa
n16dzga19WD3kHfa9+IjvSgFjVU01kXTLT6XgZjkFLrKvTj057yDfqN4ybW+35U8
YxTKO/76SGqkwRyJTLNwg0jkTeeqq/l3wwJQ5cTB3Q4AqQn0XZFhc8FRLZXL0nB/
+u7O7GKINyVwNfmvzA9kgFJ0pcoC2tW/yVpgNhdlWT9tolkmIpdEM5HGpVicgSs7
qk1ElYi8LiJRYb2kNQLWhL8UoXLsIZMfMfd3dUMSNPS4gSNAsdb8TnBRQlhahSN1
4Fj/rVQ8d+G0gYJ4Oyu+N/9iCgbKOjxvmKfP4IR8liE+FqJjb192i9s9D/evNlbG
GTovZC1xDSvz6QttpSy0DcUQo6huABF/0ScB30Z1yVmO05vNHLRXYhFNME4Po0YL
5mtUAJRzKUn10R550NVQTi0ykY64pxTIlLH3QpzBkbnMejaQKcCe88R0ZyGAA86O
hv6z5WvOHtA=
=q0wy
-----END PGP SIGNATURE-----

--qwM26dNVH5URClmjcmfu0AKb84Hxbxshc--
