Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab3IFCiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 22:38:12 -0400
Message-ID: <52294047.9000105@cn.fujitsu.com>
Date: Fri, 06 Sep 2013 10:39:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] Btrfs: fix several potential problems in copy_nocow_pages_for_inode
References: <1372330260-1584-1-git-send-email-miaox@cn.fujitsu.com> <1372330260-1584-3-git-send-email-miaox@cn.fujitsu.com> <522894E0.1000401@giantdisaster.de>
In-Reply-To: <522894E0.1000401@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 05 Sep 2013 16:27:44 +0200, Stefan Behrens wrote:
> On Thu, 27 Jun 2013 18:51:00 +0800, Miao Xie wrote: 
>> - It makes no sense that we deal with a inode in the dead tree.
> 
> This caused that the replace procedure was not dealing with free space cache entries anymore (which have btrfs_root_refs() == 0). I accidentally fixed it as a side-effect of "Btrf: cleanup: don't check for root_refs == 0 twice" and intentionally fixed it with "Btrfs: eliminate the exceptional root_tree refs=0" (which is not yet sent).
> 

Thanks for your fix. 

>> - fix the race between dio and page copy by waiting the dio completion
> 
> This causes lockdep issues which I've seen once after running './check -g all' followed by './check btrfs/005' during the 005 run, and on a second box once while running the btrfs xfstests 001 up to 011 during the xfstest 011 run, both boxes were running the latest btrfs-next plus the patch "Btrfs: eliminate the exceptional root_tree refs=0" (but I do not think that the latter patch matters). I'm unable to reproduce this lockdep warning, but it seems to make sense, see below.
> 
> ### scrub.c:
> static void copy_nocow_pages_worker(struct btrfs_work *work)
> {
> ...
>         trans = btrfs_join_transaction(root);

It seems btrfs_join_transaction() here is used to prevent the transaction from being committed,
but we wait for the running scrubber and pause the scrubber before the transaction is committed,
so do we need btrfs_join_transaction() here?

Thanks
Miao

> ...
>         ret = iterate_inodes_from_logical(logical, fs_info, path,
>                                           copy_nocow_pages_for_inode,
>                                           nocow_ctx);
> ...
>         btrfs_end_transaction(trans, root);
> ...
> }
> 
> static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
> {
> ...
>         /* Avoid truncate/dio/punch hole.. */
>         mutex_lock(&inode->i_mutex);
>         inode_dio_wait(inode);
> ...
>         mutex_unlock(&inode->i_mutex);
> ...
> }
> 
> ### file.c:
> int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> {
> ...
>         mutex_lock(&inode->i_mutex);
> ...
>         trans = btrfs_start_transaction(root, 0);
> ...
>         mutex_unlock(&inode->i_mutex);
> ...
>         ret = btrfs_end_transaction(trans, root);
> ...
> }
> 
> [ INFO: possible circular locking dependency detected ]
> 3.10.0+ #5 Not tainted
> -------------------------------------------------------
> xfs_io/30404 is trying to acquire lock:
>  (sb_internal){.+.+..}, at: [<ffffffffa00abad6>] start_transaction+0x296/0x4f0 [btrfs]
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa00bd029>] btrfs_sync_file+0xb9/0x2c0 [btrfs]
> which lock already depends on the new lock.
> the existing dependency chain (in reverse order) is:
> -> #1 (&sb->s_type->i_mutex_key#11){+.+.+.}:
>        [<ffffffff810e564a>] lock_acquire+0x8a/0x120
>        [<ffffffff81993f13>] mutex_lock_nested+0x73/0x390
>        [<ffffffffa01005d5>] copy_nocow_pages_for_inode+0x105/0x2b0 [btrfs]
>        [<ffffffffa010941e>] iterate_extent_inodes+0x1ce/0x300 [btrfs]
>        [<ffffffffa01095f7>] iterate_inodes_from_logical+0xa7/0xb0 [btrfs]
>        [<ffffffffa00fffeb>] copy_nocow_pages_worker+0x9b/0x160 [btrfs]
>        [<ffffffffa00d9b1f>] worker_loop+0x13f/0x5b0 [btrfs]
>        [<ffffffff810abd36>] kthread+0xd6/0xe0
>        [<ffffffff8199f66c>] ret_from_fork+0x7c/0xb0
> -> #0 (sb_internal){.+.+..}:
>        [<ffffffff810e4f42>] __lock_acquire+0x1d12/0x1e10
>        [<ffffffff810e564a>] lock_acquire+0x8a/0x120
>        [<ffffffff8119d7ab>] __sb_start_write+0xdb/0x1c0
>        [<ffffffffa00abad6>] start_transaction+0x296/0x4f0 [btrfs]
>        [<ffffffffa00ac0e6>] btrfs_start_transaction+0x16/0x20 [btrfs]
>        [<ffffffffa00bd0a9>] btrfs_sync_file+0x139/0x2c0 [btrfs]
>        [<ffffffff811c9848>] do_fsync+0x58/0x80
>        [<ffffffff811c9adb>] SyS_fsync+0xb/0x10
>        [<ffffffff8199f712>] system_call_fastpath+0x16/0x1b
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>        CPU0                    CPU1
>        ----                    ----
>   lock(&sb->s_type->i_mutex_key#11);
>                                lock(sb_internal);
>                                lock(&sb->s_type->i_mutex_key#11);
>   lock(sb_internal);
>  *** DEADLOCK ***
> 1 lock held by xfs_io/30404:
>  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa00bd029>] btrfs_sync_file+0xb9/0x2c0 [btrfs]
> stack backtrace:
> CPU: 3 PID: 30404 Comm: xfs_io Not tainted 3.10.0+ #5
> Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0b 09/17/2012
>  ffffffff865d9790 ffff880804ef5bb8 ffffffff8198eaba ffff880804ef5c08
>  ffffffff81989a92 00000000000003d0 ffff880804ef5c98 ffff880804d786d0
>  ffff880804d78708 ffff880804d786d0 ffff880804d78000 0000000000000000
> Call Trace:
>  [<ffffffff8198eaba>] dump_stack+0x19/0x1b
>  [<ffffffff81989a92>] print_circular_bug+0x1fe/0x20f
>  [<ffffffff810e4f42>] __lock_acquire+0x1d12/0x1e10
>  [<ffffffff810e564a>] lock_acquire+0x8a/0x120
>  [<ffffffffa00abad6>] ? start_transaction+0x296/0x4f0 [btrfs]
>  [<ffffffff8119d7ab>] __sb_start_write+0xdb/0x1c0
>  [<ffffffffa00abad6>] ? start_transaction+0x296/0x4f0 [btrfs]
>  [<ffffffffa00c2db1>] ? btrfs_put_ordered_extent+0x71/0xd0 [btrfs]
>  [<ffffffffa00abad6>] ? start_transaction+0x296/0x4f0 [btrfs]
>  [<ffffffffa00ab939>] ? start_transaction+0xf9/0x4f0 [btrfs]
>  [<ffffffff811920ef>] ? kmem_cache_alloc+0xdf/0x1b0
>  [<ffffffffa00ab939>] ? start_transaction+0xf9/0x4f0 [btrfs]
>  [<ffffffffa00abad6>] start_transaction+0x296/0x4f0 [btrfs]
>  [<ffffffffa00ac0e6>] btrfs_start_transaction+0x16/0x20 [btrfs]
>  [<ffffffffa00bd0a9>] btrfs_sync_file+0x139/0x2c0 [btrfs]
>  [<ffffffff81997c49>] ? retint_swapgs+0xe/0x13
>  [<ffffffff811c9848>] do_fsync+0x58/0x80
>  [<ffffffff8144bd8e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff811c9adb>] SyS_fsync+0xb/0x10
>  [<ffffffff8199f712>] system_call_fastpath+0x16/0x1b
> 
> (gdb) list *(copy_nocow_pages_for_inode+0x105)
> 0x875d5 is in copy_nocow_pages_for_inode (fs/btrfs/scrub.c:3230).
> 3225            if (IS_ERR(inode))
> 3226                    return PTR_ERR(inode);
> 3227
> 3228            /* Avoid truncate/dio/punch hole.. */
> 3229            mutex_lock(&inode->i_mutex);
> 3230            inode_dio_wait(inode);
> 3231
> 3232            ret = 0;
> 3233            physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
> 3234            len = nocow_ctx->len;
> 
> 
>> - avoid the page copy vs truncate/punch hole
>> - check if the page is in the page cache or not
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/scrub.c | 23 ++++++++++++++++++++++-
>>  1 file changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 186ea82..4ba2a69 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -3224,6 +3224,11 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
>>  		return PTR_ERR(local_root);
>>  	}
>>  
>> +	if (btrfs_root_refs(&local_root->root_item) == 0) {
>> +		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
>> +		return -ENOENT;
>> +	}
>> +
>>  	key.type = BTRFS_INODE_ITEM_KEY;
>>  	key.objectid = inum;
>>  	key.offset = 0;
>> @@ -3232,12 +3237,16 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
>>  	if (IS_ERR(inode))
>>  		return PTR_ERR(inode);
>>  
>> +	/* Avoid truncate/dio/punch hole.. */
>> +	mutex_lock(&inode->i_mutex);
>> +	inode_dio_wait(inode);
>> +
>>  	ret = 0;
>>  	physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
>>  	len = nocow_ctx->len;
>>  	while (len >= PAGE_CACHE_SIZE) {
>>  		index = offset >> PAGE_CACHE_SHIFT;
>> -
>> +again:
>>  		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
>>  		if (!page) {
>>  			pr_err("find_or_create_page() failed\n");
>> @@ -3258,7 +3267,18 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
>>  				ret = err;
>>  				goto next_page;
>>  			}
>> +
>>  			lock_page(page);
>> +			/*
>> +			 * If the page has been remove from the page cache,
>> +			 * the data on it is meaningless, because it may be
>> +			 * old one, the new data may be written into the new
>> +			 * page in the page cache.
>> +			 */
>> +			if (page->mapping != inode->i_mapping) {
>> +				page_cache_release(page);
>> +				goto again;
>> +			}
>>  			if (!PageUptodate(page)) {
>>  				ret = -EIO;
>>  				goto next_page;
>> @@ -3280,6 +3300,7 @@ next_page:
>>  		len -= PAGE_CACHE_SIZE;
>>  	}
>>  out:
>> +	mutex_unlock(&inode->i_mutex);
>>  	iput(inode);
>>  	return ret;
>>  }
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

