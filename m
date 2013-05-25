Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33737 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3EYOQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 10:16:52 -0400
Received: by mail-wg0-f53.google.com with SMTP id m15so3238963wgh.8
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 07:16:51 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: Add missing free() against fs_info->super_copy
Date: Sat, 25 May 2013 15:16:39 +0100
Message-Id: <1369491399-6769-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1369491399-6769-1-git-send-email-fdmanana@gmail.com>
References: <1369491399-6769-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a missing free() call against fs_info->super_copy
in several places:

1) close_ctree()

2) open_ctree_broken() on failure

3) __open_ctree_fd() on failure

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-find-root.c |    5 +++--
 disk-io.c         |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 810d835..b2690d1 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -94,7 +94,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
 	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
 	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
+	struct btrfs_fs_info *fs_info = calloc(1, sizeof(*fs_info));
 	int ret;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_fs_devices *fs_devices = NULL;
@@ -115,7 +115,6 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 			goto out;
 	}
 
-	memset(fs_info, 0, sizeof(*fs_info));
 	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
 	fs_info->tree_root = tree_root;
 	fs_info->extent_root = extent_root;
@@ -228,6 +227,8 @@ out:
 	free(chunk_root);
 	free(dev_root);
 	free(csum_root);
+	if (fs_info)
+		free(fs_info->super_copy);
 	free(fs_info);
 	return NULL;
 }
diff --git a/disk-io.c b/disk-io.c
index 21b410d..eea7453 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -812,7 +812,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
 	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
 	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
+	struct btrfs_fs_info *fs_info = calloc(1, sizeof(*fs_info));
 	int ret;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_fs_devices *fs_devices = NULL;
@@ -840,7 +840,6 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 			goto out;
 	}
 
-	memset(fs_info, 0, sizeof(*fs_info));
 	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
 	fs_info->tree_root = tree_root;
 	fs_info->extent_root = extent_root;
@@ -1039,6 +1038,8 @@ out:
 	free(chunk_root);
 	free(dev_root);
 	free(csum_root);
+	if (fs_info)
+		free(fs_info->super_copy);
 	free(fs_info);
 	return NULL;
 }
@@ -1347,6 +1348,7 @@ int close_ctree(struct btrfs_root *root)
 	free(fs_info->chunk_root);
 	free(fs_info->dev_root);
 	free(fs_info->csum_root);
+	free(fs_info->super_copy);
 	free(fs_info);
 
 	return 0;
-- 
1.7.9.5

