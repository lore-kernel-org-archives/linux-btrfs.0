Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:37377 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753248AbdG2AsF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 20:48:05 -0400
Received: by mail-yw0-f196.google.com with SMTP id s143so7315866ywg.4
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 17:48:05 -0700 (PDT)
Date: Sat, 29 Jul 2017 00:48:04 +0000
From: Josef Bacik <josef@toxicpanda.com>
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: preserve i_mode if __btrfs_set_acl() fails
Message-ID: <20170729004802.GA28703@li70-116.members.linode.com>
References: <20170729002626.GA6759@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20170729002626.GA6759@debian.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 28, 2017 at 09:26:29PM -0300, Ernesto A. Fernández wrote:
> When changing a file's acl mask, btrfs_set_acl() will first set the
> group bits of i_mode to the value of the mask, and only then set the
> actual extended attribute representing the new acl.
> 
> If the second part fails (due to lack of space, for example) and the
> file had no acl attribute to begin with, the system will from now on
> assume that the mask permission bits are actual group permission bits,
> potentially granting access to the wrong users.
> 
> Prevent this by starting the journal transaction before calling
> __btrfs_set_acl and only changing the inode mode after it returns
> successfully.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
> ---
> This issue is covered by generic/449 in xfstests. Several filesystems
> are affected; some of them have already applied patches:
>   - fe26569 ext2: preserve i_mode if ext2_set_acl() fails
>   - f070e5a jfs: preserve i_mode if __jfs_set_acl() fails
>   - fcea8ae reiserfs: preserve i_mode if __reiserfs_set_acl() fails
> 
>  fs/btrfs/acl.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 8d8370d..d041526 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -27,6 +27,7 @@
>  #include "ctree.h"
>  #include "btrfs_inode.h"
>  #include "xattr.h"
> +#include "transaction.h"
>  
>  struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>  {
> @@ -113,14 +114,36 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
>  
>  int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
>  	int ret;
> +	umode_t mode = inode->i_mode;
> +
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;
> +
> +	trans = btrfs_start_transaction(root, 2);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
>  
>  	if (type == ACL_TYPE_ACCESS && acl) {
> -		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> +		ret = posix_acl_update_mode(inode, &mode, &acl);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
> -	return __btrfs_set_acl(NULL, inode, acl, type);
> +	ret = __btrfs_set_acl(trans, inode, acl, type);
> +	if (ret)
> +		goto out;
> +
> +	inode->i_mode = mode;
> +	inode_inc_iversion(inode);
> +	inode->i_ctime = current_time(inode);
> +	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);

This only needs to be set if we actually set the xattr.  I'd fix setxattr to
call it every time it's called.

> +	ret = btrfs_update_inode(trans, root, inode);
> +	BUG_ON(ret);

No BUG_ON, return the error.  Thanks,

Josef
