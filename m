From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: fix wrong reservation when doing delayed inode
 operations
Date: Wed, 15 Jun 2011 18:47:30 +0800
Message-ID: <4DF88DC2.3050104@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have migrated the space for the delayed inode items from
trans_block_rsv to global_block_rsv, but we forgot to set trans->block_rsv to
global_block_rsv when we doing delayed inode operations, and the following Oops
happened:

[ 9792.654889] ------------[ cut here ]------------
[ 9792.654898] WARNING: at fs/btrfs/extent-tree.c:5681
btrfs_alloc_free_block+0xca/0x27c [btrfs]()
[ 9792.654899] Hardware name: To Be Filled By O.E.M.
[ 9792.654900] Modules linked in: btrfs zlib_deflate libcrc32c
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
arc4 rt61pci rt2x00pci rt2x00lib snd_hda_codec_hdmi mac80211
snd_hda_codec_realtek cfg80211 snd_hda_intel edac_core snd_seq rfkill
pcspkr serio_raw snd_hda_codec eeprom_93cx6 edac_mce_amd sp5100_tco
i2c_piix4 k10temp snd_hwdep snd_seq_device snd_pcm floppy r8169 xhci_hcd
mii snd_timer snd soundcore snd_page_alloc ipv6 firewire_ohci pata_acpi
ata_generic firewire_core pata_via crc_itu_t radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[ 9792.654919] Pid: 2762, comm: rm Tainted: G        W   2.6.39+ #1
[ 9792.654920] Call Trace:
[ 9792.654922]  [<ffffffff81053c4a>] warn_slowpath_common+0x83/0x9b
[ 9792.654925]  [<ffffffff81053c7c>] warn_slowpath_null+0x1a/0x1c
[ 9792.654933]  [<ffffffffa038e747>] btrfs_alloc_free_block+0xca/0x27c [btrfs]
[ 9792.654945]  [<ffffffffa03b8562>] ? map_extent_buffer+0x6e/0xa8 [btrfs]
[ 9792.654953]  [<ffffffffa038189b>] __btrfs_cow_block+0xfc/0x30c [btrfs]
[ 9792.654963]  [<ffffffffa0396aa6>] ? btrfs_buffer_uptodate+0x47/0x58 [btrfs]
[ 9792.654970]  [<ffffffffa0382e48>] ? read_block_for_search+0x94/0x368 [btrfs]
[ 9792.654978]  [<ffffffffa0381ba9>] btrfs_cow_block+0xfe/0x146 [btrfs]
[ 9792.654986]  [<ffffffffa03848b0>] btrfs_search_slot+0x14d/0x4b6 [btrfs]
[ 9792.654997]  [<ffffffffa03b8562>] ? map_extent_buffer+0x6e/0xa8 [btrfs]
[ 9792.655022]  [<ffffffffa03938e8>] btrfs_lookup_inode+0x2f/0x8f [btrfs]
[ 9792.655025]  [<ffffffff8147afac>] ? _cond_resched+0xe/0x22
[ 9792.655027]  [<ffffffff8147b892>] ? mutex_lock+0x29/0x50
[ 9792.655039]  [<ffffffffa03d41b1>] btrfs_update_delayed_inode+0x72/0x137 [btrfs]
[ 9792.655051]  [<ffffffffa03d4ea2>] btrfs_run_delayed_items+0x90/0xdb [btrfs]
[ 9792.655062]  [<ffffffffa039a69b>] btrfs_commit_transaction+0x228/0x654 [btrfs]
[ 9792.655064]  [<ffffffff8106e8da>] ? remove_wait_queue+0x3a/0x3a
[ 9792.655075]  [<ffffffffa03a2fa5>] btrfs_evict_inode+0x14d/0x202 [btrfs]
[ 9792.655077]  [<ffffffff81132bd6>] evict+0x71/0x111
[ 9792.655079]  [<ffffffff81132de0>] iput+0x12a/0x132
[ 9792.655081]  [<ffffffff8112aa3a>] do_unlinkat+0x106/0x155
[ 9792.655083]  [<ffffffff81127b83>] ? path_put+0x1f/0x23
[ 9792.655085]  [<ffffffff8109c53c>] ? audit_syscall_entry+0x145/0x171
[ 9792.655087]  [<ffffffff81128410>] ? putname+0x34/0x36
[ 9792.655090]  [<ffffffff8112b441>] sys_unlinkat+0x29/0x2b
[ 9792.655092]  [<ffffffff81482c42>] system_call_fastpath+0x16/0x1b
[ 9792.655093] ---[ end trace 02b696eb02b3f768 ]---

This patch fix it by setting the reservation of the transaction handle to the
correct one.

Besides that, we needn't hold the pointer of global_block_rsv because we can
access it by delayed_item->delayed_node->root->fs_info->global_block_rsv. So
clean up block_rsv in delayed items.

Reported-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c |   25 ++++++++++++++++++++-----
 fs/btrfs/delayed-inode.h |    1 -
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6462c29..fc515b7 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -297,7 +297,6 @@ struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
 		item->data_len = data_len;
 		item->ins_or_del = 0;
 		item->bytes_reserved = 0;
-		item->block_rsv = NULL;
 		item->delayed_node = NULL;
 		atomic_set(&item->refs, 1);
 	}
@@ -593,10 +592,8 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-	if (!ret) {
+	if (!ret)
 		item->bytes_reserved = num_bytes;
-		item->block_rsv = dst_rsv;
-	}
 
 	return ret;
 }
@@ -604,10 +601,13 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
 						struct btrfs_delayed_item *item)
 {
+	struct btrfs_block_rsv *rsv;
+
 	if (!item->bytes_reserved)
 		return;
 
-	btrfs_block_rsv_release(root, item->block_rsv,
+	rsv = &root->fs_info->global_block_rsv;
+	btrfs_block_rsv_release(root, rsv,
 				item->bytes_reserved);
 }
 
@@ -1014,6 +1014,7 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_root *delayed_root;
 	struct btrfs_delayed_node *curr_node, *prev_node;
 	struct btrfs_path *path;
+	struct btrfs_block_rsv *block_rsv;
 	int ret = 0;
 
 	path = btrfs_alloc_path();
@@ -1021,6 +1022,9 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	block_rsv = trans->block_rsv;
+	trans->block_rsv = &root->fs_info->global_block_rsv;
+
 	delayed_root = btrfs_get_delayed_root(root);
 
 	curr_node = btrfs_first_delayed_node(delayed_root);
@@ -1045,6 +1049,7 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_free_path(path);
+	trans->block_rsv = block_rsv;
 	return ret;
 }
 
@@ -1052,6 +1057,7 @@ static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 					      struct btrfs_delayed_node *node)
 {
 	struct btrfs_path *path;
+	struct btrfs_block_rsv *block_rsv;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -1059,6 +1065,9 @@ static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	block_rsv = trans->block_rsv;
+	trans->block_rsv = &node->root->fs_info->global_block_rsv;
+
 	ret = btrfs_insert_delayed_items(trans, path, node->root, node);
 	if (!ret)
 		ret = btrfs_delete_delayed_items(trans, path, node->root, node);
@@ -1066,6 +1075,7 @@ static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	btrfs_free_path(path);
 
+	trans->block_rsv = block_rsv;
 	return ret;
 }
 
@@ -1116,6 +1126,7 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	struct btrfs_path *path;
 	struct btrfs_delayed_node *delayed_node = NULL;
 	struct btrfs_root *root;
+	struct btrfs_block_rsv *block_rsv;
 	unsigned long nr = 0;
 	int need_requeue = 0;
 	int ret;
@@ -1134,6 +1145,9 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	if (IS_ERR(trans))
 		goto free_path;
 
+	block_rsv = trans->block_rsv;
+	trans->block_rsv = &root->fs_info->global_block_rsv;
+
 	ret = btrfs_insert_delayed_items(trans, path, root, delayed_node);
 	if (!ret)
 		ret = btrfs_delete_delayed_items(trans, path, root,
@@ -1176,6 +1190,7 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 
 	nr = trans->blocks_used;
 
+	trans->block_rsv = block_rsv;
 	btrfs_end_transaction_dmeta(trans, root);
 	__btrfs_btree_balance_dirty(root, nr);
 free_path:
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index eb7d240..cb79b67 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -75,7 +75,6 @@ struct btrfs_delayed_item {
 	struct list_head tree_list;	/* used for batch insert/delete items */
 	struct list_head readdir_list;	/* used for readdir items */
 	u64 bytes_reserved;
-	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_delayed_node *delayed_node;
 	atomic_t refs;
 	int ins_or_del;
-- 
1.7.4
