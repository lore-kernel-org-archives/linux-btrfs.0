Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:59799 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3KLNmK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 08:42:10 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so5883776wes.21
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 05:42:09 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/5] Btrfs-progs: let get_label return the label instead of printing it
Date: Tue, 12 Nov 2013 13:41:42 +0000
Message-Id: <1384263706-25549-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_label prints the label at the moment. Change this so that
the label is returned and printing is done by the caller.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-filesystem.c |   14 +++++++++++---
 utils.c           |   15 ++++++---------
 utils.h           |    2 +-
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index d2cad81..9fda41a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -810,10 +810,18 @@ static int cmd_label(int argc, char **argv)
 	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
 		usage(cmd_label_usage);
 
-	if (argc > 2)
+	if (argc > 2) {
 		return set_label(argv[1], argv[2]);
-	else
-		return get_label(argv[1]);
+	} else {
+		char label[BTRFS_LABEL_SIZE];
+		int ret;
+
+		ret = get_label(argv[1], label);
+		if (!ret)
+			fprintf(stdout, "%s\n", label);
+
+		return ret;
+	}
 }
 
 const struct cmd_group filesystem_cmd_group = {
diff --git a/utils.c b/utils.c
index 85682d9..9105af1 100644
--- a/utils.c
+++ b/utils.c
@@ -1343,7 +1343,7 @@ static int set_label_mounted(const char *mount_path, const char *label)
 	return 0;
 }
 
-static int get_label_unmounted(const char *dev)
+static int get_label_unmounted(const char *dev, char *label)
 {
 	struct btrfs_root *root;
 	int ret;
@@ -1366,7 +1366,7 @@ static int get_label_unmounted(const char *dev)
 	if(!root)
 		return -1;
 
-	fprintf(stdout, "%s\n", root->fs_info->super_copy->label);
+	memcpy(label, root->fs_info->super_copy->label, BTRFS_LABEL_SIZE);
 
 	/* Now we close it since we are done. */
 	close_ctree(root);
@@ -1401,18 +1401,15 @@ int get_label_mounted(const char *mount_path, char *labelp)
 	return 0;
 }
 
-int get_label(const char *btrfs_dev)
+int get_label(const char *btrfs_dev, char *label)
 {
 	int ret;
-	char label[BTRFS_LABEL_SIZE];
 
 	if (is_existing_blk_or_reg_file(btrfs_dev))
-		ret = get_label_unmounted(btrfs_dev);
-	else {
+		ret = get_label_unmounted(btrfs_dev, label);
+	else
 		ret = get_label_mounted(btrfs_dev, label);
-		if (!ret)
-			fprintf(stdout, "%s\n", label);
-	}
+
 	return ret;
 }
 
diff --git a/utils.h b/utils.h
index 6f4b10c..b38bd3a 100644
--- a/utils.h
+++ b/utils.h
@@ -72,7 +72,7 @@ int open_file_or_dir(const char *fname, DIR **dirstream);
 void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
-int get_label(const char *btrfs_dev);
+int get_label(const char *btrfs_dev, char *label);
 int set_label(const char *btrfs_dev, const char *label);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
-- 
1.7.9.5

