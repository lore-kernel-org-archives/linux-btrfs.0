Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C260C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6344320882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfA3OvP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:38136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731423AbfA3OvK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A973B079
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 14/15] btrfs: Implement find_first_clear_extent_bit
Date:   Wed, 30 Jan 2019 16:51:01 +0200
Message-Id: <20190130145102.4708-15-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-1-nborisov@suse.com>
References: <20190130145102.4708-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function is very similar to find_first_extent_bit except that it
locates the first contiguous span of space which does not have bits set.
It's intended use is in the freespace trimming code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  2 ++
 2 files changed, 80 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d5525d18803d..542eaab9c0c1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1474,6 +1474,84 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 	return ret;
 }
 
+/* find_first_clear_extent_bit - finds the first range that has @bits not set
+ * and that starts after @start
+ *
+ * @tree - the tree to search
+ * @start - the offset at/after which the found extent should start
+ * @start_ret - records the beginning of the range
+ * @end_ret - records the end of the range (inclusive)
+ * @bits - the set of bits which must be unset
+ *
+ * Returns 0 when a range is found and @start_ret/@end_ret are initialised
+ * accordingly, 1 otherwise. Since unallocated range is also considered one
+ * which doesn't have the bits set it's possible that @end_ret contains -1, this
+ * happens in case the range spans (last_range_end, end of device]. In this case
+ * it's up to the caller to trim @end_ret to the appropriate size.
+ */
+int find_first_clear_extent_bit(struct extent_io_tree *tree, u64 start,
+				u64 *start_ret, u64 *end_ret, unsigned bits)
+{
+	struct extent_state *state;
+	struct rb_node *node, *prev = NULL, *next;
+	int ret = 1;
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
+				ret = 0;
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
+			ret = 0;
+		} else {
+			*end_ret = state->start - 1;
+			ret = 0;
+			break;
+		}
+
+		node = rb_next(node);
+		if (!node)
+			break;
+	}
+out:
+	spin_unlock(&tree->lock);
+	return ret;
+}
+
 /*
  * find a contiguous range of bytes in the file marked as delalloc, not
  * more than 'max_bytes'.  start and end are used to return the range,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d238efd628cf..7ddb3ec70023 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -391,6 +391,8 @@ static inline int set_extent_uptodate(struct extent_io_tree *tree, u64 start,
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, unsigned bits,
 			  struct extent_state **cached_state);
+int find_first_clear_extent_bit(struct extent_io_tree *tree, u64 start,
+				u64 *start_ret, u64 *end_ret, unsigned bits);
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct page *page, struct writeback_control *wbc);
-- 
2.17.1

