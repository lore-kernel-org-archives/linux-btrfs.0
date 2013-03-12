Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50750 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab3CLRbH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A0F4F7C04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:06 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 0vMex46tCoATqdgE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/10] Btrfs-progs: add an option for specifying the root to restore
Date: Tue, 12 Mar 2013 13:38:08 -0400
Message-ID: <1363109897-7931-2-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

If the normal fs tree is hosed and the user has multiple subvolumes it's handy
to be able to specify just one of the subvolumes to restore.  It's also handy if
a user only wants to restore say /home instead of his entire disk.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 4a14f93..467e5ef 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -773,13 +773,14 @@ int cmd_restore(int argc, char **argv)
 	char dir_name[128];
 	u64 tree_location = 0;
 	u64 fs_location = 0;
+	u64 root_objectid = 0;
 	int len;
 	int ret;
 	int opt;
 	int super_mirror = 0;
 	int find_dir = 0;
 
-	while ((opt = getopt(argc, argv, "sviot:u:df:")) != -1) {
+	while ((opt = getopt(argc, argv, "sviot:u:df:r:")) != -1) {
 		switch (opt) {
 			case 's':
 				get_snaps = 1;
@@ -822,6 +823,14 @@ int cmd_restore(int argc, char **argv)
 			case 'd':
 				find_dir = 1;
 				break;
+			case 'r':
+				errno = 0;
+				root_objectid = (u64)strtoll(optarg, NULL, 10);
+				if (errno != 0) {
+					fprintf(stderr, "Root objectid not valid\n");
+					exit(1);
+				}
+				break;
 			default:
 				usage(cmd_restore_usage);
 		}
@@ -852,8 +861,6 @@ int cmd_restore(int argc, char **argv)
 		}
 	}
 
-	printf("Root objectid is %Lu\n", root->objectid);
-
 	memset(path_name, 0, 4096);
 
 	strncpy(dir_name, argv[optind + 1], sizeof dir_name);
@@ -865,6 +872,23 @@ int cmd_restore(int argc, char **argv)
 		dir_name[len] = '\0';
 	}
 
+	if (root_objectid != 0) {
+		struct btrfs_root *orig_root = root;
+
+		key.objectid = root_objectid;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+		root = btrfs_read_fs_root(orig_root->fs_info, &key);
+		if (IS_ERR(root)) {
+			fprintf(stderr, "Error reading root\n");
+			root = orig_root;
+			ret = 1;
+			goto out;
+		}
+		key.type = 0;
+		key.offset = 0;
+	}
+
 	if (find_dir) {
 		ret = find_first_dir(root, &key.objectid);
 		if (ret)
@@ -873,7 +897,7 @@ int cmd_restore(int argc, char **argv)
 		key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	}
 
-	ret = search_dir(root->fs_info->fs_root, &key, dir_name);
+	ret = search_dir(root, &key, dir_name);
 
 out:
 	close_ctree(root);
-- 
1.7.7.6

