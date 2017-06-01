Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26839 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdFAJdV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 05:33:21 -0400
Subject: Re: [PATCH 4/5] btrfs: use GFP_KERNEL in init_ipath
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496252765.git.dsterba@suse.com>
 <529ad6aaf2a0814b3b42da65f7e3afa9d0576e7c.1496252765.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d29f764c-b08b-0687-a454-02bb02c7504a@oracle.com>
Date: Thu, 1 Jun 2017 17:39:22 +0800
MIME-Version: 1.0
In-Reply-To: <529ad6aaf2a0814b3b42da65f7e3afa9d0576e7c.1496252765.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/01/17 01:49, David Sterba wrote:
> Now that init_ipath is called either from a safe context or with
> memalloc_nofs protection, we can switch to GFP_KERNEL allocations in
> init_path and init_data_container.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/backref.c | 10 +++++-----
>  fs/btrfs/ioctl.c   |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 24865da63d8f..f723c11bb763 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -16,7 +16,7 @@
>   * Boston, MA 021110-1307, USA.
>   */
>
> -#include <linux/vmalloc.h>
> +#include <linux/mm.h>
>  #include <linux/rbtree.h>
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -2305,7 +2305,7 @@ struct btrfs_data_container *init_data_container(u32 total_bytes)
>  	size_t alloc_bytes;
>
>  	alloc_bytes = max_t(size_t, total_bytes, sizeof(*data));
> -	data = vmalloc(alloc_bytes);
> +	data = kvmalloc(alloc_bytes, GFP_KERNEL);
>  	if (!data)
>  		return ERR_PTR(-ENOMEM);
>
> @@ -2339,9 +2339,9 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
>  	if (IS_ERR(fspath))
>  		return (void *)fspath;
>
> -	ifp = kmalloc(sizeof(*ifp), GFP_NOFS);
> +	ifp = kmalloc(sizeof(*ifp), GFP_KERNEL);
>  	if (!ifp) {
> -		vfree(fspath);
> +		kvfree(fspath);
>  		return ERR_PTR(-ENOMEM);
>  	}
>
> @@ -2356,6 +2356,6 @@ void free_ipath(struct inode_fs_paths *ipath)
>  {
>  	if (!ipath)
>  		return;
> -	vfree(ipath->fspath);
> +	kvfree(ipath->fspath);
>  	kfree(ipath);
>  }
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c9cdea8061bc..e4116f9248c2 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -37,7 +37,7 @@
>  #include <linux/bit_spinlock.h>
>  #include <linux/security.h>
>  #include <linux/xattr.h>
> -#include <linux/vmalloc.h>
> +#include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
>  #include <linux/uuid.h>
> @@ -4588,7 +4588,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>
>  out:
>  	btrfs_free_path(path);
> -	vfree(inodes);
> +	kvfree(inodes);
>  	kfree(loi);
>
>  	return ret;
>
