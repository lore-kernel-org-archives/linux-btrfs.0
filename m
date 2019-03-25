Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EFFC10F03
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE36A2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbfCYMbs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:31:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:55592 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731176AbfCYMbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:31:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 532CEAD8A
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 12:31:42 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 11/12] btrfs: Implement find_first_clear_extent_bit
Date:   Mon, 25 Mar 2019 14:31:31 +0200
Message-Id: <20190325123132.27835-12-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190325123132.27835-1-nborisov@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
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
index ff3f8443e180..7e49e5687bac 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1535,6 +1535,79 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
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
index 9dd5190d9dd8..120bc7346405 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -406,6 +406,8 @@ static inline int set_extent_uptodate(struct extent_io_tree *tree, u64 start,
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

