Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36579 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932394AbeFFIUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 04:20:21 -0400
Subject: Re: [PATCH 3/6] btrfs-progs: check/original: Detect and repair wrong
 inline ram_bytes
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180606072717.28854-1-wqu@suse.com>
 <20180606072717.28854-4-wqu@suse.com>
 <95764c6f-04c9-59e1-85cb-e654306466d5@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <eb57c5ee-c31d-494a-fdd6-33301d1e861d@gmx.com>
Date: Wed, 6 Jun 2018 16:19:26 +0800
MIME-Version: 1.0
In-Reply-To: <95764c6f-04c9-59e1-85cb-e654306466d5@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Vk46YQkVGGrlUDAdnOJFozNXY9BzSQ4K7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vk46YQkVGGrlUDAdnOJFozNXY9BzSQ4K7
Content-Type: multipart/mixed; boundary="7FUDf8Q79a8SA0F9x7NT8gVcAIWnsjxLA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <eb57c5ee-c31d-494a-fdd6-33301d1e861d@gmx.com>
Subject: Re: [PATCH 3/6] btrfs-progs: check/original: Detect and repair wrong
 inline ram_bytes
References: <20180606072717.28854-1-wqu@suse.com>
 <20180606072717.28854-4-wqu@suse.com>
 <95764c6f-04c9-59e1-85cb-e654306466d5@cn.fujitsu.com>
In-Reply-To: <95764c6f-04c9-59e1-85cb-e654306466d5@cn.fujitsu.com>

--7FUDf8Q79a8SA0F9x7NT8gVcAIWnsjxLA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8806=E6=97=A5 16:08, Su Yue wrote:
>=20
>=20
> On 06/06/2018 03:27 PM, Qu Wenruo wrote:
>> It looks like that around 2014, btrfs kernel has a regression that wou=
ld
>> cause offset-by-one ram_bytes for inline extent.
>>
>> Add the ability to repair it in original mode.
>>
>> Reported-by: Steve Leung <sjleung@shaw.ca>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/main.c          | 44 +++++++++++++++++++++++++++++++++++++++++-=
-
>>  check/mode-original.h |  1 +
>>  2 files changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 52ef181add61..1374d8856d72 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -1483,6 +1483,9 @@ static int process_file_extent(struct btrfs_root=
 *root,
>>  		} else {
>>  			if (num_bytes > max_inline_size)
>>  				rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LARGE;
>> +			if (btrfs_file_extent_inline_item_len(eb, item) !=3D
>> +			    num_bytes)
>> +				rec->errors |=3D I_ERR_INLINE_RAM_BYTES_WRONG;
>>  		}
>>  		rec->found_size +=3D num_bytes;
>>  		num_bytes =3D (num_bytes + mask) & ~mask;
>> @@ -2534,6 +2537,40 @@ out:
>>  	return ret;
>>  }
>> =20
>> +static int repair_inline_ram_bytes(struct btrfs_trans_handle *trans,
>> +				   struct btrfs_root *root,
>> +				   struct btrfs_path *path,
>> +				   struct inode_record *rec)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_file_extent_item *fi;
>> +	struct btrfs_item *i;
>> +	u64 on_disk_item_len;
>> +	int ret;
>> +
>> +	key.objectid =3D rec->ino;
>> +	key.offset =3D 0;
>> +	key.type =3D BTRFS_EXTENT_DATA_KEY;
>> +
>> +	ret =3D btrfs_search_slot(trans, root, &key, path, 0, 1);
>> +	if (ret > 0)
>> +		ret =3D -ENOENT;
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	i =3D btrfs_item_nr(path->slots[0]);
>> +	on_disk_item_len =3D btrfs_file_extent_inline_item_len(path->nodes[0=
], i);
>> +	fi =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +			    struct btrfs_file_extent_item);
>> +	btrfs_set_file_extent_ram_bytes(path->nodes[0], fi, on_disk_item_len=
);
>> +	btrfs_mark_buffer_dirty(path->nodes[0]);
>> +	printf("Successfully repaired inline ram_bytes for root %llu ino %ll=
u\n",
>> +		root->objectid, rec->ino);
>=20
> Miss a line "rec->errors &=3D ~I_ERR_INLINE_RAM_BYTES_WRONG;"?.
> Although the new test case passes, the fake appearance is due to
> existed bug about returned codes of check_ino_rec().

Oh, I forgot this one, thanks for pointing out.

Thanks,
Qu

>=20
> And refer to outputs of existed code, no need for the word
> 'Successfully'.
>> +out:
>> +	btrfs_release_path(path);
>> +	return ret;
>> +}
>> +
>>  static int try_repair_inode(struct btrfs_root *root, struct inode_rec=
ord *rec)
>>  {
>>  	struct btrfs_trans_handle *trans;
>> @@ -2545,8 +2582,9 @@ static int try_repair_inode(struct btrfs_root *r=
oot, struct inode_record *rec)
>>  			     I_ERR_LINK_COUNT_WRONG |
>>  			     I_ERR_NO_INODE_ITEM |
>>  			     I_ERR_FILE_EXTENT_ORPHAN |
>> -			     I_ERR_FILE_EXTENT_DISCOUNT|
>> -			     I_ERR_FILE_NBYTES_WRONG)))
>> +			     I_ERR_FILE_EXTENT_DISCOUNT |
>> +			     I_ERR_FILE_NBYTES_WRONG |
>> +			     I_ERR_INLINE_RAM_BYTES_WRONG)))
>=20
> It's better if you can add otehr infomation into print_inode_error().
>=20
> Others look fine to me.
>=20
> Thanks,
> Su
>>  		return rec->errors;
>> =20
>>  	/*
>> @@ -2575,6 +2613,8 @@ static int try_repair_inode(struct btrfs_root *r=
oot, struct inode_record *rec)
>>  		ret =3D repair_inode_nlinks(trans, root, &path, rec);
>>  	if (!ret && rec->errors & I_ERR_FILE_NBYTES_WRONG)
>>  		ret =3D repair_inode_nbytes(trans, root, &path, rec);
>> +	if (!ret && rec->errors & I_ERR_INLINE_RAM_BYTES_WRONG)
>> +		ret =3D repair_inline_ram_bytes(trans, root, &path, rec);
>>  	btrfs_commit_transaction(trans, root);
>>  	btrfs_release_path(&path);
>>  	return ret;
>> diff --git a/check/mode-original.h b/check/mode-original.h
>> index 13cfa5b9e1b3..ec2842e0b3be 100644
>> --- a/check/mode-original.h
>> +++ b/check/mode-original.h
>> @@ -187,6 +187,7 @@ struct file_extent_hole {
>>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>>  #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
>> +#define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
>> =20
>>  struct inode_record {
>>  	struct list_head backrefs;
>>
>=20
>=20


--7FUDf8Q79a8SA0F9x7NT8gVcAIWnsjxLA--

--Vk46YQkVGGrlUDAdnOJFozNXY9BzSQ4K7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsXmQ4ACgkQwj2R86El
/qiUpwf7BxXe3KC0FxfEUWbai4ymjxmXTn6HJFqmFTKYuskC8F/jFqUF7CGfEZGJ
KTPpIl9Qxw5QYiTT0wSGIx+LUuVhUYy4uKU4O1rUZwzKIBPnnkGmuBlvw9ML+/72
k17eEEN62/hIb5Egd7ixAQVxbhI9LLsG5KwPMegloZ/RHpV2b8u0za6iva4Xhmmk
MUVt9ecehRFy/yXRH6219ThzeBVvAX2TIXfFDxZvY0vhr2kJ7638hboA+b/M0tiI
20HQBwixBmn4Q6FWyi50Sz46Ex32Kh9pt5aaRQgo040GCXmrneJs38b3PvlJ2+Al
s3P2cxY7u0l3Fn2LvjpMqPaJ4UtEzA==
=xoI8
-----END PGP SIGNATURE-----

--Vk46YQkVGGrlUDAdnOJFozNXY9BzSQ4K7--
