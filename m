Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:42330 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeH3Vp5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:45:57 -0400
Received: by mail-qt0-f193.google.com with SMTP id z8-v6so11277190qto.9
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:42 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p18-v6sm5222995qtp.3.2018.08.30.10.42.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:40 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/35] btrfs: dump block_rsv whe dumping space info
Date: Thu, 30 Aug 2018 13:41:57 -0400
Message-Id: <20180830174225.2200-8-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For enospc_debug having the block rsvs is super helpful to see if we've
done something wrong.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80615a579b18..df826f713034 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7910,6 +7910,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
@@ -7929,6 +7938,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
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
