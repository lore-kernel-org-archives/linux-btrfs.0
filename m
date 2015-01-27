Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59999 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756655AbbA0DOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 22:14:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0R3DqUM016633
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 11:13:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Move (set/clear_)extent_buffer_uptodate() to extent_io.h.
Date: Tue, 27 Jan 2015 11:12:43 +0800
Message-ID: <1422328363-11405-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422328363-11405-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422328363-11405-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike kernel, these functions in userland just test/set/clear a member.
So move them to header to avoid extra function call cost.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent_io.c | 23 -----------------------
 extent_io.h | 26 ++++++++++++++++++++++----
 2 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index 3a8f96b..8176a51 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -829,29 +829,6 @@ int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 	return 0;
 }
 
-
-int set_extent_buffer_uptodate(struct extent_buffer *eb)
-{
-	eb->flags |= EXTENT_UPTODATE;
-	return 0;
-}
-
-int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb)
-{
-	eb->flags &= ~EXTENT_UPTODATE;
-	return 0;
-}
-
-int extent_buffer_uptodate(struct extent_buffer *eb)
-{
-	if (!eb || IS_ERR(eb))
-		return 0;
-	if (eb->flags & EXTENT_UPTODATE)
-		return 1;
-	return 0;
-}
-
 int set_extent_buffer_dirty(struct extent_buffer *eb)
 {
 	struct extent_io_tree *tree = eb->tree;
diff --git a/extent_io.h b/extent_io.h
index acc316e..2fe9dcd 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -100,10 +100,28 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start,
 		     u64 end, gfp_t mask);
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
 		       u64 end, gfp_t mask);
-int extent_buffer_uptodate(struct extent_buffer *eb);
-int set_extent_buffer_uptodate(struct extent_buffer *eb);
-int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb);
+static inline int set_extent_buffer_uptodate(struct extent_buffer *eb)
+{
+	eb->flags |= EXTENT_UPTODATE;
+	return 0;
+}
+
+static inline int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
+				struct extent_buffer *eb)
+{
+	eb->flags &= ~EXTENT_UPTODATE;
+	return 0;
+}
+
+static inline int extent_buffer_uptodate(struct extent_buffer *eb)
+{
+	if (!eb || IS_ERR(eb))
+		return 0;
+	if (eb->flags & EXTENT_UPTODATE)
+		return 1;
+	return 0;
+}
+
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 xprivate);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *xprivate);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-- 
2.2.2

