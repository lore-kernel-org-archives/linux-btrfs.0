Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbeGaIXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 04:23:13 -0400
Subject: Re: [PATCH 1/1] btrfs: locking: Allow btrfs_tree_lock() to return
 error to avoid deadlock
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180730061723.13290-1-wqu@suse.com>
 <20180730061723.13290-2-wqu@suse.com>
 <2427723d-1730-9b8b-98d0-ea5bf617341e@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <85b33521-ea24-c030-231c-a00f3f0f2f38@gmx.com>
Date: Tue, 31 Jul 2018 14:44:07 +0800
MIME-Version: 1.0
In-Reply-To: <2427723d-1730-9b8b-98d0-ea5bf617341e@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月31日 14:48, Su Yue wrote:
> 
> 
> On 07/30/2018 02:17 PM, Qu Wenruo wrote:
>> [BUG]
>> For certains crafted image, whose csum root leaf has missing backref, if
>> we try to trigger write with data csum, it could cause deadlock with the
>> following kernel WARN_ON():
>> ------
>> WARNING: CPU: 1 PID: 41 at fs/btrfs/locking.c:230
>> btrfs_tree_lock+0x3e2/0x400
>> CPU: 1 PID: 41 Comm: kworker/u4:1 Not tainted 4.18.0-rc1+ #8
>> Workqueue: btrfs-endio-write btrfs_endio_write_helper
>> RIP: 0010:btrfs_tree_lock+0x3e2/0x400
>> Call Trace:
>>   btrfs_alloc_tree_block+0x39f/0x770
>>   __btrfs_cow_block+0x285/0x9e0
>>   btrfs_cow_block+0x191/0x2e0
>>   btrfs_search_slot+0x492/0x1160
>>   btrfs_lookup_csum+0xec/0x280
>>   btrfs_csum_file_blocks+0x2be/0xa60
>>   add_pending_csums+0xaf/0xf0
>>   btrfs_finish_ordered_io+0x74b/0xc90
>>   finish_ordered_fn+0x15/0x20
>>   normal_work_helper+0xf6/0x500
>>   btrfs_endio_write_helper+0x12/0x20
>>   process_one_work+0x302/0x770
>>   worker_thread+0x81/0x6d0
>>   kthread+0x180/0x1d0
>>   ret_from_fork+0x35/0x40
>> ---[ end trace 2e85051acb5f6dc1 ]---
>> ------
>>
>> [CAUSE]
>> That crafted image has missing backref for csum tree root leaf.
>> And when we try to allocate new tree block, since there is no
>> EXTENT/METADATA_ITEM for csum tree root, btrfs consider it's free slot
>> and use it.
>>
>> However we have already locked csum tree root leaf by ourselves, thus we
>> will ourselves to release read/write lock, and causing deadlock.
>>
>> [FIX]
>> This patch will allow btrfs_tree_lock() to return error number, so
>> most callers can exit gracefully.
>> (Some caller doesn't really expect btrfs_tree_lock() to return error,
>> and in that case, we use BUG_ON())
>>
>> Since such problem can only happen in crafted image, we will still
>> trigger kernel warning, but with a little more meaningful warning
>> message.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200405
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> OK.. I looked through every places where the callee is called.
> Those errors are handled gracefully as my thought.
> Except one nitpick, the %llu about pid_t in btrfs_tree_lock.
> However, you can add the tag:
> 
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

snip

> 
> Nit:
> pid_t is as an signed integer, should be pid=%d .

BTW, how could pid be negative?
And why my gcc doesn't give such warning?

Thanks,
Qu

> 
> Thanks,
> Su
> 
>> +             eb->start, current->pid);
>> +        return -EUCLEAN;
>> +    }
>>   again:
>>       wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers)
>> == 0);
>>       wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers)
>> == 0);
>> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
>> index 29135def468e..7394d7ba2ff9 100644
>> --- a/fs/btrfs/locking.h
>> +++ b/fs/btrfs/locking.h
>> @@ -11,7 +11,7 @@
>>   #define BTRFS_WRITE_LOCK_BLOCKING 3
>>   #define BTRFS_READ_LOCK_BLOCKING 4
>>   -void btrfs_tree_lock(struct extent_buffer *eb);
>> +int btrfs_tree_lock(struct extent_buffer *eb);
>>   void btrfs_tree_unlock(struct extent_buffer *eb);
>>     void btrfs_tree_read_lock(struct extent_buffer *eb);
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 1874a6d2e6f5..ec4351fd7537 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1040,7 +1040,9 @@ int btrfs_quota_disable(struct
>> btrfs_trans_handle *trans,
>>         list_del(&quota_root->dirty_list);
>>   -    btrfs_tree_lock(quota_root->node);
>> +    ret = btrfs_tree_lock(quota_root->node);
>> +    if (ret < 0)
>> +        goto out;
>>       clean_tree_block(fs_info, quota_root->node);
>>       btrfs_tree_unlock(quota_root->node);
>>       btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index be94c65bb4d2..a2fc0bd83a40 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -1877,7 +1877,11 @@ int replace_path(struct btrfs_trans_handle *trans,
>>                   free_extent_buffer(eb);
>>                   break;
>>               }
>> -            btrfs_tree_lock(eb);
>> +            ret = btrfs_tree_lock(eb);
>> +            if (ret < 0) {
>> +                free_extent_buffer(eb);
>> +                break;
>> +            }
>>               if (cow) {
>>                   ret = btrfs_cow_block(trans, dest, eb, parent,
>>                                 slot, &eb);
>> @@ -2788,7 +2792,12 @@ static int do_relocation(struct
>> btrfs_trans_handle *trans,
>>               err = -EIO;
>>               goto next;
>>           }
>> -        btrfs_tree_lock(eb);
>> +        ret = btrfs_tree_lock(eb);
>> +        if (ret < 0) {
>> +            free_extent_buffer(eb);
>> +            err = ret;
>> +            goto next;
>> +        }
>>           btrfs_set_lock_blocking(eb);
>>             if (!node->eb) {
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index f8220ec02036..173bc15a7cd1 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -2588,7 +2588,11 @@ static noinline int walk_down_log_tree(struct
>> btrfs_trans_handle *trans,
>>                   }
>>                     if (trans) {
>> -                    btrfs_tree_lock(next);
>> +                    ret = btrfs_tree_lock(next);
>> +                    if (ret < 0) {
>> +                        free_extent_buffer(next);
>> +                        return ret;
>> +                    }
>>                       btrfs_set_lock_blocking(next);
>>                       clean_tree_block(fs_info, next);
>>                       btrfs_wait_tree_block_writeback(next);
>> @@ -2672,7 +2676,9 @@ static noinline int walk_up_log_tree(struct
>> btrfs_trans_handle *trans,
>>                   next = path->nodes[*level];
>>                     if (trans) {
>> -                    btrfs_tree_lock(next);
>> +                    ret = btrfs_tree_lock(next);
>> +                    if (ret < 0)
>> +                        return ret;
>>                       btrfs_set_lock_blocking(next);
>>                       clean_tree_block(fs_info, next);
>>                       btrfs_wait_tree_block_writeback(next);
>> @@ -2754,7 +2760,9 @@ static int walk_log_tree(struct
>> btrfs_trans_handle *trans,
>>               next = path->nodes[orig_level];
>>                 if (trans) {
>> -                btrfs_tree_lock(next);
>> +                ret = btrfs_tree_lock(next);
>> +                if (ret < 0)
>> +                    goto out;
>>                   btrfs_set_lock_blocking(next);
>>                   clean_tree_block(fs_info, next);
>>                   btrfs_wait_tree_block_writeback(next);
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
