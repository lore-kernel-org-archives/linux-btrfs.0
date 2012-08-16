Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:9359 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2HPFKz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 01:10:55 -0400
Message-ID: <502C80DE.3030008@jan-o-sch.net>
Date: Thu, 16 Aug 2012 07:10:54 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: use helper for logical resolve
References: <1345092166-7089-1-git-send-email-bo.li.liu@oracle.com> <1345092166-7089-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1345092166-7089-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, August 16, 2012 at 06:42 (+0200), Liu Bo wrote:
> We already have a helper, iterate_inodes_from_logical(), for logical resolve,
> so just use it.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ioctl.c |   20 +++-----------------
>  1 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 405b279..f1ff21a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3210,12 +3210,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
>  {
>  	int ret = 0;
>  	int size;
> -	u64 extent_item_pos;
> -	u64 flags = 0;
>  	struct btrfs_ioctl_logical_ino_args *loi;
>  	struct btrfs_data_container *inodes = NULL;
>  	struct btrfs_path *path = NULL;
> -	struct btrfs_key key;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -3241,20 +3238,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
>  		goto out;
>  	}
>  
> -	ret = extent_from_logical(root->fs_info, loi->logical, path, &key,
> -				  &flags);
> -	btrfs_release_path(path);
> -
> -	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
> -		ret = -ENOENT;
> -	if (ret < 0)
> -		goto out;
> -
> -	extent_item_pos = loi->logical - key.objectid;
> -	ret = iterate_extent_inodes(root->fs_info, key.objectid,
> -					extent_item_pos, 0, build_ino_list,
> -					inodes);
> -
> +	path->search_commit_root = 0;

I came across that search_commit_root as well when re-reading
iterate_inodes_from_logical. Wouldn't explicitly set the default value here,
though. We don't do it before each and every call to btrfs_search_slot, either.

> +	ret = iterate_inodes_from_logical(loi->logical, root->fs_info, path,
> +					  build_ino_list, inodes);

To maintain the current behavior, we should patch -EINVAL to -ENOENT here.

>  	if (ret < 0)
>  		goto out;
>  

Thanks,
-Jan
