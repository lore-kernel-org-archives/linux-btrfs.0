Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57967 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3CLRbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:15 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E93AC9A0645
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:14 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 07AXUMG5UkkbFmvY (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:14 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/10] restore: Split output directory and btrfs-local path search_dir() parameters
Date: Tue, 12 Mar 2013 13:38:12 -0400
Message-ID: <1363109897-7931-6-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Peter Stuge <peter@stuge.se>

search_dir() recurses down the btrfs tree, and used to take the output
path for every item (i.e. in the running system, output root directory
concatenated with btrfs-local pathname) passed as the only path
parameter. Moving the output root directory to a separate parameter
and passing the btrfs-local pathname for each file and directory
separately allows easy filtering based on the btrfs-local pathname.

Signed-off-by: Peter Stuge <peter@stuge.se>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 9781801..215958f 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -39,6 +39,7 @@
 #include "utils.h"
 #include "commands.h"
 
+static char fs_name[4096];
 static char path_name[4096];
 static int get_snaps = 0;
 static int verbose = 0;
@@ -454,7 +455,7 @@ set_size:
 }
 
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
-		      const char *dir)
+		      const char *output_rootdir, const char *dir)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -558,8 +559,11 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		type = btrfs_dir_type(leaf, dir_item);
 		btrfs_dir_item_key_to_cpu(leaf, dir_item, &location);
 
-		snprintf(path_name, 4096, "%s/%s", dir, filename);
+		/* full path from root of btrfs being restored */
+		snprintf(fs_name, 4096, "%s/%s", dir, filename);
 
+		/* full path from system root */
+		snprintf(path_name, 4096, "%s%s", output_rootdir, fs_name);
 
 		/*
 		 * At this point we're only going to restore directories and
@@ -607,7 +611,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			}
 		} else if (type == BTRFS_FT_DIR) {
 			struct btrfs_root *search_root = root;
-			char *dir = strdup(path_name);
+			char *dir = strdup(fs_name);
 
 			if (!dir) {
 				fprintf(stderr, "Ran out of memory\n");
@@ -669,7 +673,8 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				return -1;
 			}
 			loops = 0;
-			ret = search_dir(search_root, &location, dir);
+			ret = search_dir(search_root, &location,
+					 output_rootdir, dir);
 			free(dir);
 			if (ret) {
 				if (ignore_errors)
@@ -911,7 +916,7 @@ int cmd_restore(int argc, char **argv)
 		key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	}
 
-	ret = search_dir(root, &key, dir_name);
+	ret = search_dir(root, &key, dir_name, "");
 
 out:
 	close_ctree(root);
-- 
1.7.7.6

