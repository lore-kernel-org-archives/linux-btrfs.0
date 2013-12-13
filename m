Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51916 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3LMJpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:45:41 -0500
Message-ID: <52AAD78F.206@cn.fujitsu.com>
Date: Fri, 13 Dec 2013 17:46:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: fix EEXIST error when creating new file in
 subvolume/snapshot
References: <1386926183-18325-1-git-send-email-bo.li.liu@oracle.com> <1386926183-18325-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1386926183-18325-4-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 13 Dec 2013 17:16:23 +0800, Liu Bo wrote:
> While creating a subvolume/snapshot, we don't use inode cache to allocate
> an inode id for the root dir "..", so inode cache doesn't mark that id as

FIRST_FREE_OBJECTID should be the root dir ".", not "..".
The other is OK for me.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> used, and when we create a new file, it'll find that fact and throw out
> -EEXIST.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode-map.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index 493694f..bcff910 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -528,6 +528,16 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
>  	struct btrfs_key search_key;
>  	struct btrfs_key found_key;
>  	int slot;
> +	u64 min_objectid;
> +
> +	/*
> +	 * For fs/file tree, FIRST_FREE_OBJECTID is reserved for
> +	 * root dir ".."
> +	 */
> +	if (is_fstree(root->root_key.objectid))
> +		min_objectid = BTRFS_FIRST_FREE_OBJECTID;
> +	else
> +		min_objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> @@ -544,10 +554,9 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
>  		slot = path->slots[0] - 1;
>  		l = path->nodes[0];
>  		btrfs_item_key_to_cpu(l, &found_key, slot);
> -		*objectid = max_t(u64, found_key.objectid,
> -				  BTRFS_FIRST_FREE_OBJECTID - 1);
> +		*objectid = max_t(u64, found_key.objectid, min_objectid);
>  	} else {
> -		*objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
> +		*objectid = min_objectid;
>  	}
>  	ret = 0;
>  error:
> 

