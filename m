Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48309 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755836AbdJJSzF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 14:55:05 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9AIt5Qo016415
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Oct 2017 18:55:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9AIt4vV031354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Oct 2017 18:55:04 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9AIt4tf014493
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Oct 2017 18:55:04 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: avoid losing data raid profile when deleting a device
Date: Tue, 10 Oct 2017 11:53:05 -0600
Message-Id: <20171010175305.31633-1-bo.li.liu@oracle.com>
In-Reply-To: <20171009180128.23610-1-bo.li.liu@oracle.com>
References: <20171009180128.23610-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've avoided data losing raid profile when doing balance, but it
turns out that deleting a device could also result in the same
problem.

This fixes the problem by creating an empty data chunk before
relocating the data chunk.

Metadata/System chunk are supposed to have non-zero bytes all the time
so their raid profile is persistent.

Reported-by: James Alandt <James.Alandt@wdc.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---

v2: - return the correct error.
    - move helper ahead of __btrfs_balance().

 fs/btrfs/volumes.c | 84 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 65 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4a72c45..a74396d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3018,6 +3018,48 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * return 1 : allocate a data chunk successfully,
+ * return <0: errors during allocating a data chunk,
+ * return 0 : no need to allocate a data chunk.
+ */
+static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
+				      u64 chunk_offset)
+{
+	struct btrfs_block_group_cache *cache;
+	u64 bytes_used;
+	u64 chunk_type;
+
+	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	ASSERT(cache);
+	chunk_type = cache->flags;
+	btrfs_put_block_group(cache);
+
+	if (chunk_type & BTRFS_BLOCK_GROUP_DATA) {
+		spin_lock(&fs_info->data_sinfo->lock);
+		bytes_used = fs_info->data_sinfo->bytes_used;
+		spin_unlock(&fs_info->data_sinfo->lock);
+
+		if (!bytes_used) {
+			struct btrfs_trans_handle *trans;
+			int ret;
+
+			trans =	btrfs_join_transaction(fs_info->tree_root);
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
+
+			ret = btrfs_force_chunk_alloc(trans, fs_info,
+						      BTRFS_BLOCK_GROUP_DATA);
+			btrfs_end_transaction(trans);
+			if (ret < 0)
+				return ret;
+
+			return 1;
+		}
+	}
+	return 0;
+}
+
 static int insert_balance_item(struct btrfs_fs_info *fs_info,
 			       struct btrfs_balance_control *bctl)
 {
@@ -3476,7 +3518,6 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	u32 count_meta = 0;
 	u32 count_sys = 0;
 	int chunk_reserved = 0;
-	u64 bytes_used = 0;
 
 	/* step one make some room on all the devices */
 	devices = &fs_info->fs_devices->devices;
@@ -3635,28 +3676,21 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 			goto loop;
 		}
 
-		ASSERT(fs_info->data_sinfo);
-		spin_lock(&fs_info->data_sinfo->lock);
-		bytes_used = fs_info->data_sinfo->bytes_used;
-		spin_unlock(&fs_info->data_sinfo->lock);
-
-		if ((chunk_type & BTRFS_BLOCK_GROUP_DATA) &&
-		    !chunk_reserved && !bytes_used) {
-			trans = btrfs_start_transaction(chunk_root, 0);
-			if (IS_ERR(trans)) {
-				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
-				ret = PTR_ERR(trans);
-				goto error;
-			}
-
-			ret = btrfs_force_chunk_alloc(trans, fs_info,
-						      BTRFS_BLOCK_GROUP_DATA);
-			btrfs_end_transaction(trans);
+		if (!chunk_reserved) {
+			/*
+			 * We may be relocating the only data chunk we have,
+			 * which could potentially end up with losing data's
+			 * raid profile, so lets allocate an empty one in
+			 * advance.
+			 */
+			ret = btrfs_may_alloc_data_chunk(fs_info,
+							 found_key.offset);
 			if (ret < 0) {
 				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 				goto error;
+			} else if (ret == 1) {
+				chunk_reserved = 1;
 			}
-			chunk_reserved = 1;
 		}
 
 		ret = btrfs_relocate_chunk(fs_info, found_key.offset);
@@ -4419,6 +4453,18 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		chunk_offset = btrfs_dev_extent_chunk_offset(l, dev_extent);
 		btrfs_release_path(path);
 
+		/*
+		 * We may be relocating the only data chunk we have,
+		 * which could potentially end up with losing data's
+		 * raid profile, so lets allocate an empty one in
+		 * advance.
+		 */
+		ret = btrfs_may_alloc_data_chunk(fs_info, chunk_offset);
+		if (ret < 0) {
+			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			goto done;
+		}
+
 		ret = btrfs_relocate_chunk(fs_info, chunk_offset);
 		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 		if (ret && ret != -ENOSPC)
-- 
2.9.4

