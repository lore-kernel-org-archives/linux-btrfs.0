Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:41929 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2ISTkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 15:40:06 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id NW7OSct3T7gDem6P (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 13:40:04 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: handle not finding the extent exactly when logging changed extents
Date: Wed, 19 Sep 2012 15:45:14 -0400
Message-ID: <1348083914-32171-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I started hitting warnings when running xfstest 68 in a loop because there
were EM's that were not lined up properly with the physical extents.  This
is ok, if we do something like punch a hole or write to a preallocated space
or something like that we can have an EM that doesn't cover the entire
physical extent.  So fix the tree logging stuff to cope with this case so we
don't just commit the transaction.  With this patch I no longer see the
warnings from the tree logging code.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |   46 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ed1f7ce..e0ef92f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2833,6 +2833,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
 	u64 start = em->mod_start;
+	u64 search_start = start;
 	u64 len = em->mod_len;
 	u64 num_bytes;
 	int nritems;
@@ -2848,23 +2849,55 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	while (len) {
 		if (args->nr)
 			goto next_slot;
+again:
 		key.objectid = btrfs_ino(inode);
 		key.type = BTRFS_EXTENT_DATA_KEY;
-		key.offset = start;
+		key.offset = search_start;
 
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			return ret;
+
 		if (ret) {
 			/*
-			 * This shouldn't happen, but it might so warn and
-			 * return an error.
+			 * A rare case were we can have an em for a section of a
+			 * larger extent so we need to make sure that this em
+			 * falls within the extent we've found.  If not we just
+			 * bail and go back to ye-olde way of doing things but
+			 * it happens often enough in testing that we need to do
+			 * this dance to make sure.
 			 */
-			WARN_ON(1);
-			return -ENOENT;
+			do {
+				if (path->slots[0] == 0) {
+					btrfs_release_path(path);
+					if (search_start == 0)
+						return -ENOENT;
+					search_start--;
+					goto again;
+				}
+
+				path->slots[0]--;
+				btrfs_item_key_to_cpu(path->nodes[0], &key,
+						      path->slots[0]);
+				if (key.objectid != btrfs_ino(inode) ||
+				    key.type != BTRFS_EXTENT_DATA_KEY) {
+					btrfs_release_path(path);
+					return -ENOENT;
+				}
+			} while (key.offset > start);
+
+			fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_file_extent_item);
+			num_bytes = btrfs_file_extent_num_bytes(path->nodes[0],
+								fi);
+			if (key.offset + num_bytes <= start) {
+				btrfs_release_path(path);
+				return -ENOENT;
+			}
 		}
 		args->src = path->nodes[0];
 next_slot:
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 		fi = btrfs_item_ptr(args->src, path->slots[0],
 				    struct btrfs_file_extent_item);
 		if (args->nr &&
@@ -2898,8 +2931,9 @@ next_slot:
 		} else {
 			len -= num_bytes;
 		}
-		start += btrfs_file_extent_num_bytes(args->src, fi);
+		start = key.offset + num_bytes;
 		args->next_offset = start;
+		search_start = start;
 
 		if (path->slots[0] < nritems) {
 			if (len)
-- 
1.7.7.6

