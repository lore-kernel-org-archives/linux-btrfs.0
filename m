Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:49203 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933864AbeEIKfu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 06:35:50 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] btrfs: fix invalid memory access with journal_info
Date: Wed,  9 May 2018 18:35:25 +0800
Message-Id: <1525862125-15228-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

When send process requires memory allocation, shrinker may be triggered
due to insufficient memory.
Then evict_inode gets called when inode is freed, and this function
may need to start transaction.
However, the journal_info is already points to BTRFS_SEND_TRANS_STUB, it
passed the if condition,
and the following use yields illegal memory access.

  if (current->journal_info) {
      WARN_ON(type & TRANS_EXTWRITERS);
      h = current->journal_info;
      refcount_inc(&h->use_count);
      WARN_ON(refcount_read(&h->use_count) > 2);
      h->orig_rsv = h->block_rsv;
      h->block_rsv = NULL;
      goto got_it;
  }

Direct IO has a similar problem, journal_info will store btrfs_dio_data,
which will lead to illegal memory access.

We fixed the problem by save the journal_info and restore afterwards.

CallTrace looks like this:
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000021
 IP: [<ffffffffa086f2d4>] start_transaction+0x64/0x450 [btrfs]
 PGD 8fea4b067 PUD a33bea067 PMD 0
 Oops: 0000 [#1] SMP
 CPU: 3 PID: 12681 Comm: btrfs Tainted: P C O 3.10.102 #15266
 RIP: 0010:[<ffffffffa086f2d4>] start_transaction+0x64/0x450 [btrfs]
 Call Trace:
 [<ffffffffa087a838>] ? btrfs_evict_inode+0x3d8/0x580 [btrfs]
 [<ffffffff81115932>] ? evict+0xa2/0x1a0
 [<ffffffff81112888>] ? shrink_dentry_list+0x308/0x3d0
 [<ffffffff811137f3>] ? prune_dcache_sb+0x133/0x160
 [<ffffffff810fa51f>] ? prune_super+0xcf/0x1a0
 [<ffffffff810bf6bf>] ? shrink_slab+0x11f/0x1d0
 [<ffffffff810c19f2>] ? do_try_to_free_pages+0x452/0x560
 [<ffffffff810bf054>] ? throttle_direct_reclaim+0x74/0x240
 [<ffffffff810c1bae>] ? try_to_free_pages+0xae/0xc0
 [<ffffffff810ba16b>] ? __alloc_pages_nodemask+0x53b/0x9f0
 [<ffffffff810bc89c>] ? __do_page_cache_readahead+0xec/0x270
 [<ffffffff810bcb2b>] ? ondemand_readahead+0xbb/0x220
 [<ffffffffa08d7c43>] ? fill_read_buf+0x2b3/0x3a0 [btrfs]
 [<ffffffffa08dbf5e>] ? send_extent_data+0x10e/0x300 [btrfs]
 [<ffffffffa08dc34b>] ? process_extent+0x1fb/0x1310 [btrfs]
 [<ffffffffa08d8300>] ? iterate_dir_item.isra.28+0x1b0/0x250 [btrfs]
 [<ffffffffa08dd500>] ? send_set_xattr+0xa0/0xa0 [btrfs]
 [<ffffffffa08de565>] ? changed_cb+0xd5/0xc40 [btrfs]
 [<ffffffffa08df1c2>] ? full_send_tree+0xf2/0x1a0 [btrfs]
 [<ffffffffa08e022b>] ? btrfs_ioctl_send+0xfbb/0x1040 [btrfs]
 [<ffffffffa08a9864>] ? btrfs_ioctl+0x1084/0x32a0 [btrfs]

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f534701..77aec8d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5295,6 +5295,7 @@ void btrfs_evict_inode(struct inode *inode)
 	int steal_from_global = 0;
 	u64 min_size;
 	int ret;
+	void *journal_info = NULL;
 
 	trace_btrfs_inode_evict(inode);
 
@@ -5303,6 +5304,16 @@ void btrfs_evict_inode(struct inode *inode)
 		return;
 	}
 
+	/*
+	 * Send or Direct IO may store information in journal_info.
+	 * However, this function may use start_transaction and
+	 * start_transaction will use journal_info.
+	 * To avoid accessing invalid memory, we can save the journal_info
+	 * and restore it later.
+	 */
+	journal_info = current->journal_info;
+	current->journal_info = NULL;
+
 	min_size = btrfs_calc_trunc_metadata_size(fs_info, 1);
 
 	evict_inode_truncate_pages(inode);
@@ -5462,6 +5473,7 @@ void btrfs_evict_inode(struct inode *inode)
 no_delete:
 	btrfs_remove_delayed_node(BTRFS_I(inode));
 	clear_inode(inode);
+	current->journal_info = journal_info;
 }
 
 /*
-- 
1.9.1

