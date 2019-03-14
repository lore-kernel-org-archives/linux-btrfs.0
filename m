Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D108EC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 13:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA9D42085A
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 13:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfCNN2m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:28:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:59752 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbfCNN2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 09:28:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 292AEAFBB
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 13:28:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Remove EXTENT_WRITEBACK
Date:   Thu, 14 Mar 2019 15:28:30 +0200
Message-Id: <20190314132831.8749-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This flag was introduced in a52d9a8033c4 ("Btrfs: Extent based page
cache code.") and subsequently it's usage effectively was removed by
1edbb734b4e0 ("Btrfs: reduce CPU usage in the extent_state tree") and
f2a97a9dbd86 ("btrfs: remove all unused functions"). Just remove it,
no functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c |  3 +--
 fs/btrfs/extent_io.h | 31 +++++++++++++++----------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a958cbd8b11a..d3cd6cb6c1d8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4289,8 +4289,7 @@ int try_release_extent_mapping(struct page *page, gfp_t mask)
 			}
 			if (!test_range_bit(tree, em->start,
 					    extent_map_end(em) - 1,
-					    EXTENT_LOCKED | EXTENT_WRITEBACK,
-					    0, NULL)) {
+					    EXTENT_LOCKED, 0, NULL)) {
 				set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 					&btrfs_inode->runtime_flags);
 				remove_extent_mapping(map, em);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7012ff27da82..0ed7a572673d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -9,22 +9,21 @@
 
 /* bits for the extent state */
 #define EXTENT_DIRTY		(1U << 0)
-#define EXTENT_WRITEBACK	(1U << 1)
-#define EXTENT_UPTODATE		(1U << 2)
-#define EXTENT_LOCKED		(1U << 3)
-#define EXTENT_NEW		(1U << 4)
-#define EXTENT_DELALLOC		(1U << 5)
-#define EXTENT_DEFRAG		(1U << 6)
-#define EXTENT_BOUNDARY		(1U << 9)
-#define EXTENT_NODATASUM	(1U << 10)
-#define EXTENT_CLEAR_META_RESV	(1U << 11)
-#define EXTENT_NEED_WAIT	(1U << 12)
-#define EXTENT_DAMAGED		(1U << 13)
-#define EXTENT_NORESERVE	(1U << 14)
-#define EXTENT_QGROUP_RESERVED	(1U << 15)
-#define EXTENT_CLEAR_DATA_RESV	(1U << 16)
-#define EXTENT_DELALLOC_NEW	(1U << 17)
-#define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
+#define EXTENT_UPTODATE		(1U << 1)
+#define EXTENT_LOCKED		(1U << 2)
+#define EXTENT_NEW		(1U << 3)
+#define EXTENT_DELALLOC		(1U << 4)
+#define EXTENT_DEFRAG		(1U << 5)
+#define EXTENT_BOUNDARY		(1U << 6)
+#define EXTENT_NODATASUM	(1U << 7)
+#define EXTENT_CLEAR_META_RESV	(1U << 8)
+#define EXTENT_NEED_WAIT	(1U << 9)
+#define EXTENT_DAMAGED		(1U << 10)
+#define EXTENT_NORESERVE	(1U << 11)
+#define EXTENT_QGROUP_RESERVED	(1U << 12)
+#define EXTENT_CLEAR_DATA_RESV	(1U << 13)
+#define EXTENT_DELALLOC_NEW	(1U << 14)
+#define EXTENT_IOBITS		(EXTENT_LOCKED)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
-- 
2.17.1

