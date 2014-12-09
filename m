Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8765 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752480AbaLII1i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:27:38 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RFHW013453
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 04/13] btrfs-progs: Add last_cache_extent() for extent-cache.
Date: Tue, 9 Dec 2014 16:27:23 +0800
Message-ID: <1418113652-25088-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow direct search for the last cache extent.
Provide the basis for finding the last ino in inode_cache.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v4:
   Newly introduced.
---
 extent-cache.c | 9 +++++++++
 extent-cache.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/extent-cache.c b/extent-cache.c
index 7656ab2..d80aead 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -230,6 +230,15 @@ struct cache_extent *first_cache_extent(struct cache_tree *tree)
 	return rb_entry(node, struct cache_extent, rb_node);
 }
 
+struct cache_extent *last_cache_extent(struct cache_tree *tree)
+{
+	struct rb_node *node = rb_last(&tree->root);
+
+	if (!node)
+		return NULL;
+	return rb_entry(node, struct cache_extent, rb_node);
+}
+
 struct cache_extent *prev_cache_extent(struct cache_extent *pe)
 {
 	struct rb_node *node = rb_prev(&pe->rb_node);
diff --git a/extent-cache.h b/extent-cache.h
index cba83d1..a9d07e1 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -41,6 +41,7 @@ struct cache_extent {
 void cache_tree_init(struct cache_tree *tree);
 
 struct cache_extent *first_cache_extent(struct cache_tree *tree);
+struct cache_extent *last_cache_extent(struct cache_tree *tree);
 struct cache_extent *prev_cache_extent(struct cache_extent *pe);
 struct cache_extent *next_cache_extent(struct cache_extent *pe);
 
-- 
2.1.3

