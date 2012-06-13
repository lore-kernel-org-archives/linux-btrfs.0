Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16777 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2FMKL5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 06:11:57 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5DABlK4011738
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 18:11:50 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] Btrfs: merge adjacent states as much as possible
Date: Wed, 13 Jun 2012 18:19:09 +0800
Message-Id: <1339582751-32029-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to reduce write locks, we do merge_state as much as much as possible.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   47 +++++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2923ede..081fe13 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -276,29 +276,36 @@ static void merge_state(struct extent_io_tree *tree,
 	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		return;
 
-	other_node = rb_prev(&state->rb_node);
-	if (other_node) {
+	while (1) {
+		other_node = rb_prev(&state->rb_node);
+		if (!other_node)
+			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
-		if (other->end == state->start - 1 &&
-		    other->state == state->state) {
-			merge_cb(tree, state, other);
-			state->start = other->start;
-			other->tree = NULL;
-			rb_erase(&other->rb_node, &tree->state);
-			free_extent_state(other);
-		}
+		if (other->end != state->start - 1 ||
+		    other->state != state->state)
+			break;
+
+		merge_cb(tree, state, other);
+		state->start = other->start;
+		other->tree = NULL;
+		rb_erase(&other->rb_node, &tree->state);
+		free_extent_state(other);
 	}
-	other_node = rb_next(&state->rb_node);
-	if (other_node) {
+
+	while (1) {
+		other_node = rb_next(&state->rb_node);
+		if (!other_node)
+			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
-		if (other->start == state->end + 1 &&
-		    other->state == state->state) {
-			merge_cb(tree, state, other);
-			state->end = other->end;
-			other->tree = NULL;
-			rb_erase(&other->rb_node, &tree->state);
-			free_extent_state(other);
-		}
+		if (other->start != state->end + 1 ||
+		    other->state != state->state)
+			break;
+
+		merge_cb(tree, state, other);
+		state->end = other->end;
+		other->tree = NULL;
+		rb_erase(&other->rb_node, &tree->state);
+		free_extent_state(other);
 	}
 }
 
-- 
1.6.5.2

