Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02886C282E3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 07:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D04EB213A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 07:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfDVHq5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 03:46:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:39690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbfDVHq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 03:46:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83215AD0C
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2019 07:46:55 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Implement btrfs_lock_and_flush_ordered_range
Date:   Mon, 22 Apr 2019 10:46:51 +0300
Message-Id: <20190422074653.13075-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190422074653.13075-1-nborisov@suse.com>
References: <20190422074653.13075-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a certain idiom used in multiple places in btrfs' codebase,
dealing with flushing an ordered range. Factor this in a separate
function that can be reused. Future patches will replace the existing
code with that function.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ordered-data.c | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/ordered-data.h |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4d9bb0dea9af..65f6409c1c9f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -954,6 +954,38 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	return index;
 }
 
+/*
+ * btrfs_flush_ordered_range - Lock the passed range and ensures all pending
+ * ordered extents in it are run to completion.
+ *
+ * @tree:         IO tree used for locking out other users of the range
+ * @inode:        Inode whose ordered tree is to be searched
+ * @start:        Beginning of range to flush
+ * @end:          Last byte of range to lock
+ * @cached_state: If passed, will return the extent state responsible for the
+ * locked range. It's the caller's responsibility to free the cached state.
+ *
+ * This function always returns with the given range locked, ensuring after it's
+ * called no order extent can be pending.
+ */
+void btrfs_lock_and_flush_ordered_range(struct extent_io_tree *tree,
+					struct inode *inode, u64 start, u64 end,
+					struct extent_state **cached_state)
+{
+	struct btrfs_ordered_extent *ordered;
+
+	while (1) {
+		lock_extent_bits(tree, start, end, cached_state);
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start,
+						     end - start + 1);
+		if (!ordered)
+			break;
+		unlock_extent_cached(tree, start, end, cached_state);
+		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+	}
+}
+
 int __init ordered_data_init(void)
 {
 	btrfs_ordered_extent_cache = kmem_cache_create("btrfs_ordered_extent",
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 4c5991c3de14..3f6a7d12f435 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -188,6 +188,9 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
 			       const u64 range_start, const u64 range_len);
 u64 btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
 			      const u64 range_start, const u64 range_len);
+void btrfs_lock_and_flush_ordered_range(struct extent_io_tree *tree,
+					struct inode *inode, u64 start, u64 end,
+					struct extent_state **cached_state);
 int __init ordered_data_init(void);
 void __cold ordered_data_exit(void);
 
-- 
2.17.1

