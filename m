Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12873 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754444AbaHGCgS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 22:36:18 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s772aFJG005036
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Aug 2014 10:36:15 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: make close_ctree return void
Date: Thu, 7 Aug 2014 10:35:59 +0800
Message-ID: <1407378959-23728-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1407378959-23728-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1407378959-23728-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The close_ctree always returns 0 and the stuff that depends on
its return value is of no sense.
Just make close_ctree return void.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-convert.c    | 14 +++-----------
 btrfs-debug-tree.c |  3 ++-
 btrfs-image.c      |  4 ++--
 disk-io.c          |  3 +--
 disk-io.h          |  2 +-
 mkfs.c             |  3 +--
 6 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 21bbc70..c685fcf 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2297,11 +2297,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "error during cleanup_sys_chunk %d\n", ret);
 		goto fail;
 	}
-	ret = close_ctree(root);
-	if (ret) {
-		fprintf(stderr, "error during close_ctree %d\n", ret);
-		goto fail;
-	}
+	close_ctree(root);
 	close_ext2fs(ext2_fs);
 
 	/*
@@ -2325,7 +2321,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "error during fixup_chunk_tree\n");
 		goto fail;
 	}
-	ret = close_ctree(root);
+	close_ctree(root);
 	close(fd);
 
 	printf("conversion complete.\n");
@@ -2591,11 +2587,7 @@ next_extent:
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 
-	ret = close_ctree(root);
-	if (ret) {
-		fprintf(stderr, "error during close_ctree %d\n", ret);
-		goto fail;
-	}
+	close_ctree(root);
 
 	/* zero btrfs super block mirrors */
 	memset(buf, 0, sectorsize);
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index e46500d..aeeeb74 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -408,5 +408,6 @@ no_node:
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", BTRFS_BUILD_VERSION);
 close_root:
-	return close_ctree(root);
+	close_ctree(root);
+	return 0;
 }
diff --git a/btrfs-image.c b/btrfs-image.c
index 985aa26..bb3d0a9 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1333,8 +1333,8 @@ out:
 	metadump_destroy(&metadump, num_threads);
 
 	btrfs_free_path(path);
-	ret = close_ctree(root);
-	return err ? err : ret;
+	close_ctree(root);
+	return err ? err : 0;
 }
 
 static void update_super_old(u8 *buffer)
diff --git a/disk-io.c b/disk-io.c
index d10d647..f13d46d 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1410,7 +1410,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int close_ctree(struct btrfs_root *root)
+void close_ctree(struct btrfs_root *root)
 {
 	int ret;
 	struct btrfs_trans_handle *trans;
@@ -1436,7 +1436,6 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_cleanup_all_caches(fs_info);
 	btrfs_free_fs_info(fs_info);
-	return 0;
 }
 
 int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/disk-io.h b/disk-io.h
index 13d4420..87a69b5 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -78,7 +78,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 enum btrfs_open_ctree_flags flags);
-int close_ctree(struct btrfs_root *root);
+void close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
diff --git a/mkfs.c b/mkfs.c
index d980d4a..5e55e72 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1661,8 +1661,7 @@ raid_groups:
 		BUG_ON(ret);
 	}
 
-	ret = close_ctree(root);
-	BUG_ON(ret);
+	close_ctree(root);
 	free(label);
 	return 0;
 }
-- 
1.8.1.4

