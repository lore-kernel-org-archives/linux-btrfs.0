Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:16273 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3LQJPf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:15:35 -0500
Message-ID: <52B0164A.90309@cn.fujitsu.com>
Date: Tue, 17 Dec 2013 17:15:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: jeffm@suse.com
Subject: Re: [PATCH] Btrfs: fix double initialization of the raid kobject
References: <1387252872-20521-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1387252872-20521-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 17 Dec 2013 12:01:12 +0800, Miao Xie wrote:
> We met the following oops when doing space balance:
>  kobject (ffff88081b590278): tried to init an initialized object, something is seriously wrong.
>  ...
>  Call Trace:
>   [<ffffffff81937262>] dump_stack+0x49/0x5f
>   [<ffffffff8137d259>] kobject_init+0x89/0xa0
>   [<ffffffff8137d36a>] kobject_init_and_add+0x2a/0x70
>   [<ffffffffa009bd79>] ? clear_extent_bit+0x199/0x470 [btrfs]
>   [<ffffffffa005e82c>] __link_block_group+0xfc/0x120 [btrfs]
>   [<ffffffffa006b9db>] btrfs_make_block_group+0x24b/0x370 [btrfs]
>   [<ffffffffa00a899b>] __btrfs_alloc_chunk+0x54b/0x7e0 [btrfs]
>   [<ffffffffa00a8c6f>] btrfs_alloc_chunk+0x3f/0x50 [btrfs]
>   [<ffffffffa0060123>] do_chunk_alloc+0x363/0x440 [btrfs]
>   [<ffffffffa00633d4>] btrfs_check_data_free_space+0x104/0x310 [btrfs]
>   [<ffffffffa0069f4d>] btrfs_write_dirty_block_groups+0x48d/0x600 [btrfs]
>   [<ffffffffa007aad4>] commit_cowonly_roots+0x184/0x250 [btrfs]
>   ...
> 
> Steps to reproduce:
>  # mkfs.btrfs -f <dev>
>  # mount -o nospace_cache <dev> <mnt>
>  # btrfs balance start <mnt>
>  # dd if=/dev/zero of=<mnt>/tmpfile bs=1M count=1
> 
> The reason of this problem is that we initialized the raid kobject when we added
> a block group into a empty raid list. As we know, when we mounted a btrfs filesystem,
> the raid list was empty, we would initialize the raid kobject when we added the first
> block group. But if there was not data stored in the block group, the block group
> would be freed when doing balance, and the raid list would be empty. And then if we
> allocated a new block group and added it into the raid list, we would initialize
> the raid kobject again, the oops happened.
> 
> Fix this problem by initializing the raid kobject just when mounting the fs.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

This bug was reported by Wang Shilong, so add

Reported-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Thanks
Miao

> ---
>  fs/btrfs/extent-tree.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index cd4d9ca..d667aad 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3464,8 +3464,10 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  		return ret;
>  	}
>  
> -	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
> +	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
>  		INIT_LIST_HEAD(&found->block_groups[i]);
> +		kobject_init(&found->block_group_kobjs[i], &btrfs_raid_ktype);
> +	}
>  	init_rwsem(&found->groups_sem);
>  	spin_lock_init(&found->lock);
>  	found->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> @@ -8423,9 +8425,8 @@ static void __link_block_group(struct btrfs_space_info *space_info,
>  		int ret;
>  
>  		kobject_get(&space_info->kobj); /* put in release */
> -		ret = kobject_init_and_add(kobj, &btrfs_raid_ktype,
> -					   &space_info->kobj, "%s",
> -					   get_raid_name(index));
> +		ret = kobject_add(kobj, &space_info->kobj, "%s",
> +				  get_raid_name(index));
>  		if (ret) {
>  			pr_warn("btrfs: failed to add kobject for block cache. ignoring.\n");
>  			kobject_put(&space_info->kobj);
> 

