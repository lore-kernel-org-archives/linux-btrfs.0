Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56547 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756871AbdKHAwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 19:52:04 -0500
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171101122213.7122-1-wqu@suse.com>
 <20171107205024.GE27557@twin.jikos.cz>
 <8544a611-6111-05aa-89e7-85017c565cdd@gmx.com>
Message-ID: <dd390a24-7882-c53e-4a40-2b7ed36b7eb0@gmx.com>
Date: Wed, 8 Nov 2017 08:51:53 +0800
MIME-Version: 1.0
In-Reply-To: <8544a611-6111-05aa-89e7-85017c565cdd@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3MSR87oCIpvrMkboppf5aw4AD6chH6SHe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3MSR87oCIpvrMkboppf5aw4AD6chH6SHe
Content-Type: multipart/mixed; boundary="1WoB2gdB5RI70DlgwKPtKtWkKMxwQ2Iqh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <dd390a24-7882-c53e-4a40-2b7ed36b7eb0@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
References: <20171101122213.7122-1-wqu@suse.com>
 <20171107205024.GE27557@twin.jikos.cz>
 <8544a611-6111-05aa-89e7-85017c565cdd@gmx.com>
In-Reply-To: <8544a611-6111-05aa-89e7-85017c565cdd@gmx.com>

--1WoB2gdB5RI70DlgwKPtKtWkKMxwQ2Iqh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8808=E6=97=A5 08:13, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B411=E6=9C=8808=E6=97=A5 04:50, David Sterba wrote:
>> On Wed, Nov 01, 2017 at 08:22:12PM +0800, Qu Wenruo wrote:
>>> For the following types, we have items with variable length:
>>> (With BTRFS_ prefix and _KEY suffix snipped)
>>>
>>> DIR_ITEM
>>> DIR_INDEX
>>> XATTR_ITEM
>>> INODE_REF
>>> INODE_EXTREF
>>> ROOT_REF
>>> ROOT_BACKREF
>>>
>>> They all use @name_len to indicate their name length, and XATTR_ITEM =
has
>>> extra @data_len to indicate it data length.
>>>
>>> Despite their variable length, it's also possible to have several suc=
h
>>> structure inside one item.
>>>
>>> This patch will add checker to ensure:
>>>
>>> 1) No structure header and its data cross item boundary
>>> 2) Except XATTR_ITEM, no structure should have non-zero @data_len
>>>
>>> This checker is especially useful to avoid possible access beyond
>>> boundary for fuzzed image.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/tree-checker.c | 123 ++++++++++++++++++++++++++++++++++++++=
++++++++++
>>>  1 file changed, 123 insertions(+)
>>>
>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>> index 114fc5f0ecc5..f26e86fcbd74 100644
>>> --- a/fs/btrfs/tree-checker.c
>>> +++ b/fs/btrfs/tree-checker.c
>>> @@ -222,6 +222,120 @@ static int check_csum_item(struct btrfs_root *r=
oot, struct extent_buffer *leaf,
>>>  	return 0;
>>>  }
>>> =20
>>> +static u32 get_header_size(u8 type)
>>> +{
>>> +	switch (type) {
>>> +	case BTRFS_DIR_ITEM_KEY:
>>> +	case BTRFS_DIR_INDEX_KEY:
>>> +	case BTRFS_XATTR_ITEM_KEY:
>>> +		return sizeof(struct btrfs_dir_item);
>>> +	case BTRFS_INODE_REF_KEY:
>>> +		return sizeof(struct btrfs_inode_ref);
>>> +	case BTRFS_INODE_EXTREF_KEY:
>>> +		return sizeof(struct btrfs_inode_extref);
>>> +	case BTRFS_ROOT_REF_KEY:
>>> +	case BTRFS_ROOT_BACKREF_KEY:
>>> +		return sizeof(struct btrfs_root_ref);
>>> +	}
>>> +	WARN_ON(1);
>>
>> The helper name suggests is generic so this warning is there to catch
>> new use, possibly without the matching validation function? If it is s=
o,
>> I'd rather use ASSERT. If you really want a warning, then please repla=
ce
>> it with a message. The stacktrace from WARN_ON would not be very usefu=
l
>> because we know exactly how we get here, the callchaning starts in the=

>> endio handlers.
>=20
> Please ignore this patch, as there is v2 patch which doesn't use such
> centralized check.

The already submitted patchset is "[PATCH 0/3] tree-checker bug fix and
enhancement."

And patch "[PATCH 2/3] btrfs: tree-checker: Add checker for dir item"
was originally going to replace it.

I'll update the patchset to address the indent comment in v2 patchset.

Thanks,
Qu
>=20
> Thanks,
> Qu
>=20
>>
>>> +	return 0;
>>> +}
>>> +
>>> +static u16 get_header_namelen(struct extent_buffer *leaf, u8 type,
>>> +			      u32 header_offset)
>>> +{
>>> +	/*
>>> +	 * @header_offset is offset starts after leaf header, while the
>>> +	 * accessors expects offset starts from leaf header.
>>> +	 * Sowe need to adds LEAF_DATA_OFFSET here
>>> +	 */
>>
>> Can you please rephrase the text? (and fix the typos)
>>
>>> +	unsigned long leaf_offset =3D header_offset + BTRFS_LEAF_DATA_OFFSE=
T;
>>> +
>>> +	switch (type) {
>>> +	case BTRFS_DIR_ITEM_KEY:
>>> +	case BTRFS_DIR_INDEX_KEY:
>>> +	case BTRFS_XATTR_ITEM_KEY:
>>> +		return btrfs_dir_name_len(leaf, (void *)leaf_offset);
>>> +	case BTRFS_INODE_REF_KEY:
>>> +		return btrfs_inode_ref_name_len(leaf, (void *)leaf_offset);
>>> +	case BTRFS_INODE_EXTREF_KEY:
>>> +		return btrfs_inode_extref_name_len(leaf, (void *)leaf_offset);
>>> +	case BTRFS_ROOT_REF_KEY:
>>> +	case BTRFS_ROOT_BACKREF_KEY:
>>> +		return btrfs_root_ref_name_len(leaf, (void *)leaf_offset);
>>> +	}
>>> +	WARN_ON(1);
>>
>> Similar comment as to the warning above, a message would be more
>> helpful to say which type is unexpected.
>>
>>> +	return 0;
>>> +}
>>> +
>>> +static u16 get_header_datalen(struct extent_buffer *leaf, u8 type,
>>> +			      unsigned long header_offset)
>>> +{
>>> +	/* Same as get_header_namelen */
>>> +	unsigned long leaf_offset =3D header_offset + BTRFS_LEAF_DATA_OFFSE=
T;
>>> +
>>> +	switch (type) {
>>> +	case BTRFS_DIR_ITEM_KEY:
>>> +	case BTRFS_DIR_INDEX_KEY:
>>> +	case BTRFS_XATTR_ITEM_KEY:
>>> +		return btrfs_dir_data_len(leaf, (void *)leaf_offset);
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * For items with variable length, normally with namelen and tailing=
 data.
>>> + * Like INODE_REF or XATTR
>>> + */
>>> +static int check_variable_length_item(struct btrfs_root *root,
>>> +				      struct extent_buffer *leaf,
>>> +				      struct btrfs_key *key, int slot)
>>> +{
>>> +	u8 type =3D key->type;
>>> +	u32 item_start =3D btrfs_item_offset_nr(leaf, slot);
>>> +	u32 item_end =3D btrfs_item_end_nr(leaf, slot);
>>> +	u32 header_size =3D get_header_size(type);
>>> +	u32 total_size;
>>> +	u32 cur =3D item_start;
>>> +
>>> +	while (cur < item_end) {
>>> +		u32 namelen;
>>> +		u32 datalen;
>>> +
>>> +		/* header itself should not cross item boundary */
>>> +		if (cur + header_size > item_end) {
>>> +			generic_err(root, leaf, slot,
>>> +				"structure header crosses item boundary, have %u expect (%u, %u]=
",
>>
>> Un-indent please. I'm slightly confused by the "(%u, %u]" notation, th=
is
>> reads as an open interval from the left but I don't understand it in
>> this context.
>>
>>> +				cur + header_size, cur, item_end);
>>> +			return -EUCLEAN;
>>> +		}
>>> +
>>> +		namelen =3D get_header_namelen(leaf, type, cur);
>>> +		datalen =3D get_header_datalen(leaf, type, cur);
>>> +
>>> +		/* Only XATTR can own data */
>>> +		if (type !=3D BTRFS_XATTR_ITEM_KEY && datalen) {
>>> +			generic_err(root, leaf, slot,
>>> +				"item has invalid data len, have %u expect 0",
>>> +				datalen);
>>> +			return -EUCLEAN;
>>> +		}
>>> +
>>> +		total_size =3D header_size + namelen + datalen;
>>> +
>>> +		/* header and name/data should not cross item boundary */
>>> +		if (cur + total_size > item_end) {
>>> +			generic_err(root, leaf, slot,
>>> +				"structure data crosses item boundary, have %u expect (%u, %u]",=

>>
>> Same.
>>
>>> +				cur + total_size, cur + header_size, item_end);
>>> +			return -EUCLEAN;
>>> +		}
>>> +
>>> +		cur +=3D total_size;
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>>  /*
>>>   * Common point to switch the item-specific validation.
>>>   */
>>> @@ -238,6 +352,15 @@ static int check_leaf_item(struct btrfs_root *ro=
ot,
>>>  	case BTRFS_EXTENT_CSUM_KEY:
>>>  		ret =3D check_csum_item(root, leaf, key, slot);
>>>  		break;
>>> +	case BTRFS_DIR_ITEM_KEY:
>>> +	case BTRFS_XATTR_ITEM_KEY:
>>> +	case BTRFS_DIR_INDEX_KEY:
>>> +	case BTRFS_INODE_REF_KEY:
>>> +	case BTRFS_INODE_EXTREF_KEY:
>>> +	case BTRFS_ROOT_REF_KEY:
>>> +	case BTRFS_ROOT_BACKREF_KEY:
>>> +		ret =3D check_variable_length_item(root, leaf, key, slot);
>>> +		break;
>>>  	}
>>>  	return ret;
>>>  }
>>
>> Otherwise ok.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--1WoB2gdB5RI70DlgwKPtKtWkKMxwQ2Iqh--

--3MSR87oCIpvrMkboppf5aw4AD6chH6SHe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloCVSkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgnhwf+MnFYMUv8Zfzec1WzN7edpQjS
nuegRO8p9rnW46z5jSNYWxBnJdalVUatUr4yVC1nJ5AVuCE3vk3TmGjFpYrA2tbh
DCyjKAHvwv1ZDjTzw1SZ/ulTVChkCUAFV46vu0SaLVyE8QCz2xHrmAI6Dtrbpcln
yus4bTmhA4hxCdg32aXCBBFdxnhS/e0xKEdoOS6FS8NOrJuQJ2R0u9gy7IfUrgxp
NHCv+ASWmJpGdtEGcuf9h++hPuNiPhrx3/DGrdbCPj1ZbVACPAUngYit9d9hBm3X
e2B8HzN+jdyJNXPNQiQhs/0eXdMopoLdDGi8la1VxFE832/LaiR4q6xPQcdfIA==
=RZk4
-----END PGP SIGNATURE-----

--3MSR87oCIpvrMkboppf5aw4AD6chH6SHe--
