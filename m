Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753123AbeGEXom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 19:44:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 07054AD2F
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 23:44:41 +0000 (UTC)
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com> <20180705151804.GH3126@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
Date: Fri, 6 Jul 2018 07:44:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180705151804.GH3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fbgI4YjI0QDMXCpE3DnxoKX5Ez4VIBbLq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fbgI4YjI0QDMXCpE3DnxoKX5Ez4VIBbLq
Content-Type: multipart/mixed; boundary="0iv9XxF4dYkq6uDAjNUn8vRl1NOVaouiA";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com> <20180705151804.GH3126@twin.jikos.cz>
In-Reply-To: <20180705151804.GH3126@twin.jikos.cz>

--0iv9XxF4dYkq6uDAjNUn8vRl1NOVaouiA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8805=E6=97=A5 23:18, David Sterba wrote:
> On Tue, Jul 03, 2018 at 05:10:09PM +0800, Qu Wenruo wrote:
>> If a crafted btrfs has missing block group items, it could cause
>> unexpected behavior and breaks our expectation on 1:1
>> chunk<->block group mapping.
>>
>> Although we added block group -> chunk mapping check, we still need
>> chunk -> block group mapping check.
>>
>> This patch will do extra check to ensure each chunk has its
>> corresponding block group.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D199847
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 52 +++++++++++++++++++++++++++++++++++++++++=
-
>>  1 file changed, 51 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 82b446f014b9..746095034ca2 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10038,6 +10038,56 @@ static int check_exist_chunk(struct btrfs_fs_=
info *fs_info, u64 start, u64 len,
>>  	return ret;
>>  }
>> =20
>> +/*
>> + * Iterate all chunks and verify each of them has corresponding block=
 group
>> + */
>> +static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_=
info)
>> +{
>> +	struct btrfs_mapping_tree *map_tree =3D &fs_info->mapping_tree;
>> +	struct extent_map *em;
>> +	struct btrfs_block_group_cache *bg;
>> +	u64 start =3D 0;
>> +	int ret =3D 0;
>> +
>> +	while (1) {
>> +		read_lock(&map_tree->map_tree.lock);
>> +		em =3D lookup_extent_mapping(&map_tree->map_tree, start,
>> +					   (u64)-1 - start);
>=20
> This needs a comment.

For the @len part?

>=20
>> +		read_unlock(&map_tree->map_tree.lock);
>> +		if (!em)
>> +			break;
>> +
>> +		bg =3D btrfs_lookup_block_group(fs_info, em->start);
>> +		if (!bg) {
>> +			btrfs_err_rl(fs_info,
>> +	"chunk start=3D%llu len=3D%llu doesn't have corresponding block grou=
p",
>> +				     em->start, em->len);
>> +			ret =3D -ENOENT;
>=20
> -EUCLEAN ?

Either works for me.

>=20
>> +			free_extent_map(em);
>> +			break;
>> +		}
>> +		if (bg->key.objectid !=3D em->start ||
>> +		    bg->key.offset !=3D em->len ||
>> +		    (bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) !=3D
>> +		    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
>> +			btrfs_err_rl(fs_info,
>=20
> Why is this ratelmited? I'd understand that a fuzzed image will spew a
> lot of these errors but for a normal case, it should be ok to print all=

> the messages.

Well, even for fuzzed image it won't trigger twice, the first time it
triggers we will error our, so indeed no need to rate the limit anyway.

Thanks,
Qu

>=20
>> +"chunk start=3D%llu len=3D%llu flags=3D0x%llx doesn't match with bloc=
k group start=3D%llu len=3D%llu flags=3D0x%llx",
>> +				em->start, em->len,
>> +				em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK,
>> +				bg->key.objectid, bg->key.offset,
>> +				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
>> +			ret =3D -EUCLEAN;
>> +			free_extent_map(em);
>> +			btrfs_put_block_group(bg);
>> +			break;
>> +		}
>> +		start =3D em->start + em->len;
>> +		free_extent_map(em);
>> +		btrfs_put_block_group(bg);
>> +	}
>> +	return ret;
>> +}
>> +
>>  int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>  {
>>  	struct btrfs_path *path;
>> @@ -10227,7 +10277,7 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>> =20
>>  	btrfs_add_raid_kobjects(info);
>>  	init_global_block_rsv(info);
>> -	ret =3D 0;
>> +	ret =3D check_chunk_block_group_mappings(info);
>>  error:
>>  	btrfs_free_path(path);
>>  	return ret;
>> --=20
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--0iv9XxF4dYkq6uDAjNUn8vRl1NOVaouiA--

--fbgI4YjI0QDMXCpE3DnxoKX5Ez4VIBbLq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls+rWUACgkQwj2R86El
/qihNAgAoHWHrXuKCx2zSrSoFxZoiY04mOI3tuY7suD6TLD57BXhyQVTVsIQ7G75
oKsb0m5AqKE/VanRVfu+TtEfVeeH77gyMtOfk3j1NkEtYrNpyemY2PGMB1l1uXv8
rPky9xca4ujfCPu1IM+TtZ7C3iNtlK1DJNuHdCmOZo72bW+qx637AnpS3jwHpvOo
i/kqZuyK1ZoMkug1L8ymmJg610h+PY6g4xVFvy0ei/XOU1QDPyxKZ3Jb85ObEYYf
5F1oOj0PogE8cpxx2hg59PMkYLDYvGCc1S7TU9SVSAPEa5M/M1Kf1kwQG7D8zB0N
tLk29Jxp/YUGj5jIzpFrZBRKj14cMg==
=QMJP
-----END PGP SIGNATURE-----

--fbgI4YjI0QDMXCpE3DnxoKX5Ez4VIBbLq--
