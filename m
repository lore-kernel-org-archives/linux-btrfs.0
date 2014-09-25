Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:55362 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbaIYRfP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 13:35:15 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] btrfs: fix shadow warning on cmp
Date: Thu, 25 Sep 2014 19:35:02 +0200
Message-Id: <1411666502-14395-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmp was declared twice in btrfs_compare_trees resulting in a shadow
warning. This patch renames second internal variable.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 fs/btrfs/ctree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 39021bf..8d0703c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5522,18 +5522,18 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 					goto out;
 				advance_right = ADVANCE;
 			} else {
-				enum btrfs_compare_tree_result cmp;
+				enum btrfs_compare_tree_result result;
 
 				WARN_ON(!extent_buffer_uptodate(left_path->nodes[0]));
 				ret = tree_compare_item(left_root, left_path,
 						right_path, tmp_buf);
 				if (ret)
-					cmp = BTRFS_COMPARE_TREE_CHANGED;
+					result = BTRFS_COMPARE_TREE_CHANGED;
 				else
-					cmp = BTRFS_COMPARE_TREE_SAME;
+					result = BTRFS_COMPARE_TREE_SAME;
 				ret = changed_cb(left_root, right_root,
 						 left_path, right_path,
-						 &left_key, cmp, ctx);
+						 &left_key, result, ctx);
 				if (ret < 0)
 					goto out;
 				advance_left = ADVANCE;
-- 
1.9.3

