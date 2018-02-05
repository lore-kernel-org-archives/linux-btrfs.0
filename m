Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39962 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751979AbeBEGzy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Feb 2018 01:55:54 -0500
Subject: Re: [PATCH 1/4] btrfs-progs: mode-lowmem: Fix false alert about
 orphan inode
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <20180205064714.15659-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <f929f410-7413-9892-4e9c-a11c77f7e21a@cn.fujitsu.com>
Date: Mon, 5 Feb 2018 15:00:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180205064714.15659-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/05/2018 02:47 PM, Qu Wenruo wrote:
> Btrfs can delay inode deletion and in that case btrfs will unlink the
> victim inode from its parent dir, and insert a marker to info btrfs to
> delete it later.
> 
> In that case, such victim inode will have nlinks == 0, but is still
> completely valid.
> Original mode won't report such problem, but lowmem mode doesn't check
> the ORPHAN_ITEM key for such inode, and can report false alert like:
> ------
> ERROR: root 257 INODE[28891726] is orphan item
> ------
> 
> Fix such false alert by checking orphan item for inode whose nlink is 0.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   check/mode-lowmem.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 62bcf3d2e126..b11a6d77d102 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1861,6 +1861,24 @@ out:
>   	return ret;
>   }
>   
> +static bool has_orphan_item(struct btrfs_root *root, u64 ino)
> +{
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	int ret;
> +
> +	btrfs_init_path(&path);
> +	key.objectid = BTRFS_ORPHAN_OBJECTID;
> +	key.type = BTRFS_ORPHAN_ITEM_KEY;
> +	key.offset = ino;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	btrfs_release_path(&path);
> +	if (ret == 0)
> +		return true;
> +	return false;
> +}
> +

Suggestion:
Maybe "is_orphan_item" is a better name?
Anyway,

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

>   /*
>    * Check INODE_ITEM and related ITEMs (the same inode number)
>    * 1. check link count
> @@ -1890,6 +1908,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>   	u64 extent_size = 0;
>   	unsigned int dir;
>   	unsigned int nodatasum;
> +	bool is_orphan = false;
>   	int slot;
>   	int ret;
>   	int err = 0;
> @@ -2040,10 +2059,11 @@ out:
>   				      root->objectid, inode_id, nlink, refs);
>   			}
>   		} else if (!nlink) {
> -			if (repair)
> +			is_orphan = has_orphan_item(root, inode_id);
> +			if (!is_orphan && repair)
>   				ret = repair_inode_orphan_item_lowmem(root,
>   							      path, inode_id);
> -			if (!repair || ret) {
> +			if (!is_orphan && (!repair || ret)) {
>   				err |= ORPHAN_ITEM;
>   				error("root %llu INODE[%llu] is orphan item",
>   				      root->objectid, inode_id);
> 


