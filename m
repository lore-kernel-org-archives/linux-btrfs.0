Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64601 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932677AbeAJBuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 20:50:10 -0500
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
 <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
Message-ID: <4b4d169f-5cf9-270e-7423-8552d8d46577@gmx.com>
Date: Wed, 10 Jan 2018 09:49:57 +0800
MIME-Version: 1.0
In-Reply-To: <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HIKXToMJA54n9wKZOVFuC0oCzEoZRAwus"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HIKXToMJA54n9wKZOVFuC0oCzEoZRAwus
Content-Type: multipart/mixed; boundary="nr3GWTR9B794wLQZcQaXcUeGCjrC7V9Bx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <4b4d169f-5cf9-270e-7423-8552d8d46577@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
 <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
In-Reply-To: <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>

--nr3GWTR9B794wLQZcQaXcUeGCjrC7V9Bx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8810=E6=97=A5 09:30, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B401=E6=9C=8810=E6=97=A5 00:04, Nikolay Borisov wrote:
>> Currently when df (resp. statfs) is executed on a btrfs instance the
>> free space is calculated as the freespace of the block groups +
>> any unallocated space on the devices, constituting this filesystem.
>> There is a catch, however, in that the unallocated space from the
>> devices has 1 mb subtracted from each device to closely follow btrfs'
>> allocator behavior. This is all good except that when we have a file
>> system and the system chunk's allocation profile is single (as is the
>> default in mixed mode) it occupies the range 0..4mb and thus implicitl=
y
>> prevents allocation starting in the range 0..1mb. In those cases
>> additionally subtracting 1mb during statfs makes us misreport the
>> actual free space and this causes generic/015 to fail.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>> Hello,                                                                =
         =20
>>                                                                       =
         =20
>> So with this patch and adding sync to generic/015 (which is a differen=
t issue) =20
>> I can make generic/015 pass. In any case I think this behavior is corr=
ect      =20
>> though frankly I feel it's not really worth it, in the worst case we a=
re       =20
>> underreporting by at most 1mb per device.
>>
>>  fs/btrfs/super.c | 25 +++++++++++++------------
>>  1 file changed, 13 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index f33a55272deb..a4dfc9701220 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1925,12 +1925,13 @@ static int btrfs_calc_avail_data_space(struct =
btrfs_fs_info *fs_info,
>>  	struct btrfs_device_info *devices_info;
>>  	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
>>  	struct btrfs_device *device;
>> -	u64 skip_space;
>>  	u64 type;
>>  	u64 avail_space;
>>  	u64 min_stripe_size;
>>  	int min_stripes =3D 1, num_stripes =3D 1;
>>  	int i =3D 0, nr_devices;
>> +	bool sys_chunk_single =3D !(btrfs_system_alloc_profile(fs_info) &
>> +				  ~BTRFS_BLOCK_GROUP_SYSTEM);
>> =20
>>  	/*
>>  	 * We aren't under the device list lock, so this is racy-ish, but go=
od
>> @@ -1988,18 +1989,18 @@ static int btrfs_calc_avail_data_space(struct =
btrfs_fs_info *fs_info,
>>  		/*
>>  		 * In order to avoid overwriting the superblock on the drive,
>>  		 * btrfs starts at an offset of at least 1MB when doing chunk
>> -		 * allocation.
>> +		 * allocation. There is one notable exception, and that is
>> +		 * when the System chunk has allocation profile of single. In
>> +		 * this case it occupies 0..4m  and we don't really need to
>> +		 * subtract 1mb as it's implied
>=20
> This is in fact a bug in mkfs.btrfs.
>=20
> The problem is, current chunk allocator in mkfs.btrfs doesn't really
> avoid the first 1M.

Just a side note, it's the custom allocator (Yep, custom allocator
again) ignoring the 1M limit.
While the generic btrfs_alloc_chunk() is completely fine.

The fix to mkfs.btrfs can arrive very soon.

This also reminds me about the long forgot project to get rid of such
SINGLE temporary chunks (not allocating them at all) and allocate them
in native profile at the very beginning of mkfs.btrfs.

Thanks,
Qu

>=20
> So temporary (profile SINGLE) chunks can still using that reserved 1M,
> while normally such chunks get removed so reserved 1M will not be used,=

> but if we specified -m single, such chunks will just be used as is.
>=20
> And such behavior makes unallocated space calculation pretty nasty.
>=20
>>  		 */
>> -		skip_space =3D SZ_1M;
>> -
>> -		/*
>> -		 * we can use the free space in [0, skip_space - 1], subtract
>> -		 * it from the total.
>> -		 */
>> -		if (avail_space && avail_space >=3D skip_space)
>> -			avail_space -=3D skip_space;
>> -		else
>> -			avail_space =3D 0;
>> +		if (device->devid !=3D 1 ||
>> +		    (!sys_chunk_single && device->devid =3D=3D 1)) {
>> +			if (avail_space && avail_space >=3D SZ_1M)
>> +				avail_space -=3D SZ_1M;
>> +			else
>> +				avail_space =3D 0;
>> +		}
>=20
> Due to above reason, using system chunk profile and devid to check if w=
e
> need to reduce 1M is not reliable.
>=20
> That system chunk can be relocated by balance, and in that case new
> chunk may start beyond 1M.
>=20
> So the most reliable method would be manually checking the the first
> device extent of this device, and to determine if we should minus that =
1M.
>=20
> If the first device extent starts beyond 1M, reducing 1M would be good.=

> Or don't modify it.
>=20
> Thanks,
> Qu
>=20
>> =20
>>  		if (avail_space < min_stripe_size)
>>  			continue;
>>
>=20


--nr3GWTR9B794wLQZcQaXcUeGCjrC7V9Bx--

--HIKXToMJA54n9wKZOVFuC0oCzEoZRAwus
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpVcUUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgmxQf/VvasdxjDAtBl6SnQNNeRvOil
FOg5q1gLZmHyRjxHDFL5ICsicHT+/aEFu5MdLD56ouNs0FM8sD0lj36ubjlJ6AFK
2h7bIxkz9GYkfZ71sXt+M0jimrbDBCkxfypIPgjZQdyWvwuhsjH49h0w4iiXJdUL
G7uZpfoZKSRIwHC//uz5SftOf4D5GqBf2TlEup2PY8eBsdm0bR8WFSTGgdPr2SEW
URtmVpda9B5jsrvlYJjojxyKku6d3/xQUv50sCEhqG4D40J1ngVRROAWh8b8/e7+
6UdimT8Tagsm5/mS/Y/jjeVxSdvdy9IxERw0hg8+YVpSZaA1d9o7WSwD619wlg==
=F+It
-----END PGP SIGNATURE-----

--HIKXToMJA54n9wKZOVFuC0oCzEoZRAwus--
