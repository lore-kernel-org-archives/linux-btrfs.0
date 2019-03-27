Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3553EC10F00
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED602087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfC0MY2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:24:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:55254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729052AbfC0MY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 08:24:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF73DAF67
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 12:24:25 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 14/15] btrfs: Implement find_first_clear_extent_bit
Date:   Wed, 27 Mar 2019 14:24:17 +0200
Message-Id: <20190327122418.24027-15-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190327122418.24027-1-nborisov@suse.com>
References: <20190327122418.24027-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function is very similar to find_first_extent_bit except that it
locates the first contiguous span of space which does not have bits set.
It's intended use is in the freespace trimming code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  2 ++
 2 files changed, 75 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4bf17d4c0819..d26ebecce2da 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1540,6 +1540,79 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 	return ret;
 }
 
+/**
+ * find_first_clear_extent_bit - finds the first range that has @bits not set
+ * and that starts after @start
+ *
+ * @tree - the tree to search
+ * @start - the offset at/after which the found extent should start
+ * @start_ret - records the beginning of the range
+ * @end_ret - records the end of the range (inclusive)
+ * @bits - the set of bits which must be unset
+ *
+ * Since unallocated range is also considered one which doesn't have the bits
+ * set it's possible that @end_ret contains -1, this happens in case the range
+ * spans (last_range_end, end of device]. In this case it's up to the caller to
+ * trim @end_ret to the appropriate size.
+ */
+void find_first_clear_extent_bit(struct extent_io_tree *tree, u64 start,
+				 u64 *start_ret, u64 *end_ret, unsigned bits)
+{
+	struct extent_state *state;
+	struct rb_node *node, *prev = NULL, *next;
+
+	spin_lock(&tree->lock);
+
+	/* Find first extent with bits cleared */
+	while (1) {
+		node = __etree_search(tree, start, &next, &prev, NULL, NULL);
+		if (!node) {
+			node = next;
+			if (!node) {
+				/*
+				 * We are past the last allocated chunk,
+				 * set start at the end of the last extent. The
+				 * device alloc tree should never be empty so
+				 * prev is always set.
+				 */
+				ASSERT(prev);
+				state = rb_entry(prev, struct extent_state, rb_node);
+				*start_ret = state->end + 1;
+				*end_ret = -1;
+				goto out;
+			}
+		}
+		state = rb_entry(node, struct extent_state, rb_node);
+		if (in_range(start, state->start, state->end - state->start + 1) &&
+			(state->state & bits)) {
+			start = state->end + 1;
+		} else {
+			*start_ret = start;
+			break;
+		}
+	}
+
+	/*
+	 * Find the longest stretch from start until an entry which has the
+	 * bits set
+	 */
+	while (1) {
+		state = rb_entry(node, struct extent_state, rb_node);
+		if (state->end >= start && !(state->state & bits)) {
+			*end_ret = state->end;
+		} else {
+			*end_ret = state->start - 1;
+			break;
+		}
+
+		node = rb_next(node);
+		if (!node)
+			break;
+	}
+out:
+	spin_unlock(&tree->lock);
+}
+
 /*
  * find a contiguous range of bytes in the file marked as delalloc, not
  * more than 'max_bytes'.  start and end are used to return the range,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ea88dfe6dc30..66f9c6c07578 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -404,6 +404,8 @@ static inline int set_extent_uptodate(struct extent_io_tree *tree, u64 start,
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, unsigned bits,
 			  struct extent_state **cached_state);
+void find_first_clear_extent_bit(struct extent_io_tree *tree, u64 start,
+				 u64 *start_ret, u64 *end_ret, unsigned bits);
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct page *page, struct writeback_control *wbc);
-- 
2.17.1

