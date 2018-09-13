Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:48261 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbeINEmC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:42:02 -0400
Subject: Re: [PATCH v2 2/7] btrfs-progs: make btrfs_unlink() lookup
 inode_extref
To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
 <20180912204924.10089-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1cd0bf69-d4ef-e4a9-ef0a-5e5e4f3c44b7@gmx.com>
Date: Fri, 14 Sep 2018 07:30:15 +0800
MIME-Version: 1.0
In-Reply-To: <20180912204924.10089-3-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 上午4:49, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> btrfs_unlink() uses btrfs_lookup_inode_ref() to look up inode_ref
> but forget inode_extref case.
> 
> Let btrfs_unlink() call btrfs_lookup_inode_extref() if inode_ref is
> found and EXTENDED_IREF feature is enabled.
> 
> Fixes: 0cc75eddd093 ("btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.")

My fault.

Indeed we need to check extref especially EXTENTD_IREF is already
default mkfs features.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  inode.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/inode.c b/inode.c
> index 2398bca4a109..598ad0ab6b4c 100644
> --- a/inode.c
> +++ b/inode.c
> @@ -277,6 +277,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  	struct btrfs_key key;
>  	struct btrfs_inode_item *inode_item;
>  	struct btrfs_inode_ref *inode_ref;
> +	struct btrfs_inode_extref *inode_extref = NULL;
>  	struct btrfs_dir_item *dir_item;
>  	u64 inode_size;
>  	u32 nlinks;
> @@ -296,7 +297,18 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  		ret = PTR_ERR(inode_ref);
>  		goto out;
>  	}
> -	if (inode_ref)
> +
> +	if (!inode_ref && btrfs_fs_incompat(root->fs_info, EXTENDED_IREF)) {
> +		btrfs_release_path(path);
> +		inode_extref = btrfs_lookup_inode_extref(trans, root, path,
> +					 name, namelen, ino, parent_ino, 0);
> +		if (IS_ERR(inode_extref)) {
> +			ret = PTR_ERR(inode_extref);
> +			goto out;
> +		}
> +	}
> +
> +	if (inode_ref || inode_extref)
>  		del_inode_ref = 1;
>  	btrfs_release_path(path);
>  
> 
