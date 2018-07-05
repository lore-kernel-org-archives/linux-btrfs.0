Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:34239 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753123AbeGEXl4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 19:41:56 -0400
Subject: Re: [PATCH 4/5] btrfs: Check each block group has corresponding chunk
 at mount time
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-5-wqu@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557B53@G08CNEXMBPEKD02.g08.fujitsu.local>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f4f3afd2-0528-6b06-26be-3e464ac9f24f@gmx.com>
Date: Fri, 6 Jul 2018 07:41:38 +0800
MIME-Version: 1.0
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557B53@G08CNEXMBPEKD02.g08.fujitsu.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0vvrzRB3SszmBPnrw99nJ0JulzEUWUwy8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0vvrzRB3SszmBPnrw99nJ0JulzEUWUwy8
Content-Type: multipart/mixed; boundary="0laC3KzBetIjqNTJN53Guk45pv9dGHn3x";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <f4f3afd2-0528-6b06-26be-3e464ac9f24f@gmx.com>
Subject: Re: [PATCH 4/5] btrfs: Check each block group has corresponding chunk
 at mount time
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-5-wqu@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557B53@G08CNEXMBPEKD02.g08.fujitsu.local>
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557B53@G08CNEXMBPEKD02.g08.fujitsu.local>

--0laC3KzBetIjqNTJN53Guk45pv9dGHn3x
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8804=E6=97=A5 13:45, Gu, Jinxiang wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger=
=2Ekernel.org] On Behalf Of Qu Wenruo
>> Sent: Tuesday, July 03, 2018 5:10 PM
>> To: linux-btrfs@vger.kernel.org
>> Subject: [PATCH 4/5] btrfs: Check each block group has corresponding c=
hunk at mount time
>>
>> A crafted btrfs with incorrect chunk<->block group mapping, it could l=
eads
>> to a lot of unexpected behavior.
>>
>> Although the crafted image can be catched by block group item checker
>> added in "[PATCH] btrfs: tree-checker: Verify block_group_item", if on=
e
>> crafted a valid enough block group item which can pass above check but=

>> still mismatch with existing chunk, it could cause a lot of undefined
>> behavior.
>>
>> This patch will add extra block group -> chunk mapping check, to ensur=
e
>> we have a completely matching (start, len, flags) chunk for each block=

>> group at mount time.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D199837
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 55 ++++++++++++++++++++++++++++++++++++++++-=
-
>>  1 file changed, 53 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 3d9fe58c0080..82b446f014b9 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10003,6 +10003,41 @@ btrfs_create_block_group_cache(struct btrfs_f=
s_info *fs_info,
>>  	return cache;
>>  }
>>
>> +static int check_exist_chunk(struct btrfs_fs_info *fs_info, u64 start=
, u64 len,
>> +			     u64 flags)
>> +{
>> +	struct btrfs_mapping_tree *map_tree =3D &fs_info->mapping_tree;
>> +	struct extent_map *em;
>> +	int ret;
>> +
>> +	read_lock(&map_tree->map_tree.lock);
>> +	em =3D lookup_extent_mapping(&map_tree->map_tree, start, len);
>> +	read_unlock(&map_tree->map_tree.lock);
>> +
>> +	if (!em) {
>> +		btrfs_err_rl(fs_info,
>> +	"block group start=3D%llu len=3D%llu doesn't have corresponding chun=
k",
>> +			     start, len);
>> +		ret =3D -ENOENT;
>> +		goto out;
>> +	}
>=20
> This check has been done in find_first_block_group which has been calle=
d before
> check_exist_chunk be called.

Oh, yes, find_first_block_group() indeed does this check, so there is no
need for check_exsist_chunk().
>=20
>> +	if (em->start !=3D start || em->len !=3D len ||
>> +	    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK) !=3D
>> +	    (flags & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
>> +		btrfs_err_rl(fs_info,
>> +"block group start=3D%llu len=3D%llu flags=3D0x%llx doesn't match wit=
h chunk start=3D%llu len=3D%llu flags=3D0x%llx",
>> +			     start, len , flags & BTRFS_BLOCK_GROUP_TYPE_MASK,
>> +			     em->start, em->len, em->map_lookup->type &
>> +			     BTRFS_BLOCK_GROUP_TYPE_MASK);
>> +		ret =3D -EUCLEAN;
>> +		goto out;
>> +	}
> Should this check also be added to find_first_block_group?

Yep.

Thanks,
Qu

>=20
>> +	ret =3D 0;
>> +out:
>> +	free_extent_map(em);
>> +	return ret;
>> +}
>> +
>>  int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>  {
>>  	struct btrfs_path *path;
>> @@ -10036,6 +10071,9 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>>  		need_clear =3D 1;
>>
>>  	while (1) {
>> +		struct btrfs_block_group_item bg;
>> +		int slot;
>> +
>>  		ret =3D find_first_block_group(info, path, &key);
>>  		if (ret > 0)
>>  			break;
>> @@ -10043,7 +10081,20 @@ int btrfs_read_block_groups(struct btrfs_fs_i=
nfo *info)
>>  			goto error;
>>
>>  		leaf =3D path->nodes[0];
>> -		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
>> +		slot =3D path->slots[0];
>> +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
>> +
>> +		read_extent_buffer(leaf, &bg, btrfs_item_ptr_offset(leaf, slot),
>> +				   sizeof(bg));
>> +		/*
>> +		 * Chunk and block group must have 1:1 mapping.
>> +		 * So there must be a chunk for this block group.
>> +		 */
>> +		ret =3D check_exist_chunk(info, found_key.objectid,
>> +					found_key.offset,
>> +					btrfs_block_group_flags(&bg));
>> +		if (ret < 0)
>> +			goto error;
>>
>>  		cache =3D btrfs_create_block_group_cache(info, found_key.objectid,
>>  						       found_key.offset);
>> @@ -10068,7 +10119,7 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>>  		}
>>
>>  		read_extent_buffer(leaf, &cache->item,
>> -				   btrfs_item_ptr_offset(leaf, path->slots[0]),
>> +				   btrfs_item_ptr_offset(leaf, slot),
>>  				   sizeof(cache->item));
>>  		cache->flags =3D btrfs_block_group_flags(&cache->item);
>>  		if (!mixed &&
>> --
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20
>=20
> N=E5=AB=A5=E5=8F=89=E9=9D=A3=E7=AC=A1y=EE=8C=B7=E6=B0=8Ab=E7=9E=82=EE=83=
=91=E5=8D=83v=E8=B1=9D=EF=BF=BD)=E8=97=93{.n=EF=BF=BD+=E5=A3=8F=EE=9A=8F{=
=E7=9C=93=E8=B0=B6=EF=BF=BD)=E9=9F=B0=E9=AA=85w*=1Fjg=EE=83=8C=EF=BF=BD=1E=
=E7=A7=B9=E6=AE=A0=E5=A8=B8=EE=95=90/=E4=BE=81=E9=8B=A4=E7=BD=90=E6=9E=88=
=EF=BF=BD2=E5=A8=B9=E6=AB=92=E7=92=80=EF=BF=BD&=EF=BF=BD)=E6=91=BA=E7=8E=9C=
=E5=9B=A4=7F=EE=92=BF=1E=E7=93=BD=E7=8F=B4=E9=96=94=EF=BF=BD=0F=E9=8E=97:=
+v=E5=A2=BE=E5=A6=9B=E9=91=B6=E4=BD=B6
>=20


--0laC3KzBetIjqNTJN53Guk45pv9dGHn3x--

--0vvrzRB3SszmBPnrw99nJ0JulzEUWUwy8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls+rLIACgkQwj2R86El
/qjA1ggAk7QokJhF/Y/0qcwFJC06Dn032j1mhSQl/YOyKRDpfznYsc/GmgyyaqaW
08kX81Ff4RBoRcCo2gprDbhnHEHNLT8ChBrNBUHyYiL6UlVgDfamiKuNh6g7vvSi
JwqAbLUTTm49It5MotJb36ANb/OPJXlC9ubCGJUBLd5RU3anYJ1l73GZ2JJ+J3dl
8MIU2TO8yJOqHq1+0WfzY6+OQRizfNZfpyn9MjlZp/gNHshwh+tKeJ+CF2vWkl5N
oO1KWaoWuE03rmrn3A6wINb7W+cAkkQGMRiu8AX/3UlYST1u4X667TftV04T90LB
3TFlpfKrm7V7tSIVB+wh11ju3eRvgQ==
=xBxQ
-----END PGP SIGNATURE-----

--0vvrzRB3SszmBPnrw99nJ0JulzEUWUwy8--
