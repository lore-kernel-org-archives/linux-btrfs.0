Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:50828 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751085AbeE1Gah (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 02:30:37 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 46EAD4B34D40
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 14:30:33 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: drop unused space_info parameter from create_space_info
Date: Mon, 28 May 2018 14:30:27 +0800
Message-ID: <20180528063027.4527-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit dc2d3005d27d ("btrfs: remove dead create_space_info
calls"), there is only one caller btrfs_init_space_info. However, it
doesn't need create_space_info to return space_info at all.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2c65a09535b6..31627de751d1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4007,8 +4007,7 @@ static const char *alloc_name(u64 flags)
 	};
 }
 
-static int create_space_info(struct btrfs_fs_info *info, u64 flags,
-			     struct btrfs_space_info **new)
+static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 {
 
 	struct btrfs_space_info *space_info;
@@ -4046,7 +4045,6 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags,
 		return ret;
 	}
 
-	*new = space_info;
 	list_add_rcu(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		info->data_sinfo = space_info;
@@ -10810,7 +10808,6 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_space_info *space_info;
 	struct btrfs_super_block *disk_super;
 	u64 features;
 	u64 flags;
@@ -10826,21 +10823,21 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 		mixed = 1;
 
 	flags = BTRFS_BLOCK_GROUP_SYSTEM;
-	ret = create_space_info(fs_info, flags, &space_info);
+	ret = create_space_info(fs_info, flags);
 	if (ret)
 		goto out;
 
 	if (mixed) {
 		flags = BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA;
-		ret = create_space_info(fs_info, flags, &space_info);
+		ret = create_space_info(fs_info, flags);
 	} else {
 		flags = BTRFS_BLOCK_GROUP_METADATA;
-		ret = create_space_info(fs_info, flags, &space_info);
+		ret = create_space_info(fs_info, flags);
 		if (ret)
 			goto out;
 
 		flags = BTRFS_BLOCK_GROUP_DATA;
-		ret = create_space_info(fs_info, flags, &space_info);
+		ret = create_space_info(fs_info, flags);
 	}
 out:
 	return ret;
-- 
2.17.0



