Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32988 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755793AbdCUWlO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Mar 2017 18:41:14 -0400
Date: Tue, 21 Mar 2017 15:40:25 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH RFC] btrfs: introduce a separate mutex for
 caching_block_groups list
Message-ID: <20170321224025.GB1986@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <7D943753182E46848AC6B688BF365906@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7D943753182E46848AC6B688BF365906@alyakaslap>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 19, 2017 at 07:18:59PM +0200, Alex Lyakas wrote:
> We have a commit_root_sem, which is a read-write semaphore that protects the
> commit roots.
> But it is also used to protect the list of caching block groups.
> 
> As a result, while doing "slow" caching, the following issue is seen:
> 
> Some of the caching threads are scanning the extent tree with
> commit_root_sem
> acquired in shared mode, with stack like:
> [<ffffffffc0ad27b2>] read_extent_buffer_pages+0x2d2/0x300 [btrfs]
> [<ffffffffc0a9fbe7>] btree_read_extent_buffer_pages.constprop.50+0xb7/0x1e0
> [btrfs]
> [<ffffffffc0aa1550>] read_tree_block+0x40/0x70 [btrfs]
> [<ffffffffc0a7aa7c>] read_block_for_search.isra.33+0x12c/0x370 [btrfs]
> [<ffffffffc0a7ce86>] btrfs_search_slot+0x3c6/0xb10 [btrfs]
> [<ffffffffc0a975b9>] caching_thread+0x1b9/0x820 [btrfs]
> [<ffffffffc0adfa36>] normal_work_helper+0xc6/0x340 [btrfs]
> [<ffffffffc0adfd22>] btrfs_cache_helper+0x12/0x20 [btrfs]
> 
> IO requests that want to allocate space are waiting in cache_block_group()
> to acquire the commit_root_sem in exclusive mode. But they only want to add
> the caching control structure to the list of caching block-groups:
> [<ffffffff817136c9>] schedule+0x29/0x70
> [<ffffffff81716085>] rwsem_down_write_failed+0x145/0x320
> [<ffffffff813a1ae3>] call_rwsem_down_write_failed+0x13/0x20
> [<ffffffffc0a86d0b>] cache_block_group+0x25b/0x450 [btrfs]
> [<ffffffffc0a94d36>] find_free_extent+0xd16/0xdb0 [btrfs]
> [<ffffffffc0a94e7f>] btrfs_reserve_extent+0xaf/0x160 [btrfs]
> 
> Other caching threads want to continue their scanning, and for that they
> are waiting to acquire commit_root_sem in shared mode. But since there are
> IO threads that want the exclusive lock, the caching threads are unable
> to continue the scanning, because (I presume) rw_semaphore guarantees some
> fairness:
> [<ffffffff817136c9>] schedule+0x29/0x70
> [<ffffffff81715ee5>] rwsem_down_read_failed+0xc5/0x120
> [<ffffffff813a1ab4>] call_rwsem_down_read_failed+0x14/0x30
> [<ffffffffc0a975a1>] caching_thread+0x1a1/0x820 [btrfs]
> [<ffffffffc0adfa36>] normal_work_helper+0xc6/0x340 [btrfs]
> [<ffffffffc0adfd22>] btrfs_cache_helper+0x12/0x20 [btrfs]
> [<ffffffff8108bd56>] process_one_work+0x146/0x410
> 
> This causes slowness of the IO, especially when there are many block groups
> that need to be scanned for free space. In some cases it takes minutes
> until a single IO thread is able to allocate free space.
> 
> I don't see a deadlock here, because the caching threads that were able to
> acquire
> the commit_root_sem will call rwsem_is_contended() and should give up the
> semaphore,
> so that IO threads are able to acquire it in exclusive mode.
> 
> However, introducing a separate mutex that protects only the list of caching
> block groups makes things move forward much faster.
>

The problem did exist and the patch looks good to me.

> This patch is based on kernel 3.18.
> Unfortunately, I am not able to submit a patch based on one of the latest
> kernels, because
> here btrfs is part of the larger system, and upgrading the kernel is a
> significant effort.
> Hence marking the patch as RFC.
> Hopefully, this patch still has some value to the community.
> 
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 42d11e7..74feacb 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1490,6 +1490,8 @@ struct btrfs_fs_info {
>     struct list_head trans_list;
>     struct list_head dead_roots;
>     struct list_head caching_block_groups;
> +    /* protects the above list */
> +    struct mutex caching_block_groups_mutex;
> 
>     spinlock_t delayed_iput_lock;
>     struct list_head delayed_iputs;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5177954..130ec58 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2229,6 +2229,7 @@ int open_ctree(struct super_block *sb,
>     INIT_LIST_HEAD(&fs_info->delayed_iputs);
>     INIT_LIST_HEAD(&fs_info->delalloc_roots);
>     INIT_LIST_HEAD(&fs_info->caching_block_groups);
> +    mutex_init(&fs_info->caching_block_groups_mutex);
>     spin_lock_init(&fs_info->delalloc_root_lock);
>     spin_lock_init(&fs_info->trans_lock);
>     spin_lock_init(&fs_info->fs_roots_radix_lock);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a067065..906fb08 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -637,10 +637,10 @@ static int cache_block_group(struct
> btrfs_block_group_cache *cache,
>         return 0;
>     }
> 
> -    down_write(&fs_info->commit_root_sem);
> +    mutex_lock(&fs_info->caching_block_groups_mutex);
>     atomic_inc(&caching_ctl->count);
>     list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
> -    up_write(&fs_info->commit_root_sem);
> +    mutex_unlock(&fs_info->caching_block_groups_mutex);
> 
>     btrfs_get_block_group(cache);
> 
> @@ -5693,6 +5693,7 @@ void btrfs_prepare_extent_commit(struct
> btrfs_trans_handle *trans,
> 
>     down_write(&fs_info->commit_root_sem);
>

Witht the new mutex, it's not necessary to take commit_root_sem here
because a) pinned_extents could not be modified outside of a
transaction, and b) while at btrfs_prepare_extent_commit(), it's
already at the very end of commiting a transaction.

caching_ctl should have at least one reference and
caching_ctl->progress is supposed to be protected by
caching_ctl->mutex.

Thanks,

-liubo

> +    mutex_lock(&fs_info->caching_block_groups_mutex);
>     list_for_each_entry_safe(caching_ctl, next,
>                  &fs_info->caching_block_groups, list) {
>         cache = caching_ctl->block_group;
> @@ -5704,6 +5705,7 @@ void btrfs_prepare_extent_commit(struct
> btrfs_trans_handle *trans,
>             cache->last_byte_to_unpin = caching_ctl->progress;
>         }
>     }
> +    mutex_unlock(&fs_info->caching_block_groups_mutex);
> 
>     if (fs_info->pinned_extents == &fs_info->freed_extents[0])
>         fs_info->pinned_extents = &fs_info->freed_extents[1];
> @@ -8849,14 +8851,14 @@ int btrfs_free_block_groups(struct btrfs_fs_info
> *info)
>     struct btrfs_caching_control *caching_ctl;
>     struct rb_node *n;
> 
> -    down_write(&info->commit_root_sem);
> +    mutex_lock(&info->caching_block_groups_mutex);
>     while (!list_empty(&info->caching_block_groups)) {
>         caching_ctl = list_entry(info->caching_block_groups.next,
>                      struct btrfs_caching_control, list);
>         list_del(&caching_ctl->list);
>         put_caching_control(caching_ctl);
>     }
> -    up_write(&info->commit_root_sem);
> +    mutex_unlock(&info->caching_block_groups_mutex);
> 
>     spin_lock(&info->unused_bgs_lock);
>     while (!list_empty(&info->unused_bgs)) {
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
