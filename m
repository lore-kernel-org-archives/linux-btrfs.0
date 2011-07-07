From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v3 8/8] new ioctls to do logical->inode and inode->path
 resolving
Date: Thu, 7 Jul 2011 23:29:47 +0100
Message-ID: <20110707222947.GE4325@carfax.org.uk>
References: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
 <d7f2eb7de3b6e8bc9f40ad96b9943d9680f88987.1310053204.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d7f2eb7de3b6e8bc9f40ad96b9943d9680f88987.1310053204.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Jan,

On Thu, Jul 07, 2011 at 05:48:33PM +0200, Jan Schmidt wrote:
> these ioctls make use of the new functions initially added for scrub. they
> return all inodes belonging to a logical address (BTRFS_IOC_LOGICAL_INO) and
> all paths belonging to an inode (BTRFS_IOC_INO_PATHS).

   I've not read this patch in detail, so I may have missed something,
but why do we need new ioctls for these functions, when we have
BTRFS_IOC_TREE_SEARCH, which will allow us to perform the same two
operations using existing kernel-side infrastructure?

   Hugo.

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ioctl.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |   19 ++++++++
>  2 files changed, 153 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a3c4751..5299b40 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -51,6 +51,7 @@
>  #include "volumes.h"
>  #include "locking.h"
>  #include "inode-map.h"
> +#include "backref.h"
>  
>  /* Mask out flags that are inappropriate for the given type of inode. */
>  static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
> @@ -2836,6 +2837,135 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
>  	return ret;
>  }
>  
> +static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
> +{
> +	int ret = 0;
> +	int i;
> +	unsigned long rel_ptr;
> +	int size;
> +	struct btrfs_ioctl_ino_path_args *ipa;
> +	struct inode_fs_paths *ipath = NULL;
> +	struct btrfs_path *path;
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ipa = memdup_user(arg, sizeof(*ipa));
> +	if (IS_ERR(ipa)) {
> +		ret = PTR_ERR(ipa);
> +		ipa = NULL;
> +		goto out;
> +	}
> +
> +	size = min(ipa->size, 4096);
> +	ipath = init_ipath(size, root, path);
> +	if (IS_ERR(ipath)) {
> +		ret = PTR_ERR(ipath);
> +		ipath = NULL;
> +		goto out;
> +	}
> +
> +	ret = paths_from_inode(ipa->inum, ipath);
> +	if (ret < 0)
> +		goto out;
> +
> +	for (i = 0; i < ipath->fspath->elem_cnt; ++i) {
> +		rel_ptr = ipath->fspath->str[i] - (char *)ipath->fspath->str;
> +		ipath->fspath->str[i] = (void *)rel_ptr;
> +	}
> +
> +	ret = copy_to_user(ipa->fspath, ipath->fspath, size);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +out:
> +	btrfs_free_path(path);
> +	free_ipath(ipath);
> +	kfree(ipa);
> +
> +	return ret;
> +}
> +
> +static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
> +{
> +	struct btrfs_data_container *inodes = ctx;
> +
> +	inodes->size -= 3 * sizeof(u64);
> +	if (inodes->size > 0) {
> +		inodes->val[inodes->elem_cnt] = inum;
> +		inodes->val[inodes->elem_cnt + 1] = offset;
> +		inodes->val[inodes->elem_cnt + 2] = root;
> +		inodes->elem_cnt += 3;
> +	} else {
> +		inodes->elem_missed += 3;
> +	}
> +
> +	return 0;
> +}
> +
> +static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
> +					void __user *arg)
> +{
> +	int ret = 0;
> +	int size;
> +	u64 extent_offset;
> +	struct btrfs_ioctl_logical_ino_args *loi;
> +	struct btrfs_data_container *inodes = NULL;
> +	struct btrfs_path *path = NULL;
> +	struct btrfs_key key;
> +
> +	loi = memdup_user(arg, sizeof(*loi));
> +	if (IS_ERR(loi)) {
> +		ret = PTR_ERR(loi);
> +		loi = NULL;
> +		goto out;
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	size = min(loi->size, 4096);
> +	inodes = init_data_container(size);
> +	if (IS_ERR(inodes)) {
> +		ret = PTR_ERR(inodes);
> +		inodes = NULL;
> +		goto out;
> +	}
> +
> +	ret = extent_from_logical(root->fs_info, loi->logical, path, &key);
> +
> +	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
> +		ret = -ENOENT;
> +	if (ret < 0)
> +		goto out;
> +
> +	extent_offset = loi->logical - key.objectid;
> +	ret = iterate_extent_inodes(root->fs_info, path, key.objectid,
> +					extent_offset, build_ino_list, inodes);
> +
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = copy_to_user(loi->inodes, inodes, size);
> +	if (ret)
> +		ret = -EFAULT;
> +
> +out:
> +	btrfs_free_path(path);
> +	kfree(inodes);
> +	kfree(loi);
> +
> +	return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -2893,6 +3023,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_tree_search(file, argp);
>  	case BTRFS_IOC_INO_LOOKUP:
>  		return btrfs_ioctl_ino_lookup(file, argp);
> +	case BTRFS_IOC_INO_PATHS:
> +		return btrfs_ioctl_ino_to_path(root, argp);
> +	case BTRFS_IOC_LOGICAL_INO:
> +		return btrfs_ioctl_logical_to_ino(root, argp);
>  	case BTRFS_IOC_SPACE_INFO:
>  		return btrfs_ioctl_space_info(root, argp);
>  	case BTRFS_IOC_SYNC:
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 4afb60b..10a0c10 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -203,6 +203,20 @@ struct btrfs_data_container {
>  	};
>  };
>  
> +struct btrfs_ioctl_ino_path_args {
> +	__u64				inum;		/* in */
> +	__s32				size;		/* in */
> +	__u64				reserved[4];
> +	struct btrfs_data_container	*fspath;	/* out */
> +};
> +
> +struct btrfs_ioctl_logical_ino_args {
> +	__u64				logical;	/* in */
> +	__s32				size;		/* in */
> +	__u64				reserved[4];
> +	struct btrfs_data_container	*inodes;	/* out */
> +};
> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -258,4 +272,9 @@ struct btrfs_data_container {
>  				 struct btrfs_ioctl_dev_info_args)
>  #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
>  			       struct btrfs_ioctl_fs_info_args)
> +#define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
> +					struct btrfs_ioctl_ino_path_args)
> +#define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
> +					struct btrfs_ioctl_ino_path_args)
> +
>  #endif

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- This year,  I'm giving up Lent. ---                 

--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOFjNbIKyzvlFcI40RAui6AJ9T/9geG8NUcFECmeoNvdLe8EL2JACfWVBq
KLsmxoaj8UoT2R0eBPPiXF8=
=l7cQ
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--
