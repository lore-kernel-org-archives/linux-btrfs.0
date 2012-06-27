Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55713 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2F0NRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:17:04 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so935379bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 06:17:04 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCHv2 2/3] Btrfs-progs: let get_label return the label instead of of printing it
Date: Wed, 27 Jun 2012 15:16:50 +0200
Message-Id: <1340803011-21882-3-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
References: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_label prints the label at the moment. Change this so that
the label is returned and printing is done by the caller.

Also bail out when open_ctree failed to avoid a crash when btrfs fi
label is called on a device with no btrfs on it.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 btrfslabel.c      |   13 ++++++++-----
 btrfslabel.h      |    4 ++--
 cmds-filesystem.c |   14 +++++++++++---
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index bf73802..59cad82 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -67,7 +67,7 @@ static void change_label_unmounted(char *dev, char *nLabel)
        close_ctree(root);
 }
 
-static void get_label_unmounted(char *dev)
+static int get_label_unmounted(char *dev, char **label)
 {
        struct btrfs_root *root;
 
@@ -75,14 +75,18 @@ static void get_label_unmounted(char *dev)
         * and as read-only.
         */
        root = open_ctree(dev, 0, 0);
+       if (!root)
+	       return -1;
 
-       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+       *label = strdup(root->fs_info->super_copy.label);
 
        /* Now we close it since we are done. */
        close_ctree(root);
+
+       return 0;
 }
 
-int get_label(char *btrfs_dev)
+int get_label(char *btrfs_dev, char **label)
 {
 
 	int ret;
@@ -98,8 +102,7 @@ int get_label(char *btrfs_dev)
 	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
 	       return -2;
 	}
-	get_label_unmounted(btrfs_dev);
-	return 0;
+	return get_label_unmounted(btrfs_dev, label);
 }
 
 
diff --git a/btrfslabel.h b/btrfslabel.h
index abf43ad..ce6765b 100644
--- a/btrfslabel.h
+++ b/btrfslabel.h
@@ -1,5 +1,5 @@
 /* btrflabel.h */
 
 
-int get_label(char *btrfs_dev);
-int set_label(char *btrfs_dev, char *nLabel);
\ No newline at end of file
+int get_label(char *btrfs_dev, char **label);
+int set_label(char *btrfs_dev, char *nLabel);
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1457de..c5289e3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -518,13 +518,21 @@ static const char * const cmd_label_usage[] = {
 
 static int cmd_label(int argc, char **argv)
 {
+	int ret;
+	char *label;
 	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
 		usage(cmd_label_usage);
 
-	if (argc > 2)
+	if (argc > 2) {
 		return set_label(argv[1], argv[2]);
-	else
-		return get_label(argv[1]);
+	} else {
+		ret = get_label(argv[1], &label);
+		if (ret < 0)
+			return ret;
+		fprintf(stdout, "%s\n", label);
+		free(label);
+		return ret;
+	}
 }
 
 const struct cmd_group filesystem_cmd_group = {
-- 
1.7.10

