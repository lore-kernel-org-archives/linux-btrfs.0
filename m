Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45773 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755235Ab1K1Tdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:51 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWeZc020822
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:40 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWdil012440
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:39 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWcWn020403
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:39 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWb3p020399
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:37 -0200
Message-Id: <01a9eab29d8163688b729f2cbcccef545e6fe999.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Tue, 8 Nov 2011 12:25:49 -0200
Subject: [PATCH 14/20] Btrfs: introduce option to rebalance only metadata
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Experimental patch to be able to compact only the metadata after
excessive block groups are created.  I guess it should be implemented
as a balance option rather than a separate ioctl, but this was good
enough for me to try it.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/ioctl.c   |    2 ++
 fs/btrfs/ioctl.h   |    3 +++
 fs/btrfs/volumes.c |   33 ++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h |    1 +
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a90e749..6f53983 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3077,6 +3077,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
+	case BTRFS_IOC_BALANCE_METADATA:
+		return btrfs_balance_metadata(root->fs_info->dev_root);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 252ae99..46bc428 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -277,4 +277,7 @@ struct btrfs_ioctl_logical_ino_args {
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
 
+#define BTRFS_IOC_BALANCE_METADATA _IOW(BTRFS_IOCTL_MAGIC, 37, \
+					struct btrfs_ioctl_vol_args)
+
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7b348c2..db4397d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2084,7 +2084,7 @@ static u64 div_factor(u64 num, int factor)
 	return num;
 }
 
-int btrfs_balance(struct btrfs_root *dev_root)
+static int btrfs_balance_skip(struct btrfs_root *dev_root, u64 skip_type)
 {
 	int ret;
 	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
@@ -2096,6 +2096,9 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
+	struct btrfs_chunk *chunk;
+	u64 chunk_type;
+	bool skip;
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
@@ -2165,11 +2168,21 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		if (found_key.offset == 0)
 			break;
 
+		if (skip_type) {
+			chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					       struct btrfs_chunk);
+			chunk_type = btrfs_chunk_type(path->nodes[0], chunk);
+			skip = (chunk_type & skip_type);
+		} else
+			skip = false;
+
 		btrfs_release_path(path);
-		ret = btrfs_relocate_chunk(chunk_root,
-					   chunk_root->root_key.objectid,
-					   found_key.objectid,
-					   found_key.offset);
+
+		ret = (skip ? 0 :
+		       btrfs_relocate_chunk(chunk_root,
+					    chunk_root->root_key.objectid,
+					    found_key.objectid,
+					    found_key.offset));
 		if (ret && ret != -ENOSPC)
 			goto error;
 		key.offset = found_key.offset - 1;
@@ -2181,6 +2194,16 @@ error:
 	return ret;
 }
 
+int btrfs_balance(struct btrfs_root *dev_root)
+{
+	return btrfs_balance_skip(dev_root, 0);
+}
+
+int btrfs_balance_metadata(struct btrfs_root *dev_root)
+{
+	return btrfs_balance_skip(dev_root, BTRFS_BLOCK_GROUP_DATA);
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 78f2d4d..6844010 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -229,6 +229,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
+int btrfs_balance_metadata(struct btrfs_root *dev_root);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.4.4

