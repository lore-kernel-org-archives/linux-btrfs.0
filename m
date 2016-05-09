Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38229 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbcEIWOA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 18:14:00 -0400
Date: Mon, 9 May 2016 15:15:46 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: fix race in relocation that makes us miss
 extents
Message-ID: <20160509221546.GD4954@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1461546072-11154-1-git-send-email-fdmanana@kernel.org>
 <1461546072-11154-2-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461546072-11154-2-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2016 at 02:01:10AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Before it starts the actual process of moving extents, relocation first
> sets the block group to read only mode, to prevent tasks from allocating
> new extents from it, and then flushes delalloc and waits for any ordered
> extents to complete. The flushing is done to synchronize with tasks that
> are running concurrently and have allocated an extent from the block group
> right before we set it to readonly mode but have not yet created the
> respective ordered extent (i.e. tasks that started flushing delalloc).
> 
> Even though we wait for the ordered extents to complete, this is not
> enough to guarantee we will process (relocate) the respective extents,
> because the extent items are added to extent tree only when delayed
> references are run and we search for extents through the extent tree's
> commit root. Therefore we need to commit the current transaction if we
> waited for any ordered extents, otherwise we will miss extent items in
> find_next_extent() unless by chance the transaction used to complete
> the ordered extents is committed by some other concurrent task before
> we start scanning for extents in the extent tree.
> 
> The race is illustrated by the following diagram:
> 
>           CPU 1                                          CPU 2                                 CPU 3
> 
>                                               does buffered write against
>                                               inode I
> 
>  btrfs_relocate_block_group(bg X)
> 
>                                               starts flushing delalloc
> 
>                                               extent_writepages()
>                                                 extent_write_cache_pages()
>                                                   locks first page in range
>                                                   __extent_writepage()
>                                                     writepage_delalloc()
>                                                       run_delalloc_range()
>                                                         cow_file_range()
>                                                           btrfs_reserve_extent()
>                                                             --> reserves extent
>                                                                 from bg X
> 
>    sets bg X to RO
> 
>    btrfs_start_delalloc_roots()
>      __start_delalloc_inodes()
>        btrfs_alloc_delalloc_work()
>          queues job to run
>          btrfs_run_delalloc_work(inode I)
>          at CPU 3
> 
>        waits for job at CPU 3 to complete
> 
>                                                                                              btrfs_run_delalloc_work(inode I)
>                                                                                                filemap_flush()
>                                                                                                  writepages()
>                                                                                                    extent_writepages()
>                                                                                                      extent_write_cache_pages()
>                                                                                                        --> blocks when trying to
>                                                                                                            lock first page in range
> 
>                                                           btrfs_add_ordered_extent(oe O)
> 
>                                                           clears EXTENT_DELALLOC bit from
>                                                           the range
> 
>                                                   unlocks first page in range
> 
>                                                                                                      gets lock on page
>                                                                                                      leaves and unlocks the page
>                                                                                                      because it's under writeback
> 
>    btrfs_wait_ordered_roots()
>      btrfs_wait_ordered_extents()
>        --> waits for ordered extent O to
>            complete
> 
>                                                                                                      ordered extent O completes
>                                                                                                      (btrfs_finish_ordered_io())
>                                                                                                      using transaction N to update
>                                                                                                      the subvol and csum trees
> 
>    at this point transaction N is still the current
>    transaction, it hasn't been committed yet nor
>    did its delayed references got run, meaning there
>    isn't yet an extent item in the extent tree for
>    the extent that ordered extent O used
> 
>    we're at rc->stage == MOVE_DATA_EXTENTS
> 
>    relocate_block_group(bg X)
>      find_next_extent()
>        --> searches the extent tree for extent items
>            using the commit root
>        --> transaction N still not committed so it
>            misses the extent from ordered extent O
> 
> When this happens we end up not moving the extent resulting in the
> following trace/warning once the relocation finishes:
> 
> [ 7260.832836] ------------[ cut here ]------------
> [ 7260.834653] WARNING: CPU: 5 PID: 6765 at fs/btrfs/relocation.c:4318 btrfs_relocate_block_group+0x245/0x2a1 [btrfs]()
> [ 7260.838268] Modules linked in: btrfs crc32c_generic xor ppdev raid6_pq psmouse sg acpi_cpufreq evdev i2c_piix4 tpm_tis serio_raw tpm i2c_core pcspkr parport_pc parport processor button loop autofs4 ext4 crc16 mbcache jbd2 sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring e1000 virtio scsi_mod floppy [last unloaded: btrfs]
> [ 7260.850935] CPU: 5 PID: 6765 Comm: btrfs Not tainted 4.5.0-rc6-btrfs-next-28+ #1
> [ 7260.852998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS by qemu-project.org 04/01/2014
> [ 7260.852998]  0000000000000000 ffff88020bf57bc0 ffffffff812648b3 0000000000000000
> [ 7260.852998]  0000000000000009 ffff88020bf57bf8 ffffffff81051608 ffffffffa03c1b2d
> [ 7260.852998]  ffff8800b2bbb800 0000000000000000 ffff8800b17bcc58 ffff8800399dd000
> [ 7260.852998] Call Trace:
> [ 7260.852998]  [<ffffffff812648b3>] dump_stack+0x67/0x90
> [ 7260.852998]  [<ffffffff81051608>] warn_slowpath_common+0x99/0xb2
> [ 7260.852998]  [<ffffffffa03c1b2d>] ? btrfs_relocate_block_group+0x245/0x2a1 [btrfs]
> [ 7260.852998]  [<ffffffff810516d4>] warn_slowpath_null+0x1a/0x1c
> [ 7260.852998]  [<ffffffffa03c1b2d>] btrfs_relocate_block_group+0x245/0x2a1 [btrfs]
> [ 7260.852998]  [<ffffffffa039d9de>] btrfs_relocate_chunk.isra.29+0x66/0xdb [btrfs]
> [ 7260.852998]  [<ffffffffa039f314>] btrfs_balance+0xde1/0xe4e [btrfs]
> [ 7260.852998]  [<ffffffff8127d671>] ? debug_smp_processor_id+0x17/0x19
> [ 7260.852998]  [<ffffffffa03a9583>] btrfs_ioctl_balance+0x255/0x2d3 [btrfs]
> [ 7260.852998]  [<ffffffffa03ac96a>] btrfs_ioctl+0x11e0/0x1dff [btrfs]
> [ 7260.852998]  [<ffffffff811451df>] ? handle_mm_fault+0x443/0xd63
> [ 7260.852998]  [<ffffffff81491817>] ? _raw_spin_unlock+0x31/0x44
> [ 7260.852998]  [<ffffffff8108b36a>] ? arch_local_irq_save+0x9/0xc
> [ 7260.852998]  [<ffffffff811876ab>] vfs_ioctl+0x18/0x34
> [ 7260.852998]  [<ffffffff81187cb2>] do_vfs_ioctl+0x550/0x5be
> [ 7260.852998]  [<ffffffff81190c30>] ? __fget_light+0x4d/0x71
> [ 7260.852998]  [<ffffffff81187d77>] SyS_ioctl+0x57/0x79
> [ 7260.852998]  [<ffffffff81492017>] entry_SYSCALL_64_fastpath+0x12/0x6b
> [ 7260.893268] ---[ end trace eb7803b24ebab8ad ]---
> 
> It is triggered because after the first stage of the relocation (rc->stage
> == MOVE_DATA_EXTENTS), we commit the current transaction and then the
> second time we call relocate_block_group() (rc->stage == UPDATE_DATA_PTRS),
> we have flushed and waited for delalloc on the relocation inode, but since
> we didn't find and move the extent in the first stage, the block group
> still has a non zero number of used bytes and therefore it triggers a
> warning at the end of btrfs_relocate_block_group().
> 
> Later on when trying to read the extent contents from disk we hit a
> BUG_ON() due to the inability to map a block with a logical address that
> belongs to the block group we relocated and is no longer valid, resulting
> in the following trace:
> 
> [ 7344.885290] BTRFS critical (device sdi): unable to find logical 12845056 len 4096
> [ 7344.887518] ------------[ cut here ]------------
> [ 7344.888431] kernel BUG at fs/btrfs/inode.c:1833!
> [ 7344.888431] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 7344.888431] Modules linked in: btrfs crc32c_generic xor ppdev raid6_pq psmouse sg acpi_cpufreq evdev i2c_piix4 tpm_tis serio_raw tpm i2c_core pcspkr parport_pc parport processor button loop autofs4 ext4 crc16 mbcache jbd2 sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring e1000 virtio scsi_mod floppy [last unloaded: btrfs]
> [ 7344.888431] CPU: 0 PID: 6831 Comm: od Tainted: G        W       4.5.0-rc6-btrfs-next-28+ #1
> [ 7344.888431] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS by qemu-project.org 04/01/2014
> [ 7344.888431] task: ffff880215818600 ti: ffff880204684000 task.ti: ffff880204684000
> [ 7344.888431] RIP: 0010:[<ffffffffa037c88c>]  [<ffffffffa037c88c>] btrfs_merge_bio_hook+0x54/0x6b [btrfs]
> [ 7344.888431] RSP: 0018:ffff8802046878f0  EFLAGS: 00010282
> [ 7344.888431] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000001
> [ 7344.888431] RDX: ffff88023ec0f950 RSI: ffffffff8183b638 RDI: 00000000ffffffff
> [ 7344.888431] RBP: ffff880204687908 R08: 0000000000000001 R09: 0000000000000000
> [ 7344.888431] R10: ffff880204687770 R11: ffffffff82f2d52d R12: 0000000000001000
> [ 7344.888431] R13: ffff88021afbfee8 R14: 0000000000006208 R15: ffff88006cd199b0
> [ 7344.888431] FS:  00007f1f9e1d6700(0000) GS:ffff88023ec00000(0000) knlGS:0000000000000000
> [ 7344.888431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7344.888431] CR2: 00007f1f9dc8cb60 CR3: 000000023e3b6000 CR4: 00000000000006f0
> [ 7344.888431] Stack:
> [ 7344.888431]  0000000000001000 0000000000001000 ffff880204687b98 ffff880204687950
> [ 7344.888431]  ffffffffa0395c8f ffffea0004d64d48 0000000000000000 0000000000001000
> [ 7344.888431]  ffffea0004d64d48 0000000000001000 0000000000000000 0000000000000000
> [ 7344.888431] Call Trace:
> [ 7344.888431]  [<ffffffffa0395c8f>] submit_extent_page+0xf5/0x16f [btrfs]
> [ 7344.888431]  [<ffffffffa03970ac>] __do_readpage+0x4a0/0x4f1 [btrfs]
> [ 7344.888431]  [<ffffffffa039680d>] ? btrfs_create_repair_bio+0xcb/0xcb [btrfs]
> [ 7344.888431]  [<ffffffffa037eeb4>] ? btrfs_writepage_start_hook+0xbc/0xbc [btrfs]
> [ 7344.888431]  [<ffffffff8108df55>] ? trace_hardirqs_on+0xd/0xf
> [ 7344.888431]  [<ffffffffa039728c>] __do_contiguous_readpages.constprop.26+0xc2/0xe4 [btrfs]
> [ 7344.888431]  [<ffffffffa037eeb4>] ? btrfs_writepage_start_hook+0xbc/0xbc [btrfs]
> [ 7344.888431]  [<ffffffffa039739b>] __extent_readpages.constprop.25+0xed/0x100 [btrfs]
> [ 7344.888431]  [<ffffffff81129d24>] ? lru_cache_add+0xe/0x10
> [ 7344.888431]  [<ffffffffa0397ea8>] extent_readpages+0x160/0x1aa [btrfs]
> [ 7344.888431]  [<ffffffffa037eeb4>] ? btrfs_writepage_start_hook+0xbc/0xbc [btrfs]
> [ 7344.888431]  [<ffffffff8115daad>] ? alloc_pages_current+0xa9/0xcd
> [ 7344.888431]  [<ffffffffa037cdc9>] btrfs_readpages+0x1f/0x21 [btrfs]
> [ 7344.888431]  [<ffffffff81128316>] __do_page_cache_readahead+0x168/0x1fc
> [ 7344.888431]  [<ffffffff811285a0>] ondemand_readahead+0x1f6/0x207
> [ 7344.888431]  [<ffffffff811285a0>] ? ondemand_readahead+0x1f6/0x207
> [ 7344.888431]  [<ffffffff8111cf34>] ? pagecache_get_page+0x2b/0x154
> [ 7344.888431]  [<ffffffff8112870e>] page_cache_sync_readahead+0x3d/0x3f
> [ 7344.888431]  [<ffffffff8111dbf7>] generic_file_read_iter+0x197/0x4e1
> [ 7344.888431]  [<ffffffff8117773a>] __vfs_read+0x79/0x9d
> [ 7344.888431]  [<ffffffff81178050>] vfs_read+0x8f/0xd2
> [ 7344.888431]  [<ffffffff81178a38>] SyS_read+0x50/0x7e
> [ 7344.888431]  [<ffffffff81492017>] entry_SYSCALL_64_fastpath+0x12/0x6b
> [ 7344.888431] Code: 8d 4d e8 45 31 c9 45 31 c0 48 8b 00 48 c1 e2 09 48 8b 80 80 fc ff ff 4c 89 65 e8 48 8b b8 f0 01 00 00 e8 1d 42 02 00 85 c0 79 02 <0f> 0b 4c 01 e3 31 c0 48 3b 5d e8 5a 5b 41 5c 0f 97 c0 5d c3 31
> [ 7344.888431] RIP  [<ffffffffa037c88c>] btrfs_merge_bio_hook+0x54/0x6b [btrfs]
> [ 7344.888431]  RSP <ffff8802046878f0>
> [ 7344.970544] ---[ end trace eb7803b24ebab8ae ]---
> 
> So if we waited for any ordered extents, make sure we attach to the
> current transaction and commit it. Another patch in the series makes
> sure that we only wait for ordered extents against extents located
> in our block group instead of any ordered extent.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ordered-data.c |  6 +++++-
>  fs/btrfs/ordered-data.h |  2 +-
>  fs/btrfs/relocation.c   | 24 +++++++++++++++++++++++-
>  3 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 0de7da5..41101b2 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -708,11 +708,12 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
>  	return count;
>  }
>  
> -void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
> +int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
>  {
>  	struct btrfs_root *root;
>  	struct list_head splice;
>  	int done;
> +	int total_done = 0;
>  
>  	INIT_LIST_HEAD(&splice);
>  
> @@ -730,6 +731,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
>  
>  		done = btrfs_wait_ordered_extents(root, nr);
>  		btrfs_put_fs_root(root);
> +		total_done += done;
>  
>  		spin_lock(&fs_info->ordered_root_lock);
>  		if (nr != -1) {
> @@ -740,6 +742,8 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
>  	list_splice_tail(&splice, &fs_info->ordered_roots);
>  	spin_unlock(&fs_info->ordered_root_lock);
>  	mutex_unlock(&fs_info->ordered_operations_mutex);
> +
> +	return total_done;
>  }
>  
>  /*
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 23c9605..f29e08e 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -198,7 +198,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
>  int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
>  			   u32 *sum, int len);
>  int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr);
> -void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr);
> +int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr);
>  void btrfs_get_logged_extents(struct inode *inode,
>  			      struct list_head *logged_list,
>  			      const loff_t start,
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 2bd0011..f689be2 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4258,7 +4258,29 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>  		err = ret;
>  		goto out;
>  	}
> -	btrfs_wait_ordered_roots(fs_info, -1);
> +	ret = btrfs_wait_ordered_roots(fs_info, -1);
> +	/*
> +	 * We might have waited for an ordered extent to complete which was
> +	 * destined at an extent allocated from our block group. The extent item
> +	 * is only added to the extent tree after delayed references are run
> +	 * and it won't be accessible through the extent tree's commit root
> +	 * unless we commit the current transaction (the one the ordered extent
> +	 * used to update the subvol and csum trees).
> +	 * We always search for extents using the extent tree's commit root,
> +	 * with find_next_extent(), so we do this transaction commit to make
> +	 * sure we don't miss any extents.
> +	 */
> +	if (ret > 0) {
> +		struct btrfs_trans_handle *trans;
> +
> +		trans = btrfs_attach_transaction(extent_root);
> +		if (IS_ERR(trans) && PTR_ERR(trans) != -ENOENT)
> +			err = PTR_ERR(trans);
> +		else if (!IS_ERR(trans))
> +			err = btrfs_commit_transaction(trans, extent_root);
> +		if (err)
> +			goto out;
> +	}

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

>  
>  	while (1) {
>  		mutex_lock(&fs_info->cleaner_mutex);
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
