Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbaEOBTn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 21:19:43 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4F1JHb5006738
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 09:19:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: fix NULL pointer crash when running balance and scrub concurrently
Date: Thu, 15 May 2014 09:20:18 +0800
Message-ID: <1400116818-14811-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1400116818-14811-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1400116818-14811-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

While running balance, scrub, fsstress concurrently we hit the
following kernel crash:

[56561.448845] BTRFS info (device sde): relocating block group 11005853696 flags 132
[56561.524077] BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
[56561.524237] IP: [<ffffffffa038956d>] scrub_chunk.isra.12+0xdd/0x130 [btrfs]
[56561.524297] PGD 9be28067 PUD 7f3dd067 PMD 0
[56561.524325] Oops: 0000 [#1] SMP
[....]
[56561.527237] Call Trace:
[56561.527309]  [<ffffffffa038980e>] scrub_enumerate_chunks+0x24e/0x490 [btrfs]
[56561.527392]  [<ffffffff810abe00>] ? abort_exclusive_wait+0x50/0xb0
[56561.527476]  [<ffffffffa038add4>] btrfs_scrub_dev+0x1a4/0x530 [btrfs]
[56561.527561]  [<ffffffffa0368107>] btrfs_ioctl+0x13f7/0x2a90 [btrfs]
[56561.527639]  [<ffffffff811c82f0>] do_vfs_ioctl+0x2e0/0x4c0
[56561.527712]  [<ffffffff8109c384>] ? vtime_account_user+0x54/0x60
[56561.527788]  [<ffffffff810f768c>] ? __audit_syscall_entry+0x9c/0xf0
[56561.527870]  [<ffffffff811c8551>] SyS_ioctl+0x81/0xa0
[56561.527941]  [<ffffffff815707f7>] tracesys+0xdd/0xe2
[...]
[56561.528304] RIP  [<ffffffffa038956d>] scrub_chunk.isra.12+0xdd/0x130 [btrfs]
[56561.528395]  RSP <ffff88004c0f5be8>
[56561.528454] CR2: 0000000000000078

This is because in btrfs_relocate_chunk(), we will free @bdev directly while
scrub may still hold extent mapping, and may access freed memory.

Fix this problem by wrapping freeing @bdev work into free_extent_map() which
is based on reference count.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |  2 ++
 fs/btrfs/extent_map.h |  1 +
 fs/btrfs/volumes.c    | 10 +++-------
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 1874aee..225302b 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -75,6 +75,8 @@ void free_extent_map(struct extent_map *em)
 	if (atomic_dec_and_test(&em->refs)) {
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
+		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
+			kfree(em->bdev);
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index e7fd8a5..b2991fd 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -15,6 +15,7 @@
 #define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
 #define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
 #define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
+#define EXTENT_FLAG_FS_MAPPING 6 /* filesystem extent mapping type */
 
 struct extent_map {
 	struct rb_node rb_node;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49d7fab..a7b9e85 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2490,9 +2490,6 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	remove_extent_mapping(em_tree, em);
 	write_unlock(&em_tree->lock);
 
-	kfree(map);
-	em->bdev = NULL;
-
 	/* once for the tree */
 	free_extent_map(em);
 	/* once for us */
@@ -4213,9 +4210,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	em = alloc_extent_map();
 	if (!em) {
+		kfree(map);
 		ret = -ENOMEM;
 		goto error;
 	}
+	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
 	em->bdev = (struct block_device *)map;
 	em->start = start;
 	em->len = num_bytes;
@@ -4258,7 +4257,6 @@ error_del_extent:
 	/* One for the tree reference */
 	free_extent_map(em);
 error:
-	kfree(map);
 	kfree(devices_info);
 	return ret;
 }
@@ -4470,7 +4468,6 @@ void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
 		write_unlock(&tree->map_tree.lock);
 		if (!em)
 			break;
-		kfree(em->bdev);
 		/* once for us */
 		free_extent_map(em);
 		/* once for the tree */
@@ -5734,6 +5731,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		return -ENOMEM;
 	}
 
+	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
 	em->bdev = (struct block_device *)map;
 	em->start = logical;
 	em->len = length;
@@ -5758,7 +5756,6 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		map->stripes[i].dev = btrfs_find_device(root->fs_info, devid,
 							uuid, NULL);
 		if (!map->stripes[i].dev && !btrfs_test_opt(root, DEGRADED)) {
-			kfree(map);
 			free_extent_map(em);
 			return -EIO;
 		}
@@ -5766,7 +5763,6 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			map->stripes[i].dev =
 				add_missing_dev(root, devid, uuid);
 			if (!map->stripes[i].dev) {
-				kfree(map);
 				free_extent_map(em);
 				return -EIO;
 			}
-- 
1.9.2

