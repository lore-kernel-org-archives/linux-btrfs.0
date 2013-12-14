Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42753 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3LNNtz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 08:49:55 -0500
Date: Sat, 14 Dec 2013 21:49:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix a warning when iput a file
Message-ID: <20131214134935.GA23060@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1387006051-17067-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387006051-17067-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 14, 2013 at 03:27:31PM +0800, Wang Shilong wrote:
> See the warning below:
> 
> [ 1209.102076]  [<ffffffffa04721b9>] remove_extent_mapping+0x69/0x70 [btrfs]
> [ 1209.102084]  [<ffffffffa0466b06>] btrfs_evict_inode+0x96/0x4d0 [btrfs]
> [ 1209.102089]  [<ffffffff81073010>] ? wake_atomic_t_function+0x40/0x40
> [ 1209.102092]  [<ffffffff8118ab2e>] evict+0x9e/0x190
> [ 1209.102094]  [<ffffffff8118b313>] iput+0xf3/0x180
> [ 1209.102101]  [<ffffffffa0461fd1>] btrfs_run_delayed_iputs+0xb1/0xd0 [btrfs]
> [ 1209.102107]  [<ffffffffa045d358>] __btrfs_end_transaction+0x268/0x350 [btrfs]
> 
> clear extent bit here to avoid triggering WARN_ON() in remove_extent_mapping()

Why PINNED and LOGGING isn't unset as usual?

-liubo

> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e889779..c0f0f9d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4515,6 +4515,8 @@ static void evict_inode_truncate_pages(struct inode *inode)
>  
>  		node = rb_first(&map_tree->map);
>  		em = rb_entry(node, struct extent_map, rb_node);
> +		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
> +		clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
>  		remove_extent_mapping(map_tree, em);
>  		free_extent_map(em);
>  	}
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
