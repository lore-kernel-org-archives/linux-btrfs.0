Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EB6C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 13:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 403002089D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 13:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="llhzvHxs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 403002089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389712AbeKPXRI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 18:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbeKPXRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 18:17:08 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D0CB2087A
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 13:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542373488;
        bh=OdWmvk0jr9y6Epk4H+alV5g9dfhMLphqM9G502rPXLg=;
        h=From:To:Subject:Date:From;
        b=llhzvHxsTy8Ysh7W2QBxqqVmP9DYTMlZDVSZVW5GFDbrdp/cTcEN6H9AEMIgyXb8T
         UzYjMk6SZCFMl80H10tMmEk+W6Km+96tHTARhlUqMMD20vFA+ASKbw47tRDtkJRe6f
         KU1efaoL7Q93qw/N77soBRxvIaEHYkeVk+wUoeMA=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allow clear_extent_dirty() to receive a cached extent state record
Date:   Fri, 16 Nov 2018 13:04:44 +0000
Message-Id: <20181116130444.22431-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We can have a lot freed extents during the life span of transaction, so
the red black tree that keeps track of the ranges of each freed extent
(fs_info->freed_extents[]) can get quite big. When finishing a transaction
commit we find each range, process it (discard the extents, unpin them)
and then remove it from the red black tree. We can use an extent state
record as a cache when searching for a range, so that when we clean the
range we can use the cached extent state we passed to the search function
instead of iterating the red black tree again. Doing things as fast as
possible when finishing a transaction (in state TRANS_STATE_UNBLOCKED)
is convenient as it reduces the time we block another task that wants to
commit the next transaction.

So change clear_extent_dirty() to allow an optional extent state record to
be passed as an argument, which will be passed down to __clear_extent_bit.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c     | 7 +++++--
 fs/btrfs/extent-tree.c | 7 +++++--
 fs/btrfs/extent_io.h   | 4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 05dc3c17cb62..ecf3a45490e3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4359,12 +4359,15 @@ static int btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
 	unpin = pinned_extents;
 again:
 	while (1) {
+		struct extent_state *cached_state = NULL;
+
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
-					    EXTENT_DIRTY, NULL);
+					    EXTENT_DIRTY, &cached_state);
 		if (ret)
 			break;
 
-		clear_extent_dirty(unpin, start, end);
+		clear_extent_dirty(unpin, start, end, &cached_state);
+		free_extent_state(cached_state);
 		btrfs_error_unpin_extent_range(fs_info, start, end);
 		cond_resched();
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 577878324799..33142d9c36d5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6615,9 +6615,11 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 		unpin = &fs_info->freed_extents[0];
 
 	while (!trans->aborted) {
+		struct extent_state *cached_state = NULL;
+
 		mutex_lock(&fs_info->unused_bg_unpin_mutex);
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
-					    EXTENT_DIRTY, NULL);
+					    EXTENT_DIRTY, &cached_state);
 		if (ret) {
 			mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 			break;
@@ -6627,9 +6629,10 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 			ret = btrfs_discard_extent(fs_info, start,
 						   end + 1 - start, NULL);
 
-		clear_extent_dirty(unpin, start, end);
+		clear_extent_dirty(unpin, start, end, &cached_state);
 		unpin_extent_range(fs_info, start, end, true);
 		mutex_unlock(&fs_info->unused_bg_unpin_mutex);
+		free_extent_state(cached_state);
 		cond_resched();
 	}
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b4d03e677e1d..36f7a9f87e46 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -353,11 +353,11 @@ static inline int set_extent_dirty(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
-		u64 end)
+				     u64 end, struct extent_state **cached)
 {
 	return clear_extent_bit(tree, start, end,
 				EXTENT_DIRTY | EXTENT_DELALLOC |
-				EXTENT_DO_ACCOUNTING, 0, 0, NULL);
+				EXTENT_DO_ACCOUNTING, 0, 0, cached);
 }
 
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-- 
2.11.0

