Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37859 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeIKW6v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:58:51 -0400
Received: by mail-qk1-f194.google.com with SMTP id f17-v6so17316636qkh.4
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:26 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 08/36] btrfs: dump block_rsv whe dumping space info
Date: Tue, 11 Sep 2018 13:57:39 -0400
Message-Id: <20180911175807.26181-9-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For enospc_debug having the block rsvs is super helpful to see if we've
done something wrong.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a3baa16d456f..1cf66a92829b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7918,6 +7918,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static void dump_block_rsv(struct btrfs_fs_info *fs_info,
+			   struct btrfs_block_rsv *rsv)
+{
+	spin_lock(&rsv->lock);
+	btrfs_info(fs_info, "%d: size %llu reserved %llu\n",
+		   rsv->type, (unsigned long long)rsv->size,
+		   (unsigned long long)rsv->reserved);
+	spin_unlock(&rsv->lock);
+}
+
 static void dump_space_info(struct btrfs_fs_info *fs_info,
 			    struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups)
@@ -7937,6 +7947,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
 		info->bytes_readonly);
 	spin_unlock(&info->lock);
 
+	dump_block_rsv(fs_info, &fs_info->global_block_rsv);
+	dump_block_rsv(fs_info, &fs_info->trans_block_rsv);
+	dump_block_rsv(fs_info, &fs_info->chunk_block_rsv);
+	dump_block_rsv(fs_info, &fs_info->delayed_block_rsv);
+	dump_block_rsv(fs_info, &fs_info->delayed_refs_rsv);
+
 	if (!dump_block_groups)
 		return;
 
-- 
2.14.3
