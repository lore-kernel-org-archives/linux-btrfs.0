Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57344 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751931AbdKBMhl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 08:37:41 -0400
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171101121450.6297-1-wqu@suse.com>
 <a6d2aaf5-d1fb-d963-dd02-84e6ffa07954@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dd9afa2c-cc6b-3f1a-d5f4-88e53908d444@gmx.com>
Date: Thu, 2 Nov 2017 20:37:09 +0800
MIME-Version: 1.0
In-Reply-To: <a6d2aaf5-d1fb-d963-dd02-84e6ffa07954@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tRv2og8xScVLlEvMVbQDHVWSClT1HD278"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tRv2og8xScVLlEvMVbQDHVWSClT1HD278
Content-Type: multipart/mixed; boundary="rkfGCxgcqlfDkNfk6ApmfJt1kkeBCSxHE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <dd9afa2c-cc6b-3f1a-d5f4-88e53908d444@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
References: <20171101121450.6297-1-wqu@suse.com>
 <a6d2aaf5-d1fb-d963-dd02-84e6ffa07954@suse.com>
In-Reply-To: <a6d2aaf5-d1fb-d963-dd02-84e6ffa07954@suse.com>

--rkfGCxgcqlfDkNfk6ApmfJt1kkeBCSxHE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8802=E6=97=A5 20:06, Nikolay Borisov wrote:
>=20
>=20
> On  1.11.2017 14:14, Qu Wenruo wrote:
>> For the following types, we have items with variable length:
>> (With BTRFS_ prefix and _KEY suffix snipped)
>>
>> DIR_ITEM
>> DIR_INDEX
>> XATTR_ITEM
>> INODE_REF
>> INODE_EXTREF
>> ROOT_REF
>> ROOT_BACKREF
>>
>> They all use @name_len to indicate their name length, and XATTR_ITEM h=
as
>> extra @data_len to indicate it data length.
>>
>> Despite their variable length, it's also possible to have several such=

>> structure inside one item.
>>
>> This patch will add checker to ensure:
>>
>> 1) No structure header and its data cross item boundary
>> 2) Except XATTR_ITEM, no structure should have non-zero @data_len
>>
>> This checker is especially useful to avoid possible access beyond
>> boundary for fuzzed image.
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/tree-checker.c | 123 +++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  1 file changed, 123 insertions(+)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 114fc5f0ecc5..f26e86fcbd74 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -222,6 +222,120 @@ static int check_csum_item(struct btrfs_root *ro=
ot, struct extent_buffer *leaf,
>>  	return 0;
>>  }
>> =20
>> +static u32 get_header_size(u8 type)
>> +{
>> +	switch (type) {
>> +	case BTRFS_DIR_ITEM_KEY:
>> +	case BTRFS_DIR_INDEX_KEY:
>> +	case BTRFS_XATTR_ITEM_KEY:
>> +		return sizeof(struct btrfs_dir_item);
>> +	case BTRFS_INODE_REF_KEY:
>> +		return sizeof(struct btrfs_inode_ref);
>> +	case BTRFS_INODE_EXTREF_KEY:
>> +		return sizeof(struct btrfs_inode_extref);
>> +	case BTRFS_ROOT_REF_KEY:
>> +	case BTRFS_ROOT_BACKREF_KEY:
>> +		return sizeof(struct btrfs_root_ref);
>> +	}
>> +	WARN_ON(1);
>> +	return 0;
>> +}
>> +
>> +static u16 get_header_namelen(struct extent_buffer *leaf, u8 type,
>> +			      u32 header_offset)
>> +{
>> +	/*
>> +	 * @header_offset is offset starts after leaf header, while the
>> +	 * accessors expects offset starts from leaf header.
>> +	 * Sowe need to adds LEAF_DATA_OFFSET here
>> +	 */
>=20
> The comment is confusing (but so are the internals of accessing an
> extent buffer and all the offset magic happening behind the scenes).

The sentence inside the brackets is the point. :)

>=20
> You are essentially opencoding btrfs_item_ptr_offset but instead of
> pointing at the first entry in the data portion, you really point to
> 'cur' entry and in order to make it "accessor friendly" you do the +
> BTRFS_LEAF_DATA_OFFSET. I'd say just put something like :
>=20
> "This is the same as btrfs_item_ptr_offset but starting at item data
> pointed by header_offset". In fact I'd suggest renaming header_offset t=
o
> data_offset

Only if we can ensure all offsets passed in are starting after header,
then I'm OK to rename it to "data_offset"

The "header_offset" here is to info any caller that one should pass
"normal" offset here, to avoid possible LEAF_DATA_OFFSET hassle.

Thanks,
Qu

>=20
>> +	unsigned long leaf_offset =3D header_offset + BTRFS_LEAF_DATA_OFFSET=
;
>> +
>> +	switch (type) {
>> +	case BTRFS_DIR_ITEM_KEY:
>> +	case BTRFS_DIR_INDEX_KEY:
>> +	case BTRFS_XATTR_ITEM_KEY:
>> +		return btrfs_dir_name_len(leaf, (void *)leaf_offset);
>> +	case BTRFS_INODE_REF_KEY:
>> +		return btrfs_inode_ref_name_len(leaf, (void *)leaf_offset);
>> +	case BTRFS_INODE_EXTREF_KEY:
>> +		return btrfs_inode_extref_name_len(leaf, (void *)leaf_offset);
>> +	case BTRFS_ROOT_REF_KEY:
>> +	case BTRFS_ROOT_BACKREF_KEY:
>> +		return btrfs_root_ref_name_len(leaf, (void *)leaf_offset);
>> +	}
>> +	WARN_ON(1);
>> +	return 0;
>> +}
>> +
>> +static u16 get_header_datalen(struct extent_buffer *leaf, u8 type,
>> +			      unsigned long header_offset)
>> +{
>> +	/* Same as get_header_namelen */
>> +	unsigned long leaf_offset =3D header_offset + BTRFS_LEAF_DATA_OFFSET=
;
>> +
>> +	switch (type) {
>> +	case BTRFS_DIR_ITEM_KEY:
>> +	case BTRFS_DIR_INDEX_KEY:
>> +	case BTRFS_XATTR_ITEM_KEY:
>> +		return btrfs_dir_data_len(leaf, (void *)leaf_offset);
>> +	}
>> +	return 0;
>> +}
>> +
>> +/*
>> + * For items with variable length, normally with namelen and tailing =
data.
>> + * Like INODE_REF or XATTR
>> + */
>> +static int check_variable_length_item(struct btrfs_root *root,
>> +				      struct extent_buffer *leaf,
>> +				      struct btrfs_key *key, int slot)
>> +{
>> +	u8 type =3D key->type;
>> +	u32 item_start =3D btrfs_item_offset_nr(leaf, slot);
>> +	u32 item_end =3D btrfs_item_end_nr(leaf, slot);
>> +	u32 header_size =3D get_header_size(type);
>> +	u32 total_size;
>> +	u32 cur =3D item_start;
>=20
> nit: Rename cur to cur_offset to make it clear this is an offset.
>=20
>> +
>> +	while (cur < item_end) {
>> +		u32 namelen;
>> +		u32 datalen;
>> +
>> +		/* header itself should not cross item boundary */
>> +		if (cur + header_size > item_end) {
>> +			generic_err(root, leaf, slot,
>> +				"structure header crosses item boundary, have %u expect (%u, %u]"=
,
>> +				cur + header_size, cur, item_end);
>> +			return -EUCLEAN;
>> +		}
>> +
>> +		namelen =3D get_header_namelen(leaf, type, cur);
>> +		datalen =3D get_header_datalen(leaf, type, cur);
>> +
>> +		/* Only XATTR can own data */
>> +		if (type !=3D BTRFS_XATTR_ITEM_KEY && datalen) {
>> +			generic_err(root, leaf, slot,
>> +				"item has invalid data len, have %u expect 0",
>> +				datalen);
>> +			return -EUCLEAN;
>> +		}
>> +
>> +		total_size =3D header_size + namelen + datalen;
>> +
>> +		/* header and name/data should not cross item boundary */
>> +		if (cur + total_size > item_end) {
>> +			generic_err(root, leaf, slot,
>> +				"structure data crosses item boundary, have %u expect (%u, %u]",
>> +				cur + total_size, cur + header_size, item_end);
>> +			return -EUCLEAN;
>> +		}
>> +
>> +		cur +=3D total_size;
>> +	}
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Common point to switch the item-specific validation.
>>   */
>> @@ -238,6 +352,15 @@ static int check_leaf_item(struct btrfs_root *roo=
t,
>>  	case BTRFS_EXTENT_CSUM_KEY:
>>  		ret =3D check_csum_item(root, leaf, key, slot);
>>  		break;
>> +	case BTRFS_DIR_ITEM_KEY:
>> +	case BTRFS_XATTR_ITEM_KEY:
>> +	case BTRFS_DIR_INDEX_KEY:
>> +	case BTRFS_INODE_REF_KEY:
>> +	case BTRFS_INODE_EXTREF_KEY:
>> +	case BTRFS_ROOT_REF_KEY:
>> +	case BTRFS_ROOT_BACKREF_KEY:
>> +		ret =3D check_variable_length_item(root, leaf, key, slot);
>> +		break;
>>  	}
>>  	return ret;
>>  }
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--rkfGCxgcqlfDkNfk6ApmfJt1kkeBCSxHE--

--tRv2og8xScVLlEvMVbQDHVWSClT1HD278
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln7EXUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjgxQf/SvQ3btr04yRA1gI62105+4NE
IB6B3PtZgzh1KBet2EZydcRYU7q1SCoht6oCzECNZqp3uDJdPMIWh3DgZLsISwEG
hRsF34caEVVDayUi43FpebApCk28LLvMnk/m/4vuvHlKm4DNp93q8bb98y4xUG9R
78WqNGHB65aueDqQ68U4tR29Iu9oH+OmB882lUPNWWKSXfHRFPe6I7jl3ElzMQBm
kh1JaysRGQDMT8PhkhLTbBBjWQv+Zh6dTWH9SycBz+SysomfqpsldkfJ665ald7z
1+p7CD6AHz6p3FHE/MUgD+QQyv6VAAry4C1riI60rszcmY5xh3KSJ5sw6RpRMA==
=NnAO
-----END PGP SIGNATURE-----

--tRv2og8xScVLlEvMVbQDHVWSClT1HD278--
