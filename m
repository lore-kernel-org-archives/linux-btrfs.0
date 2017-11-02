Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64869 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754894AbdKBNfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 09:35:18 -0400
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171101121450.6297-1-wqu@suse.com>
 <f6ec5a67-95e0-0950-3efa-c9c77ded3b2c@suse.com>
 <b62fa3aa-8b09-dd34-0ef6-97d8229bd535@gmx.com>
 <0a79c9cd-ba67-293a-2981-3182775eda90@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f2cf1b05-4941-a0ad-e8a4-e926950a03a6@gmx.com>
Date: Thu, 2 Nov 2017 21:35:03 +0800
MIME-Version: 1.0
In-Reply-To: <0a79c9cd-ba67-293a-2981-3182775eda90@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4ano7iIDNo4wJbmd3VjOaALE56ba1Aa7G"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4ano7iIDNo4wJbmd3VjOaALE56ba1Aa7G
Content-Type: multipart/mixed; boundary="lclGKp2j8INoBu9x9QV4ihDqqQP53Xi2c";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <f2cf1b05-4941-a0ad-e8a4-e926950a03a6@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
References: <20171101121450.6297-1-wqu@suse.com>
 <f6ec5a67-95e0-0950-3efa-c9c77ded3b2c@suse.com>
 <b62fa3aa-8b09-dd34-0ef6-97d8229bd535@gmx.com>
 <0a79c9cd-ba67-293a-2981-3182775eda90@suse.com>
In-Reply-To: <0a79c9cd-ba67-293a-2981-3182775eda90@suse.com>

--lclGKp2j8INoBu9x9QV4ihDqqQP53Xi2c
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8802=E6=97=A5 20:56, Nikolay Borisov wrote:
>=20
>=20
> On  2.11.2017 14:48, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8802=E6=97=A5 20:12, Nikolay Borisov wrote:
>>>
>>>
>>> On  1.11.2017 14:14, Qu Wenruo wrote:
>>>> For the following types, we have items with variable length:
>>>> (With BTRFS_ prefix and _KEY suffix snipped)
>>>>
>>>> DIR_ITEM
>>>> DIR_INDEX
>>>> XATTR_ITEM
>>>> INODE_REF
>>>> INODE_EXTREF
>>>> ROOT_REF
>>>> ROOT_BACKREF
>>>>
>>>> They all use @name_len to indicate their name length, and XATTR_ITEM=
 has
>>>> extra @data_len to indicate it data length.
>>>>
>>>> Despite their variable length, it's also possible to have several su=
ch
>>>> structure inside one item.
>>>>
>>>> This patch will add checker to ensure:
>>>>
>>>> 1) No structure header and its data cross item boundary
>>>> 2) Except XATTR_ITEM, no structure should have non-zero @data_len
>>>>
>>>> This checker is especially useful to avoid possible access beyond
>>>> boundary for fuzzed image.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/tree-checker.c | 123 +++++++++++++++++++++++++++++++++++++=
+++++++++++
>>>>  1 file changed, 123 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>>> index 114fc5f0ecc5..f26e86fcbd74 100644
>>>> --- a/fs/btrfs/tree-checker.c
>>>> +++ b/fs/btrfs/tree-checker.c
>>>> @@ -222,6 +222,120 @@ static int check_csum_item(struct btrfs_root *=
root, struct extent_buffer *leaf,
>>>>  	return 0;
>>>>  }
>>>> =20
>>>> +static u32 get_header_size(u8 type)
>>>> +{
>>>> +	switch (type) {
>>>> +	case BTRFS_DIR_ITEM_KEY:
>>>> +	case BTRFS_DIR_INDEX_KEY:
>>>> +	case BTRFS_XATTR_ITEM_KEY:
>>>> +		return sizeof(struct btrfs_dir_item);
>>>> +	case BTRFS_INODE_REF_KEY:
>>>> +		return sizeof(struct btrfs_inode_ref);
>>>> +	case BTRFS_INODE_EXTREF_KEY:
>>>> +		return sizeof(struct btrfs_inode_extref);
>>>> +	case BTRFS_ROOT_REF_KEY:
>>>> +	case BTRFS_ROOT_BACKREF_KEY:
>>>> +		return sizeof(struct btrfs_root_ref);
>>>> +	}
>>>> +	WARN_ON(1);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static u16 get_header_namelen(struct extent_buffer *leaf, u8 type,
>>>> +			      u32 header_offset)
>>>> +{
>>>> +	/*
>>>> +	 * @header_offset is offset starts after leaf header, while the
>>>> +	 * accessors expects offset starts from leaf header.
>>>> +	 * Sowe need to adds LEAF_DATA_OFFSET here
>>>> +	 */
>>>> +	unsigned long leaf_offset =3D header_offset + BTRFS_LEAF_DATA_OFFS=
ET;
>>>> +
>>>> +	switch (type) {
>>>> +	case BTRFS_DIR_ITEM_KEY:
>>>> +	case BTRFS_DIR_INDEX_KEY:
>>>> +	case BTRFS_XATTR_ITEM_KEY:
>>>> +		return btrfs_dir_name_len(leaf, (void *)leaf_offset);
>>>> +	case BTRFS_INODE_REF_KEY:
>>>> +		return btrfs_inode_ref_name_len(leaf, (void *)leaf_offset);
>>>> +	case BTRFS_INODE_EXTREF_KEY:
>>>> +		return btrfs_inode_extref_name_len(leaf, (void *)leaf_offset);
>>>> +	case BTRFS_ROOT_REF_KEY:
>>>> +	case BTRFS_ROOT_BACKREF_KEY:
>>>> +		return btrfs_root_ref_name_len(leaf, (void *)leaf_offset);
>>>> +	}
>>>> +	WARN_ON(1);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static u16 get_header_datalen(struct extent_buffer *leaf, u8 type,
>>>> +			      unsigned long header_offset)
>>>> +{
>>>> +	/* Same as get_header_namelen */
>>>> +	unsigned long leaf_offset =3D header_offset + BTRFS_LEAF_DATA_OFFS=
ET;
>>>> +
>>>> +	switch (type) {
>>>> +	case BTRFS_DIR_ITEM_KEY:
>>>> +	case BTRFS_DIR_INDEX_KEY:
>>>> +	case BTRFS_XATTR_ITEM_KEY:
>>>> +		return btrfs_dir_data_len(leaf, (void *)leaf_offset);
>>>> +	}
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * For items with variable length, normally with namelen and tailin=
g data.
>>>> + * Like INODE_REF or XATTR
>>>> + */
>>>> +static int check_variable_length_item(struct btrfs_root *root,
>>>> +				      struct extent_buffer *leaf,
>>>> +				      struct btrfs_key *key, int slot)
>>>> +{
>>>
>>> One more thing - you are only validating the boundaries of such varia=
ble
>>> length items, so make this specific. I.e rename the function to
>>> something like:
>>
>> If you follow the naming schema in tree-checker, you'll find that we (=
at
>> least myself) is naming these function always using "check_" prefix, s=
o
>> "validate_" prefix seems less consistent.
>>
>> Further more, the naming has its level"
>> leaf (all items boundary already checked)
>> |- leaf_item (hub wrapper)
>>    |- csum_item
>>    |- extent_data_item
>>
>> So here check_<something>_item follows the original level according to=

>> the naming schema.
>>
>> Further more, although we're checking boundary, the truth is, we are
>> check the name_len/data_len *members*, so the check_<something>_item
>> still makes sence.
>>
>> If really want to change the name, I prefer some naming can show that
>> we're checking several items which share the same variable length prop=
erty.
>>
>> So at least, none of the alternative seems to fit the schema.
>=20
> The reason why I wanted this function renamed is that we have this
> function which performs only some checks and then we have the
> verify_dir_item which performs different checks for the same item. So
> why can't those function be turned into one ? I'm not too hung up on th=
e
> actual naming!

Well, this makes sense.

I should merge them up.
Since verify_dir_item() just do extra check on types, they can be easily
merged.
The original plan is to have check_<some extra item> under
check_variable_length_item() if needed.

Considering only type and maximum name len need to be addded, it's quite
an easy work.

I'll add them in next update. (With extra possible checks).

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> validate_variable_boundaries
>>> check_variable_length_item_boundary
>>> check_item_boundaries
>>>
>>>> +	u8 type =3D key->type;
>>>> +	u32 item_start =3D btrfs_item_offset_nr(leaf, slot);
>>>> +	u32 item_end =3D btrfs_item_end_nr(leaf, slot);
>>>> +	u32 header_size =3D get_header_size(type);
>>>> +	u32 total_size;
>>>> +	u32 cur =3D item_start;
>>>> +
>>>> +	while (cur < item_end) {
>>>> +		u32 namelen;
>>>> +		u32 datalen;
>>>> +
>>>> +		/* header itself should not cross item boundary */
>>>> +		if (cur + header_size > item_end) {
>>>> +			generic_err(root, leaf, slot,
>>>> +				"structure header crosses item boundary, have %u expect (%u, %u=
]",
>>>> +				cur + header_size, cur, item_end);
>>>> +			return -EUCLEAN;
>>>> +		}
>>>> +
>>>> +		namelen =3D get_header_namelen(leaf, type, cur);
>>>> +		datalen =3D get_header_datalen(leaf, type, cur);
>>>> +
>>>> +		/* Only XATTR can own data */
>>>> +		if (type !=3D BTRFS_XATTR_ITEM_KEY && datalen) {
>>>> +			generic_err(root, leaf, slot,
>>>> +				"item has invalid data len, have %u expect 0",
>>>> +				datalen);
>>>> +			return -EUCLEAN;
>>>> +		}
>>>> +
>>>> +		total_size =3D header_size + namelen + datalen;
>>>> +
>>>> +		/* header and name/data should not cross item boundary */
>>>> +		if (cur + total_size > item_end) {
>>>> +			generic_err(root, leaf, slot,
>>>> +				"structure data crosses item boundary, have %u expect (%u, %u]"=
,
>>>> +				cur + total_size, cur + header_size, item_end);
>>>> +			return -EUCLEAN;
>>>> +		}
>>>> +
>>>> +		cur +=3D total_size;
>>>> +	}
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  /*
>>>>   * Common point to switch the item-specific validation.
>>>>   */
>>>> @@ -238,6 +352,15 @@ static int check_leaf_item(struct btrfs_root *r=
oot,
>>>>  	case BTRFS_EXTENT_CSUM_KEY:
>>>>  		ret =3D check_csum_item(root, leaf, key, slot);
>>>>  		break;
>>>> +	case BTRFS_DIR_ITEM_KEY:
>>>> +	case BTRFS_XATTR_ITEM_KEY:
>>>> +	case BTRFS_DIR_INDEX_KEY:
>>>> +	case BTRFS_INODE_REF_KEY:
>>>> +	case BTRFS_INODE_EXTREF_KEY:
>>>> +	case BTRFS_ROOT_REF_KEY:
>>>> +	case BTRFS_ROOT_BACKREF_KEY:
>>>> +		ret =3D check_variable_length_item(root, leaf, key, slot);
>>>> +		break;
>>>>  	}
>>>>  	return ret;
>>>>  }
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>


--lclGKp2j8INoBu9x9QV4ihDqqQP53Xi2c--

--4ano7iIDNo4wJbmd3VjOaALE56ba1Aa7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln7HwgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjz7gf/cvNGwB9PoR9ss17ZTFUGUpAv
rNq+OLkB9TvZMQPpFSVcJjZ/Tuj3l0AOgYfe5KoR1seM58Prl9yS+/J1fIEq6lbD
IZVP/Vt67/Y/yR5pUbGC2wFi0oHLJqakmqtxw+7sPs4n/XwbFql0wKbJx50odC45
wkPTNmH7RbNEhcP7c1CuZKy7cr2hm3s8vH1/u1SmPJJ5od7VsmilURZxdynN3COe
u3oaNce5iyThkvIMmAmGP3OguoCNluaIZ3pdOwoGbH/R1UYoX/KPE/XGXrqh4iZ/
4uCvZxJET54GfbjHMfHpCxG7HAgSg8ZUZ78LHd/5UI0kMHebVodeFZgqp+57qg==
=v0fo
-----END PGP SIGNATURE-----

--4ano7iIDNo4wJbmd3VjOaALE56ba1Aa7G--
