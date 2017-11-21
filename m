Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49579 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdKUIHG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 21 Nov 2017 03:07:06 -0500
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171121055445.13972-1-wqu@suse.com>
 <78abe4d1-b83c-980a-4594-e1f25b52b81a@suse.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <c864ff00-ec2a-603b-cc2c-b942d2373f7c@suse.com>
Date: Tue, 21 Nov 2017 16:06:54 +0800
MIME-Version: 1.0
In-Reply-To: <78abe4d1-b83c-980a-4594-e1f25b52b81a@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qfbp4vg8msXjiDTDbT5W3L1EIxo9Wud4j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qfbp4vg8msXjiDTDbT5W3L1EIxo9Wud4j
Content-Type: multipart/mixed; boundary="TFiVkARsDtJwW65CuwTlrias4543nI4A8";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <c864ff00-ec2a-603b-cc2c-b942d2373f7c@suse.com>
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
References: <20171121055445.13972-1-wqu@suse.com>
 <78abe4d1-b83c-980a-4594-e1f25b52b81a@suse.com>
In-Reply-To: <78abe4d1-b83c-980a-4594-e1f25b52b81a@suse.com>

--TFiVkARsDtJwW65CuwTlrias4543nI4A8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 15:33, Nikolay Borisov wrote:
>=20
>=20
> On 21.11.2017 07:54, Qu Wenruo wrote:
>> To save reader seconds before checking if it's rounding up or down.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 309a109069f1..8ab18e25cb91 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2054,7 +2054,7 @@ static int btrfs_issue_discard(struct block_devi=
ce *bdev, u64 start, u64 len,
>>  {
>>  	int j, ret =3D 0;
>>  	u64 bytes_left, end;
>> -	u64 aligned_start =3D ALIGN(start, 1 << 9);
>> +	u64 aligned_start =3D round_up(start, 1 << 9);
>=20
> nit: 1 << 9 =3D=3D SZ_512 or essentially sector size however looking at=
 the
> defines there is SECTOR_SIZE defined in ide.h which we do not include.
> Or just use 512 no need to obscure it behind a shift.

I also noticed that while I don't have any good idea which macro should
be used.

That SECTOR_SIZE defined in ide.h doesn't sound good to me.
And all other filesystems are using their own definition, without some
definition in fs/bio level.

Thanks,
Qu

>=20
>> =20
>>  	if (WARN_ON(start !=3D aligned_start)) {
>>  		len -=3D aligned_start - start;
>> @@ -4266,7 +4266,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs=
_inode *inode, u64 bytes)
>>  	int have_pinned_space;
>> =20
>>  	/* make sure bytes are sectorsize aligned */
>> -	bytes =3D ALIGN(bytes, fs_info->sectorsize);
>> +	bytes =3D round_up(bytes, fs_info->sectorsize);
>> =20
>>  	if (btrfs_is_free_space_inode(inode)) {
>>  		need_commit =3D 0;
>> @@ -6080,7 +6080,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs=
_inode *inode, u64 num_bytes)
>>  	if (delalloc_lock)
>>  		mutex_lock(&inode->delalloc_mutex);
>> =20
>> -	num_bytes =3D ALIGN(num_bytes, fs_info->sectorsize);
>> +	num_bytes =3D round_up(num_bytes, fs_info->sectorsize);
>> =20
>>  	/* Add our new extents and calculate the new rsv size. */
>>  	spin_lock(&inode->lock);
>> @@ -6135,7 +6135,7 @@ void btrfs_delalloc_release_metadata(struct btrf=
s_inode *inode, u64 num_bytes)
>>  {
>>  	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->vfs_inode.i_sb);
>> =20
>> -	num_bytes =3D ALIGN(num_bytes, fs_info->sectorsize);
>> +	num_bytes =3D round_up(num_bytes, fs_info->sectorsize);
>>  	spin_lock(&inode->lock);
>>  	inode->csum_bytes -=3D num_bytes;
>>  	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>> @@ -7818,7 +7818,7 @@ static noinline int find_free_extent(struct btrf=
s_fs_info *fs_info,
>>  			goto loop;
>>  		}
>>  checks:
>> -		search_start =3D ALIGN(offset, fs_info->stripesize);
>> +		search_start =3D round_up(offset, fs_info->stripesize);
>> =20
>>  		/* move on to the next group */
>>  		if (search_start + num_bytes >
>>


--TFiVkARsDtJwW65CuwTlrias4543nI4A8--

--qfbp4vg8msXjiDTDbT5W3L1EIxo9Wud4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAloT3p4NHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qNBxB/9nIKlcs9Gz6iiXagSMjqfahAo+DU/1NiBLY/Yz
JwK7FnQWPawFawnXPFtzwU30Taeq+tXtKjN2M+noxHQ+hwIbw8t9aNSxQY7j4qc6
hnnsF/+IUWDuHh4wElqjD0zgnT4kw6vvumbo7VMuNszrIvpTNnkPkZ0x7cFPvJ+k
TquE7Im6GpZBaTzfGZ+xBNG5Vn3zVj9baRW3b2v489cwAauhI5tmvMxgldC4qqqJ
I8HP6Lk5htNfKHR1yCl14a3vwsb8bQzJj0gcLH6OhvUQzzIy87wyQnHa8ZDgHYCv
x/VyzbNxkELr+UZLftq6dd3IM1KLxYf797YMc5pd/xmJnfiy
=9uy5
-----END PGP SIGNATURE-----

--qfbp4vg8msXjiDTDbT5W3L1EIxo9Wud4j--
