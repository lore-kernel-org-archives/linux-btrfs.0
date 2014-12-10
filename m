Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:41843 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933311AbaLJVFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:42 -0500
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id 4705AD7F4A
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:41 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 08/18] btrfs restore: track number of bytes restored
Date: Wed, 10 Dec 2014 21:51:38 +0100
Message-Id: <1418244708-7087-9-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Track the number of bytes read from extents and restored.
This is useful for detecting errors and corruptions.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index f9dab7e..8ecd896 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -222,7 +222,8 @@ again:
 	return 0;
 }
 
-static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
+static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos,
+			   u64 *bytes_written)
 {
 	struct extent_buffer *leaf = path->nodes[0];
 	struct btrfs_file_extent_item *fi;
@@ -246,6 +247,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	compress = btrfs_file_extent_compression(leaf, fi);
 	if (compress == BTRFS_COMPRESS_NONE) {
 		done = pwrite(fd, buf, len, pos);
+		*bytes_written += done;
 		if (done < len) {
 			fprintf(stderr, "Short inline write, wanted %d, did "
 				"%zd: %d\n", len, done, errno);
@@ -269,6 +271,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 
 	done = pwrite(fd, outbuf, ram_size, pos);
 	free(outbuf);
+	*bytes_written += done;
 	if (done < ram_size) {
 		fprintf(stderr, "Short compressed inline write, wanted %Lu, "
 			"did %zd: %d\n", ram_size, done, errno);
@@ -280,7 +283,8 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 
 static int copy_one_extent(struct btrfs_root *root, int fd,
 			   struct extent_buffer *leaf,
-			   struct btrfs_file_extent_item *fi, u64 pos)
+			   struct btrfs_file_extent_item *fi, u64 pos,
+			   u64 *bytes_written)
 {
 	struct btrfs_multi_bio *multi = NULL;
 	struct btrfs_device *device;
@@ -410,6 +414,7 @@ again:
 		total += done;
 	}
 out:
+	*bytes_written += total;
 	free(inbuf);
 	free(outbuf);
 	return ret;
@@ -651,6 +656,8 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	int extent_type;
 	int compression;
 	int loops = 0;
+	u64 bytes_written, next_pos = 0ULL;
+	u64 total_written = 0ULL;
 	struct stat st;
 
 	path = btrfs_alloc_path();
@@ -734,14 +741,15 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
 			goto next;
 		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-			ret = copy_one_inline(fd, path, found_key.offset);
+			ret = copy_one_inline(fd, path, found_key.offset,
+					      &bytes_written);
 			if (ret) {
 				btrfs_free_path(path);
 				return -1;
 			}
 		} else if (extent_type == BTRFS_FILE_EXTENT_REG) {
 			ret = copy_one_extent(root, fd, leaf, fi,
-					      found_key.offset);
+					      found_key.offset, &bytes_written);
 			if (ret) {
 				btrfs_free_path(path);
 				return ret;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
