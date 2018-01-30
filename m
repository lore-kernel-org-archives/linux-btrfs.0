Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59982 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751563AbeA3KFU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 05:05:20 -0500
Subject: Re: [PATCH 1/3] btrfs: Refactor __get_raid_index() to
 btrfs_bg_flags_to_raid_index()
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180130074039.24987-1-wqu@suse.com>
 <d5e4fab5-11a2-59ac-f5e9-ed17784ad779@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <25fe9fb8-c693-4c10-e568-56a58f5d4f31@gmx.com>
Date: Tue, 30 Jan 2018 18:05:09 +0800
MIME-Version: 1.0
In-Reply-To: <d5e4fab5-11a2-59ac-f5e9-ed17784ad779@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fPaRMR0pP6KWfGgl713LYsn5InTombb9k"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fPaRMR0pP6KWfGgl713LYsn5InTombb9k
Content-Type: multipart/mixed; boundary="kgnckyHmlXxSVKKylV6PC5IPlcPhpUVtv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <25fe9fb8-c693-4c10-e568-56a58f5d4f31@gmx.com>
Subject: Re: [PATCH 1/3] btrfs: Refactor __get_raid_index() to
 btrfs_bg_flags_to_raid_index()
References: <20180130074039.24987-1-wqu@suse.com>
 <d5e4fab5-11a2-59ac-f5e9-ed17784ad779@suse.com>
In-Reply-To: <d5e4fab5-11a2-59ac-f5e9-ed17784ad779@suse.com>

--kgnckyHmlXxSVKKylV6PC5IPlcPhpUVtv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8830=E6=97=A5 16:16, Nikolay Borisov wrote:
>=20
>=20
> On 30.01.2018 09:40, Qu Wenruo wrote:
>> Function __get_raid_index() is used to convert block group flags into
>> raid index, which can be used to get various info directly from
>> btrfs_raid_array[].
>>
>> Refactor this function a little:
>>
>> 1) Rename to btrfs_bg_flags_to_raid_index()
>>    Double underline prefix is normally for internal functions, while t=
he
>>    function is used by both extent-tree and volumes.
>>
>>    Although the name is a little longer, but it should explain its usa=
ge
>>    quite well.
>>
>> 2) Move it to volumes.h and make it static inline
>>    Just several if-else branches, really no need to define it as a nor=
mal
>>    function.
>>
>>    This also makes later code re-use between kernel and btrfs-progs
>>    easier.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Generally this looks good so you can add my :
>=20
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>=20
> However I wonder whether we should strive to add proper kernel docs to
> function whenever we can (without going out of the way to do so).

Kernel docs here seems a little over killed here.
IMHO kernel docs are used for things like API, state machine or design
overview.

Here the raid type index is mostly internal used as a quicker and
unified way to access btrfs_raid_array[].

Extra comment (maybe 1 or 2 lines) will be added in next version about
the usage, and hopes it should work.

> I.e
> you are modifying the function now so might as well add them and
> explicitly state it's used to convert blockgroup flags to raid levels.
> The end goal is to make it easier for people who are looking for the
> first time at the source to have easier time.

Yep, making the source easier to read is always good.

Thanks,
Qu

>=20
>> ---
>>  fs/btrfs/extent-tree.c | 26 ++++----------------------
>>  fs/btrfs/volumes.c     |  2 +-
>>  fs/btrfs/volumes.h     | 18 ++++++++++++++++++
>>  3 files changed, 23 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 2f4328511ac8..e9c31b567a9c 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7346,27 +7346,9 @@ wait_block_group_cache_done(struct btrfs_block_=
group_cache *cache)
>>  	return ret;
>>  }
>> =20
>> -int __get_raid_index(u64 flags)
>> -{
>> -	if (flags & BTRFS_BLOCK_GROUP_RAID10)
>> -		return BTRFS_RAID_RAID10;
>> -	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
>> -		return BTRFS_RAID_RAID1;
>> -	else if (flags & BTRFS_BLOCK_GROUP_DUP)
>> -		return BTRFS_RAID_DUP;
>> -	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
>> -		return BTRFS_RAID_RAID0;
>> -	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
>> -		return BTRFS_RAID_RAID5;
>> -	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
>> -		return BTRFS_RAID_RAID6;
>> -
>> -	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
>> -}
>> -
>>  int get_block_group_index(struct btrfs_block_group_cache *cache)
>>  {
>> -	return __get_raid_index(cache->flags);
>> +	return btrfs_bg_flags_to_raid_index(cache->flags);
>>  }
>> =20
>>  static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] =3D {
>> @@ -7483,7 +7465,7 @@ static noinline int find_free_extent(struct btrf=
s_fs_info *fs_info,
>>  	u64 empty_cluster =3D 0;
>>  	struct btrfs_space_info *space_info;
>>  	int loop =3D 0;
>> -	int index =3D __get_raid_index(flags);
>> +	int index =3D btrfs_bg_flags_to_raid_index(flags);
>>  	bool failed_cluster_refill =3D false;
>>  	bool failed_alloc =3D false;
>>  	bool use_cluster =3D true;
>> @@ -7579,7 +7561,7 @@ static noinline int find_free_extent(struct btrf=
s_fs_info *fs_info,
>>  	}
>>  search:
>>  	have_caching_bg =3D false;
>> -	if (index =3D=3D 0 || index =3D=3D __get_raid_index(flags))
>> +	if (index =3D=3D 0 || index =3D=3D btrfs_bg_flags_to_raid_index(flag=
s))
>>  		full_search =3D true;
>>  	down_read(&space_info->groups_sem);
>>  	list_for_each_entry(block_group, &space_info->block_groups[index],
>> @@ -9643,7 +9625,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_=
info, u64 bytenr)
>>  	 */
>>  	target =3D get_restripe_target(fs_info, block_group->flags);
>>  	if (target) {
>> -		index =3D __get_raid_index(extended_to_chunk(target));
>> +		index =3D btrfs_bg_flags_to_raid_index(extended_to_chunk(target));
>>  	} else {
>>  		/*
>>  		 * this is just a balance, so if we were marked as full
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index a25684287501..d818b1f9c625 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -4625,7 +4625,7 @@ static int __btrfs_alloc_chunk(struct btrfs_tran=
s_handle *trans,
>>  	if (list_empty(&fs_devices->alloc_list))
>>  		return -ENOSPC;
>> =20
>> -	index =3D __get_raid_index(type);
>> +	index =3D btrfs_bg_flags_to_raid_index(type);
>> =20
>>  	sub_stripes =3D btrfs_raid_array[index].sub_stripes;
>>  	dev_stripes =3D btrfs_raid_array[index].dev_stripes;
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index ff15208344a7..413e07e44b42 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -533,6 +533,24 @@ static inline void btrfs_dev_stat_reset(struct bt=
rfs_device *dev,
>>  	btrfs_dev_stat_set(dev, index, 0);
>>  }
>> =20
>> +static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 =
flags)
>> +{
>> +	if (flags & BTRFS_BLOCK_GROUP_RAID10)
>> +		return BTRFS_RAID_RAID10;
>> +	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
>> +		return BTRFS_RAID_RAID1;
>> +	else if (flags & BTRFS_BLOCK_GROUP_DUP)
>> +		return BTRFS_RAID_DUP;
>> +	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
>> +		return BTRFS_RAID_RAID0;
>> +	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
>> +		return BTRFS_RAID_RAID5;
>> +	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
>> +		return BTRFS_RAID_RAID6;
>> +
>> +	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
>> +}
>> +
>>  void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
>>  void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_i=
nfo,
>>  					struct btrfs_transaction *transaction);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--kgnckyHmlXxSVKKylV6PC5IPlcPhpUVtv--

--fPaRMR0pP6KWfGgl713LYsn5InTombb9k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpwQ1UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhM/Qf/U64CAWCitVSKpPSbotWi4SnH
1T0W7FGEceYyOqHXOv2RTKgWTmNxXyITvVDT/NiHqdjVgOp3p/s8Zute+A++VcQC
FpMZu13ekkJj7rWgodnJPSJ3UofyOK7pX+x/ijw3JnYCoLao9pI0viv9ZZBUGKvq
yfehgW9MaFBR44ft6MXGhRIsINdXILYijPDyYOj7eiJmPh1eKu/dWdgqU4WLPgTW
sDKqvYRrMIiYZZhACjBSe+LfcbkM44pRg89vkN/ht8eafvwTvTRw8TbMNKuL1YjO
h8hZy+qSLefzBars3gXTBZmfQVc0+qAB+ulMKEEUQipFZ1Tx8R6DQjCPB8NgtQ==
=Lbxu
-----END PGP SIGNATURE-----

--fPaRMR0pP6KWfGgl713LYsn5InTombb9k--
