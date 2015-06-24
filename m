Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47846 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752243AbbFXURd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 16:17:33 -0400
Date: Wed, 24 Jun 2015 16:17:32 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add no_mtime flag to btrfs-extent-same
Message-ID: <20150624201732.GA14931@hungrycats.org>
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-6-git-send-email-mfasheh@suse.de>
 <20150623151156.GI6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
In-Reply-To: <20150623151156.GI6761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2015 at 05:11:56PM +0200, David Sterba wrote:
> On Mon, Jun 22, 2015 at 03:47:42PM -0700, Mark Fasheh wrote:
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -87,7 +87,8 @@ struct btrfs_ioctl_received_subvol_args_32 {
> > =20
> > =20
> >  static int btrfs_clone(struct inode *src, struct inode *inode,
> > -		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> > +		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
> > +		       int no_mtime);
>=20
> Please make it 'flags' and pass the verified flags directly.
>=20
> >  /* Mask out flags that are inappropriate for the given type of inode. =
*/
> >  static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
> > @@ -2974,7 +2975,7 @@ static int extent_same_check_offsets(struct inode=
 *inode, u64 off, u64 *plen,
> >  }
> > =20
> >  static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> > -			     struct inode *dst, u64 dst_loff)
> > +			     struct inode *dst, u64 dst_loff, int no_mtime)
> >  {
> >  	int ret;
> >  	u64 len =3D olen;
> > @@ -3054,7 +3055,8 @@ static int btrfs_extent_same(struct inode *src, u=
64 loff, u64 olen,
> >  	/* pass original length for comparison so we stay within i_size */
> >  	ret =3D btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> >  	if (ret =3D=3D 0)
> > -		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff);
> > +		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff,
> > +				  no_mtime);
> > =20
> >  	if (same_inode)
> >  		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> > @@ -3088,6 +3090,7 @@ static long btrfs_ioctl_file_extent_same(struct f=
ile *file,
> >  	u64 bs =3D BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> >  	bool is_admin =3D capable(CAP_SYS_ADMIN);
> >  	u16 count;
> > +	int no_mtime =3D 0;
> > =20
> >  	if (!(file->f_mode & FMODE_READ))
> >  		return -EINVAL;
> > @@ -3139,6 +3142,12 @@ static long btrfs_ioctl_file_extent_same(struct =
file *file,
> >  	if (!S_ISREG(src->i_mode))
> >  		goto out;
> > =20
> > +	ret =3D -EINVAL;
> > +	if (same->flags & ~BTRFS_SAME_FLAGS)
> > +		goto out;
> > +	if (same->flags & BTRFS_SAME_NO_MTIME)
> > +		no_mtime =3D 1;
> > +
> >  	/* pre-format output fields to sane values */
> >  	for (i =3D 0; i < count; i++) {
> >  		same->info[i].bytes_deduped =3D 0ULL;
> > @@ -3164,7 +3173,8 @@ static long btrfs_ioctl_file_extent_same(struct f=
ile *file,
> >  			info->status =3D -EACCES;
> >  		} else {
> >  			info->status =3D btrfs_extent_same(src, off, len, dst,
> > -							info->logical_offset);
> > +							 info->logical_offset,
> > +							 no_mtime);
> >  			if (info->status =3D=3D 0)
> >  				info->bytes_deduped +=3D len;
> >  		}
> > @@ -3219,13 +3229,17 @@ static int clone_finish_inode_update(struct btr=
fs_trans_handle *trans,
> >  				     struct inode *inode,
> >  				     u64 endoff,
> >  				     const u64 destoff,
> > -				     const u64 olen)
> > +				     const u64 olen,
> > +				     int no_mtime)
> >  {
> >  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> >  	int ret;
> > =20
> >  	inode_inc_iversion(inode);
> > -	inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
> > +	if (no_mtime)
> > +		inode->i_ctime =3D CURRENT_TIME;
> > +	else
> > +		inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
> >  	/*
> >  	 * We round up to the block size at eof when determining which
> >  	 * extents to clone above, but shouldn't round up the file size.
> > @@ -3316,7 +3330,7 @@ static void clone_update_extent_map(struct inode =
*inode,
> >   */
> >  static int btrfs_clone(struct inode *src, struct inode *inode,
> >  		       const u64 off, const u64 olen, const u64 olen_aligned,
> > -		       const u64 destoff)
> > +		       const u64 destoff, int no_mtime)
> >  {
> >  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> >  	struct btrfs_path *path =3D NULL;
> > @@ -3640,7 +3654,7 @@ process_slot:
> >  					      root->sectorsize);
> >  			ret =3D clone_finish_inode_update(trans, inode,
> >  							last_dest_end,
> > -							destoff, olen);
> > +							destoff, olen, no_mtime);
> >  			if (ret)
> >  				goto out;
> >  			if (new_key.offset + datal >=3D destoff + len)
> > @@ -3678,7 +3692,7 @@ process_slot:
> >  		clone_update_extent_map(inode, trans, NULL, last_dest_end,
> >  					destoff + len - last_dest_end);
> >  		ret =3D clone_finish_inode_update(trans, inode, destoff + len,
> > -						destoff, olen);
> > +						destoff, olen, no_mtime);
> >  	}
> > =20
> >  out:
> > @@ -3808,7 +3822,7 @@ static noinline long btrfs_ioctl_clone(struct fil=
e *file, unsigned long srcfd,
> >  		btrfs_double_extent_lock(src, off, inode, destoff, len);
> >  	}
> > =20
> > -	ret =3D btrfs_clone(src, inode, off, olen, len, destoff);
> > +	ret =3D btrfs_clone(src, inode, off, olen, len, destoff, 0);
> > =20
> >  	if (same_inode) {
> >  		u64 lock_start =3D min_t(u64, off, destoff);
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index b6dec05..beeb51c 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
>=20
> > +#define	BTRFS_SAME_NO_MTIME	0x1
> > +#define	BTRFS_SAME_FLAGS	(BTRFS_SAME_NO_MTIME)
>=20
> The naming scheme used eg. for the send flags:
>=20
> BTRFS_SEND_FLAG_MASK
> BTRFS_SEND_FLAG_NO_FILE_DATA
>=20
> So I suggest to follow it:
>=20
> BTRFS_SAME_FLAG_MASK
> BTRFS_SAME_FLAG_NO_MTIME
>=20
> Though I'd rather see it named it with BTRFS_EXTENT_SAME_ prefix so it
> (almost ...) matches the ioctl name (and is greppable).

Is there any sane use case where we would _want_ EXTENT_SAME to change
the mtime?  We do a lot of work to make sure that none of the files
involved have any sort of content change.  Why do we need the flag at all?

> This is going to be in a public interface so the naming is important.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWLEFwACgkQgfmLGlazG5wZQgCg6pmHyK76y9g80P24ledozkgP
C3MAoLOfXliNlGDWw4Kcb7Q2L0PAAM5J
=aUrP
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
