Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36679 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753625AbbEAPND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 May 2015 11:13:03 -0400
Date: Fri, 1 May 2015 11:13:01 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Matt Robinson <git@nerdoftheherd.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: Align EOF length to block in extent_same
Message-ID: <20150501151301.GA18025@hungrycats.org>
References: <1430071511-6055-1-git-send-email-git@nerdoftheherd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <1430071511-6055-1-git-send-email-git@nerdoftheherd.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 26, 2015 at 07:05:11PM +0100, Matt Robinson wrote:
> It is not currently possible to deduplicate the last block of files
> whose size is not a multiple of the block size, as the btrfs_extent_same
> ioctl returns -EINVAL if offset + size is greater than the file size or
> is not aligned to the fs block size.
>=20
> For example, with the default block size of 16K and two identical
> 1,000,000 byte files, calling the extent_same ioctl with offset 0 and
> length set to 1,000,000 the call fails with -EINVAL.  The same call
> with a length of 999,424 will succeed, but the final 576 bytes can then
> not be shared.  This seems to have a larger impact on the amount of
> space actually freed by the ioctl than would be expected - in my
> testing the amount of space freed was generally reduced by 50-100% for
> files sized from a few megabytes downwards which has a significant
> negative impact on the usefulness of the extent_same ioctl in some
> circumstances.
>=20
> To resolve this, this patch allows unaligned offset + length values to
> be passed to btrfs_ioctl_file_extent_same if offset + length is equal
> to the file size of both src and dest.  This is implemented in the same
> way as in btrfs_ioctl_clone.
>=20
> To return to the earlier example 1,000,000 byte file - this patch would
> allow a length of 1,000,000 bytes to be passed as it is equal to the
> file lengths and would be internally extended to the end of the block
> (1,015,808), allowing one set of extents to be shared completely between
> the full length of both files.

I would love to test this, but currently I'm not using extent-same for
deduplication because of the deadlock bug.  :-/

Was there a patch for that bug that I missed?

> Signed-off-by: Matt Robinson <git@nerdoftheherd.com>
> ---
>  fs/btrfs/ioctl.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ca5d968..0588076 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2878,14 +2878,16 @@ static int btrfs_cmp_data(struct inode *src, u64 =
loff, struct inode *dst,
>  	return ret;
>  }
> =20
> -static int extent_same_check_offsets(struct inode *inode, u64 off, u64 l=
en)
> +static int extent_same_check_offsets(struct inode *inode, u64 off, u64 l=
en,
> +				     u64 len_aligned)
>  {
>  	u64 bs =3D BTRFS_I(inode)->root->fs_info->sb->s_blocksize;
> =20
>  	if (off + len > inode->i_size || off + len < off)
>  		return -EINVAL;
> +
>  	/* Check that we are block aligned - btrfs_clone() requires this */
> -	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
> +	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len_aligned, bs))
>  		return -EINVAL;
> =20
>  	return 0;
> @@ -2895,6 +2897,8 @@ static int btrfs_extent_same(struct inode *src, u64=
 loff, u64 len,
>  			     struct inode *dst, u64 dst_loff)
>  {
>  	int ret;
> +	u64 len_aligned =3D len;
> +	u64 bs =3D BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> =20
>  	/*
>  	 * btrfs_clone() can't handle extents in the same file
> @@ -2909,11 +2913,15 @@ static int btrfs_extent_same(struct inode *src, u=
64 loff, u64 len,
> =20
>  	btrfs_double_lock(src, loff, dst, dst_loff, len);
> =20
> -	ret =3D extent_same_check_offsets(src, loff, len);
> +	/* if we extend to both eofs, continue to block boundaries */
> +	if (loff + len =3D=3D src->i_size && dst_loff + len =3D=3D dst->i_size)
> +		len_aligned =3D ALIGN(src->i_size, bs) - loff;
> +
> +	ret =3D extent_same_check_offsets(src, loff, len, len_aligned);
>  	if (ret)
>  		goto out_unlock;
> =20
> -	ret =3D extent_same_check_offsets(dst, dst_loff, len);
> +	ret =3D extent_same_check_offsets(dst, dst_loff, len, len_aligned);
>  	if (ret)
>  		goto out_unlock;
> =20
> @@ -2926,7 +2934,7 @@ static int btrfs_extent_same(struct inode *src, u64=
 loff, u64 len,
> =20
>  	ret =3D btrfs_cmp_data(src, loff, dst, dst_loff, len);
>  	if (ret =3D=3D 0)
> -		ret =3D btrfs_clone(src, dst, loff, len, len, dst_loff);
> +		ret =3D btrfs_clone(src, dst, loff, len, len_aligned, dst_loff);
> =20
>  out_unlock:
>  	btrfs_double_unlock(src, loff, dst, dst_loff, len);
> @@ -3172,8 +3180,7 @@ static void clone_update_extent_map(struct inode *i=
node,
>   * @inode: Inode to clone to
>   * @off: Offset within source to start clone from
>   * @olen: Original length, passed by user, of range to clone
> - * @olen_aligned: Block-aligned value of olen, extent_same uses
> - *               identical values here
> + * @olen_aligned: Block-aligned value of olen
>   * @destoff: Offset within @inode to start clone
>   */
>  static int btrfs_clone(struct inode *src, struct inode *inode,
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVDl/0ACgkQgfmLGlazG5x1cQCfaObUxmY8LfdWaGULljKYM9Co
uPkAoIF7zQ6iZ3GbQX8S2gSFLuCBZT8H
=fCsH
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
