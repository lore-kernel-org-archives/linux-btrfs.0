Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59883 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751756AbeCVIcr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 04:32:47 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Use macro to replace
 immediate number for readable flags string buffer length
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180322073711.5943-1-wqu@suse.com>
 <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7076d888-34ee-d9d9-8187-8d024b5a1465@gmx.com>
Date: Thu, 22 Mar 2018 16:32:34 +0800
MIME-Version: 1.0
In-Reply-To: <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vFuI80pHQuxElUB4Q28HMDUnYd4UnT01C"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vFuI80pHQuxElUB4Q28HMDUnYd4UnT01C
Content-Type: multipart/mixed; boundary="ZoeH2vwiPNNtIVX9kQ4XmyhGBY2wJkRAj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <7076d888-34ee-d9d9-8187-8d024b5a1465@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Use macro to replace
 immediate number for readable flags string buffer length
References: <20180322073711.5943-1-wqu@suse.com>
 <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>
In-Reply-To: <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>

--ZoeH2vwiPNNtIVX9kQ4XmyhGBY2wJkRAj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 16:20, Nikolay Borisov wrote:
>=20
>=20
> On 22.03.2018 09:37, Qu Wenruo wrote:
>> In print-tree, we have a lot of parsers to convert numeric flags to
>> human readable string.
>>
>> For the buffer size we're using immediate numbers for all their caller=
s.
>> Change this to macro so it will be much easier for us to expand the
>> buffer size.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> The changes look good per se, however I'd like to have all such macros
> grouped at the beginning of the file - in their own section so to speak=
=2E
>=20

That's also what I considered.
However this makes stack consumption larger for some callers who don't
really need that much buffer size.
And this also makes expanding buffer size a little more complex, as
later change must check if it breaks the up limit.

While current layout makes any modification to the buffer size super
obvious.

Thanks,
Qu

>> ---
>>  print-tree.c | 29 ++++++++++++++++++++---------
>>  1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index a2f6bfc027c9..d5bb413019bb 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -137,7 +137,12 @@ static void print_inode_ref_item(struct extent_bu=
ffer *eb, u32 size,
>>  	}
>>  }
>> =20
>> -/* Caller should ensure sizeof(*ret)>=3D21 "DATA|METADATA|RAID10" */
>> +/*
>> + * Caller should ensure sizeof(*ret)>=3D21 "DATA|METADATA|RAID10"
>> + * Here we bump up to 64 bytes to handle the worst (and invalid) case=
:
>> + * "DATA|METADATA|SYSTEM|RAID0|RAID1|DUP|RAID10|RAID5|RAID6"
>> + */
>> +#define BG_FLAGS_BUF_LEN	64
>>  static void bg_flags_to_str(u64 flags, char *ret)
>>  {
>>  	int empty =3D 1;
>> @@ -181,6 +186,7 @@ static void bg_flags_to_str(u64 flags, char *ret)
>>  }
>> =20
>>  /* Caller should ensure sizeof(*ret)>=3D 26 "OFF|SCANNING|INCONSISTEN=
T" */
>> +#define QGROUP_FLAGS_BUF_LEN	32
>>  static void qgroup_flags_to_str(u64 flags, char *ret)
>>  {
>>  	if (flags & BTRFS_QGROUP_STATUS_FLAG_ON)
>> @@ -199,7 +205,7 @@ void print_chunk_item(struct extent_buffer *eb, st=
ruct btrfs_chunk *chunk)
>>  	u16 num_stripes =3D btrfs_chunk_num_stripes(eb, chunk);
>>  	int i;
>>  	u32 chunk_item_size;
>> -	char chunk_flags_str[32] =3D {0};
>> +	char chunk_flags_str[BG_FLAGS_BUF_LEN] =3D {0};
>> =20
>>  	/* The chunk must contain at least one stripe */
>>  	if (num_stripes < 1) {
>> @@ -385,7 +391,9 @@ static void print_file_extent_item(struct extent_b=
uffer *eb,
>>  			compress_str);
>>  }
>> =20
>> -/* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK") */
>> +/* Caller should ensure sizeof(*ret) >
>> + * strlen("DATA|TREE_BLOCK|FULL_BACKREF") */
>> +#define EXTENT_FLAGS_BUF_LEN	32
>>  static void extent_flags_to_str(u64 flags, char *ret)
>>  {
>>  	int empty =3D 1;
>> @@ -420,7 +428,7 @@ void print_extent_item(struct extent_buffer *eb, i=
nt slot, int metadata)
>>  	u32 item_size =3D btrfs_item_size_nr(eb, slot);
>>  	u64 flags;
>>  	u64 offset;
>> -	char flags_str[32] =3D {0};
>> +	char flags_str[EXTENT_FLAGS_BUF_LEN] =3D {0};
>> =20
>>  	if (item_size < sizeof(*ei)) {
>>  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
>> @@ -543,6 +551,7 @@ static int empty_uuid(const u8 *uuid)
>>  /*
>>   * Caller must ensure sizeof(*ret) >=3D 7 "RDONLY"
>>   */
>> +#define ROOT_FLAGS_BUF_LEN	16
>>  static void root_flags_to_str(u64 flags, char *ret)
>>  {
>>  	if (flags & BTRFS_ROOT_SUBVOL_RDONLY)
>> @@ -577,7 +586,7 @@ static void print_root_item(struct extent_buffer *=
leaf, int slot)
>>  	struct btrfs_root_item root_item;
>>  	int len;
>>  	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>> -	char flags_str[32] =3D {0};
>> +	char flags_str[ROOT_FLAGS_BUF_LEN] =3D {0};
>>  	struct btrfs_key drop_key;
>> =20
>>  	ri =3D btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
>> @@ -888,6 +897,7 @@ static void print_uuid_item(struct extent_buffer *=
l, unsigned long offset,
>>   * Caller should ensure sizeof(*ret) >=3D 102: all charactors plus '|=
' of
>>   * BTRFS_INODE_* flags
>>   */
>> +#define INODE_FLAGS_BUF_LEN	128
>>  static void inode_flags_to_str(u64 flags, char *ret)
>>  {
>>  	int empty =3D 1;
>> @@ -911,7 +921,7 @@ static void inode_flags_to_str(u64 flags, char *re=
t)
>>  static void print_inode_item(struct extent_buffer *eb,
>>  		struct btrfs_inode_item *ii)
>>  {
>> -	char flags_str[256];
>> +	char flags_str[INODE_FLAGS_BUF_LEN];
>> =20
>>  	memset(flags_str, 0, sizeof(flags_str));
>>  	inode_flags_to_str(btrfs_inode_flags(eb, ii), flags_str);
>> @@ -1002,7 +1012,7 @@ static void print_block_group_item(struct extent=
_buffer *eb,
>>  		struct btrfs_block_group_item *bgi)
>>  {
>>  	struct btrfs_block_group_item bg_item;
>> -	char flags_str[256];
>> +	char flags_str[BG_FLAGS_BUF_LEN];
>> =20
>>  	read_extent_buffer(eb, &bg_item, (unsigned long)bgi, sizeof(bg_item)=
);
>>  	memset(flags_str, 0, sizeof(flags_str));
>> @@ -1070,7 +1080,7 @@ static void print_dev_extent(struct extent_buffe=
r *eb, int slot)
>>  static void print_qgroup_status(struct extent_buffer *eb, int slot)
>>  {
>>  	struct btrfs_qgroup_status_item *qg_status;
>> -	char flags_str[256];
>> +	char flags_str[QGROUP_FLAGS_BUF_LEN];
>> =20
>>  	qg_status =3D btrfs_item_ptr(eb, slot, struct btrfs_qgroup_status_it=
em);
>>  	memset(flags_str, 0, sizeof(flags_str));
>> @@ -1158,6 +1168,7 @@ static void print_extent_csum(struct extent_buff=
er *eb,
>>  }
>> =20
>>  /* Caller must ensure sizeof(*ret) >=3D 14 "WRITTEN|RELOC" */
>> +#define HEADER_FLAGS_BUF_LEN	32
>>  static void header_flags_to_str(u64 flags, char *ret)
>>  {
>>  	int empty =3D 1;
>> @@ -1177,7 +1188,7 @@ void btrfs_print_leaf(struct btrfs_root *root, s=
truct extent_buffer *eb)
>>  {
>>  	struct btrfs_item *item;
>>  	struct btrfs_disk_key disk_key;
>> -	char flags_str[128];
>> +	char flags_str[HEADER_FLAGS_BUF_LEN];
>>  	u32 i;
>>  	u32 nr;
>>  	u64 flags;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ZoeH2vwiPNNtIVX9kQ4XmyhGBY2wJkRAj--

--vFuI80pHQuxElUB4Q28HMDUnYd4UnT01C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqzaiIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgehAf/e419qSAq+4hQH9u9ow+p+QZf
IsrOsNx6wXF5fZrt00jEE8TT1mR64hMC/W06TKvT/UTTfo1hwSio4EdEY++oKpdY
Kr+SPRBfjmug0QIhZGhIzUGi2V5IqYAUSTqbfTwCjouzmwXf5dIDE29OPfpF6DL/
+O3GymuA+k1mZ7IW+vL3whNTEUCqUDoRxKoW3I6Ed5kULT7ytlBAc5q7P5d3L5/p
Dp7EUqU0Jyrn9FfeBAx7kI8gGwyGbw3FLVz5rOHLZj9dcQomkZH+0ZsicEr+EJ7P
L4NLhBjn+5BaZ0FObtLXim9DpFU2A22pqMr6d1b6qk3c/LlfJV7tnD6OrTP97w==
=ko5h
-----END PGP SIGNATURE-----

--vFuI80pHQuxElUB4Q28HMDUnYd4UnT01C--
