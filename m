Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34575 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751818AbbHUDXd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 23:23:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <theosib@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: Use existing facility to replace read_data_extent function
Date: Fri, 21 Aug 2015 11:21:27 +0800
Message-ID: <1440127287-21368-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1440127287-21368-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1440127287-21368-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function read_data_extent() in btrfs-image.c is using manual-and-read
codes.
Replace it with existing read_extent_data() to reduce duplication.

Also, now we can use other mirror to try our best to do the dump, just
like read_tree_block().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-image.c | 58 +++++++++++++++++++---------------------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index b225325..f48d81a 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -872,54 +872,34 @@ out:
 static int read_data_extent(struct metadump_struct *md,
 			    struct async_work *async)
 {
-	struct btrfs_multi_bio *multi = NULL;
-	struct btrfs_device *device;
+	struct btrfs_root *root = md->root;
 	u64 bytes_left = async->size;
 	u64 logical = async->start;
 	u64 offset = 0;
-	u64 bytenr;
 	u64 read_len;
-	ssize_t done;
-	int fd;
+	int num_copies;
+	int cur_mirror;
 	int ret;
 
-	while (bytes_left) {
-		read_len = bytes_left;
-		ret = btrfs_map_block(&md->root->fs_info->mapping_tree, READ,
-				      logical, &read_len, &multi, 0, NULL);
-		if (ret) {
-			fprintf(stderr, "Couldn't map data block %d\n", ret);
-			return ret;
-		}
-
-		device = multi->stripes[0].dev;
-
-		if (device->fd <= 0) {
-			fprintf(stderr,
-				"Device we need to read from is not open\n");
-			free(multi);
-			return -EIO;
-		}
-		fd = device->fd;
-		bytenr = multi->stripes[0].physical;
-		free(multi);
+	num_copies = btrfs_num_copies(&root->fs_info->mapping_tree, logical,
+				      bytes_left);
 
-		read_len = min(read_len, bytes_left);
-		done = pread64(fd, async->buffer+offset, read_len, bytenr);
-		if (done < read_len) {
-			if (done < 0)
-				fprintf(stderr, "Error reading extent %d\n",
-					errno);
-			else
-				fprintf(stderr, "Short read\n");
-			return -EIO;
+	/* Try our best to read data, just like read_tree_block() */
+	for (cur_mirror = 0; cur_mirror < num_copies; cur_mirror++) {
+		while (bytes_left) {
+			read_len = bytes_left;
+			ret = read_extent_data(root,
+					(char *)(async->buffer + offset),
+					logical, &read_len, cur_mirror);
+			if (ret < 0)
+				break;
+			offset += read_len;
+			logical += read_len;
+			bytes_left -= read_len;
 		}
-
-		bytes_left -= done;
-		offset += done;
-		logical += done;
 	}
-
+	if (bytes_left)
+		return -EIO;
 	return 0;
 }
 
-- 
2.5.0

