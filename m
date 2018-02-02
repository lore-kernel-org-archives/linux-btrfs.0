Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53799 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750773AbeBBLyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 06:54:06 -0500
Subject: Re: [PATCH 4/7] btrfs-progs: Introduce btrfs_raid_array and related
 infrastructures
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-5-wqu@suse.com>
 <79ec4cb5-e891-73e9-71f6-523b48c4a9c9@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e1b7376c-78a4-3b31-4c56-73843fd71932@gmx.com>
Date: Fri, 2 Feb 2018 19:53:50 +0800
MIME-Version: 1.0
In-Reply-To: <79ec4cb5-e891-73e9-71f6-523b48c4a9c9@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vlM2hUd4pdWdVffnZvnH5VZyU5rIaRfxr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vlM2hUd4pdWdVffnZvnH5VZyU5rIaRfxr
Content-Type: multipart/mixed; boundary="owIbAdDaMRkDwyiWPg846fh1uKmI86fHi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <e1b7376c-78a4-3b31-4c56-73843fd71932@gmx.com>
Subject: Re: [PATCH 4/7] btrfs-progs: Introduce btrfs_raid_array and related
 infrastructures
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-5-wqu@suse.com>
 <79ec4cb5-e891-73e9-71f6-523b48c4a9c9@suse.com>
In-Reply-To: <79ec4cb5-e891-73e9-71f6-523b48c4a9c9@suse.com>

--owIbAdDaMRkDwyiWPg846fh1uKmI86fHi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8802=E6=97=A5 19:37, Nikolay Borisov wrote:
>=20
>=20
> On  2.02.2018 10:19, Qu Wenruo wrote:
>> As part of the effort to unify code and behavior between btrfs-progs a=
nd
>> kernel, copy the btrfs_raid_array from kernel to btrfs-progs.
>>
>> So later we can use the btrfs_raid_array[] to get needed raid info oth=
er
>> than manually do if-else branches.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  ctree.h   | 12 +++++++++++-
>>  volumes.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  volumes.h | 30 +++++++++++++++++++++++++++++
>>  3 files changed, 107 insertions(+), 1 deletion(-)
>>
>> diff --git a/ctree.h b/ctree.h
>> index 17cdac76c58c..c76849d8deb7 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -958,7 +958,17 @@ struct btrfs_csum_item {
>>  #define BTRFS_BLOCK_GROUP_RAID5    	(1ULL << 7)
>>  #define BTRFS_BLOCK_GROUP_RAID6    	(1ULL << 8)
>>  #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
> <not related to this patch but i just saw it>=20
>=20
> BTRFS_BLOCK_GROUP_RESERVED differs in userspace than in kernel space.=20
> The btrfs_Tree header has it defined as:=20
>=20
> #define BTRFS_BLOCK_GROUP_RESERVED      (BTRFS_AVAIL_ALLOC_BIT_SINGLE |=
 \      =20
>                                          BTRFS_SPACE_INFO_GLOBAL_RSV)

Another good place to cleanup. :)

Thanks,
Qu

>=20
>=20
> Otherwise LGTM:=20
>=20
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>=20
>> -#define BTRFS_NR_RAID_TYPES             7
>> +
>> +enum btrfs_raid_types {
>> +	BTRFS_RAID_RAID10,
>> +	BTRFS_RAID_RAID1,
>> +	BTRFS_RAID_DUP,
>> +	BTRFS_RAID_RAID0,
>> +	BTRFS_RAID_SINGLE,
>> +	BTRFS_RAID_RAID5,
>> +	BTRFS_RAID_RAID6,
>> +	BTRFS_NR_RAID_TYPES
>> +};
>> =20
>>  #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
>>  					 BTRFS_BLOCK_GROUP_SYSTEM |  \
>> diff --git a/volumes.c b/volumes.c
>> index a9dc8c939dc5..b47ff1f392b5 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -30,6 +30,72 @@
>>  #include "utils.h"
>>  #include "kernel-lib/raid56.h"
>> =20
>> +const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] =3D=
 {
>> +	[BTRFS_RAID_RAID10] =3D {
>> +		.sub_stripes	=3D 2,
>> +		.dev_stripes	=3D 1,
>> +		.devs_max	=3D 0,	/* 0 =3D=3D as many as possible */
>> +		.devs_min	=3D 4,
>> +		.tolerated_failures =3D 1,
>> +		.devs_increment	=3D 2,
>> +		.ncopies	=3D 2,
>> +	},
>> +	[BTRFS_RAID_RAID1] =3D {
>> +		.sub_stripes	=3D 1,
>> +		.dev_stripes	=3D 1,
>> +		.devs_max	=3D 2,
>> +		.devs_min	=3D 2,
>> +		.tolerated_failures =3D 1,
>> +		.devs_increment	=3D 2,
>> +		.ncopies	=3D 2,
>> +	},
>> +	[BTRFS_RAID_DUP] =3D {
>> +		.sub_stripes	=3D 1,
>> +		.dev_stripes	=3D 2,
>> +		.devs_max	=3D 1,
>> +		.devs_min	=3D 1,
>> +		.tolerated_failures =3D 0,
>> +		.devs_increment	=3D 1,
>> +		.ncopies	=3D 2,
>> +	},
>> +	[BTRFS_RAID_RAID0] =3D {
>> +		.sub_stripes	=3D 1,
>> +		.dev_stripes	=3D 1,
>> +		.devs_max	=3D 0,
>> +		.devs_min	=3D 2,
>> +		.tolerated_failures =3D 0,
>> +		.devs_increment	=3D 1,
>> +		.ncopies	=3D 1,
>> +	},
>> +	[BTRFS_RAID_SINGLE] =3D {
>> +		.sub_stripes	=3D 1,
>> +		.dev_stripes	=3D 1,
>> +		.devs_max	=3D 1,
>> +		.devs_min	=3D 1,
>> +		.tolerated_failures =3D 0,
>> +		.devs_increment	=3D 1,
>> +		.ncopies	=3D 1,
>> +	},
>> +	[BTRFS_RAID_RAID5] =3D {
>> +		.sub_stripes	=3D 1,
>> +		.dev_stripes	=3D 1,
>> +		.devs_max	=3D 0,
>> +		.devs_min	=3D 2,
>> +		.tolerated_failures =3D 1,
>> +		.devs_increment	=3D 1,
>> +		.ncopies	=3D 2,
>> +	},
>> +	[BTRFS_RAID_RAID6] =3D {
>> +		.sub_stripes	=3D 1,
>> +		.dev_stripes	=3D 1,
>> +		.devs_max	=3D 0,
>> +		.devs_min	=3D 3,
>> +		.tolerated_failures =3D 2,
>> +		.devs_increment	=3D 1,
>> +		.ncopies	=3D 3,
>> +	},
>> +};
>> +
>>  struct stripe {
>>  	struct btrfs_device *dev;
>>  	u64 physical;
>> diff --git a/volumes.h b/volumes.h
>> index 7bbdf615d31a..612a0a7586f4 100644
>> --- a/volumes.h
>> +++ b/volumes.h
>> @@ -108,6 +108,36 @@ struct map_lookup {
>>  	struct btrfs_bio_stripe stripes[];
>>  };
>> =20
>> +struct btrfs_raid_attr {
>> +	int sub_stripes;	/* sub_stripes info for map */
>> +	int dev_stripes;	/* stripes per dev */
>> +	int devs_max;		/* max devs to use */
>> +	int devs_min;		/* min devs needed */
>> +	int tolerated_failures; /* max tolerated fail devs */
>> +	int devs_increment;	/* ndevs has to be a multiple of this */
>> +	int ncopies;		/* how many copies to data has */
>> +};
>> +
>> +extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TY=
PES];
>> +
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
>>  #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
>>  			    (sizeof(struct btrfs_bio_stripe) * (n)))
>>  #define btrfs_map_lookup_size(n) (sizeof(struct map_lookup) + \
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--owIbAdDaMRkDwyiWPg846fh1uKmI86fHi--

--vlM2hUd4pdWdVffnZvnH5VZyU5rIaRfxr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp0UU4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhKHwgAkXyCwPhAsnUbjji8tK0ucWYH
qmK1XvXAlgYXz5p4foyrGEQIfMMdoBE7xRxBWON3lKZW66ijMSyxA/fVTNCiIoxs
5QjbQ6yYk1FhVv5v4treR7vcgpQdjqt+woD5IjAmuJAO/53hP7NKnoUABUt0F9Ig
kadgpUEYfOu/tvAVcii7eELGLoe8cXUzhDJvYEecjkr3rRdRVnyL1/hT6RYf+jaI
pW3LDDYQeVPHurWAqch0h1gQsUehopiUwQieUKJAPtakwDJbZbMkFr1mkMhuW1/G
QBXG5ccYTR504E98t8dD6NpeXNTJWKJ/nVNlBDb2gqY2xt6JdRzcTLGk0YN48Q==
=yx+N
-----END PGP SIGNATURE-----

--vlM2hUd4pdWdVffnZvnH5VZyU5rIaRfxr--
