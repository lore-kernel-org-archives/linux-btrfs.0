Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57310 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754998AbeAHISQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 03:18:16 -0500
Subject: Re: [PATCH 1/3] btrfs: fail mount when sb flag is not in
 BTRFS_SUPER_FLAG_SUPP
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-2-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6a45174b-d882-2dce-4729-6e1fcbb2edae@gmx.com>
Date: Mon, 8 Jan 2018 16:17:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180108080421.17668-2-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JnxlJFV0NfdS3SyJsALeHKVJyV3uPWr5c"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JnxlJFV0NfdS3SyJsALeHKVJyV3uPWr5c
Content-Type: multipart/mixed; boundary="o5uPCi0BzhOCBF7HBs2dpkRiyZoNBJPi6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <6a45174b-d882-2dce-4729-6e1fcbb2edae@gmx.com>
Subject: Re: [PATCH 1/3] btrfs: fail mount when sb flag is not in
 BTRFS_SUPER_FLAG_SUPP
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-2-anand.jain@oracle.com>
In-Reply-To: <20180108080421.17668-2-anand.jain@oracle.com>

--o5uPCi0BzhOCBF7HBs2dpkRiyZoNBJPi6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 16:04, Anand Jain wrote:
> It appear from the original commit [1] that there isn't any design
> specific reason not to fail the mount instead of just warning. This
> patch will change it to fail.
>=20
> [1]
>  commit 319e4d0661e5323c9f9945f0f8fb5905e5fe74c3
>     btrfs: Enhance super validation check
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>   cc: wqu@suse.com

The patch itself is good.

But it should be the last patch, to avoid breaking bisect.

With that fixed, feel free to add my tag:

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/disk-io.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a69e5944dc08..b04da740a9a2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3906,9 +3906,11 @@ static int btrfs_check_super_valid(struct btrfs_=
fs_info *fs_info)
>  		btrfs_err(fs_info, "no valid FS found");
>  		ret =3D -EINVAL;
>  	}
> -	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP)
> -		btrfs_warn(fs_info, "unrecognized super flag: %llu",
> +	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
> +		btrfs_err(fs_info, "unrecognized or unsupported super flag: %llu",
>  				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
> +		ret =3D -EINVAL;
> +	}
>  	if (btrfs_super_root_level(sb) >=3D BTRFS_MAX_LEVEL) {
>  		btrfs_err(fs_info, "tree_root level too big: %d >=3D %d",
>  				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
>=20


--o5uPCi0BzhOCBF7HBs2dpkRiyZoNBJPi6--

--JnxlJFV0NfdS3SyJsALeHKVJyV3uPWr5c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpTKTcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiHlwgAqlaIjYVO/J74PVYruaPa4lZD
4BUm/BAeRW4OEZSoyUskAghU6JYgj1sfy1OrXxBDhPyQEndMYWGpgDiIFBfiT+xb
cMxQhuF+rHrIkEuWeK2M5VWlFoqrNmCqvMx2hgJsBNFXy8WgK91OI1ee/3eXDEUj
i9rlmQjqQL48nAA90m3c0ycNB9c0a04Wq2phjrbL65v1SLJZiw9sR+Y1R+MFdy36
HWj3z3PVwBHa098VJsB0ToOwc7mTS7eUOxrBx+dGYYuefXbU8wh+640ydxDn9F3Y
9ga/UdbkB6E598Z2tzepxYjCc0MgbnjJc52ipmOh8tPM0sUqUBLnM4k9yer2Dg==
=k6ak
-----END PGP SIGNATURE-----

--JnxlJFV0NfdS3SyJsALeHKVJyV3uPWr5c--
