Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58761 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbeDYHfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 03:35:45 -0400
Subject: Re: [PATCH] btrfs: kill btrfs_raid_type_names[]
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180425072608.25445-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5ccee7aa-acd8-3274-777c-cf48d26fc4f5@gmx.com>
Date: Wed, 25 Apr 2018 15:35:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180425072608.25445-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zhWoyyWoBrv8BSyUznEAoPblgpaOSJGnH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zhWoyyWoBrv8BSyUznEAoPblgpaOSJGnH
Content-Type: multipart/mixed; boundary="xXrTixFlRpegYnte9TQOXctO3d1ZeY13Z";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <5ccee7aa-acd8-3274-777c-cf48d26fc4f5@gmx.com>
Subject: Re: [PATCH] btrfs: kill btrfs_raid_type_names[]
References: <20180425072608.25445-1-anand.jain@oracle.com>
In-Reply-To: <20180425072608.25445-1-anand.jain@oracle.com>

--xXrTixFlRpegYnte9TQOXctO3d1ZeY13Z
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8825=E6=97=A5 15:26, Anand Jain wrote:
> Add a new member struct btrfs_raid_attr::raid_name so that
> btrfs_raid_array[] can maintain the name of the raid type,
> and so we can kill btrfs_raid_type_names[].
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Looks much better than the old way.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  fs/btrfs/extent-tree.c | 18 ------------------
>  fs/btrfs/volumes.c     | 15 +++++++++++++++
>  fs/btrfs/volumes.h     |  3 +++
>  3 files changed, 18 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 90d28a3727c6..4742734a73d7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7338,24 +7338,6 @@ wait_block_group_cache_done(struct btrfs_block_g=
roup_cache *cache)
>  	return ret;
>  }
> =20
> -static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] =3D {
> -	[BTRFS_RAID_RAID10]	=3D "raid10",
> -	[BTRFS_RAID_RAID1]	=3D "raid1",
> -	[BTRFS_RAID_DUP]	=3D "dup",
> -	[BTRFS_RAID_RAID0]	=3D "raid0",
> -	[BTRFS_RAID_SINGLE]	=3D "single",
> -	[BTRFS_RAID_RAID5]	=3D "raid5",
> -	[BTRFS_RAID_RAID6]	=3D "raid6",
> -};
> -
> -static const char *get_raid_name(enum btrfs_raid_types type)
> -{
> -	if (type >=3D BTRFS_NR_RAID_TYPES)
> -		return NULL;
> -
> -	return btrfs_raid_type_names[type];
> -}
> -
>  enum btrfs_loop_type {
>  	LOOP_CACHING_NOWAIT =3D 0,
>  	LOOP_CACHING_WAIT =3D 1,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9c29fdca9075..04b8d602dc08 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -52,6 +52,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_N=
R_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 1,
>  		.devs_increment	=3D 2,
>  		.ncopies	=3D 2,
> +		.raid_name	=3D"raid10",
>  	},
>  	[BTRFS_RAID_RAID1] =3D {
>  		.sub_stripes	=3D 1,
> @@ -61,6 +62,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_N=
R_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 1,
>  		.devs_increment	=3D 2,
>  		.ncopies	=3D 2,
> +		.raid_name	=3D"raid1",
>  	},
>  	[BTRFS_RAID_DUP] =3D {
>  		.sub_stripes	=3D 1,
> @@ -70,6 +72,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_N=
R_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 0,
>  		.devs_increment	=3D 1,
>  		.ncopies	=3D 2,
> +		.raid_name	=3D"dup",
>  	},
>  	[BTRFS_RAID_RAID0] =3D {
>  		.sub_stripes	=3D 1,
> @@ -79,6 +82,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_N=
R_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 0,
>  		.devs_increment	=3D 1,
>  		.ncopies	=3D 1,
> +		.raid_name	=3D"raid0",
>  	},
>  	[BTRFS_RAID_SINGLE] =3D {
>  		.sub_stripes	=3D 1,
> @@ -88,6 +92,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_N=
R_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 0,
>  		.devs_increment	=3D 1,
>  		.ncopies	=3D 1,
> +		.raid_name	=3D"single",
>  	},
>  	[BTRFS_RAID_RAID5] =3D {
>  		.sub_stripes	=3D 1,
> @@ -97,6 +102,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_=
NR_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 1,
>  		.devs_increment	=3D 1,
>  		.ncopies	=3D 2,
> +		.raid_name	=3D"raid5",
>  	},
>  	[BTRFS_RAID_RAID6] =3D {
>  		.sub_stripes	=3D 1,
> @@ -106,9 +112,18 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRF=
S_NR_RAID_TYPES] =3D {
>  		.tolerated_failures =3D 2,
>  		.devs_increment	=3D 1,
>  		.ncopies	=3D 3,
> +		.raid_name	=3D"raid6",
>  	},
>  };
> =20
> +const char *get_raid_name(enum btrfs_raid_types type)
> +{
> +	if (type >=3D BTRFS_NR_RAID_TYPES)
> +		return NULL;
> +
> +	return btrfs_raid_array[type].raid_name;
> +}
> +
>  const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES] =3D {
>  	[BTRFS_RAID_RAID10] =3D BTRFS_BLOCK_GROUP_RAID10,
>  	[BTRFS_RAID_RAID1]  =3D BTRFS_BLOCK_GROUP_RAID1,
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ef220d541d4b..2acd32ce1573 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -342,6 +342,7 @@ struct btrfs_raid_attr {
>  	int tolerated_failures; /* max tolerated fail devs */
>  	int devs_increment;	/* ndevs has to be a multiple of this */
>  	int ncopies;		/* how many copies to data has */
> +	char *raid_name;	/* name of the raid */
>  };
> =20
>  extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYP=
ES];
> @@ -563,6 +564,8 @@ static inline enum btrfs_raid_types btrfs_bg_flags_=
to_raid_index(u64 flags)
>  	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
>  }
> =20
> +const char *get_raid_name(enum btrfs_raid_types type);
> +
>  void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
>  void btrfs_update_commit_device_bytes_used(struct btrfs_transaction *t=
rans);
> =20
>=20


--xXrTixFlRpegYnte9TQOXctO3d1ZeY13Z--

--zhWoyyWoBrv8BSyUznEAoPblgpaOSJGnH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrgL7sACgkQwj2R86El
/qjmewf/SuTFKufAIoXgkrz4b14fOu35QBAakuo8K+y5qiKpYdGLmDNcRfy7z2le
Ex30Db3PXnKzd/d5duS6k5ValHJoxCQYh3fsKwW2b5qacKsD7QKh173mrNatKdvX
nQl3r4q3ZeJIwC4EUTAr6sHmx2HHlGzE37/ENHfeAHef08FQO7BBp/0iua9CJoIv
qOEWGPUhH2HXXeyAQqX2oUpqOz/ZM2P67iTEguYmLJ+xTAs3PpIRy7VJtKdtbVvN
bZtOp2ziiZhn/mJ53syNUVdpzQK2RFNwTbg97dm+4O9yNLdgnVj5VL3fPMOLQNgA
4uUw5CrT1E1cjqB9Ol7HsPn3F2JW5w==
=7qDj
-----END PGP SIGNATURE-----

--zhWoyyWoBrv8BSyUznEAoPblgpaOSJGnH--
