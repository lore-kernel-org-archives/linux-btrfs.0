Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:52064 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933317AbaLJVFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:42 -0500
Received: from mail-in-02-z2.arcor-online.net (mail-in-19-z2.arcor-online.net [151.189.8.36])
	by mx.arcor.de (Postfix) with ESMTP id 913E52D6538
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:41 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 09/18] btrfs restore: more graceful error handling in copy_file
Date: Wed, 10 Dec 2014 21:51:39 +0100
Message-Id: <1418244708-7087-10-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Setting size and attributes of a file makes sense even if some
errors have occured during revovery.

Also, do something useful with the number of bytes written.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 8ecd896..10bb8be 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -715,7 +715,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 					return ret;
 				} else if (ret) {
 					/* No more leaves to search */
-					btrfs_free_path(path);
+					ret = 0;
 					goto set_size;
 				}
 				leaf = path->nodes[0];
@@ -734,35 +734,36 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		if (compression >= BTRFS_COMPRESS_LAST) {
 			fprintf(stderr, "Don't support compression yet %d\n",
 				compression);
-			btrfs_free_path(path);
-			return -1;
+			ret = -1;
+			goto set_size;
 		}
 
+		bytes_written = 0ULL;
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
 			goto next;
 		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			ret = copy_one_inline(fd, path, found_key.offset,
 					      &bytes_written);
-			if (ret) {
-				btrfs_free_path(path);
-				return -1;
-			}
 		} else if (extent_type == BTRFS_FILE_EXTENT_REG) {
 			ret = copy_one_extent(root, fd, leaf, fi,
 					      found_key.offset, &bytes_written);
-			if (ret) {
-				btrfs_free_path(path);
-				return ret;
-			}
 		} else {
 			printf("Weird extent type %d\n", extent_type);
 		}
+		total_written += bytes_written;
+		next_pos = found_key.offset + bytes_written;
+		if (ret) {
+			fprintf(stderr, "ERROR after writing %llu bytes\n",
+				total_written);
+			ret = -1;
+			goto set_size;
+		}
 next:
 		path->slots[0]++;
 	}
 
-	btrfs_free_path(path);
 set_size:
+	btrfs_free_path(path);
 	if (get_xattrs) {
 		ret = set_file_xattrs(root, key->objectid, fd, file);
 		if (ret)
@@ -771,7 +772,7 @@ set_size:
 	}
 
 	set_fd_attrs(fd, &st, file);
-	return 0;
+	return ret;
 }
 
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
