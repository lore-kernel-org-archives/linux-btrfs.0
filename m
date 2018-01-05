Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37669 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbeAEJoz (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 5 Jan 2018 04:44:55 -0500
Subject: Re: [PATCH 1/2] btrfs-progs: Merge btrfs_alloc_data_chunk into
 btrfs_alloc_chunk
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180105081212.27175-1-wqu@suse.com>
 <20180105081212.27175-2-wqu@suse.com>
 <db7c7780-46e4-1573-8b66-e5c58b71a5fa@cn.fujitsu.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <c5927a0b-f7c7-812a-2a47-8560ffe06b77@suse.com>
Date: Fri, 5 Jan 2018 17:44:37 +0800
MIME-Version: 1.0
In-Reply-To: <db7c7780-46e4-1573-8b66-e5c58b71a5fa@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MUth4NWrqdwNRAT9iNGVgRkS8lxv801K0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MUth4NWrqdwNRAT9iNGVgRkS8lxv801K0
Content-Type: multipart/mixed; boundary="0NUdGNeq70IcHCzwC12Q9ZF7mPY1Uthdh";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <c5927a0b-f7c7-812a-2a47-8560ffe06b77@suse.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Merge btrfs_alloc_data_chunk into
 btrfs_alloc_chunk
References: <20180105081212.27175-1-wqu@suse.com>
 <20180105081212.27175-2-wqu@suse.com>
 <db7c7780-46e4-1573-8b66-e5c58b71a5fa@cn.fujitsu.com>
In-Reply-To: <db7c7780-46e4-1573-8b66-e5c58b71a5fa@cn.fujitsu.com>

--0NUdGNeq70IcHCzwC12Q9ZF7mPY1Uthdh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8805=E6=97=A5 17:36, Su Yue wrote:
>=20
>=20
> On 01/05/2018 04:12 PM, Qu Wenruo wrote:
>> We used to have two chunk allocators, btrfs_alloc_chunk() and
>> btrfs_alloc_data_chunk(), the former is the more generic one, while th=
e
>> later is only used in mkfs and convert, to allocate SINGLE data chunk.=

>>
>> Although btrfs_alloc_data_chunk() has some special hacks to cooperate
>> with convert, it's quite simple to integrity it into the generic chunk=

>> allocator.
>>
>> So merge them into one btrfs_alloc_chunk(), with extra @convert
>> parameter and necessary comment, to make code less duplicated and less=

>> thing to maintain.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 convert/main.c |=C2=A0=C2=A0 6 +-
>> =C2=A0 extent-tree.c=C2=A0 |=C2=A0=C2=A0 2 +-
>> =C2=A0 mkfs/main.c=C2=A0=C2=A0=C2=A0 |=C2=A0 14 ++--
>> =C2=A0 volumes.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 220
>> ++++++++++++++++++++++-----------------------------------
>> =C2=A0 volumes.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 5 +-
>> =C2=A0 5 files changed, 98 insertions(+), 149 deletions(-)
>>
>> diff --git a/convert/main.c b/convert/main.c
>> index 4a510a786394..8ee858fb2d05 100644
>> --- a/convert/main.c
>> +++ b/convert/main.c
>> @@ -910,9 +910,9 @@ static int make_convert_data_block_groups(struct
>> btrfs_trans_handle *trans,
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 len =3D min(max_chunk_size,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->start + cache->size - c=
ur);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_alloc_data_chunk(trans, fs_info,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cur_backup, len,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_DATA, 1);=

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_alloc_chunk(trans, fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cur_backup, &len,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_DATA, tru=
e);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (ret < 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ret =3D btrfs_make_block_group(trans, fs_info, 0,
>> diff --git a/extent-tree.c b/extent-tree.c
>> index db24da3a3a8c..4231be11bd53 100644
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> @@ -1907,7 +1907,7 @@ static int do_chunk_alloc(struct
>> btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_chunk(trans,=
 fs_info, &start, &num_bytes,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 space_info->flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 space_info->flags, false);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -ENOSPC) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 space_info->ful=
l =3D 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> diff --git a/mkfs/main.c b/mkfs/main.c
>> index 938025bfd32e..f8e27a7ec8b8 100644
>> --- a/mkfs/main.c
>> +++ b/mkfs/main.c
>> @@ -92,7 +92,7 @@ static int create_metadata_block_groups(struct
>> btrfs_root *root, int mixed,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_a=
lloc_chunk(trans, fs_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chu=
nk_size,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_=
METADATA |
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_DATA);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_DATA, fal=
se);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D =
-ENOSPC) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 error("no space to allocate data/metadata chunk");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto err;
>> @@ -109,7 +109,7 @@ static int create_metadata_block_groups(struct
>> btrfs_root *root, int mixed,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_a=
lloc_chunk(trans, fs_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chu=
nk_size,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_METADATA)=
;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_METADATA,=
 false);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D =
-ENOSPC) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 error("no space to allocate metadata chunk");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto err;
>> @@ -143,7 +143,7 @@ static int create_data_block_groups(struct
>> btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!mixed) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_a=
lloc_chunk(trans, fs_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chu=
nk_size,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_DATA);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_DATA, fal=
se);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D =
-ENOSPC) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 error("no space to allocate data chunk");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto err;
>> @@ -251,7 +251,7 @@ static int create_one_raid_group(struct
>> btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_chunk(trans,=
 fs_info,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chunk_size, type);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chunk_size, type, false);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -ENOSPC) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("not enou=
gh free space to allocate chunk");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exit(1);
>> @@ -1003,7 +1003,7 @@ static int create_chunks(struct
>> btrfs_trans_handle *trans,
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < num_of_meta_ch=
unks; i++) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_a=
lloc_chunk(trans, fs_info,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chunk_size, =
meta_type);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &chunk_size, meta_type, false);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 return ret;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_m=
ake_block_group(trans, fs_info, 0,
>> @@ -1019,8 +1019,8 @@ static int create_chunks(struct
>> btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (size_of_data < minimum_data_chunk_s=
ize)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_of_data =3D=
 minimum_data_chunk_size;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_data_chunk(trans, fs_in=
fo,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &chunk_start, size_of=
_data, data_type, 0);
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_chunk(trans, fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &chunk_start, &size_of_data, data_type, false);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_make_block_group(trans, f=
s_info, 0,
>> diff --git a/volumes.c b/volumes.c
>> index fa3c6de023f9..89c2f952f5b3 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -844,9 +844,23 @@ error:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - 2 * sizeof(struct btrfs_chunk))=C2=A0=C2=
=A0=C2=A0 \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 / sizeof(struct btrfs_stripe) + 1)
>> =C2=A0 +/*
>> + * Alloc a chunk, will insert dev extents, chunk item.
>> + * NOTE: This function will not insert block group item nor mark newl=
y
>> + * allocated chunk available for later allocation.
>> + * Block group item and free space update is handled by
>> btrfs_make_block_group()
>> + *
>> + * @start:=C2=A0=C2=A0=C2=A0 return value of allocated chunk start by=
tenr.
>> + * @num_bytes:=C2=A0=C2=A0=C2=A0 return value of allocated chunk size=

>> + * @type:=C2=A0=C2=A0=C2=A0 chunk type (including both profile and ty=
pe)
>> + * @convert:=C2=A0=C2=A0=C2=A0 if the chunk is allocated for convert =
case.
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If @convert is tru=
e, chunk allocator will skip device extent
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 search, but use *s=
tart and *num_bytes as chunk
>> start/num_bytes
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 and devive offset,=
 to build a 1:1 chunk mapping for convert.
>> + */
>> =C2=A0 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type, bool convert)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 dev_offset;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *extent_root =3D info=
->extent_root;
>> @@ -876,10 +890,39 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle
>> *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 offset;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 if (list_empty(dev_list)) {
>> +=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&private_devs);
>=20
> private_devs is initiated twice in the function.
> It seems that you forgot to delete latter one.

That's completely fine, since @private_devs is empty anyway.
Reinitiliazing it won't cause any problem.

On the other hand, if you don't init @private_devs, you will easily hit
BUG_ON(!list_empty(private_devs));

But since the unconditionally re-init seems a little annoying, I could
move it do convert branch, or just enhance the later BUG_ON() to skip
the check for convert =3D=3D true case.

>> +=C2=A0=C2=A0=C2=A0 if (list_empty(dev_list))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOSPC;=

>> -=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 if (convert) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* For convert, profile mu=
st be BTRFS_BLOCK_GROUP_DATA */
>=20
> I wonder why not also check type like:
> "if (type & BTRFS_BLOCK_GROUP_DATA) ..."

Well, wrong comment.
Here I mean SINGLE profile, so the code is wrong but with wrong comment.

>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type & BTRFS_BLOCK_GRO=
UP_PROFILE_MASK) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("convert only suports SINGLE profile");
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(*start, in=
fo->sectorsize)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("chunk start not aligned, start=3D%llu sectorsize=3D%u\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *start, info->sectorsize);
>=20
> error() breaks line itself. '\n' is unnecessary.

Yep, I forgot that.

Will update them soon.

Thanks,
Qu

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(*num_bytes=
, info->sectorsize)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("chunk size not aligned, size=3D%llu sectorsize=3D%u\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *num_bytes, info->sectorsize);
>=20
> And line break here.
>=20
> Other changes are nice to me.
>=20
> Thanks,
> Su
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size =3D *num_bytes;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D *start;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * For convert, we us=
e 1:1 chunk mapping specified by @start and
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * @num_bytes, so the=
re is no need to go through dev_extent
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * searching.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto alloc_chunk;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Chunk size calculation part.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type & BTRFS_BLOCK_GROUP_PROFILE_MA=
SK) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type & BTRF=
S_BLOCK_GROUP_SYSTEM) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 calc_size =3D SZ_8M;
>> @@ -950,6 +993,9 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle
>> *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percent_max =3D
>> div_factor(btrfs_super_total_bytes(info->super_copy), 1);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 max_chunk_size =3D min(percent_max, max=
_chunk_size);
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Reserve space from each device.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0 again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (chunk_bytes_by_type(type, calc_size=
, num_stripes,
>> sub_stripes) >
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 max_chunk_size)=
 {
>> @@ -980,7 +1026,8 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 return ret;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur =3D cur->ne=
xt;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (avail >=3D =
min_free) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_move_tail(&device->dev_list, &private_devs);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_move_tail(&device->dev_list,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &private_=
devs);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 index++;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (type & BTRFS_BLOCK_GROUP_DUP)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index++;
>> @@ -1007,9 +1054,16 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOSPC;=

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 ret =3D find_next_chunk(info, &offset);
>> -=C2=A0=C2=A0=C2=A0 if (ret)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Fill chunk mapping and chunk stripes
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +alloc_chunk:
>> +=C2=A0=C2=A0=C2=A0 if (!convert) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_next_chunk(in=
fo, &offset);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3D BTRFS_FIRST_CHUNK_TREE=
_OBJECTID;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_CHUNK_ITEM_KEY;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D offset;
>> @@ -1030,17 +1084,31 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while(index < num_stripes) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_st=
ripe *stripe;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(list_empty(&private=
_devs));
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur =3D private_devs.next;=

>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device =3D list_entry(cur,=
 struct btrfs_device, dev_list);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* loop over this d=
evice again if we're doing a dup group */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(type & BTRFS_BLOCK_G=
ROUP_DUP) ||
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (i=
ndex =3D=3D num_stripes - 1))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
st_move_tail(&device->dev_list, dev_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!convert) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (list_empty(&private_devs))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -ENODEV;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cu=
r =3D private_devs.next;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
vice =3D list_entry(cur, struct btrfs_device, dev_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (!(type & BTRFS_BLOCK_GROUP_DUP) ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 (index =3D=3D num_stripes - 1)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * loop over this device again if we're doing =
a
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * dup group
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 list_move_tail(&device->dev_list, dev_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Only SINGLE is accepted in convert case */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BU=
G_ON(num_stripes > 1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
vice =3D list_entry(dev_list->next, struct btrfs_device,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev=
_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ke=
y.offset =3D *start;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v_offset =3D *start;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D =
btrfs_alloc_dev_extent(trans, device, key.offset,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size, &dev_offset, 0);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size, &dev_offset, convert);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out_chunk_map;
>> =C2=A0 @@ -1077,6 +1145,9 @@ again:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->num_stripes =3D num_stripes;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->sub_stripes =3D sub_stripes;
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Insert chunk item and chunk mapping.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_insert_item(trans, chunk_=
root, &key, chunk,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_chunk_item_size(num_stripes));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> @@ -1106,125 +1177,6 @@ out_chunk:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> =C2=A0 -/*
>> - * Alloc a DATA chunk with SINGLE profile.
>> - *
>> - * If 'convert' is set, it will alloc a chunk with 1:1 mapping
>> - * (btrfs logical bytenr =3D=3D on-disk bytenr)
>> - * For that case, caller must make sure the chunk and dev_extent are =
not
>> - * occupied.
>> - */
>> -int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 struct btrfs_fs_info *info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u64 num_bytes, u64 type, int convert)
>> -{
>> -=C2=A0=C2=A0=C2=A0 u64 dev_offset;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root *extent_root =3D info->extent_ro=
ot;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root *chunk_root =3D info->chunk_root=
;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_stripe *stripes;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_device *device =3D NULL;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_chunk *chunk;
>> -=C2=A0=C2=A0=C2=A0 struct list_head *dev_list =3D &info->fs_devices->=
devices;
>> -=C2=A0=C2=A0=C2=A0 struct list_head *cur;
>> -=C2=A0=C2=A0=C2=A0 struct map_lookup *map;
>> -=C2=A0=C2=A0=C2=A0 u64 calc_size =3D SZ_8M;
>> -=C2=A0=C2=A0=C2=A0 int num_stripes =3D 1;
>> -=C2=A0=C2=A0=C2=A0 int sub_stripes =3D 0;
>> -=C2=A0=C2=A0=C2=A0 int ret;
>> -=C2=A0=C2=A0=C2=A0 int index;
>> -=C2=A0=C2=A0=C2=A0 int stripe_len =3D BTRFS_STRIPE_LEN;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> -
>> -=C2=A0=C2=A0=C2=A0 key.objectid =3D BTRFS_FIRST_CHUNK_TREE_OBJECTID;
>> -=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_CHUNK_ITEM_KEY;
>> -=C2=A0=C2=A0=C2=A0 if (convert) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (*start !=3D round_down=
(*start, info->sectorsize)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("DATA chunk start not sectorsize aligned: %llu",
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long long)*start)=
;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D *start;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_offset =3D *start;
>> -=C2=A0=C2=A0=C2=A0 } else {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 tmp;
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_next_chunk(in=
fo, &tmp);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D tmp;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 chunk =3D kmalloc(btrfs_chunk_item_size(num_stripe=
s), GFP_NOFS);
>> -=C2=A0=C2=A0=C2=A0 if (!chunk)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> -
>> -=C2=A0=C2=A0=C2=A0 map =3D kmalloc(btrfs_map_lookup_size(num_stripes)=
, GFP_NOFS);
>> -=C2=A0=C2=A0=C2=A0 if (!map) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(chunk);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 stripes =3D &chunk->stripe;
>> -=C2=A0=C2=A0=C2=A0 calc_size =3D num_bytes;
>> -
>> -=C2=A0=C2=A0=C2=A0 index =3D 0;
>> -=C2=A0=C2=A0=C2=A0 cur =3D dev_list->next;
>> -=C2=A0=C2=A0=C2=A0 device =3D list_entry(cur, struct btrfs_device, de=
v_list);
>> -
>> -=C2=A0=C2=A0=C2=A0 while (index < num_stripes) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_stripe *strip=
e;
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_dev_ex=
tent(trans, device, key.offset,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 calc_size, &dev_offset, convert);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device->bytes_used +=3D ca=
lc_size;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_update_devic=
e(trans, device);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->stripes[index].dev =3D=
 device;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 map->stripes[index].physic=
al =3D dev_offset;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe =3D stripes + index=
;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_stack_stripe_dev=
id(stripe, device->devid);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_stack_stripe_off=
set(stripe, dev_offset);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(stripe->dev_uuid, d=
evice->uuid, BTRFS_UUID_SIZE);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index++;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 /* key was set above */
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_length(chunk, num_bytes);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_owner(chunk, extent_root->ro=
ot_key.objectid);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_stripe_len(chunk, stripe_len=
);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_type(chunk, type);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_num_stripes(chunk, num_strip=
es);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_io_align(chunk, stripe_len);=

>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_io_width(chunk, stripe_len);=

>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_sector_size(chunk, info->sec=
torsize);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_chunk_sub_stripes(chunk, sub_strip=
es);
>> -=C2=A0=C2=A0=C2=A0 map->sector_size =3D info->sectorsize;
>> -=C2=A0=C2=A0=C2=A0 map->stripe_len =3D stripe_len;
>> -=C2=A0=C2=A0=C2=A0 map->io_align =3D stripe_len;
>> -=C2=A0=C2=A0=C2=A0 map->io_width =3D stripe_len;
>> -=C2=A0=C2=A0=C2=A0 map->type =3D type;
>> -=C2=A0=C2=A0=C2=A0 map->num_stripes =3D num_stripes;
>> -=C2=A0=C2=A0=C2=A0 map->sub_stripes =3D sub_stripes;
>> -
>> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_insert_item(trans, chunk_root, &key,=
 chunk,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_chunk_item_size(num_stripes));
>> -=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -=C2=A0=C2=A0=C2=A0 if (!convert)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *start =3D key.offset;
>> -
>> -=C2=A0=C2=A0=C2=A0 map->ce.start =3D key.offset;
>> -=C2=A0=C2=A0=C2=A0 map->ce.size =3D num_bytes;
>> -
>> -=C2=A0=C2=A0=C2=A0 ret =3D insert_cache_extent(&info->mapping_tree.ca=
che_tree, &map->ce);
>> -=C2=A0=C2=A0=C2=A0 BUG_ON(ret);
>> -
>> -=C2=A0=C2=A0=C2=A0 kfree(chunk);
>> -=C2=A0=C2=A0=C2=A0 return ret;
>> -}
>> -
>> =C2=A0 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical=
, u64
>> len)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_mapping_tree *map_tree =3D=
 &fs_info->mapping_tree;
>> diff --git a/volumes.h b/volumes.h
>> index 11572e78c04f..7bbdf615d31a 100644
>> --- a/volumes.h
>> +++ b/volumes.h
>> @@ -208,10 +208,7 @@ int btrfs_read_sys_array(struct btrfs_fs_info
>> *fs_info);
>> =C2=A0 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
>> =C2=A0 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type);
>> -int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info, u64 *start,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u64 num_bytes, u64 type, int convert);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 *num_bytes, u64 type, bool convert);
>> =C2=A0 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int flags);
>> =C2=A0 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>>
>=20
>=20
>=20


--0NUdGNeq70IcHCzwC12Q9ZF7mPY1Uthdh--

--MUth4NWrqdwNRAT9iNGVgRkS8lxv801K0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpPSQUNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qEzAB/4hRhlyNg0m8Y10LKD2OK/vQeZof/uk8r8wVY9Q
doZz4qhYvc6TIcFxrRyEhud8I3SR4tgPvvw2jz0a1ppmvvzSZUj2Nxgg/EYBaxoL
/0XGA05GxhnccjSfYjDpUT7bxff3mVBLMSepvhf1+7OONjoKVbTIh8ZZsXb22LVe
8uC6V49lNKZRPGquv0MkkwhOLl0RIAM8RY1h9hkx2jit+fmKJMACt3tT6oPxl/4K
DNCy1m+HtqFn9sPVLZEfxKT7lbCyv0VunD+B+CM6mQKkmfDBlfEA2FYbuCoVfy3X
wcznMO3s+HwSrHrK2XIma0JHTZViOhGDbw1RnxC3LhpFv8Jo
=DLxW
-----END PGP SIGNATURE-----

--MUth4NWrqdwNRAT9iNGVgRkS8lxv801K0--
