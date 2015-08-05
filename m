Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28845 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185AbbHEKBy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 06:01:54 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t759xm0u021992
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Aug 2015 17:59:48 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: Cleanup: Remove chunk_objectid argument from btrfs_relocate_chunk()
Date: Wed, 5 Aug 2015 18:00:04 +0800
Message-ID: <c99521398156d533c225f99a12b9dbd76e84bda1.1438768766.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
References: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove chunk_objectid argument from btrfs_relocate_chunk() because
it is not necessary, it can also cleanup some code in caller for
prepare its value.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 66f5a15..c3977ed 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2755,9 +2755,7 @@ out:
 	return ret;
 }
 
-static int btrfs_relocate_chunk(struct btrfs_root *root,
-				u64 chunk_objectid,
-				u64 chunk_offset)
+static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
 {
 	struct btrfs_root *extent_root;
 	struct btrfs_trans_handle *trans;
@@ -2857,7 +2855,6 @@ again:
 
 		if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) {
 			ret = btrfs_relocate_chunk(chunk_root,
-						   found_key.objectid,
 						   found_key.offset);
 			if (ret == -ENOSPC)
 				failed++;
@@ -3377,7 +3374,6 @@ again:
 		}
 
 		ret = btrfs_relocate_chunk(chunk_root,
-					   found_key.objectid,
 					   found_key.offset);
 		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 		if (ret && ret != -ENOSPC)
@@ -4079,7 +4075,6 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
 	u64 length;
-	u64 chunk_objectid;
 	u64 chunk_offset;
 	int ret;
 	int slot;
@@ -4156,11 +4151,10 @@ again:
 			break;
 		}
 
-		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
 		chunk_offset = btrfs_dev_extent_chunk_offset(l, dev_extent);
 		btrfs_release_path(path);
 
-		ret = btrfs_relocate_chunk(root, chunk_objectid, chunk_offset);
+		ret = btrfs_relocate_chunk(root, chunk_offset);
 		mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
 		if (ret && ret != -ENOSPC)
 			goto done;
-- 
1.8.5.1

