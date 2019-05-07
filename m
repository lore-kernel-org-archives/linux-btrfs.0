Return-Path: <SRS0=hL4i=TH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE63C04AAD
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 May 2019 07:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB58620989
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 May 2019 07:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfEGHT3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 May 2019 03:19:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:53554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726584AbfEGHT2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 May 2019 03:19:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DEADFAE40
        for <linux-btrfs@vger.kernel.org>; Tue,  7 May 2019 07:19:27 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 3/3] btrfs: Always use a cached extent_state in btrfs_lock_and_flush_ordered_range
Date:   Tue,  7 May 2019 10:19:24 +0300
Message-Id: <20190507071924.17643-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190507071924.17643-1-nborisov@suse.com>
References: <20190507071924.17643-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In case no cached_state argument is passed to
btrfs_lock_and_flush_ordered_range use one locally in the function. This
optimises the case when an ordered extent is found since the unlock
function will be able to unlock that state directly without searching
for it again.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ordered-data.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 37401cc04a6b..df02ed25b7db 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -982,14 +982,26 @@ void btrfs_lock_and_flush_ordered_range(struct extent_io_tree *tree,
 					struct extent_state **cached_state)
 {
 	struct btrfs_ordered_extent *ordered;
+	struct extent_state *cachedp = NULL;
+
+	if (cached_state)
+		cachedp = *cached_state;
 
 	while (1) {
-		lock_extent_bits(tree, start, end, cached_state);
+		lock_extent_bits(tree, start, end, &cachedp);
 		ordered = btrfs_lookup_ordered_range(inode, start,
 						     end - start + 1);
-		if (!ordered)
+		if (!ordered) {
+			/*
+			 * If no external cached_state has been passed then
+			 * decrement the extra ref taken for cachedp since we
+			 * aren't exposing it outside of this function
+			 */
+			if (!cached_state)
+				refcount_dec(&cachedp->refs);
 			break;
-		unlock_extent_cached(tree, start, end, cached_state);
+		}
+		unlock_extent_cached(tree, start, end, &cachedp);
 		btrfs_start_ordered_extent(&inode->vfs_inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 	}
-- 
2.17.1

