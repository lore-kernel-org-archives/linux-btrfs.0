Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59395 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754067AbcHWKnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7FEEEAD54
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/13] btrfs-progs: two staged filesystem creation
Date: Tue, 23 Aug 2016 12:25:09 +0200
Message-Id: <1471947917-5324-6-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The filesystem existence on a device is manifested by the signature,
during the mkfs process we write it first and then create other
structures. Such filesystem is not valid and should not be registered
during device scan nor listed among devices from blkid.

This patch will introduce two staged creation. In the first phase, the
signature is wrong, but recognized as a partially created filesystem (by
open or scan helpers). Once we successfully create and write everything,
we fixup the signature. At this point automated scanning should find
a valid filesystem on all devices.

We can also rely on the partially created filesystem to do better error
handling during creation. We can just bail out and do not need to clean
up.

The partial signature is '!BHRfS_M', can be shown by

  btrfs inspect-internal dump-super -F image

Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfs-convert.c |  7 +++++--
 ctree.h         |  1 +
 disk-io.c       | 35 +++++++++++++++++++++++++++++------
 disk-io.h       | 11 ++++++++++-
 mkfs.c          |  7 ++++++-
 utils.c         | 10 ++++++++--
 6 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a8852d612886..b34a413de5be 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2345,7 +2345,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 	}
 
 	root = open_ctree_fd(fd, devname, mkfs_cfg.super_bytenr,
-			     OPEN_CTREE_WRITES);
+			     OPEN_CTREE_WRITES | OPEN_CTREE_FS_PARTIAL);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
@@ -2431,11 +2431,14 @@ static int do_convert(const char *devname, int datacsum, int packing,
 	}
 	is_btrfs = 1;
 
-	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
+	root = open_ctree_fd(fd, devname, 0,
+			OPEN_CTREE_WRITES | OPEN_CTREE_FS_PARTIAL);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
+	root->fs_info->finalize_on_close = 1;
+	close_ctree(root);
 	close(fd);
 
 	printf("conversion complete.\n");
diff --git a/ctree.h b/ctree.h
index 89e47abd9d14..d0569835d0a2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1032,6 +1032,7 @@ struct btrfs_fs_info {
 	unsigned int ignore_chunk_tree_error:1;
 	unsigned int avoid_meta_chunk_alloc:1;
 	unsigned int avoid_sys_chunk_alloc:1;
+	unsigned int finalize_on_close:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/disk-io.c b/disk-io.c
index 4874f0689228..dd4a34142496 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1225,6 +1225,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	struct extent_buffer *eb;
 	int ret;
 	int oflags;
+	unsigned sbflags = SBREAD_DEFAULT;
 
 	if (sb_bytenr == 0)
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
@@ -1247,9 +1248,18 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR)
 		fs_info->ignore_chunk_tree_error = 1;
 
-	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
-		(flags & OPEN_CTREE_RECOVER_SUPER) ? SBREAD_RECOVER : SBREAD_DEFAULT,
-		(flags & OPEN_CTREE_NO_DEVICES));
+	if ((flags & OPEN_CTREE_RECOVER_SUPER)
+	     && (flags & OPEN_CTREE_FS_PARTIAL)) {
+		fprintf(stderr,
+		    "cannot open a partially created filesystem for recovery");
+		return NULL;
+	}
+
+	if (flags & OPEN_CTREE_FS_PARTIAL)
+		sbflags = SBREAD_PARTIAL;
+
+	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr, sbflags,
+			(flags & OPEN_CTREE_NO_DEVICES));
 	if (ret)
 		goto out;
 
@@ -1272,7 +1282,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 				sb_bytenr, SBREAD_RECOVER);
 	else
 		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr,
-				SBREAD_DEFAULT);
+				sbflags);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -1401,8 +1411,12 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 	int csum_size;
 
 	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
-		error("superblock magic doesn't match");
-		return -EIO;
+		if (btrfs_super_magic(sb) == BTRFS_MAGIC_PARTIAL) {
+			if (!(sbflags & SBREAD_PARTIAL)) {
+				error("superblock magic doesn't match");
+				return -EIO;
+			}
+		}
 	}
 
 	csum_type = btrfs_super_csum_type(sb);
@@ -1747,6 +1761,15 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 		write_ctree_super(trans, root);
 		btrfs_free_transaction(root, trans);
 	}
+
+	if (fs_info->finalize_on_close) {
+		btrfs_set_super_magic(fs_info->super_copy, BTRFS_MAGIC);
+		root->fs_info->finalize_on_close = 0;
+		ret = write_all_supers(root);
+		if (ret)
+			fprintf(stderr,
+				"failed to write new super block err %d\n", ret);
+	}
 	btrfs_free_block_groups(fs_info);
 
 	free_fs_roots_tree(&fs_info->fs_root_tree);
diff --git a/disk-io.h b/disk-io.h
index 153ef1f49641..a73dede1e8d0 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -61,7 +61,10 @@ enum btrfs_open_ctree_flags {
 	 * It's useful for chunk corruption case.
 	 * Makes no sense for open_ctree variants returning btrfs_root.
 	 */
-	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1 << 11)
+	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1 << 11),
+
+	/* Allow to open a partially created filesystem */
+	OPEN_CTREE_FS_PARTIAL = (1 << 12),
 };
 
 /*
@@ -71,6 +74,12 @@ enum btrfs_read_sb_flags {
 	SBREAD_DEFAULT		= 0,
 	/* Reading superblock during recovery */
 	SBREAD_RECOVER		= (1 << 0),
+
+	/*
+	 * Read superblock with the fake signature, cannot be used with
+	 * SBREAD_RECOVER
+	 */
+	SBREAD_PARTIAL		= (1 << 1),
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
diff --git a/mkfs.c b/mkfs.c
index 0b081dd44457..ee5a30daff54 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1708,7 +1708,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	root = open_ctree(file, 0, OPEN_CTREE_WRITES);
+	root = open_ctree(file, 0, OPEN_CTREE_WRITES | OPEN_CTREE_FS_PARTIAL);
 	if (!root) {
 		error("open ctree failed");
 		close(fd);
@@ -1858,6 +1858,11 @@ int main(int argc, char **argv)
 		list_all_devices(root);
 	}
 
+	/*
+	 * The filesystem is now fully set up, commit the remaining changes and
+	 * fix the signature as the last step before closing the devices.
+	 */
+	root->fs_info->finalize_on_close = 1;
 out:
 	ret = close_ctree(root);
 	BUG_ON(ret);
diff --git a/utils.c b/utils.c
index e7195b53b015..cec7c738e088 100644
--- a/utils.c
+++ b/utils.c
@@ -238,6 +238,9 @@ static inline int write_temp_super(int fd, struct btrfs_super_block *sb,
  *
  * For now sys chunk array will be empty and dev_item is empty too.
  * They will be re-initialized at temp chunk tree setup.
+ *
+ * The superblock signature is not valid, denotes a partially created
+ * filesystem, needs to be finalized.
  */
 static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 			    u64 root_bytenr, u64 chunk_bytenr)
@@ -276,7 +279,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 
 	btrfs_set_super_bytenr(super, cfg->super_bytenr);
 	btrfs_set_super_num_devices(super, 1);
-	btrfs_set_super_magic(super, BTRFS_MAGIC);
+	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_super_generation(super, 1);
 	btrfs_set_super_root(super, root_bytenr);
 	btrfs_set_super_chunk_root(super, chunk_bytenr);
@@ -1004,6 +1007,9 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 
 /*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
+ *
+ * The superblock signature is not valid, denotes a partially created
+ * filesystem, needs to be finalized.
  */
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 		struct btrfs_convert_context *cctx)
@@ -1064,7 +1070,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 
 	btrfs_set_super_bytenr(&super, cfg->blocks[0]);
 	btrfs_set_super_num_devices(&super, 1);
-	btrfs_set_super_magic(&super, BTRFS_MAGIC);
+	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_super_generation(&super, 1);
 	btrfs_set_super_root(&super, cfg->blocks[1]);
 	btrfs_set_super_chunk_root(&super, cfg->blocks[3]);
-- 
2.7.1

