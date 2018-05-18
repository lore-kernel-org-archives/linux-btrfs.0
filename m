Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56215 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERFWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:22:24 -0400
Subject: Re: [PATCH v2 2/6] Btrfs: use more straightforward
 extent_buffer_uptodate
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-3-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dc89782c-b9d2-cd1c-4e5e-a308dd647962@gmx.com>
Date: Fri, 18 May 2018 13:17:16 +0800
MIME-Version: 1.0
In-Reply-To: <1526612424-97061-3-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RF67xrp0LXih1SPa5BvCnuXdMLxar9Rew"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RF67xrp0LXih1SPa5BvCnuXdMLxar9Rew
Content-Type: multipart/mixed; boundary="rqtwhRvBbaJEDYAZhAkNkfVY7Oe15QPCC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <dc89782c-b9d2-cd1c-4e5e-a308dd647962@gmx.com>
Subject: Re: [PATCH v2 2/6] Btrfs: use more straightforward
 extent_buffer_uptodate
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-3-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-3-git-send-email-bo.liu@linux.alibaba.com>

--rqtwhRvBbaJEDYAZhAkNkfVY7Oe15QPCC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 11:00, Liu Bo wrote:
> If parent_transid "0" is passed to btrfs_buffer_uptodate(),
> btrfs_buffer_uptodate() is equivalent to extent_buffer_uptodate(), but
> extent_buffer_uptodate() is preferred since we don't have to look into
> verify_parent_transid().
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And considering how little extra work we do in btrfs_buffer_uptodate(),
what about make it an inline function?

Thanks,
Qu

> ---
>  fs/btrfs/ctree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 9fa3d77c98d4..a96d308c51b8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2445,7 +2445,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_p=
ath *path, int level)
>  		 * and give up so that our caller doesn't loop forever
>  		 * on our EAGAINs.
>  		 */
> -		if (!btrfs_buffer_uptodate(tmp, 0, 0))
> +		if (!extent_buffer_uptodate(tmp))
>  			ret =3D -EIO;
>  		free_extent_buffer(tmp);
>  	} else {
>=20


--rqtwhRvBbaJEDYAZhAkNkfVY7Oe15QPCC--

--RF67xrp0LXih1SPa5BvCnuXdMLxar9Rew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+YdwACgkQwj2R86El
/qjsNggAl4n3eb3d6S3j9p/zfSnmmCLqvY6vZfAEdhBjBXQGuqmIaEv74zE8IEo3
WNGEJUeMPf4DlVvYuo1rphm1Qqnj91c40mBY/DUkYvTlWubsDQrfaKeOBHhUEL1w
tbjNyPmmgx/RmlmFluiShocGJsiBPXN0j3FjggC/5PhQC5QNY6w2Kp1QharS6Qyg
TIKMAflLiqKtsAFJCoXn/LR7K5hPDnLg6v9Z31sVuiwj/DmNbum++6j4J71k0kHf
fV6zOk+Ndh6UrrqFbQTwPbaYfQmvJExVtvHSX1Xr8thXunvW116Fh1eKI8emY84g
oj1WandxCUNcn+aUhIGaPFctNVhBGA==
=V3S8
-----END PGP SIGNATURE-----

--RF67xrp0LXih1SPa5BvCnuXdMLxar9Rew--
