Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A57C43610
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7393920825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7393920825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbeKIXtb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:49818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728684AbeKIXtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3A36FADD6
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5/9] btrfs: Remove extent_io_ops::check_extent_io_range callback
Date:   Fri,  9 Nov 2018 16:08:34 +0200
Message-Id: <20181109140838.10457-6-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback was only used in debug builds by btrfs_leak_debug_check.
A better approach is to move its implementation in
btrfs_leak_debug_check and ensure the latter is only executed for extent
tree which have ->private_data set i.e. relate to a data node and not
the btree one. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 15 ++++++++++++---
 fs/btrfs/extent_io.h |  2 --
 fs/btrfs/inode.c     | 15 ---------------
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 33d761ff5bd3..c63334c6b008 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -89,9 +89,18 @@ void btrfs_leak_debug_check(void)
 static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 		struct extent_io_tree *tree, u64 start, u64 end)
 {
-	if (tree->ops && tree->ops->check_extent_io_range)
-		tree->ops->check_extent_io_range(tree->private_data, caller,
-						 start, end);
+	struct inode *inode = tree->private_data;
+	u64 isize;
+
+	if (!inode || !is_data_inode(inode))
+		return;
+
+	isize = i_size_read(inode);
+	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
+		btrfs_debug_rl(BTRFS_I(inode)->root->fs_info,
+		    "%s: ino %llu isize %llu odd range [%llu,%llu]",
+			caller, btrfs_ino(BTRFS_I(inode)), isize, start, end);
+	}
 }
 #else
 #define btrfs_leak_debug_add(new, head)	do {} while (0)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 415ea7c2b058..3cb84a0fbaab 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -116,8 +116,6 @@ struct extent_io_ops {
 				  struct extent_state *other);
 	void (*split_extent_hook)(void *private_data,
 				  struct extent_state *orig, u64 split);
-	void (*check_extent_io_range)(void *private_data, const char *caller,
-				      u64 start, u64 end);
 };
 
 struct extent_io_tree {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 536635efa069..dbe956e1a50f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10439,20 +10439,6 @@ static int btrfs_readpage_io_failed_hook(struct page *page, int failed_mirror)
 	return -EAGAIN;
 }
 
-static void btrfs_check_extent_io_range(void *private_data, const char *caller,
-					u64 start, u64 end)
-{
-	struct inode *inode = private_data;
-	u64 isize;
-
-	isize = i_size_read(inode);
-	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
-		btrfs_debug_rl(BTRFS_I(inode)->root->fs_info,
-		    "%s: ino %llu isize %llu odd range [%llu,%llu]",
-			caller, btrfs_ino(BTRFS_I(inode)), isize, start, end);
-	}
-}
-
 void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	struct inode *inode = tree->private_data;
@@ -10518,7 +10504,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
 	.split_extent_hook = btrfs_split_extent_hook,
-	.check_extent_io_range = btrfs_check_extent_io_range,
 };
 
 /*
-- 
2.17.1

