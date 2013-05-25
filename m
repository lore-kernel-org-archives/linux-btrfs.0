Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:56013 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab3EYNuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 09:50:08 -0400
Received: by mail-we0-f182.google.com with SMTP id q57so3113334wes.27
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 06:50:06 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: Add missing free() against fs_info->super_copy
Date: Sat, 25 May 2013 14:49:52 +0100
Message-Id: <1369489792-5673-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1369489792-5673-1-git-send-email-fdmanana@gmail.com>
References: <1369489792-5673-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a missing free() call against fs_info->super_copy
in several places:

1) close_ctree()

2) open_ctree_broken() on failure

3) __open_ctree_fd() on failure

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-find-root.c |    4 ++--
 disk-io.c         |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 810d835..5616e5c 100644
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
@@ -228,6 +227,7 @@ out:
 	free(chunk_root);
 	free(dev_root);
 	free(csum_root);
+	free(fs_info->super_copy);
 	free(fs_info);
 	return NULL;
 }
diff --git a/disk-io.c b/disk-io.c
index 21b410d..3b9b3ed 100644
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
@@ -1039,6 +1038,7 @@ out:
 	free(chunk_root);
 	free(dev_root);
 	free(csum_root);
+	free(fs_info->super_copy);
 	free(fs_info);
 	return NULL;
 }
@@ -1347,6 +1347,7 @@ int close_ctree(struct btrfs_root *root)
 	free(fs_info->chunk_root);
 	free(fs_info->dev_root);
 	free(fs_info->csum_root);
+	free(fs_info->super_copy);
 	free(fs_info);
 
 	return 0;
-- 
1.7.9.5

