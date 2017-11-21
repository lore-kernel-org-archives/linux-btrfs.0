Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51174 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdKUBHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 20:07:41 -0500
Subject: Re: [PATCH] btrfs: Enhance btrfs_trim_fs function to handle error
 better
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        lists@colorremedies.com
References: <20171120055651.17892-1-wqu@suse.com>
 <20171120175106.GE3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6639f8f2-7842-65ad-bfbb-fa04439b58c2@gmx.com>
Date: Tue, 21 Nov 2017 09:07:01 +0800
MIME-Version: 1.0
In-Reply-To: <20171120175106.GE3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mLTo5WW9ecUU8oLFC7W3wFW4rvkHQPBa7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mLTo5WW9ecUU8oLFC7W3wFW4rvkHQPBa7
Content-Type: multipart/mixed; boundary="94Tis4nPWh68VLcD7k0Q0fHuSBqkn0uBL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 lists@colorremedies.com
Message-ID: <6639f8f2-7842-65ad-bfbb-fa04439b58c2@gmx.com>
Subject: Re: [PATCH] btrfs: Enhance btrfs_trim_fs function to handle error
 better
References: <20171120055651.17892-1-wqu@suse.com>
 <20171120175106.GE3553@twin.jikos.cz>
In-Reply-To: <20171120175106.GE3553@twin.jikos.cz>

--94Tis4nPWh68VLcD7k0Q0fHuSBqkn0uBL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 01:51, David Sterba wrote:
> On Mon, Nov 20, 2017 at 01:56:51PM +0800, Qu Wenruo wrote:
>> Function btrfs_trim_fs() doesn't handle errors in a consistent way, if=

>> error happens when trimming existing block groups, it will skip the
>> remaining blocks and continue to trim unallocated space for each devic=
e.
>>
>> And the return value will only reflect the final error from device
>> trimming.
>>
>> This patch will fix such behavior by:
>>
>> 1) Recording first error from block group or device trimming
>>    So return value will also reflect any error found when trimming.
>>    Make developer more aware of the problem.
>>
>> 2) Outputting btrfs warning message for each trimming failure
>>    Any error for block group or device trimming will cause btrfs warni=
ng
>>    kernel message.
>=20
> I think this could become too noisy, trimming failures are soft errors
> IMO, so it should be enough to report all errors cumulatively
> per-device.

Although block group trimming errors are not that obvious to be reported
at per-device base.

>=20
>> 3) Continuing trimming if we can
>>    If we failed to trim one block group or device, we could still try
>>    next block group or device.
>=20
> Right, best-effort.
>=20
>> Such behavior can avoid confusion for case like failure to trim the
>> first block group and then only unallocated space is trimmed.
>>
>> Reported-by: Chris Murphy <lists@colorremedies.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++++++++++++-----=
---------
>>  1 file changed, 43 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 309a109069f1..46d65ffb3bd1 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10948,6 +10948,16 @@ static int btrfs_trim_free_extents(struct btr=
fs_device *device,
>>  	return ret;
>>  }
>> =20
>> +/*
>> + * Trim the whole fs, by:
>> + * 1) Trimming free space in each block group
>> + * 2) Trimming unallocated space in each device
>> + *
>> + * Will try to continue trimming even if we failed to trim one block =
group or
>> + * device.
>> + * The return value will be the error return value of the first error=
=2E
>> + * Or 0 if nothing wrong happened.
>> + */
>>  int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range =
*range)
>>  {
>>  	struct btrfs_block_group_cache *cache =3D NULL;
>> @@ -10958,6 +10968,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_inf=
o, struct fstrim_range *range)
>>  	u64 end;
>>  	u64 trimmed =3D 0;
>>  	u64 total_bytes =3D btrfs_super_total_bytes(fs_info->super_copy);
>> +	int bg_ret =3D 0;
>> +	int dev_ret =3D 0;
>>  	int ret =3D 0;
>> =20
>>  	/*
>> @@ -10968,7 +10980,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_inf=
o, struct fstrim_range *range)
>>  	else
>>  		cache =3D btrfs_lookup_block_group(fs_info, range->start);
>> =20
>> -	while (cache) {
>> +	for (; cache; cache =3D next_block_group(fs_info, cache)) {
>>  		if (cache->key.objectid >=3D (range->start + range->len)) {
>>  			btrfs_put_block_group(cache);
>>  			break;
>> @@ -10982,29 +10994,36 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_i=
nfo, struct fstrim_range *range)
>>  			if (!block_group_cache_done(cache)) {
>>  				ret =3D cache_block_group(cache, 0);
>>  				if (ret) {
>> -					btrfs_put_block_group(cache);
>> -					break;
>> +					btrfs_warn_rl(fs_info,
>> +		"failed to cache block group %llu ret %d",
>=20
> If this is meant for a developer as you say in the changelog, then
> btrfs_debug is better.

Btrfs_debug looks good to me.

>=20
>> +						   cache->key.objectid, ret);
>> +					if (!bg_ret)
>> +						bg_ret =3D ret;
>> +					continue;
>>  				}
>>  				ret =3D wait_block_group_cache_done(cache);
>>  				if (ret) {
>> -					btrfs_put_block_group(cache);
>> -					break;
>> +					btrfs_warn_rl(fs_info,
>> +		"failed to wait cache for block group %llu ret %d",
>=20
> The message wording is confusing, if this is another message for
> developer, the function name can be printed.

OK.

>=20
>> +						   cache->key.objectid, ret);
>> +					if (!bg_ret)
>> +						bg_ret =3D ret;
>> +					continue;
>>  				}
>>  			}
>> -			ret =3D btrfs_trim_block_group(cache,
>> -						     &group_trimmed,
>> -						     start,
>> -						     end,
>> -						     range->minlen);
>> +			ret =3D btrfs_trim_block_group(cache, &group_trimmed,
>> +						start, end, range->minlen);
>> =20
>>  			trimmed +=3D group_trimmed;
>>  			if (ret) {
>> -				btrfs_put_block_group(cache);
>> -				break;
>> +				btrfs_warn_rl(fs_info,
>> +		"failed to trim block group %llu ret %d",
>> +					   cache->key.objectid, ret);
>> +				if (!bg_ret)
>> +					bg_ret =3D ret;
>> +				continue;
>>  			}
>>  		}
>> -
>> -		cache =3D next_block_group(fs_info, cache);
>>  	}
>> =20
>>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>> @@ -11012,15 +11031,23 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_i=
nfo, struct fstrim_range *range)
>>  	list_for_each_entry(device, devices, dev_alloc_list) {
>>  		ret =3D btrfs_trim_free_extents(device, range->minlen,
>>  					      &group_trimmed);
>> -		if (ret)
>> +		if (ret) {
>> +			btrfs_warn_rl(fs_info,
>> +		"failed to trim unallocated space for devid %llu ret %d",
>> +				      device->devid, ret);
>=20
> So the idea is to print one message here, with devid, number of errors
> and how many bytes were skipped.

About number of errors, did you mean also accounting the errors found in
block group trimming?
In that case, it may not be related to all devices of a block group.

So this doesn't look appropriate to account block group errors into
device error.

Thanks,
Qu

>=20
>> +			if (!dev_ret)
>> +				dev_ret =3D ret;
>>  			break;
>> +		}
>> =20
>>  		trimmed +=3D group_trimmed;
>>  	}
>>  	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> =20
>>  	range->len =3D trimmed;
>> -	return ret;
>> +	if (bg_ret)
>> +		return bg_ret;
>> +	return dev_ret;
>>  }
>> =20
>>  /*
>> --=20
>> 2.15.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--94Tis4nPWh68VLcD7k0Q0fHuSBqkn0uBL--

--mLTo5WW9ecUU8oLFC7W3wFW4rvkHQPBa7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloTfDUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhv4wf/dRmbKv8L1jJ2gb1MPpv3tEGA
hjvti8JPpA6MnQjYe+1BvD+cAzZQOinPZ6u2Y5AAnFH0NCS/xBjmVZNjyW1AnzWz
UN7RsZnPlCzbKC0oaf/KfNMA0JIuNaimDZPpT1FYlIcCxcY2Iz0dLrfzI8yfHWqB
GXf8vAO7scJvax9cPDvxZ9TBC8RsLhUZfjvfBSYjfzjb48LI0fHGZPy74zl9Ngdi
2cyGfw4wqV6NQNoBgbwzM6fM8tH3LPs4n3zsJb7rcKNPgRcnsJbGJ5ia+GtIoZ0H
47P6j58QhRiQfota3B0EbSz/InXuIukQJSXzHBiupNAeeu6EEIb/7JAizY0n3Q==
=TPuK
-----END PGP SIGNATURE-----

--mLTo5WW9ecUU8oLFC7W3wFW4rvkHQPBa7--
