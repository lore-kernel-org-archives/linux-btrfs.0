Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34700 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752000AbbF0Vob (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 17:44:31 -0400
Date: Sat, 27 Jun 2015 17:44:28 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: don't update mtime on deduped inodes
Message-ID: <20150627214427.GC14931@hungrycats.org>
References: <1435352461-17689-1-git-send-email-mfasheh@suse.de>
 <1435352461-17689-6-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
In-Reply-To: <1435352461-17689-6-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2015 at 02:01:01PM -0700, Mark Fasheh wrote:
> One issue users have reported is that dedupe changes mtime on files,
> resulting in tools like rsync thinking that their contents have changed w=
hen
> in fact the data is exactly the same. Clone still wants an mtime change, =
so
> we special case this in the code.
>=20
> This was tested with the btrfs-extent-same tool.
>=20
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/ioctl.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 83f4679..0af0f13 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -87,7 +87,8 @@ struct btrfs_ioctl_received_subvol_args_32 {
> =20
> =20
>  static int btrfs_clone(struct inode *src, struct inode *inode,
> -		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> +		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
> +		       int no_mtime);
> =20
>  /* Mask out flags that are inappropriate for the given type of inode. */
>  static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
> @@ -3054,7 +3055,7 @@ static int btrfs_extent_same(struct inode *src, u64=
 loff, u64 olen,
>  	/* pass original length for comparison so we stay within i_size */
>  	ret =3D btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
>  	if (ret =3D=3D 0)
> -		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff);
> +		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> =20
>  	if (same_inode)
>  		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> @@ -3219,13 +3220,17 @@ static int clone_finish_inode_update(struct btrfs=
_trans_handle *trans,
>  				     struct inode *inode,
>  				     u64 endoff,
>  				     const u64 destoff,
> -				     const u64 olen)
> +				     const u64 olen,
> +				     int no_mtime)
>  {
>  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
>  	int ret;
> =20
>  	inode_inc_iversion(inode);
> -	inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
> +	if (no_mtime)
> +		inode->i_ctime =3D CURRENT_TIME;

I don't see a good reason to modify the ctime either.  Again, nothing
is changing here.  All we are doing is shuffling physical storage around.

Defrag and balance (which also move physical extents around) don't
touch ctime, mtime, or even atime.

> +	else
> +		inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
>  	/*
>  	 * We round up to the block size at eof when determining which
>  	 * extents to clone above, but shouldn't round up the file size.
> @@ -3310,13 +3315,13 @@ static void clone_update_extent_map(struct inode =
*inode,
>   * @inode: Inode to clone to
>   * @off: Offset within source to start clone from
>   * @olen: Original length, passed by user, of range to clone
> - * @olen_aligned: Block-aligned value of olen, extent_same uses
> - *               identical values here
> + * @olen_aligned: Block-aligned value of olen
>   * @destoff: Offset within @inode to start clone
> + * @no_mtime: Whether to update mtime on the target inode
>   */
>  static int btrfs_clone(struct inode *src, struct inode *inode,
>  		       const u64 off, const u64 olen, const u64 olen_aligned,
> -		       const u64 destoff)
> +		       const u64 destoff, int no_mtime)
>  {
>  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
>  	struct btrfs_path *path =3D NULL;
> @@ -3640,7 +3645,7 @@ process_slot:
>  					      root->sectorsize);
>  			ret =3D clone_finish_inode_update(trans, inode,
>  							last_dest_end,
> -							destoff, olen);
> +							destoff, olen, no_mtime);
>  			if (ret)
>  				goto out;
>  			if (new_key.offset + datal >=3D destoff + len)
> @@ -3678,7 +3683,7 @@ process_slot:
>  		clone_update_extent_map(inode, trans, NULL, last_dest_end,
>  					destoff + len - last_dest_end);
>  		ret =3D clone_finish_inode_update(trans, inode, destoff + len,
> -						destoff, olen);
> +						destoff, olen, no_mtime);
>  	}
> =20
>  out:
> @@ -3808,7 +3813,7 @@ static noinline long btrfs_ioctl_clone(struct file =
*file, unsigned long srcfd,
>  		btrfs_double_extent_lock(src, off, inode, destoff, len);
>  	}
> =20
> -	ret =3D btrfs_clone(src, inode, off, olen, len, destoff);
> +	ret =3D btrfs_clone(src, inode, off, olen, len, destoff, 0);
> =20
>  	if (same_inode) {
>  		u64 lock_start =3D min_t(u64, off, destoff);
> --=20
> 2.1.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWPGTsACgkQgfmLGlazG5wYIACfabxWTT/t0rHfJPCWDNESEP+P
4HEAnA/ovdGxt58Ubp2FWV+BdUVTzZjN
=XLVI
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
