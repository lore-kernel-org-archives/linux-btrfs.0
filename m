From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] Btrfs: support security xattr with SELinux enabled
Date: Wed, 7 Jan 2009 15:48:47 -0500
Message-ID: <20090107204846.GG5266@unused.rdu.redhat.com>
References: <49650E5A.3030602@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49650E5A.3030602@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 07, 2009 at 03:19:38PM -0500, jim owens wrote:
>
> Add call to LSM security initialization and save
> resulting security xattr for new inodes.
>
> Add xattr support to symlink inode ops.
>
> Set inode->i_op for existing special files.
>
> Signed-off-by: jim owens <jowens@hp.com>
> ---
>  fs/btrfs/inode.c |   23 +++++++++++++++++++----
>  fs/btrfs/xattr.c |   32 ++++++++++++++++++++++++++++++++
>  fs/btrfs/xattr.h |    2 ++
>  3 files changed, 53 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index cdb7011..dd6152a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -91,6 +91,16 @@ static noinline int cow_file_range(struct inode *inode,
>  				   u64 start, u64 end, int *page_started,
>  				   unsigned long *nr_written, int unlock);
>
> +static int btrfs_init_inode_security(struct inode *inode,  struct inode  
> *dir)
> +{
> +	int err;
> +
> +	err = btrfs_init_acl(inode, dir);
> +	if (!err)
> +		err = btrfs_xattr_security_init(inode, dir);
> +	return err;
> +}
> +
>  /*
>   * a very lame attempt at stopping writes when the FS is 85% full.  There
>   * are countless ways this is incorrect, but it is better than nothing.
> @@ -2039,6 +2049,7 @@ void btrfs_read_locked_inode(struct inode *inode)
>  		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
>  		break;
>  	default:
> +		inode->i_op = &btrfs_special_inode_operations;
>  		init_special_inode(inode, inode->i_mode, rdev);
>  		break;
>  	}
> @@ -3586,7 +3597,7 @@ static int btrfs_mknod(struct inode *dir, struct  
> dentry *dentry,
>  	if (IS_ERR(inode))
>  		goto out_unlock;
>
> -	err = btrfs_init_acl(inode, dir);
> +	err = btrfs_init_inode_security(inode, dir);
>  	if (err) {
>  		drop_inode = 1;
>  		goto out_unlock;
> @@ -3649,7 +3660,7 @@ static int btrfs_create(struct inode *dir, struct  
> dentry *dentry,
>  	if (IS_ERR(inode))
>  		goto out_unlock;
>
> -	err = btrfs_init_acl(inode, dir);
> +	err = btrfs_init_inode_security(inode, dir);
>  	if (err) {
>  		drop_inode = 1;
>  		goto out_unlock;
> @@ -3772,7 +3783,7 @@ static int btrfs_mkdir(struct inode *dir, struct  
> dentry *dentry, int mode)
>
>  	drop_on_err = 1;
>
> -	err = btrfs_init_acl(inode, dir);
> +	err = btrfs_init_inode_security(inode, dir);
>  	if (err)
>  		goto out_fail;
>
> @@ -4733,7 +4744,7 @@ static int btrfs_symlink(struct inode *dir, struct  
> dentry *dentry,
>  	if (IS_ERR(inode))
>  		goto out_unlock;
>
> -	err = btrfs_init_acl(inode, dir);
> +	err = btrfs_init_inode_security(inode, dir);
>  	if (err) {
>  		drop_inode = 1;
>  		goto out_unlock;
> @@ -5032,4 +5043,8 @@ static struct inode_operations  
> btrfs_symlink_inode_operations = {
>  	.follow_link	= page_follow_link_light,
>  	.put_link	= page_put_link,
>  	.permission	= btrfs_permission,
> +	.setxattr	= btrfs_setxattr,
> +	.getxattr	= btrfs_getxattr,
> +	.listxattr	= btrfs_listxattr,
> +	.removexattr	= btrfs_removexattr,
>  };
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index 7f332e2..02195f4 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -21,6 +21,7 @@
>  #include <linux/slab.h>
>  #include <linux/rwsem.h>
>  #include <linux/xattr.h>
> +#include <linux/security.h>
>  #include "ctree.h"
>  #include "btrfs_inode.h"
>  #include "transaction.h"
> @@ -320,3 +321,34 @@ int btrfs_removexattr(struct dentry *dentry, const  
> char *name)
>  		return -EOPNOTSUPP;
>  	return __btrfs_setxattr(dentry->d_inode, name, NULL, 0, XATTR_REPLACE);
>  }
> +
> +int btrfs_xattr_security_init(struct inode *inode, struct inode *dir)
> +{
> +	int err;
> +	size_t len;
> +	void *value;
> +	char *suffix;
> +	char *name;
> +
> +	err = security_inode_init_security(inode, dir, &suffix, &value, &len);
> +	if (err) {
> +		if (err == -EOPNOTSUPP)
> +			return 0;
> +		return err;
> +	}
> +
> +	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(suffix) + 1,
> +		       GFP_NOFS);

Use kzalloc here otherwise the end of name could be some random thing and
strlen() will read past the end of the memory.  Thanks,

Josef
