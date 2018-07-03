Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754041AbeGCG16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 02:27:58 -0400
Subject: Re: [PATCH v2] btrfs: Add chunk type check in read a chunk
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: wen.xu@gatech.edu, xuwen.sjtu@gmail.com
References: <1530598800-9174-1-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6b0a3307-1b9a-cdaf-d483-be0530435e73@gmx.com>
Date: Tue, 3 Jul 2018 14:27:43 +0800
MIME-Version: 1.0
In-Reply-To: <1530598800-9174-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AKZJ2ttlEqu0kC25IjcHMc3m40mqNmrcr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AKZJ2ttlEqu0kC25IjcHMc3m40mqNmrcr
Content-Type: multipart/mixed; boundary="SubMPLF6a6TYVRRYJLOmYr0QkQaLoAlz5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: wen.xu@gatech.edu, xuwen.sjtu@gmail.com
Message-ID: <6b0a3307-1b9a-cdaf-d483-be0530435e73@gmx.com>
Subject: Re: [PATCH v2] btrfs: Add chunk type check in read a chunk
References: <1530598800-9174-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1530598800-9174-1-git-send-email-gujx@cn.fujitsu.com>

--SubMPLF6a6TYVRRYJLOmYr0QkQaLoAlz5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8803=E6=97=A5 14:20, Gu Jinxiang wrote:
> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=3D199839,
> which has a invalid chunk, not return error opportunlly.
>=20
> Add chunk type check in btrfs_check_chunk_valid,
> to make error be returned in advance.
>=20
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> changelog:
> v2:
> deal with comment by Qu, add precise check for chunk type.
>=20
>  fs/btrfs/volumes.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..fcdb1a75d653 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6401,6 +6401,8 @@ static int btrfs_check_chunk_valid(struct btrfs_f=
s_info *fs_info,
>  	u16 num_stripes;
>  	u16 sub_stripes;
>  	u64 type;
> +	u64 features;
> +	int mixed =3D 0;
> =20
>  	length =3D btrfs_chunk_length(leaf, chunk);
>  	stripe_len =3D btrfs_chunk_stripe_len(leaf, chunk);
> @@ -6439,6 +6441,31 @@ static int btrfs_check_chunk_valid(struct btrfs_=
fs_info *fs_info,
>  			  btrfs_chunk_type(leaf, chunk));
>  		return -EIO;
>  	}
> +
> +	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
> +		return -EIO;
> +	}
> +
> +	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> +	(type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
> +		btrfs_err(fs_info, "duplicate chunk type flag: %llu", type);
> +		return -EIO;
> +	}
> +
> +	features =3D btrfs_super_incompat_flags(fs_info->super_copy);
> +	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> +		mixed =3D 1;
> +
> +	if (!mixed) {
> +		if (type &
> +		(BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
> +			btrfs_err(fs_info,
> +			"mixed chunk type flag in non-mixed mode: %llu", type);
> +			return -EIO;
> +		}
> +	}
> +
>  	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes !=3D 2) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
>=20


--SubMPLF6a6TYVRRYJLOmYr0QkQaLoAlz5--

--AKZJ2ttlEqu0kC25IjcHMc3m40mqNmrcr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls7F18ACgkQwj2R86El
/qjYzwf/auAs1F2Vl/M69N2i9gn8pBCbuS8fyX+hHkDCJ3lSWJgr8eYEY7Q9cDvs
8zNHtB2LELPprWPxwaOHbiPBgTKmuL/wWHDkU2jCsLmAu38U4KFpvUAFXJFVK/5y
VUwAz8sNjhCIbrUoDjUHPzysqCkfCzQZCQ6v3UY21nTOASkJMxLABF2jQ66OiUP4
LgQwHbCe5EYYGij45CC7WNqeKACRYqBGgQ0z+s6Jt+nVGRl/L6doobIN4GZ6SYdo
s2s9YaXLAfI5taH1vuvPMw2v0IIudgSnCTxfFJl6jmGydYfFpQXyxjzmsnLs1miE
crISn2Cnk34lUKsQoxR+OYcQYexU0A==
=TGIm
-----END PGP SIGNATURE-----

--AKZJ2ttlEqu0kC25IjcHMc3m40mqNmrcr--
