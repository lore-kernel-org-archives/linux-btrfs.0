From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH 2/2 v2] Btrfs: Per file/directory controls for COW and
 compression
Date: Mon, 04 Apr 2011 12:31:44 +0300
Message-ID: <4D999000.1000608@gmail.com>
References: <4D8712E9.108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8712E9.108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I would like to ask about the status of this feature/patch, is it=20
accepted into btrfs code, and how can I use it?

I am interested in enabling compression in a specific=20
folder(force-compress would be ideal) of a large btrfs volume, and=20
disabling it for the rest.


On 21/3/2011 10:57 =CF=80=CE=BC, liubo wrote:
> Data compression and data cow are controlled across the entire FS by =
mount
> options right now.  ioctls are needed to set this on a per file or pe=
r
> directory basis.  This has been proposed previously, but VFS develope=
rs
> wanted us to use generic ioctls rather than btrfs-specific ones.
>
> According to chris's comment, there should be just one true compressi=
on
> method(probably LZO) stored in the super.  However, before this, we w=
ould
> wait for that one method is stable enough to be adopted into the supe=
r.
> So I list it as a long term goal, and just store it in ram today.
>
> After applying this patch, we can use the generic "FS_IOC_SETFLAGS" i=
octl to
> control file and directory's datacow and compression attribute.
>
> NOTE:
>   - The compression type is selected by such rules:
>     If we mount btrfs with compress options, ie, zlib/lzo, the type i=
s it.
>     Otherwise, we'll use the default compress type (zlib today).
>
> v1->v2:
> Rebase the patch with the latest btrfs.
>
> Signed-off-by: Liu Bo<liubo2009@cn.fujitsu.com>
> ---
>   fs/btrfs/ctree.h   |    1 +
>   fs/btrfs/disk-io.c |    6 ++++++
>   fs/btrfs/inode.c   |   32 ++++++++++++++++++++++++++++----
>   fs/btrfs/ioctl.c   |   41 +++++++++++++++++++++++++++++++++++++----
>   4 files changed, 72 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8b4b9d1..b77d1a5 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1283,6 +1283,7 @@ struct btrfs_root {
>   #define BTRFS_INODE_NODUMP		(1<<  8)
>   #define BTRFS_INODE_NOATIME		(1<<  9)
>   #define BTRFS_INODE_DIRSYNC		(1<<  10)
> +#define BTRFS_INODE_COMPRESS		(1<<  11)
>
>   /* some macros to generate set/get funcs for the struct fields.  Th=
is
>    * assumes there is a lefoo_to_cpu for every type, so lets make a s=
imple
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 3e1ea3e..a894c12 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1762,6 +1762,12 @@ struct btrfs_root *open_ctree(struct super_blo=
ck *sb,
>
>   	btrfs_check_super_valid(fs_info, sb->s_flags&  MS_RDONLY);
>
> +	/*
> +	 * In the long term, we'll store the compression type in the super
> +	 * block, and it'll be used for per file compression control.
> +	 */
> +	fs_info->compress_type =3D BTRFS_COMPRESS_ZLIB;
> +
>   	ret =3D btrfs_parse_options(tree_root, options);
>   	if (ret) {
>   		err =3D ret;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index db67821..e687bb9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -381,7 +381,8 @@ again:
>   	 */
>   	if (!(BTRFS_I(inode)->flags&  BTRFS_INODE_NOCOMPRESS)&&
>   	(btrfs_test_opt(root, COMPRESS) ||
> -	     (BTRFS_I(inode)->force_compress))) {
> +	     (BTRFS_I(inode)->force_compress) ||
> +	     (BTRFS_I(inode)->flags&  BTRFS_INODE_COMPRESS))) {
>   		WARN_ON(pages);
>   		pages =3D kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
>
> @@ -1253,7 +1254,8 @@ static int run_delalloc_range(struct inode *ino=
de, struct page *locked_page,
>   		ret =3D run_delalloc_nocow(inode, locked_page, start, end,
>   					 page_started, 0, nr_written);
>   	else if (!btrfs_test_opt(root, COMPRESS)&&
> -		 !(BTRFS_I(inode)->force_compress))
> +		 !(BTRFS_I(inode)->force_compress)&&
> +		 !(BTRFS_I(inode)->flags&  BTRFS_INODE_COMPRESS))
>   		ret =3D cow_file_range(inode, locked_page, start, end,
>   				      page_started, nr_written, 1);
>   	else
> @@ -4581,8 +4583,6 @@ static struct inode *btrfs_new_inode(struct btr=
fs_trans_handle *trans,
>   	location->offset =3D 0;
>   	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
>
> -	btrfs_inherit_iflags(inode, dir);
> -
>   	if ((mode&  S_IFREG)) {
>   		if (btrfs_test_opt(root, NODATASUM))
>   			BTRFS_I(inode)->flags |=3D BTRFS_INODE_NODATASUM;
> @@ -4590,6 +4590,8 @@ static struct inode *btrfs_new_inode(struct btr=
fs_trans_handle *trans,
>   			BTRFS_I(inode)->flags |=3D BTRFS_INODE_NODATACOW;
>   	}
>
> +	btrfs_inherit_iflags(inode, dir);
> +
>   	insert_inode_hash(inode);
>   	inode_tree_add(inode);
>   	return inode;
> @@ -6803,6 +6805,26 @@ static int btrfs_getattr(struct vfsmount *mnt,
>   	return 0;
>   }
>
> +/*
> + * If a file is moved, it will inherit the cow and compression flags=
 of the new
> + * directory.
> + */
> +static void fixup_inode_flags(struct inode *dir, struct inode *inode=
)
> +{
> +	struct btrfs_inode *b_dir =3D BTRFS_I(dir);
> +	struct btrfs_inode *b_inode =3D BTRFS_I(inode);
> +
> +	if (b_dir->flags&  BTRFS_INODE_NODATACOW)
> +		b_inode->flags |=3D BTRFS_INODE_NODATACOW;
> +	else
> +		b_inode->flags&=3D ~BTRFS_INODE_NODATACOW;
> +
> +	if (b_dir->flags&  BTRFS_INODE_COMPRESS)
> +		b_inode->flags |=3D BTRFS_INODE_COMPRESS;
> +	else
> +		b_inode->flags&=3D ~BTRFS_INODE_COMPRESS;
> +}
> +
>   static int btrfs_rename(struct inode *old_dir, struct dentry *old_d=
entry,
>   			   struct inode *new_dir, struct dentry *new_dentry)
>   {
> @@ -6936,6 +6958,8 @@ static int btrfs_rename(struct inode *old_dir, =
struct dentry *old_dentry,
>   		}
>   	}
>
> +	fixup_inode_flags(new_dir, old_inode);
> +
>   	ret =3D btrfs_add_link(trans, new_dir, old_inode,
>   			     new_dentry->d_name.name,
>   			     new_dentry->d_name.len, 0, index);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5fdb2ab..93e7f6c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -138,6 +138,24 @@ static int btrfs_ioctl_getflags(struct file *fil=
e, void __user *arg)
>   	return 0;
>   }
>
> +static int check_flags(unsigned int flags)
> +{
> +	if (flags&  ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
> +		      FS_NOATIME_FL | FS_NODUMP_FL | \
> +		      FS_SYNC_FL | FS_DIRSYNC_FL | \
> +		      FS_NOCOMP_FL | FS_COMPR_FL | \
> +		      FS_NOCOW_FL | FS_COW_FL))
> +		return -EOPNOTSUPP;
> +
> +	if ((flags&  FS_NOCOMP_FL)&&  (flags&  FS_COMPR_FL))
> +		return -EINVAL;
> +
> +	if ((flags&  FS_NOCOW_FL)&&  (flags&  FS_COW_FL))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   static int btrfs_ioctl_setflags(struct file *file, void __user *arg=
)
>   {
>   	struct inode *inode =3D file->f_path.dentry->d_inode;
> @@ -153,10 +171,9 @@ static int btrfs_ioctl_setflags(struct file *fil=
e, void __user *arg)
>   	if (copy_from_user(&flags, arg, sizeof(flags)))
>   		return -EFAULT;
>
> -	if (flags&  ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
> -		      FS_NOATIME_FL | FS_NODUMP_FL | \
> -		      FS_SYNC_FL | FS_DIRSYNC_FL))
> -		return -EOPNOTSUPP;
> +	ret =3D check_flags(flags);
> +	if (ret)
> +		return ret;
>
>   	if (!is_owner_or_cap(inode))
>   		return -EACCES;
> @@ -201,6 +218,22 @@ static int btrfs_ioctl_setflags(struct file *fil=
e, void __user *arg)
>   	else
>   		ip->flags&=3D ~BTRFS_INODE_DIRSYNC;
>
> +	/*
> +	 * The COMPRESS flag can only be changed by users, while the NOCOMP=
RESS
> +	 * flag may be changed automatically if compression code won't make
> +	 * things smaller.
> +	 */
> +	if (flags&  FS_NOCOMP_FL) {
> +		ip->flags&=3D ~BTRFS_INODE_COMPRESS;
> +		ip->flags |=3D BTRFS_INODE_NOCOMPRESS;
> +	} else if (flags&  FS_COMPR_FL) {
> +		ip->flags |=3D BTRFS_INODE_COMPRESS;
> +		ip->flags&=3D ~BTRFS_INODE_NOCOMPRESS;
> +	}
> +	if (flags&  FS_NOCOW_FL)
> +		ip->flags |=3D BTRFS_INODE_NODATACOW;
> +	else if (flags&  FS_COW_FL)
> +		ip->flags&=3D ~BTRFS_INODE_NODATACOW;
>
>   	trans =3D btrfs_join_transaction(root, 1);
>   	BUG_ON(IS_ERR(trans));

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
