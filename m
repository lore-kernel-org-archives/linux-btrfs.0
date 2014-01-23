Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44151 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaAWHVM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 02:21:12 -0500
Date: Thu, 23 Jan 2014 15:20:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix warning while merging two adjacent extents
Message-ID: <20140123072055.GC24664@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1390455669-2022-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390455669-2022-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 23, 2014 at 01:41:09PM +0800, Gui Hecheng wrote:
> When we have two adjacent extents in relink_extent_backref,
> we try to merge them. When we use btrfs_search_slot to locate the
> slot for the current extent, we shouldn't set "ins_len = 1",
> because we will merge it into the previous extent rather than
> insert a new item. Otherwise, we may happen to create a new leaf
> in btrfs_search_slot and path->slot[0] will be 0. Then we try to
> fetch the previous item using "path->slots[0]--", and it will cause
> a warning as follows:
> 
> 	[  145.713385] WARNING: CPU: 3 PID: 1796 at fs/btrfs/extent_io.c:5043 map_private_extent_buffer+0xd4/0xe0
> 	[  145.713387] btrfs bad mapping eb start 5337088 len 4096, wanted 167772306 8
> 	...
> 	[  145.713462]  [<ffffffffa034b1f4>] map_private_extent_buffer+0xd4/0xe0
> 	[  145.713476]  [<ffffffffa030097a>] ? btrfs_free_path+0x2a/0x40
> 	[  145.713485]  [<ffffffffa0340864>] btrfs_get_token_64+0x64/0xf0
> 	[  145.713498]  [<ffffffffa033472c>] relink_extent_backref+0x41c/0x820
> 	[  145.713508]  [<ffffffffa0334d69>] btrfs_finish_ordered_io+0x239/0xa80
> 
> I encounter this warning when running defrag having mkfs.btrfs
> with option -M. At the same time there are read/writes & snapshots
> running at background.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1ea19ce..7f955d6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2314,7 +2314,7 @@ again:
>  		u64 extent_len;
>  		struct btrfs_key found_key;
>  
> -		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
> +		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
>  		if (ret < 0)
>  			goto out_free_path;
>  
> -- 
> 1.8.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
