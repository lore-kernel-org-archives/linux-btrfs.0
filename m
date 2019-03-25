Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FEDC10F03
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8966D2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfCYMbo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:31:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:55598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731160AbfCYMbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:31:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACD13AEEE
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 12:31:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 09/12] btrfs: Factor out in_range macro
Date:   Mon, 25 Mar 2019 14:31:29 +0200
Message-Id: <20190325123132.27835-10-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190325123132.27835-1-nborisov@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is used in more than one places so let's factor it out in ctree.h.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 2 ++
 fs/btrfs/extent-tree.c | 1 -
 fs/btrfs/volumes.c     | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b25c2f1b77d..ddf8db4a8948 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3811,6 +3811,8 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 	return signal_pending(current);
 }
 
+#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
+
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_inode_set_ops(struct inode *inode);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8ddcbd3478ad..574c73e0a7c0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1905,7 +1905,6 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
 static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 			       u64 *discarded_bytes)
 {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7131315e809b..4f00a02a6764 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1515,7 +1515,6 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
  * Tries to find a chunk that intersects [start, start +len] range and when one
  * such is found, records the end of it in *start
  */
-#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
 static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
 				    u64 len)
 {
-- 
2.17.1

