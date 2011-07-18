From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: don't be as agressive with delalloc metadata reservations
Date: Mon, 18 Jul 2011 11:04:13 +0800
Message-ID: <4E23A2AD.8030901@cn.fujitsu.com>
References: <1310754551-30924-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310754551-30924-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/16/2011 02:29 AM, Josef Bacik wrote:
> Currently we reserve enough space to COW an entirely full btree for every extent
> we have reserved for an inode.  This _sucks_, because you only need to COW once,
> and then everybody else is ok.  Unfortunately we don't know we'll all be able to
> get into the same transaction so that's what we have had to do.  But the global
> reserve holds a reservation large enough to cover a large percentage of all the
> metadata currently in the fs.  So all we really need to account for is any new
> blocks that we may allocate.  So fix this by
> 
> 1) Passing to btrfs_alloc_free_block() wether this is a new block or a COW
> block.  If it is a COW block we use the global reserve, if not we use the
> trans->block_rsv.
> 2) Reduce the amount of space we reserve.  Since we don't need to account for
> cow'ing the tree we can just keep track of new blocks to reserve, which greatly
> reduces the reservation amount.
> 
> This makes my basic random write test go from 3 mb/s to 75 mb/s.  I've tested
> this with my horrible ENOSPC test and it seems to work out fine.  Thanks,
> 

Hi, Josef,

After I patched this and did a "tar xf source.tar", I got lots of warnings,

Would you like to look into this?

------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x178/0x340 [btrfs]()
Hardware name: QiTianM7150
Modules linked in: btrfs iptable_nat nf_nat zlib_deflate libcrc32c ebtable_nat ebtables bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod sg ppdev serio_raw pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support sky2 parport_pc parport ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
Pid: 16008, comm: umount Tainted: G        W   2.6.39+ #9
Call Trace:
 [<ffffffff81053baf>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81053c0a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa04d37d8>] btrfs_alloc_free_block+0x178/0x340 [btrfs]
 [<ffffffffa0501768>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
 [<ffffffffa04be625>] __btrfs_cow_block+0x155/0x5f0 [btrfs]
 [<ffffffffa04bebcb>] btrfs_cow_block+0x10b/0x240 [btrfs]
 [<ffffffffa04c4c8e>] btrfs_search_slot+0x49e/0x7a0 [btrfs]
 [<ffffffffa04d2399>] btrfs_write_dirty_block_groups+0x1a9/0x4d0 [btrfs]
 [<ffffffffa0512e20>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
 [<ffffffffa04df845>] commit_cowonly_roots+0x105/0x1e0 [btrfs]
 [<ffffffffa04e0708>] btrfs_commit_transaction+0x428/0x850 [btrfs]
 [<ffffffffa04df9b8>] ? wait_current_trans+0x28/0x100 [btrfs]
 [<ffffffffa04e0c25>] ? join_transaction+0x25/0x250 [btrfs]
 [<ffffffff81075590>] ? wake_up_bit+0x40/0x40
 [<ffffffffa04bb187>] btrfs_sync_fs+0x67/0xd0 [btrfs]
 [<ffffffff8116c27e>] __sync_filesystem+0x5e/0x90
 [<ffffffff8116c38b>] sync_filesystem+0x4b/0x70
 [<ffffffff811441c4>] generic_shutdown_super+0x34/0xf0
 [<ffffffff81144316>] kill_anon_super+0x16/0x60
 [<ffffffff81144a25>] deactivate_locked_super+0x45/0x70
 [<ffffffff8114568a>] deactivate_super+0x4a/0x70
 [<ffffffff8115efdc>] mntput_no_expire+0x13c/0x1c0
 [<ffffffff8115f7bb>] sys_umount+0x7b/0x3a0
 [<ffffffff81466b2b>] system_call_fastpath+0x16/0x1b
---[ end trace 9a65800674b03b84 ]---


thanks,
liubo


> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/ctree.c       |   10 +++++-----
>  fs/btrfs/ctree.h       |    5 ++---
>  fs/btrfs/disk-io.c     |    3 ++-
>  fs/btrfs/extent-tree.c |   20 +++++++++++++++-----
>  fs/btrfs/ioctl.c       |    2 +-
>  5 files changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 2e66786..fbd48e9 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -206,7 +206,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
>  
>  	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
>  				     new_root_objectid, &disk_key, level,
> -				     buf->start, 0);
> +				     buf->start, 0, 1);
>  	if (IS_ERR(cow))
>  		return PTR_ERR(cow);
>  
> @@ -412,7 +412,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>  
>  	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
>  				     root->root_key.objectid, &disk_key,
> -				     level, search_start, empty_size);
> +				     level, search_start, empty_size, 0);
>  	if (IS_ERR(cow))
>  		return PTR_ERR(cow);
>  
> @@ -1985,7 +1985,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
>  
>  	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
>  				   root->root_key.objectid, &lower_key,
> -				   level, root->node->start, 0);
> +				   level, root->node->start, 0, 1);
>  	if (IS_ERR(c))
>  		return PTR_ERR(c);
>  
> @@ -2112,7 +2112,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
>  
>  	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
>  					root->root_key.objectid,
> -					&disk_key, level, c->start, 0);
> +					&disk_key, level, c->start, 0, 1);
>  	if (IS_ERR(split))
>  		return PTR_ERR(split);
>  
> @@ -2937,7 +2937,7 @@ again:
>  
>  	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
>  					root->root_key.objectid,
> -					&disk_key, 0, l->start, 0);
> +					&disk_key, 0, l->start, 0, 1);
>  	if (IS_ERR(right))
>  		return PTR_ERR(right);
>  
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3ba4d5f..1accb56 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2135,8 +2135,7 @@ static inline bool btrfs_mixed_space_info(struct btrfs_space_info *space_info)
>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
>  						 unsigned num_items)
>  {
> -	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
> -		3 * num_items;
> +	return root->leafsize * 3 * num_items;
>  }
>  
>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
> @@ -2161,7 +2160,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
>  					struct btrfs_root *root, u32 blocksize,
>  					u64 parent, u64 root_objectid,
>  					struct btrfs_disk_key *key, int level,
> -					u64 hint, u64 empty_size);
> +					u64 hint, u64 empty_size, int new_block);
>  void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root,
>  			   struct extent_buffer *buf,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 234a084..0245cad 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1143,7 +1143,8 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
>  	root->ref_cows = 0;
>  
>  	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
> -				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
> +				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0,
> +				      1);
>  	if (IS_ERR(leaf)) {
>  		kfree(root);
>  		return ERR_CAST(leaf);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2e0f87b..e2dd833 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5661,13 +5661,23 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
>  
>  static struct btrfs_block_rsv *
>  use_block_rsv(struct btrfs_trans_handle *trans,
> -	      struct btrfs_root *root, u32 blocksize)
> +	      struct btrfs_root *root, u32 blocksize, int new_block)
>  {
> -	struct btrfs_block_rsv *block_rsv;
> +	struct btrfs_block_rsv *block_rsv = NULL;
>  	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
>  	int ret;
>  
> -	block_rsv = get_block_rsv(trans, root);
> +	if (root->ref_cows) {
> +		if (new_block)
> +			block_rsv = trans->block_rsv;
> +		else
> +			block_rsv = global_rsv;
> +	} else {
> +		block_rsv = root->block_rsv;
> +	}
> +
> +	if (!block_rsv)
> +		block_rsv = &root->fs_info->empty_block_rsv;
>  
>  	if (block_rsv->size == 0) {
>  		ret = reserve_metadata_bytes(trans, root, block_rsv,
> @@ -5726,7 +5736,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
>  					struct btrfs_root *root, u32 blocksize,
>  					u64 parent, u64 root_objectid,
>  					struct btrfs_disk_key *key, int level,
> -					u64 hint, u64 empty_size)
> +					u64 hint, u64 empty_size, int new_block)
>  {
>  	struct btrfs_key ins;
>  	struct btrfs_block_rsv *block_rsv;
> @@ -5735,7 +5745,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
>  	int ret;
>  
>  
> -	block_rsv = use_block_rsv(trans, root, blocksize);
> +	block_rsv = use_block_rsv(trans, root, blocksize, new_block);
>  	if (IS_ERR(block_rsv))
>  		return ERR_CAST(block_rsv);
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index fd252ff..39fb634 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -352,7 +352,7 @@ static noinline int create_subvol(struct btrfs_root *root,
>  	}
>  
>  	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
> -				      0, objectid, NULL, 0, 0, 0);
> +				      0, objectid, NULL, 0, 0, 0, 1);
>  	if (IS_ERR(leaf)) {
>  		ret = PTR_ERR(leaf);
>  		goto fail;

