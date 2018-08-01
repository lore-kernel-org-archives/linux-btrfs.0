Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbeHAEU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 00:20:59 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6DE7AE2E
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 02:37:42 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/6] btrfs: Remove unused function btrfs_account_dev_extents_size()
Date: Wed,  1 Aug 2018 10:37:18 +0800
Message-Id: <20180801023721.32143-4-wqu@suse.com>
In-Reply-To: <20180801023721.32143-1-wqu@suse.com>
References: <20180801023721.32143-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is never used by any one in kernel, just remove it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 85 ----------------------------------------------
 fs/btrfs/volumes.h |  2 --
 2 files changed, 87 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b33bf29130b6..e6a8e4aabc66 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1259,91 +1259,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	return ret;
 }
 
-/* helper to account the used device space in the range */
-int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
-				   u64 end, u64 *length)
-{
-	struct btrfs_key key;
-	struct btrfs_root *root = device->fs_info->dev_root;
-	struct btrfs_dev_extent *dev_extent;
-	struct btrfs_path *path;
-	u64 extent_end;
-	int ret;
-	int slot;
-	struct extent_buffer *l;
-
-	*length = 0;
-
-	if (start >= device->total_bytes ||
-		test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
-		return 0;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	path->reada = READA_FORWARD;
-
-	key.objectid = device->devid;
-	key.offset = start;
-	key.type = BTRFS_DEV_EXTENT_KEY;
-
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-	if (ret > 0) {
-		ret = btrfs_previous_item(root, path, key.objectid, key.type);
-		if (ret < 0)
-			goto out;
-	}
-
-	while (1) {
-		l = path->nodes[0];
-		slot = path->slots[0];
-		if (slot >= btrfs_header_nritems(l)) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret == 0)
-				continue;
-			if (ret < 0)
-				goto out;
-
-			break;
-		}
-		btrfs_item_key_to_cpu(l, &key, slot);
-
-		if (key.objectid < device->devid)
-			goto next;
-
-		if (key.objectid > device->devid)
-			break;
-
-		if (key.type != BTRFS_DEV_EXTENT_KEY)
-			goto next;
-
-		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
-		extent_end = key.offset + btrfs_dev_extent_length(l,
-								  dev_extent);
-		if (key.offset <= start && extent_end > end) {
-			*length = end - start + 1;
-			break;
-		} else if (key.offset <= start && extent_end > start)
-			*length += extent_end - start;
-		else if (key.offset > start && extent_end <= end)
-			*length += extent_end - key.offset;
-		else if (key.offset > start && key.offset <= end) {
-			*length += end - key.offset + 1;
-			break;
-		} else if (key.offset > end)
-			break;
-
-next:
-		path->slots[0]++;
-	}
-	ret = 0;
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
 static int contains_pending_extent(struct btrfs_transaction *transaction,
 				   struct btrfs_device *device,
 				   u64 *start, u64 len)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 77e6004b6cb9..6d4f38ad9f5c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -384,8 +384,6 @@ static inline enum btrfs_map_op btrfs_op(struct bio *bio)
 	}
 }
 
-int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
-				   u64 end, u64 *length);
 void btrfs_get_bbio(struct btrfs_bio *bbio);
 void btrfs_put_bbio(struct btrfs_bio *bbio);
 int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
-- 
2.18.0

