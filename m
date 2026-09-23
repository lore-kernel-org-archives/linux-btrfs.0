Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982BC313547
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 02:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790130989; cv=none; b=I7u0tCSYDyB4N/HGl7YVX90+qEWUZC49BAXNez3xyjWB/EJuhWUpoF2idw5ZeeYElZLD9JeHOStFTOOqt9lCPyG6MYidgs/8OL/K9Hw06nQRhWSg83oSJ1PCXqftfqO2ipXMzncMHRyZ9XUBglqtCgRi8amH28AXtu6rByrZ4I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790130989; c=relaxed/simple;
	bh=1paIx0OJrLPJNOHIflzWw52KG2T5dhuY5FEdxRlnMy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihCQwldb+DQXUG/hcE5VU8jNUNoOmN9n/7RLmC+XDjJeEltQygk3lNnhTtiSiQ92JdRP3Mbtzqh6p6AuMj9kQytE3kZmg17wskUw2blDSeFhLmoZkKRueCvEHLqUgUeeaYIakhrz2TYbDdQBJVCcOC/F3HcPnm2mOin2ZvmVLXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id EF0EC1BDE185; Tue, 22 Sep 2026 22:28:53 -0400 (EDT)
Date: Tue, 22 Sep 2026 22:28:53 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: dsterba@suse.com, boris@bur.io, loemra.dev@gmail.com, fdmanana@suse.com,
	wqu@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1] btrfs: add LOGICAL_INO_V2 flag for avoiding the tree
 modification log
Message-ID: <arM5ZbekdkYsCfke@hungrycats.org>
References: <20260922201258.874070-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260922201258.874070-1-joannelkoong@gmail.com>

On Tue, Sep 22, 2026 at 01:12:57PM -0700, Joanne Koong wrote:
> At Meta, we use the LOGICAL_INO_V2 ioctl to estimate sharing-aware space
> usage. We sample the logical address space and resolve each sample back
> to the inodes which reference it. The measurement is statistical, so
> with enough samples it gives good bounds on real usage.
>=20
> Currently in the LOGICAL_INO_V2 ioctl path, iterate_extent_inodes()
> (which can walk backrefs either against the current trees or against the
> commit roots) acquires a tree modification log sequence number when
> walking the current trees, since those trees are being modified while
> the walk is in progress. The log is then enabled filesystem wide for as
> long as any such walk is running, and is only disabled again once the
> last walk has finished.
>=20
> While it is enabled the cost impacts the whole filesystem, not only the
> caller. Modifications of interior nodes of the extent tree and of
> subvolume trees have to be recorded, serialized on a single filesystem
> wide lock. Delayed refs with a sequence number at or above the oldest
> active one can not be run (the run path bails out with -EAGAIN in
> btrfs_run_delayed_refs_for_head()), and metadata refs above it can not
> be merged, so they accumulate and that work is deferred to transaction
> commit.
>=20
> Currently, userspace has no way to ask for anything cheaper. Whenever a
> transaction is running, the walk uses the tree modification log, even if
> the caller would tolerate results that could be up to one commit interval
> stale.
>=20
> Give userspace this option by adding BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT,
> which makes the backref walk use the commit roots and therefore never
> enables the tree modification log. Behavior is unchanged unless the flag
> gets explicitly passed by userspace. iterate_extent_inodes() already
> takes a search_commit_root argument for this, which scrub, send and the
> data relocation warning path all pass as true. The flag simply plumbs it
> through to userspace.

I was about to send the same patch after tracking down some performance
issues.  This is the same use case as btdu, and bees goes a lot faster
without the tree mod log as well.  Much appreciated!

> Assisted-by: LLM
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/btrfs/backref.c         |  6 ++++--
>  fs/btrfs/backref.h         |  3 ++-
>  fs/btrfs/ioctl.c           |  9 +++++++--
>  include/uapi/linux/btrfs.h | 10 ++++++++++
>  4 files changed, 23 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 1be632c742bd..364ec3ad7d8a 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -2549,7 +2549,8 @@ static int build_ino_list(u64 inum, u64 offset, u64=
 num_bytes, u64 root, void *c
>  }
> =20
>  int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_in=
fo,
> -				void *ctx, bool ignore_offset)
> +				void *ctx, bool ignore_offset,
> +				bool search_commit_root)
>  {
>  	struct btrfs_backref_walk_ctx walk_ctx =3D { 0 };
>  	int ret;
> @@ -2575,7 +2576,8 @@ int iterate_inodes_from_logical(u64 logical, struct=
 btrfs_fs_info *fs_info,
>  		walk_ctx.extent_item_pos =3D logical - found_key.objectid;
>  	walk_ctx.fs_info =3D fs_info;
> =20
> -	return iterate_extent_inodes(&walk_ctx, false, build_ino_list, ctx);
> +	return iterate_extent_inodes(&walk_ctx, search_commit_root,
> +				     build_ino_list, ctx);
>  }
> =20
>  static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index 179791de6b19..f8dc8a3723cf 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -226,7 +226,8 @@ int iterate_extent_inodes(struct btrfs_backref_walk_c=
tx *ctx,
>  			  iterate_extent_inodes_t *iterate, void *user_ctx);
> =20
>  int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_in=
fo,
> -				void *ctx, bool ignore_offset);
> +				void *ctx, bool ignore_offset,
> +				bool search_commit_root);
> =20
>  int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
> =20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 52aab510aea0..63257f8fb897 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3286,6 +3286,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs=
_fs_info *fs_info,
>  	struct btrfs_ioctl_logical_ino_args AUTO_KFREE(loi);
>  	struct btrfs_data_container AUTO_KVFREE(inodes);
>  	bool ignore_offset;
> +	bool search_commit_root;
> =20
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -3296,6 +3297,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs=
_fs_info *fs_info,
> =20
>  	if (version =3D=3D 1) {
>  		ignore_offset =3D false;
> +		search_commit_root =3D false;
>  		size =3D min_t(u32, loi->size, SZ_64K);
>  	} else {
>  		/* All reserved bits must be 0 for now */
> @@ -3303,10 +3305,12 @@ static long btrfs_ioctl_logical_to_ino(struct btr=
fs_fs_info *fs_info,
>  			return -EINVAL;
> =20
>  		/* Only accept flags we have defined so far */
> -		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET))
> +		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET |
> +				   BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT))
>  			return -EINVAL;
> =20
>  		ignore_offset =3D loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
> +		search_commit_root =3D loi->flags & BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT;
>  		size =3D min_t(u32, loi->size, SZ_16M);
>  	}
> =20
> @@ -3314,7 +3318,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs=
_fs_info *fs_info,
>  	if (IS_ERR(inodes))
>  		return PTR_ERR(inodes);
> =20
> -	ret =3D iterate_inodes_from_logical(loi->logical, fs_info, inodes, igno=
re_offset);
> +	ret =3D iterate_inodes_from_logical(loi->logical, fs_info, inodes,
> +					  ignore_offset, search_commit_root);
>  	if (ret =3D=3D -EINVAL)
>  		return -ENOENT;
>  	if (ret < 0)
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 0a13baf3d8d1..b6f196bfa600 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -732,6 +732,16 @@ struct btrfs_ioctl_logical_ino_args {
>   */
>  #define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
> =20
> +/*
> + * Resolve backrefs against the commit roots instead of the current tree=
s.
> + *
> + * Resolving against the current trees is more expensive for the filesys=
tem as
> + * a whole, not only for the caller. Callers that do not need to observe=
 the
> + * currently running transaction should set this. The result can be up t=
o one
> + * commit interval stale.
> + */
> +#define BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT	(1ULL << 1)
> +
>  enum btrfs_dev_stat_values {
>  	/* disk I/O failure stats */
>  	BTRFS_DEV_STAT_WRITE_ERRS, /* EIO or EREMOTEIO from lower layers */
> --=20
> 2.52.0
>=20
>=20
