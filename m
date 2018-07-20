Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:46353 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730798AbeGTNFM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 09:05:12 -0400
Subject: Re: [PATCH v2] btrfs: fix bug of chunk type check
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1532081841-2301-1-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <626c50a2-d85c-0ea8-9ca0-901b0494cc94@gmx.com>
Date: Fri, 20 Jul 2018 20:17:05 +0800
MIME-Version: 1.0
In-Reply-To: <1532081841-2301-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tjMdxMH79XoLc1TeMLGydqZ6WoBJcaFrT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tjMdxMH79XoLc1TeMLGydqZ6WoBJcaFrT
Content-Type: multipart/mixed; boundary="EtCSCTysGoqShSHwqQOVsoPoaHck1X3qz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <626c50a2-d85c-0ea8-9ca0-901b0494cc94@gmx.com>
Subject: Re: [PATCH v2] btrfs: fix bug of chunk type check
References: <1532081841-2301-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1532081841-2301-1-git-send-email-gujx@cn.fujitsu.com>

--EtCSCTysGoqShSHwqQOVsoPoaHck1X3qz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8820=E6=97=A5 18:17, Gu Jinxiang wrote:
> chunk type BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_DATA
> should not be set in a non-mixed chunk at the same time.
>=20
> Since BTRFS_BLOCK_GROUP_METADATA is 0x4 and BTRFS_BLOCK_GROUP_DATA is 0=
x1,
> BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA will be 0x0,
> so we should judge type is one of them separately.
>=20
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changelog:
>  v2: As comment by Qu, change the print format of bit from %llu to 0x%l=
lx.
>=20
>  fs/btrfs/volumes.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3f2f01ad9356..d61c604b280c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6360,7 +6360,7 @@ static int btrfs_check_chunk_valid(struct btrfs_f=
s_info *fs_info,
>  	}
>  	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &=

>  	    type) {
> -		btrfs_err(fs_info, "unrecognized chunk type: %llu",
> +		btrfs_err(fs_info, "unrecognized chunk type: 0x%llx",
>  			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
>  			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
>  			  btrfs_chunk_type(leaf, chunk));
> @@ -6368,14 +6368,14 @@ static int btrfs_check_chunk_valid(struct btrfs=
_fs_info *fs_info,
>  	}
> =20
>  	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) =3D=3D 0) {
> -		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
> +		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
>  		return -EIO;
>  	}
> =20
>  	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
>  	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {=

>  		btrfs_err(fs_info,
> -			"system chunk with data or metadata type: %llu", type);
> +		"system chunk with data or metadata type: 0x%llx", type);
>  		return -EIO;
>  	}
> =20
> @@ -6384,10 +6384,10 @@ static int btrfs_check_chunk_valid(struct btrfs=
_fs_info *fs_info,
>  		mixed =3D 1;
> =20
>  	if (!mixed) {
> -		if (type &
> -		    (BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
> +		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
> +			(type & BTRFS_BLOCK_GROUP_DATA)) {
>  			btrfs_err(fs_info,
> -			"mixed chunk type in non-mixed mode: %llu", type);
> +			"mixed chunk type in non-mixed mode: 0x%llx", type);
>  			return -EIO;
>  		}
>  	}
> @@ -6400,7 +6400,7 @@ static int btrfs_check_chunk_valid(struct btrfs_f=
s_info *fs_info,
>  	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) =3D=3D 0 &&
>  	     num_stripes !=3D 1)) {
>  		btrfs_err(fs_info,
> -			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
> +			"invalid num_stripes:sub_stripes %u:%u for profile 0x%llx",
>  			num_stripes, sub_stripes,
>  			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
>  		return -EIO;
>=20


--EtCSCTysGoqShSHwqQOVsoPoaHck1X3qz--

--tjMdxMH79XoLc1TeMLGydqZ6WoBJcaFrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltR0sEACgkQwj2R86El
/qiIFQgAp+4XmZQnDIuHySPASOGB5vDWORRTjx13YpL5+9Pt4I13/jNTWrQTH1cT
HY7kdxUzSr12sAI4uyXsQyRfV4Vy6bvV9yw4B+w3xtEhfqEM0aTNIdCBMRulnioN
w7Pw+fScPzgg13IeEOa/ESAfqrqXL8cB+RnIk1S5L8m/+urZFF5+LhtIOIBJzEFT
v3glHiwGhoETTsQpKJ8zkeUXTaSkrZqFzORPeA/8BYHRPctFwv+3EREThIc4Qeer
AvB8JGriNdmHH82hc38sxKxtv8/W27fvClTTkzXXHO8wWOzQadjYdVsqPh/DXPBh
FIORv0JnsOSra7PVbBTCziSx+PrvNA==
=0btS
-----END PGP SIGNATURE-----

--tjMdxMH79XoLc1TeMLGydqZ6WoBJcaFrT--
