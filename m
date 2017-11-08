Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdKHIDt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Nov 2017 03:03:49 -0500
Subject: Re: [PATCH v2 1/3] btrfs: tree-checker: Fix false panic for sanity
 test
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-2-wqu@suse.com>
 <fabe0bca-372b-699d-c418-42c55c04c539@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8bf83e81-290d-7568-2d95-6fc7d1f209d2@gmx.com>
Date: Wed, 8 Nov 2017 16:03:35 +0800
MIME-Version: 1.0
In-Reply-To: <fabe0bca-372b-699d-c418-42c55c04c539@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3iHHt7t3VNR10KfDDWxvIpSTFxpwhDHNW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3iHHt7t3VNR10KfDDWxvIpSTFxpwhDHNW
Content-Type: multipart/mixed; boundary="QSNlKOh7jVlUk0GrrxxNhhAVoIQ1INCOP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>
Message-ID: <8bf83e81-290d-7568-2d95-6fc7d1f209d2@gmx.com>
Subject: Re: [PATCH v2 1/3] btrfs: tree-checker: Fix false panic for sanity
 test
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-2-wqu@suse.com>
 <fabe0bca-372b-699d-c418-42c55c04c539@suse.com>
In-Reply-To: <fabe0bca-372b-699d-c418-42c55c04c539@suse.com>

--QSNlKOh7jVlUk0GrrxxNhhAVoIQ1INCOP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8808=E6=97=A5 15:55, Nikolay Borisov wrote:
>=20
>=20
> On  8.11.2017 02:54, Qu Wenruo wrote:
>> [BUG]
>> If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=3Dy, it will
>> instantly cause kernel panic like:
>>
>> ------
>> ...
>> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
>> ...
>> Call Trace:
>>  btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
>>  setup_items_for_insert+0x385/0x650 [btrfs]
>>  __btrfs_drop_extents+0x129a/0x1870 [btrfs]
>> ...
>> -----
>>
>> [Cause]
>> Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to che=
ck
>> if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=3Dy.
>>
>> However quite some btrfs_mark_buffer_dirty() callers(*) don't really
>> initialize its item data but only initialize its item pointers, leavin=
g
>> item data uninitialized.
>>
>> This makes tree-checker catch uninitialized data as error, causing
>> such panic.
>>
>> *: These callers include but not limited to
>> setup_items_for_insert()
>> btrfs_split_item()
>> btrfs_expand_item()
>>
>> [Fix]
>> Add a new parameter @check_item_data to btrfs_check_leaf().
>> With @check_item_data set to false, item data check will be skipped an=
d
>> fallback to old btrfs_check_leaf() behavior.
>>
>> So we can still get early warning if we screw up item pointers, and
>> avoid false panic.
>>
>> Cc: Filipe Manana <fdmanana@gmail.com>
>> Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c      | 10 ++++++++--
>>  fs/btrfs/tree-checker.c | 27 ++++++++++++++++++++++-----
>>  fs/btrfs/tree-checker.h | 14 +++++++++++++-
>>  3 files changed, 43 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index efce9a2fa9be..10a2a579cc7f 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -610,7 +610,7 @@ static int btree_readpage_end_io_hook(struct btrfs=
_io_bio *io_bio,
>>  	 * that we don't try and read the other copies of this block, just
>>  	 * return -EIO.
>>  	 */
>> -	if (found_level =3D=3D 0 && btrfs_check_leaf(root, eb)) {
>> +	if (found_level =3D=3D 0 && btrfs_check_leaf_full(root, eb)) {
>>  		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>>  		ret =3D -EIO;
>>  	}
>> @@ -3848,7 +3848,13 @@ void btrfs_mark_buffer_dirty(struct extent_buff=
er *buf)
>>  					 buf->len,
>>  					 fs_info->dirty_metadata_batch);
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>> -	if (btrfs_header_level(buf) =3D=3D 0 && btrfs_check_leaf(root, buf))=
 {
>> +	/*
>> +	 * Since btrfs_mark_buffer_dirty() can be called with item pointer s=
et
>> +	 * but item data not updated.
>> +	 * So here we should only check item pointers, not item data.
>> +	 */
>> +	if (btrfs_header_level(buf) =3D=3D 0 &&
>> +	    btrfs_check_leaf_relaxed(root, buf)) {
>>  		btrfs_print_leaf(buf);
>>  		ASSERT(0);
>>  	}
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 114fc5f0ecc5..ce4ed6ec8f39 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -242,7 +242,8 @@ static int check_leaf_item(struct btrfs_root *root=
,
>>  	return ret;
>>  }
>> =20
>> -int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *l=
eaf)
>> +static int check_leaf(struct btrfs_root *root, struct extent_buffer *=
leaf,
>> +		      bool check_item_data)
>>  {
>>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>>  	/* No valid key type is 0, so all key should be larger than this key=
 */
>> @@ -361,10 +362,15 @@ int btrfs_check_leaf(struct btrfs_root *root, st=
ruct extent_buffer *leaf)
>>  			return -EUCLEAN;
>>  		}
>> =20
>> -		/* Check if the item size and content meet other criteria */
>> -		ret =3D check_leaf_item(root, leaf, &key, slot);
>> -		if (ret < 0)
>> -			return ret;
>> +		if (check_item_data) {
>> +			/*
>> +			 * Check if the item size and content meet other
>> +			 * criteria
>> +			 */
>> +			ret =3D check_leaf_item(root, leaf, &key, slot);
>> +			if (ret < 0)
>> +				return ret;
>> +		}
>> =20
>>  		prev_key.objectid =3D key.objectid;
>>  		prev_key.type =3D key.type;
>> @@ -374,6 +380,17 @@ int btrfs_check_leaf(struct btrfs_root *root, str=
uct extent_buffer *leaf)
>>  	return 0;
>>  }
>> =20
>> +int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buff=
er *leaf)
>> +{
>> +	return check_leaf(root, leaf, true);
>> +}
>> +
>> +int btrfs_check_leaf_relaxed(struct btrfs_root *root,
>> +			     struct extent_buffer *leaf)
>> +{
>> +	return check_leaf(root, leaf, false);
>> +}
>=20
> Presumably the compiler will figure it out but such trivial function ar=
e
> usually defined straight into the header file so that the compiler
> inlines them.

In that case, the function check_leaf() must be exported, so that we can
inline it in header.

But exporting check_leaf() increases the possibility for caller to use
it incorrectly, so I prefer no to export any internal used function.


And compiler may or may not inline check_leaf() into
btrfs_check_leaf_relaxed() function, but it doesn't matter.

If optimization can be done by compiler, then let compiler to do it.

What we should do is to ensure the abstraction/interface design is good
enough, other than doing possible "over-optimization".

Thanks,
Qu

> Can you check if you have separate objects for
> btrfs_check_leaf_relaxed  with the way you've written the patch or
> whether all instances have been inlined? If they are not, then move
> those function definition into tree-checker.h and make them 'static
> inline' as per the style of the whole kernel
>=20
>> +
>>  int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *n=
ode)
>>  {
>>  	unsigned long nr =3D btrfs_header_nritems(node);
>> diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
>> index 96c486e95d70..3d53e8d6fda0 100644
>> --- a/fs/btrfs/tree-checker.h
>> +++ b/fs/btrfs/tree-checker.h
>> @@ -20,7 +20,19 @@
>>  #include "ctree.h"
>>  #include "extent_io.h"
>> =20
>> -int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *l=
eaf);
>> +/*
>> + * Comprehensive leaf checker.
>> + * Will check not only the item pointers, but also every possible mem=
ber
>> + * in item data.
>> + */
>> +int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buff=
er *leaf);
>> +
>> +/*
>> + * Less strict leaf checker.
>> + * Will only check item pointers, not reading item data.
>> + */
>> +int btrfs_check_leaf_relaxed(struct btrfs_root *root,
>> +			     struct extent_buffer *leaf);
>>  int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *n=
ode);
>> =20
>>  #endif
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--QSNlKOh7jVlUk0GrrxxNhhAVoIQ1INCOP--

--3iHHt7t3VNR10KfDDWxvIpSTFxpwhDHNW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloCulcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhJwQf/U6fWRLoWh0tmqxl05vi4+MdV
GO8UlFDPgap8ZizelhK4GQRVPjSRxw4npylK/roYkjLkHlWlkJ8hnpW0W/me22IN
XH0LjYBiXOdhGf9yUpkD3LlL57bjSk4vySxdjt8HnAf46Lzd1OL8b+1WoSu/BnvQ
qTQtEK63ftFh2J58bpHJHHXjsHxDVupeLf/6KQt5Lx5nqcjL4CbOXTTAN8veilI8
3kwi3xWGtF9fnl0YqovRDbG4rlw0GxoqYr6X2WfNr0s1BZ3HdPjehQc8zm6WqrqB
VrOra7cafPkQrgciWCKvPXCb/7WMivs9ljyMIwq0EMXcAAMklSB0O44EYLcbew==
=2P1u
-----END PGP SIGNATURE-----

--3iHHt7t3VNR10KfDDWxvIpSTFxpwhDHNW--
