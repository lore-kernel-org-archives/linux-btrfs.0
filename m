Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50582 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeA3Hkz (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 30 Jan 2018 02:40:55 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 2/3] btrfs: Unexport get_block_group_index()
Date: Tue, 30 Jan 2018 15:40:38 +0800
Message-Id: <20180130074039.24987-2-wqu@suse.com>
In-Reply-To: <20180130074039.24987-1-wqu@suse.com>
References: <20180130074039.24987-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That function is only used inside extent-tree.c.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       | 1 -
 fs/btrfs/extent-tree.c | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 13c260b525a1..27249240fa3e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2629,7 +2629,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 u64 bytenr);
 void btrfs_get_block_group(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
-int get_block_group_index(struct btrfs_block_group_cache *cache);
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     u64 parent, u64 root_objectid,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e9c31b567a9c..6e1128aa29d6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7346,7 +7346,8 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 	return ret;
 }
 
-int get_block_group_index(struct btrfs_block_group_cache *cache)
+static enum btrfs_raid_types
+get_block_group_index(struct btrfs_block_group_cache *cache)
 {
 	return btrfs_bg_flags_to_raid_index(cache->flags);
 }
-- 
2.16.1

