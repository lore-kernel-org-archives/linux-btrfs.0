Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20D4C282D8
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7399A20882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbfA3OvG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:38100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731391AbfA3OvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A1E3B08F
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/15] btrfs: Remove  EXTENT_FIRST_DELALLOC bit
Date:   Wed, 30 Jan 2019 16:50:50 +0200
Message-Id: <20190130145102.4708-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-1-nborisov@suse.com>
References: <20190130145102.4708-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With the refactoring introduced in 8b62f87bad9c ("Btrfs: reworki
outstanding_extents") this flag became unused. Remove it and renumber
the following flags accordingly. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c |  2 --
 fs/btrfs/extent_io.h | 15 +++++++--------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 71db9f8bcdaa..01f596d42f59 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -585,7 +585,6 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
-	bits |= EXTENT_FIRST_DELALLOC;
 
 	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		clear = 1;
@@ -850,7 +849,6 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
-	bits |= EXTENT_FIRST_DELALLOC;
 again:
 	if (!prealloc && gfpflags_allow_blocking(mask)) {
 		/*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9673be3f3d1f..08749e0b9c32 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -18,17 +18,16 @@
 #define EXTENT_BOUNDARY		(1U << 9)
 #define EXTENT_NODATASUM	(1U << 10)
 #define EXTENT_CLEAR_META_RESV	(1U << 11)
-#define EXTENT_FIRST_DELALLOC	(1U << 12)
-#define EXTENT_NEED_WAIT	(1U << 13)
-#define EXTENT_DAMAGED		(1U << 14)
-#define EXTENT_NORESERVE	(1U << 15)
-#define EXTENT_QGROUP_RESERVED	(1U << 16)
-#define EXTENT_CLEAR_DATA_RESV	(1U << 17)
-#define EXTENT_DELALLOC_NEW	(1U << 18)
+#define EXTENT_NEED_WAIT	(1U << 12)
+#define EXTENT_DAMAGED		(1U << 13)
+#define EXTENT_NORESERVE	(1U << 14)
+#define EXTENT_QGROUP_RESERVED	(1U << 15)
+#define EXTENT_CLEAR_DATA_RESV	(1U << 16)
+#define EXTENT_DELALLOC_NEW	(1U << 17)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
-#define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
+#define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
 
 /*
  * flags for bio submission. The high bits indicate the compression
-- 
2.17.1

