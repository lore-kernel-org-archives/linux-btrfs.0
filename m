Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:47406 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbcBZFlg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 00:41:36 -0500
Date: Fri, 26 Feb 2016 10:41:31 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs: Continue write in case of can_not_nocow
Message-ID: <20160226104131.21d98d57@natsu>
In-Reply-To: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
References: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9h7AQ5XnD=GEwEm.WqcSdJm"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/9h7AQ5XnD=GEwEm.WqcSdJm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Jan 2016 19:00:17 +0800
Zhao Lei <zhaolei@cn.fujitsu.com> wrote:

> btrfs failed in xfstests btrfs/080 with -o nodatacow.
>=20
> Can be reproduced by following script:
>   DEV=3D/dev/vdg
>   MNT=3D/mnt/tmp
>=20
>   umount $DEV &>/dev/null
>   mkfs.btrfs -f $DEV
>   mount -o nodatacow $DEV $MNT
>=20
>   dd if=3D/dev/zero of=3D$MNT/test bs=3D1 count=3D2048 &
>   btrfs subvolume snapshot -r $MNT $MNT/test_snap &
>   wait
>   --
>   We can see dd failed on NO_SPACE.
>=20
> Reason:
>   __btrfs_buffered_write should run cow write when no_cow impossible,
>   and current code is designed with above logic.
>   But check_can_nocow() have 2 type of return value(0 and <0) on
>   can_not_no_cow, and current code only continue write on first case,
>   the second case happened in doing subvolume.
>=20
> Fix:
>   Continue write when check_can_nocow() return 0 and <0.
>=20
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Guys please don't forget about this patch. It solves real problem for peopl=
e,
http://www.spinics.net/lists/linux-btrfs/msg51276.html
http://www.spinics.net/lists/linux-btrfs/msg51819.html
but it's not in 4.4.1, not in 4.4.2... and now not in 4.4.3

> ---
>  fs/btrfs/file.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 977e715..11fd981 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1516,27 +1516,24 @@ static noinline ssize_t __btrfs_buffered_write(st=
ruct file *file,
> =20
>  		reserve_bytes =3D num_pages << PAGE_CACHE_SHIFT;
> =20
> -		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> -					     BTRFS_INODE_PREALLOC)) {
> -			ret =3D check_can_nocow(inode, pos, &write_bytes);
> -			if (ret < 0)
> -				break;
> -			if (ret > 0) {
> -				/*
> -				 * For nodata cow case, no need to reserve
> -				 * data space.
> -				 */
> -				only_release_metadata =3D true;
> -				/*
> -				 * our prealloc extent may be smaller than
> -				 * write_bytes, so scale down.
> -				 */
> -				num_pages =3D DIV_ROUND_UP(write_bytes + offset,
> -							 PAGE_CACHE_SIZE);
> -				reserve_bytes =3D num_pages << PAGE_CACHE_SHIFT;
> -				goto reserve_metadata;
> -			}
> +		if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> +					      BTRFS_INODE_PREALLOC)) &&
> +		    check_can_nocow(inode, pos, &write_bytes) > 0) {
> +			/*
> +			 * For nodata cow case, no need to reserve
> +			 * data space.
> +			 */
> +			only_release_metadata =3D true;
> +			/*
> +			 * our prealloc extent may be smaller than
> +			 * write_bytes, so scale down.
> +			 */
> +			num_pages =3D DIV_ROUND_UP(write_bytes + offset,
> +						 PAGE_CACHE_SIZE);
> +			reserve_bytes =3D num_pages << PAGE_CACHE_SHIFT;
> +			goto reserve_metadata;
>  		}
> +
>  		ret =3D btrfs_check_data_free_space(inode, pos, write_bytes);
>  		if (ret < 0)
>  			break;


--=20
With respect,
Roman

--Sig_/9h7AQ5XnD=GEwEm.WqcSdJm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlbP5YsACgkQTLKSvz+PZwgUqACfe0p/2hQQIUfQtPjZtpnlEyqH
vkUAn35KhYUwH43a2JhVhP48/DFTeQJX
=s/2o
-----END PGP SIGNATURE-----

--Sig_/9h7AQ5XnD=GEwEm.WqcSdJm--
