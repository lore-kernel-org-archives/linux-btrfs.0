Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3382 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760733AbbBIUDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:35 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 04/16] Btrfs-progs: read super properly in btrfs-image
Date: Mon, 9 Feb 2015 15:03:07 -0500
Message-ID: <1423512199-16552-5-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs-image makes a metadump it'll map all the blocks from their logical
address to their physical.  This works out fine with the exception of the super
block, which is the physical offset.  Normally this just works, but if the user
has balanced their fs it'll either crash btrfs-image or it'll copy some
completely arbitrary data.  This forces btrfs-image to read the super directly
from the disk.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-image.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index f6347f3..4bcaf6c 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -868,6 +868,15 @@ static int read_data_extent(struct metadump_struct *md,
 	return 0;
 }
 
+static int get_dev_fd(struct btrfs_root *root)
+{
+	struct btrfs_device *dev;
+
+	dev = list_first_entry(&root->fs_info->fs_devices->devices,
+			       struct btrfs_device, dev_list);
+	return dev->fd;
+}
+
 static int flush_pending(struct metadump_struct *md, int done)
 {
 	struct async_work *async = NULL;
@@ -904,6 +913,24 @@ static int flush_pending(struct metadump_struct *md, int done)
 			}
 		}
 
+		/*
+		 * Balance can make the mapping not cover the super block, so
+		 * just copy directly from one of the devices.
+		 */
+		if (start == BTRFS_SUPER_INFO_OFFSET) {
+			int fd = get_dev_fd(md->root);
+
+			ret = pread64(fd, async->buffer, size, start);
+			if (ret < size) {
+				free(async->buffer);
+				free(async);
+				fprintf(stderr, "Error reading superblock\n");
+				return -EIO;
+			}
+			size = 0;
+			ret = 0;
+		}
+
 		while (!md->data && size > 0) {
 			u64 this_read = min(blocksize, size);
 			eb = read_tree_block(md->root, start, this_read, 0);
-- 
1.8.3.1

