Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:35823 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3LNO4W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 09:56:22 -0500
Received: by mail-qe0-f43.google.com with SMTP id 2so2579266qeb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 06:56:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387032218-29998-1-git-send-email-fdmanana@gmail.com>
References: <1387032218-29998-1-git-send-email-fdmanana@gmail.com>
Date: Sat, 14 Dec 2013 22:56:21 +0800
Message-ID: <CAP9B-Q=o7j8bdopw4TRyYZAXmuezVYAoxp8fmk+4=iZ+H_LQDg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: wait for ordered extents before removing extent maps
From: Shilong Wang <wangshilong1991@gmail.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Filipe,

2013/12/14 Filipe David Borba Manana <fdmanana@gmail.com>:
> Wang Shilong got into a case where during inode eviction we were
> removing an extent map while it was pinned. This triggered a warning
> in remove_extent_mapping() because the extent map had the pinned
> flag set:
>
> [ 1209.102076]  [<ffffffffa04721b9>] remove_extent_mapping+0x69/0x70 [btrfs]
> [ 1209.102084]  [<ffffffffa0466b06>] btrfs_evict_inode+0x96/0x4d0 [btrfs]
> [ 1209.102089]  [<ffffffff81073010>] ? wake_atomic_t_function+0x40/0x40
> [ 1209.102092]  [<ffffffff8118ab2e>] evict+0x9e/0x190
> [ 1209.102094]  [<ffffffff8118b313>] iput+0xf3/0x180
> [ 1209.102101]  [<ffffffffa0461fd1>] btrfs_run_delayed_iputs+0xb1/0xd0 [btrfs]
> [ 1209.102107]  [<ffffffffa045d358>] __btrfs_end_transaction+0x268/0x350 [btrfs]
>
> Therefore wait for any pending ordered extents, if any, which will
> trigger calls to unpin_extent_cache(), before removing the extent maps.
>
> Wang's solution of simply clearing the pinned bit wasn't enough, as after
> unpin_extent_cache() will be called and trigger another WARN_ON() because
> the lookup for the extent map returned NULL.

Why not in evict_inode_truncate_pages() move remove_extent_mapping() after
clear_extent_bit()?

Thanks,
Wang
>
> Thanks Wang for finding out this.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/inode.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e889779..c2933fb 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4509,6 +4509,9 @@ static void evict_inode_truncate_pages(struct inode *inode)
>         ASSERT(inode->i_state & I_FREEING);
>         truncate_inode_pages(&inode->i_data, 0);
>
> +       /* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
> +       btrfs_wait_ordered_range(inode, 0, (u64)-1);
> +
>         write_lock(&map_tree->lock);
>         while (!RB_EMPTY_ROOT(&map_tree->map)) {
>                 struct extent_map *em;
> @@ -4566,8 +4569,6 @@ void btrfs_evict_inode(struct inode *inode)
>                 btrfs_orphan_del(NULL, inode);
>                 goto no_delete;
>         }
> -       /* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
> -       btrfs_wait_ordered_range(inode, 0, (u64)-1);
>
>         if (root->fs_info->log_root_recovering) {
>                 BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
