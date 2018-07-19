Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33243 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSPdu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:50 -0400
Received: by mail-qt0-f194.google.com with SMTP id c15-v6so7416270qtp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 08/22] btrfs: dump block_rsv whe dumping space info
Date: Thu, 19 Jul 2018 10:49:52 -0400
Message-Id: <20180719145006.17532-8-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For enospc_debug having the block rsvs is super helpful to see if we've
done something wrong.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6de9a180abdd..35c1c1b7ba1d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8050,6 +8050,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static void dump_block_rsv(struct btrfs_block_rsv *rsv)
+{
+	spin_lock(&rsv->lock);
+	printk(KERN_ERR "%d: size %llu reserved %llu\n",
+	       rsv->type, (unsigned long long)rsv->size,
+	       (unsigned long long)rsv->reserved);
+	spin_unlock(&rsv->lock);
+}
+
 static void dump_space_info(struct btrfs_fs_info *fs_info,
 			    struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups)
@@ -8069,6 +8078,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
 		info->bytes_readonly);
 	spin_unlock(&info->lock);
 
+	dump_block_rsv(&fs_info->global_block_rsv);
+	dump_block_rsv(&fs_info->trans_block_rsv);
+	dump_block_rsv(&fs_info->chunk_block_rsv);
+	dump_block_rsv(&fs_info->delayed_block_rsv);
+	dump_block_rsv(&fs_info->delayed_refs_rsv);
+
 	if (!dump_block_groups)
 		return;
 
-- 
2.14.3

