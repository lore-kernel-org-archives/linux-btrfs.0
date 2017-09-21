Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33382 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdIUUWi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 16:22:38 -0400
Date: Thu, 21 Sep 2017 16:16:35 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: add a flags argument to LOGICAL_INO and call
 it LOGICAL_INO_V2
Message-ID: <20170921201634.y2o7ir3kgqqcgqts@hungrycats.org>
References: <20170921041016.14752-1-ce3g8jdj@umail.furryterror.org>
 <20170921041016.14752-3-ce3g8jdj@umail.furryterror.org>
 <20170921195942.GA5718@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="w33a3rhvgvqyv24v"
In-Reply-To: <20170921195942.GA5718@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--w33a3rhvgvqyv24v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 21, 2017 at 12:59:42PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 21, 2017 at 12:10:15AM -0400, Zygo Blaxell wrote:
> > Now that check_extent_in_eb()'s extent offset filter can be turned off,
> > we need a way to do it from userspace.
> >=20
> > Add a 'flags' field to the btrfs_logical_ino_args structure to disable =
extent
> > offset filtering, taking the place of one of the reserved[] fields.
> >=20
> > Previous versions of LOGICAL_INO neglected to check whether any of the
> > reserved fields have non-zero values.  Assigning meaning to those fields
> > now may change the behavior of existing programs that left these fields
> > uninitialized.
> >=20
> > To avoid any surprises, define a new ioctl LOGICAL_INO_V2 which uses
> > the same argument layout as LOGICAL_INO, but uses one of the reserved
> > fields for flags.  The V2 ioctl explicitly checks that unsupported flag
> > bits are zero so that userspace can probe for future feature bits as
> > they are defined.  If the other reserved fields are used in the future,
> > one of the remaining flag bits could specify that the other reserved
> > fields are valid, so we don't need to check those for now.
> >=20
> > Since the memory layouts and behavior of the two ioctls' arguments
> > are almost identical, there is no need for a separate function for
> > logical_to_ino_v2 (contrast with tree_search_v2 vs tree_search).
> > A version parameter and an 'if' statement will suffice.
> >=20
> > Now that we have a flags field in logical_ino_args, add a flag
> > BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET to get the behavior we want,
> > and pass it down the stack to iterate_inodes_from_logical.
> >=20
> > Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> > ---
> >  fs/btrfs/ioctl.c           | 21 ++++++++++++++++++---
> >  include/uapi/linux/btrfs.h |  8 +++++++-
> >  2 files changed, 25 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index b7de32568082..2bc3a9588d1d 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -4536,13 +4536,14 @@ static int build_ino_list(u64 inum, u64 offset,=
 u64 root, void *ctx)
> >  }
> > =20
> >  static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
> > -					void __user *arg)
> > +					void __user *arg, int version)
> >  {
> >  	int ret =3D 0;
> >  	int size;
> >  	struct btrfs_ioctl_logical_ino_args *loi;
> >  	struct btrfs_data_container *inodes =3D NULL;
> >  	struct btrfs_path *path =3D NULL;
> > +	bool ignore_offset;
> > =20
> >  	if (!capable(CAP_SYS_ADMIN))
> >  		return -EPERM;
> > @@ -4551,6 +4552,17 @@ static long btrfs_ioctl_logical_to_ino(struct bt=
rfs_fs_info *fs_info,
> >  	if (IS_ERR(loi))
> >  		return PTR_ERR(loi);
> > =20
> > +	if (version =3D=3D 1) {
> > +		ignore_offset =3D false;
> > +	} else {
> > +		/* Only accept flags we have defined so far */
> > +		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET)) {
> > +			ret =3D -EINVAL;
> > +			goto out_loi;
> > +		}
> > +		ignore_offset =3D loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
>=20
> Please check loi->reserved[3] for zeroness so that the next person who
> wants to add a field to btrfs_ioctl_logical_ino_args doesn't have to
> create LOGICAL_INO_V3 for the same reason you're creating V2.

OK now I'm confused, in several distinct ways.

I wonder if you meant reserved[1] and reserved[2] there, since I'm not
checking them (for reasons stated in the commit log--we can use flags
to indicate whether and what values are present there).

But that's not the bigger problem.  Maybe you did mean reserved[3], but
there's no "reserved[3]" any more.  I shortened the reserved array from
4 elements to 3, so "reserved[3]" is no longer a valid memory reference.
Also "reserved[0]" no longer refers to the same thing it once did.

> --D
>=20
> > +	}
> > +
> >  	path =3D btrfs_alloc_path();
> >  	if (!path) {
> >  		ret =3D -ENOMEM;
> > @@ -4566,7 +4578,7 @@ static long btrfs_ioctl_logical_to_ino(struct btr=
fs_fs_info *fs_info,
> >  	}
> > =20
> >  	ret =3D iterate_inodes_from_logical(loi->logical, fs_info, path,
> > -					  build_ino_list, inodes, false);
> > +					  build_ino_list, inodes, ignore_offset);
> >  	if (ret =3D=3D -EINVAL)
> >  		ret =3D -ENOENT;
> >  	if (ret < 0)
> > @@ -4580,6 +4592,7 @@ static long btrfs_ioctl_logical_to_ino(struct btr=
fs_fs_info *fs_info,
> >  out:
> >  	btrfs_free_path(path);
> >  	kvfree(inodes);
> > +out_loi:
> >  	kfree(loi);
> > =20
> >  	return ret;
> > @@ -5550,7 +5563,9 @@ long btrfs_ioctl(struct file *file, unsigned int
> >  	case BTRFS_IOC_INO_PATHS:
> >  		return btrfs_ioctl_ino_to_path(root, argp);
> >  	case BTRFS_IOC_LOGICAL_INO:
> > -		return btrfs_ioctl_logical_to_ino(fs_info, argp);
> > +		return btrfs_ioctl_logical_to_ino(fs_info, argp, 1);
> > +	case BTRFS_IOC_LOGICAL_INO_V2:
> > +		return btrfs_ioctl_logical_to_ino(fs_info, argp, 2);
> >  	case BTRFS_IOC_SPACE_INFO:
> >  		return btrfs_ioctl_space_info(fs_info, argp);
> >  	case BTRFS_IOC_SYNC: {
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index 378230c163d5..0b3de597e04f 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -608,10 +608,14 @@ struct btrfs_ioctl_ino_path_args {
> >  struct btrfs_ioctl_logical_ino_args {
> >  	__u64				logical;	/* in */
> >  	__u64				size;		/* in */
> > -	__u64				reserved[4];
> > +	__u64				flags;		/* in, v2 only */
> > +	__u64				reserved[3];

Should I rename 'reserved' here, e.g.

  	__u64				logical;	/* in */
  	__u64				size;		/* in */
  	__u64				flags;		/* in, v2 only */
  	__u64				reserved1;
  	__u64				reserved2;
  	__u64				reserved3;
     	/* struct btrfs_data_container	*inodes;	out   */
     	__u64				inodes;

That way any existing code that happened to use reserved[3] now
fails to compile instead of clobbering the first u64 of inodes,
and there's no silent rearrangement of reserved[0..2].

Another option is I just put flags where reserved[3] is:

  	__u64				logical;	/* in */
  	__u64				size;		/* in */
  	__u64				reserved[3];
  	__u64				flags;		/* in, v2 only */
     	/* struct btrfs_data_container	*inodes;	out   */
     	__u64				inodes;

This means code that has reserved[3] still works (maybe it just prints
the value for a human to read), and it just happens to land where the
new flags field is.

> >  	/* struct btrfs_data_container	*inodes;	out   */
> >  	__u64				inodes;
> >  };
> > +/* Return every ref to the extent, not just those containing logical b=
lock.
> > + * Requires logical =3D=3D extent bytenr. */
> > +#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
> > =20
> >  enum btrfs_dev_stat_values {
> >  	/* disk I/O failure stats */
> > @@ -835,5 +839,7 @@ enum btrfs_err_code {
> >  				   struct btrfs_ioctl_feature_flags[3])
> >  #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
> >  				   struct btrfs_ioctl_vol_args_v2)
> > +#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
> > +					struct btrfs_ioctl_logical_ino_args)
> > =20
> >  #endif /* _UAPI_LINUX_BTRFS_H */
> > --=20
> > 2.11.0
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--w33a3rhvgvqyv24v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlnEHiIACgkQgfmLGlazG5yg+ACff+5BWu4nW645cxmTM0E4L3sG
P7YAoJ+Wf/dHYF0W/Oc/crGD8RRBfGiH
=8IBl
-----END PGP SIGNATURE-----

--w33a3rhvgvqyv24v--
