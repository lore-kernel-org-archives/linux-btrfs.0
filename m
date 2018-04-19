Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58181 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751325AbeDSKcq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 06:32:46 -0400
Subject: Re: [PATCH 3/3] btrfs: Do super block verification before writing it
 to disk
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-3-wqu@suse.com> <20180419101651.GZ21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <454cdaee-d9ec-b427-f08d-aa0310ffe29a@gmx.com>
Date: Thu, 19 Apr 2018 18:32:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180419101651.GZ21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="z2gDaTOtNhFEmQwKdj0ci5RdNLl80ofMG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z2gDaTOtNhFEmQwKdj0ci5RdNLl80ofMG
Content-Type: multipart/mixed; boundary="QI5aa5ZaoB7SYR6ZjzSfbYg4BKfJObFYt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <454cdaee-d9ec-b427-f08d-aa0310ffe29a@gmx.com>
Subject: Re: [PATCH 3/3] btrfs: Do super block verification before writing it
 to disk
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-3-wqu@suse.com> <20180419101651.GZ21272@twin.jikos.cz>
In-Reply-To: <20180419101651.GZ21272@twin.jikos.cz>

--QI5aa5ZaoB7SYR6ZjzSfbYg4BKfJObFYt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8819=E6=97=A5 18:16, David Sterba wrote:
> Looks good, some minor comments below. I'm wondering how to test that.

Currently I'm using the most stupid way to test it, insert code randomly
modifies super blocks.

> We'd have to inject either the corruption or to provide a way to
> forcibly fail the test. For the latter a debugfs should do, I'll send
> something for comments.

What about a sysfs interface to modify super blocks?
Since we already have sectorsize and nodessize, allow it to be writeable
for CONFIG_BTRFS_DEBUG looks pretty good.

Thanks,
Qu

>=20
> On Thu, Apr 19, 2018 at 05:38:16PM +0800, Qu Wenruo wrote:
>> @@ -3563,6 +3565,12 @@ int write_all_supers(struct btrfs_fs_info *fs_i=
nfo, int max_mirrors)
>>  	sb =3D fs_info->super_for_commit;
>>  	dev_item =3D &sb->dev_item;
>> =20
>> +	if (btrfs_check_super_valid(fs_info, sb, -1)) {
>=20
> A comment that this is skipping the bytenr check would be good.
>=20
>> +		btrfs_err(fs_info,
>> +		"superblock corruption detected before transaction commitment");
>=20
>                                                                    comm=
it
>=20
>=20
>> +		return -EUCLEAN;
>> +	}
>> +
>>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>>  	head =3D &fs_info->fs_devices->devices;
>>  	max_errors =3D btrfs_super_num_devices(fs_info->super_copy) - 1;
>> @@ -3974,9 +3982,18 @@ int btrfs_read_buffer(struct extent_buffer *buf=
, u64 parent_transid, int level,
>>  					      level, first_key);
>>  }
>> =20
>> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>> +/*
>> + * Check the validation of btrfs super block.
>> + *
>> + * @sb:			super block to check
>> + * @super_mirror:	the super block number to check its bytenr.
>> + * 			0 means the primary (1st) sb, 1 and 2 means 2nd and
>> + * 			3rd backup sb, while -1 means to skip bytenr check.
>> + */
>> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>> +				   struct btrfs_super_block *sb,
>> +				   int super_mirror)
>>  {
>> -	struct btrfs_super_block *sb =3D fs_info->super_copy;
>>  	u64 nodesize =3D btrfs_super_nodesize(sb);
>>  	u64 sectorsize =3D btrfs_super_sectorsize(sb);
>>  	int ret =3D 0;
>> @@ -4019,7 +4036,7 @@ static int btrfs_check_super_valid(struct btrfs_=
fs_info *fs_info)
>>  	 * Check sectorsize and nodesize first, other check will need it.
>>  	 * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
>>  	 */
>> -	if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
>> +	if (!is_power_of_2(sectorsize) || sectorsize < SZ_4K ||
>=20
> No unrelated changes please. There are some remaining raw values, send =
a
> separate patch if you want to convert them.
>=20
>>  	    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>>  		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
>>  		ret =3D -EINVAL;
>> @@ -4088,9 +4105,10 @@ static int btrfs_check_super_valid(struct btrfs=
_fs_info *fs_info)
>>  		ret =3D -EINVAL;
>>  	}
>> =20
>> -	if (btrfs_super_bytenr(sb) !=3D BTRFS_SUPER_INFO_OFFSET) {
>> -		btrfs_err(fs_info, "super offset mismatch %llu !=3D %u",
>> -			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>> +	if (super_mirror >=3D 0 && btrfs_super_bytenr(sb) !=3D
>> +	    btrfs_sb_offset(super_mirror)) {
>> +		btrfs_err(fs_info, "super offset mismatch %llu !=3D %llu",
>> +			btrfs_super_bytenr(sb), btrfs_sb_offset(super_mirror));
>>  		ret =3D -EINVAL;
>>  	}
>> =20
>> --=20
>> 2.17.0
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


--QI5aa5ZaoB7SYR6ZjzSfbYg4BKfJObFYt--

--z2gDaTOtNhFEmQwKdj0ci5RdNLl80ofMG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrYcEEACgkQwj2R86El
/qiDeAgArofL/9XKxyuCE9kSUzRdiWbCClI+rkaom8JhWAz60WnTgyZb5x4e5nHX
5kKXXTgZx8YIz4gOZ1YTLhpbeXkwleYL9hDOnSSQv4O0OFKkRvAgjm8CC0tpnwUw
VYVIpdc4uo5tUHN+lsIlQhd+Chs4gx1MEVhpUon4YVhpKvIUzSgatpoPdkkE37E1
0kWNiBT4elF8ty10XgfoPaMvxR9+/OGaGCnnJZf/01xnYujn5An9w4Cs6kge6TZ9
WK5DDSkiDnfWDfKRAHxHs2jVGTY+P9RfKOWXbqKishtB/9lYyXMR/H6gyixxARfZ
9QkGFRffdmQGXUx8LGDFgZwu7iyGlg==
=3KXW
-----END PGP SIGNATURE-----

--z2gDaTOtNhFEmQwKdj0ci5RdNLl80ofMG--
