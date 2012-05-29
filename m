Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51225 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2E2JLW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 05:11:22 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 2EC0B3EE0B5
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 18:11:21 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1482945DE58
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 18:11:21 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id EBA9C45DE52
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 18:11:20 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id CDA751DB8041
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 18:11:20 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 65A3E1DB8042
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 18:11:20 +0900 (JST)
Message-Id: <201205290910.AA00001@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 29 May 2012 18:10:13 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@oracle.com
Subject: [PATCH] Btrfs: return value of btrfs_read_buffer is checked correctly
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_buffer() has the possibility of returning the error.
Therefore, I add the code in which the return value of btrfs_read_buffer()
is checked.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c    |    6 +++++-
 fs/btrfs/tree-log.c |   16 +++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4106264..c1af717 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -739,7 +739,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 				if (!cur)
 					return -EIO;
 			} else if (!uptodate) {
-				btrfs_read_buffer(cur, gen);
+				err = btrfs_read_buffer(cur, gen);
+				if (err) {
+					free_extent_buffer(cur);
+					return err;
+				}
 			}
 		}
 		if (search_start == 0)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index eb1ae90..6f22a4f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1628,7 +1628,9 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 	int i;
 	int ret;
 
-	btrfs_read_buffer(eb, gen);
+	ret = btrfs_read_buffer(eb, gen);
+	if (ret)
+		return ret;
 
 	level = btrfs_header_level(eb);
 
@@ -1749,7 +1751,11 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 			path->slots[*level]++;
 			if (wc->free) {
-				btrfs_read_buffer(next, ptr_gen);
+				ret = btrfs_read_buffer(next, ptr_gen);
+				if (ret) {
+					free_extent_buffer(next);
+					return ret;
+				}
 
 				btrfs_tree_lock(next);
 				btrfs_set_lock_blocking(next);
@@ -1766,7 +1772,11 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			free_extent_buffer(next);
 			continue;
 		}
-		btrfs_read_buffer(next, ptr_gen);
+		ret = btrfs_read_buffer(next, ptr_gen);
+		if (ret) {
+			free_extent_buffer(next);
+			return ret;
+		}
 
 		WARN_ON(*level <= 0);
 		if (path->nodes[*level-1])

