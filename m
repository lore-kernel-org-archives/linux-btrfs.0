Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07550C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 13:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB6B2184E
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 13:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfCNN2n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:28:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:59758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727028AbfCNN2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 09:28:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F3A8AFC7
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 13:28:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Remove EXTENT_IOBITS
Date:   Thu, 14 Mar 2019 15:28:31 +0200
Message-Id: <20190314132831.8749-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190314132831.8749-1-nborisov@suse.com>
References: <20190314132831.8749-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This flag just became synonymous to EXTENT_LOCKED, so just remove it and
used EXTENT_LOCKED directly. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 11 +++++------
 fs/btrfs/extent_io.h |  1 -
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d3cd6cb6c1d8..a04e0328f1bb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -427,7 +427,7 @@ static void merge_state(struct extent_io_tree *tree,
 	struct extent_state *other;
 	struct rb_node *other_node;
 
-	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
+	if (state->state & (EXTENT_LOCKED | EXTENT_BOUNDARY))
 		return;
 
 	other_node = rb_prev(&state->rb_node);
@@ -645,7 +645,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
 
-	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
+	if (bits & (EXTENT_LOCKED | EXTENT_BOUNDARY))
 		clear = 1;
 again:
 	if (!prealloc && gfpflags_allow_blocking(mask)) {
@@ -877,7 +877,7 @@ static void cache_state(struct extent_state *state,
 			struct extent_state **cached_ptr)
 {
 	return cache_state_if_flags(state, cached_ptr,
-				    EXTENT_IOBITS | EXTENT_BOUNDARY);
+				    EXTENT_LOCKED | EXTENT_BOUNDARY);
 }
 
 /*
@@ -4233,10 +4233,9 @@ static int try_release_extent_state(struct extent_io_tree *tree,
 	u64 end = start + PAGE_SIZE - 1;
 	int ret = 1;
 
-	if (test_range_bit(tree, start, end,
-			   EXTENT_IOBITS, 0, NULL))
+	if (test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL)) {
 		ret = 0;
-	else {
+	} else {
 		/*
 		 * at this point we can safely clear everything except the
 		 * locked bit and the nodatasum bit
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0ed7a572673d..f41797690839 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -23,7 +23,6 @@
 #define EXTENT_QGROUP_RESERVED	(1U << 12)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 13)
 #define EXTENT_DELALLOC_NEW	(1U << 14)
-#define EXTENT_IOBITS		(EXTENT_LOCKED)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
-- 
2.17.1

