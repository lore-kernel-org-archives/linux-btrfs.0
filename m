Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:34440 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbcCRMoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 08:44:08 -0400
Date: Fri, 18 Mar 2016 17:44:03 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix performance regression of writing to
 prealloc/nocow file
Message-ID: <20160318174403.273da4f2@natsu>
In-Reply-To: <1458252975-1349-1-git-send-email-bo.li.liu@oracle.com>
References: <1458252975-1349-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WlY.CEQZ7BTAM/aj4+TVsO9"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/WlY.CEQZ7BTAM/aj4+TVsO9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Mar 2016 15:16:15 -0700
Liu Bo <bo.li.liu@oracle.com> wrote:

> For nocow/prealloc files, we try our best to not allocate space, however,
> this ends up a huge performance regression since it's expensive to check
> if data is shared.
>=20
> Let's go back to only go check shared data once we're not able to allocate
> space.

As mentioned by Holger there's another patch modifying the same function:
https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/f=
s/btrfs?h=3Dintegration-4.6&id=3D4da2e26a2a32b174878744bd0f07db180c875f26
and that one fixes a serious regression in the 4.4 series.
I did not try yours, but could you please ensure that you do not hit the
described problem with your version of the patch, or perhaps even better,
consider re-testing performance and then basing any further performance
optimizations upon a state with no known grave functionality bugs (i.e. with
the above patch applied).

Thanks

> The test was made against a tmpfs backed loop device:
>=20
> xfs_io -f -c "falloc 0 400M" foobar
> xfs_io -c "pwrite -W -b 4096 0 400M" foobar
>=20
> Vanilla:
> wrote 419430400/419430400 bytes at offset 0
> 400 MiB, 102400 ops; 0:00:01.00 (200.015 MiB/sec and 51203.8403 ops/sec)
>=20
> Patched kernel:
> wrote 419430400/419430400 bytes at offset 0
> 400 MiB, 102400 ops; 0:00:01.00 (346.137 MiB/sec and 88610.9796 ops/sec)
>=20
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/file.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 098bb8f..f66c1bc 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1525,16 +1525,12 @@ static noinline ssize_t __btrfs_buffered_write(st=
ruct file *file,
> =20
>  		reserve_bytes =3D num_pages << PAGE_CACHE_SHIFT;
> =20
> -		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> -					     BTRFS_INODE_PREALLOC)) {
> +		ret =3D btrfs_check_data_free_space(inode, pos, write_bytes);
> +		if (ret =3D=3D -ENOSPC &&
> +		    BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> +						     BTRFS_INODE_PREALLOC)) {
>  			ret =3D check_can_nocow(inode, pos, &write_bytes);
> -			if (ret < 0)
> -				break;
>  			if (ret > 0) {
> -				/*
> -				 * For nodata cow case, no need to reserve
> -				 * data space.
> -				 */
>  				only_release_metadata =3D true;
>  				/*
>  				 * our prealloc extent may be smaller than
> @@ -1543,10 +1539,13 @@ static noinline ssize_t __btrfs_buffered_write(st=
ruct file *file,
>  				num_pages =3D DIV_ROUND_UP(write_bytes + offset,
>  							 PAGE_CACHE_SIZE);
>  				reserve_bytes =3D num_pages << PAGE_CACHE_SHIFT;
> +
> +				ret =3D 0;
>  				goto reserve_metadata;
> +			} else {
> +				ret =3D -ENOSPC;
>  			}
>  		}
> -		ret =3D btrfs_check_data_free_space(inode, pos, write_bytes);
>  		if (ret < 0)
>  			break;
> =20


--=20
With respect,
Roman

--Sig_/WlY.CEQZ7BTAM/aj4+TVsO9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbr+BUACgkQTLKSvz+PZwiWAACfSUfuur95zJVZFFjKjbzA3if5
I48Anijj65DHm7z6A7igB7/mzGxfm+b9
=QLBz
-----END PGP SIGNATURE-----

--Sig_/WlY.CEQZ7BTAM/aj4+TVsO9--
