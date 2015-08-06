Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:23125 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbbHFDGu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 23:06:50 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id AB6C0AC0159
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 12:06:47 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id 8FA58DC
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 12:06:47 +0900 (JST)
Message-Id: <201508060305.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 06 Aug 2015 12:05:55 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add newline to some error messages
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added a missing newline to some error messages.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 btrfs-corrupt-block.c | 2 +-
 cmds-check.c          | 4 ++--
 cmds-send.c           | 4 ++--
 dir-item.c            | 6 +++---
 mkfs.c                | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 1a2aa23..ea871f4 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1010,7 +1010,7 @@ int find_chunk_offset(struct btrfs_root *root,
 		goto out;
 	}
 	if (ret < 0) {
-		fprintf(stderr, "Error searching chunk");
+		fprintf(stderr, "Error searching chunk\n");
 		goto out;
 	}
 out:
diff --git a/cmds-check.c b/cmds-check.c
index dd2fce3..0ddf57c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2398,7 +2398,7 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
 				  mode);
 		if (ret < 0) {
-			fprintf(stderr, "Failed to create '%s' dir: %s",
+			fprintf(stderr, "Failed to create '%s' dir: %s\n",
 				dir_name, strerror(-ret));
 			goto out;
 		}
@@ -2426,7 +2426,7 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 		}
 		if (ret < 0) {
 			fprintf(stderr,
-				"Failed to link the inode %llu to %s dir: %s",
+				"Failed to link the inode %llu to %s dir: %s\n",
 				rec->ino, dir_name, strerror(-ret));
 			goto out;
 		}
diff --git a/cmds-send.c b/cmds-send.c
index 20bba18..78ee54c 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -192,13 +192,13 @@ static int write_buf(int fd, const void *buf, int size)
 		ret = write(fd, (char*)buf + pos, size - pos);
 		if (ret < 0) {
 			ret = -errno;
-			fprintf(stderr, "ERROR: failed to dump stream. %s",
+			fprintf(stderr, "ERROR: failed to dump stream. %s\n",
 					strerror(-ret));
 			goto out;
 		}
 		if (!ret) {
 			ret = -EIO;
-			fprintf(stderr, "ERROR: failed to dump stream. %s",
+			fprintf(stderr, "ERROR: failed to dump stream. %s\n",
 					strerror(-ret));
 			goto out;
 		}
diff --git a/dir-item.c b/dir-item.c
index a5bf861..f3ad98f 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -285,7 +285,7 @@ int verify_dir_item(struct btrfs_root *root,
 	u8 type = btrfs_dir_type(leaf, dir_item);
 
 	if (type >= BTRFS_FT_MAX) {
-		fprintf(stderr, "invalid dir item type: %d",
+		fprintf(stderr, "invalid dir item type: %d\n",
 		       (int)type);
 		return 1;
 	}
@@ -294,7 +294,7 @@ int verify_dir_item(struct btrfs_root *root,
 		namelen = XATTR_NAME_MAX;
 
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
-		fprintf(stderr, "invalid dir item name len: %u",
+		fprintf(stderr, "invalid dir item name len: %u\n",
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
@@ -302,7 +302,7 @@ int verify_dir_item(struct btrfs_root *root,
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if ((btrfs_dir_data_len(leaf, dir_item) +
 	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
-		fprintf(stderr, "invalid dir item name + data len: %u + %u",
+		fprintf(stderr, "invalid dir item name + data len: %u + %u\n",
 		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
diff --git a/mkfs.c b/mkfs.c
index dafd500..909b591 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -599,7 +599,7 @@ static int add_symbolic_link(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 	if (ret >= sectorsize) {
-		fprintf(stderr, "symlink too long for %s", path_name);
+		fprintf(stderr, "symlink too long for %s\n", path_name);
 		ret = -1;
 		goto fail;
 	}
-- 
2.4.5

----
Tsutomu Itoh  t-itoh@jp.fujitsu.com

