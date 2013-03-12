Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57971 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160Ab3CLRbY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:24 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EFDDC9A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:23 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id MH6fvzrPhnHCMfij (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:22 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/10] Btrfs-progs: give restore a list roots option
Date: Tue, 12 Mar 2013 13:38:16 -0400
Message-ID: <1363109897-7931-10-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

Since restore has the ability to open really really screwed up file systems, add
a list roots option to it so we can still get the contents of the tree root on a
horribly broken fs.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 7e99970..f4e75cf 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -776,9 +776,70 @@ next:
 	return 0;
 }
 
-static struct btrfs_root *open_fs(const char *dev, u64 root_location, int super_mirror)
+static int do_list_roots(struct btrfs_root *root)
 {
-	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root_item ri;
+	unsigned long offset;
+	int slot;
+	int ret;
+
+	root = root->fs_info->tree_root;
+	path = btrfs_alloc_path();
+	if (!path) {
+		fprintf(stderr, "Failed to alloc path\n");
+		return -1;
+	}
+
+	key.offset = 0;
+	key.objectid = 0;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to do search %d\n", ret);
+		btrfs_free_path(path);
+		return -1;
+	}
+
+	while (1) {
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret)
+				break;
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+		}
+		btrfs_item_key(leaf, &disk_key, slot);
+		btrfs_disk_key_to_cpu(&found_key, &disk_key);
+		if (btrfs_key_type(&found_key) != BTRFS_ROOT_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		offset = btrfs_item_ptr_offset(leaf, slot);
+		read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+		printf(" tree ");
+		btrfs_print_key(&disk_key);
+		printf(" %Lu level %d\n", btrfs_root_bytenr(&ri),
+		       btrfs_root_level(&ri));
+		path->slots[0]++;
+	}
+	btrfs_free_path(path);
+
+	return 0;
+}
+
+static struct btrfs_root *open_fs(const char *dev, u64 root_location,
+				  int super_mirror, int list_roots)
+{
+	struct btrfs_root *root = NULL;
 	u64 bytenr;
 	int i;
 
@@ -786,11 +847,19 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location, int super_
 		bytenr = btrfs_sb_offset(i);
 		root = open_ctree_recovery(dev, bytenr, root_location);
 		if (root)
-			return root;
+			break;
 		fprintf(stderr, "Could not open root, trying backup super\n");
 	}
 
-	return NULL;
+	if (root && list_roots) {
+		int ret = do_list_roots(root);
+		if (ret) {
+			close_ctree(root);
+			root = NULL;
+		}
+	}
+
+	return root;
 }
 
 static int find_first_dir(struct btrfs_root *root, u64 *objectid)
@@ -885,8 +954,9 @@ int cmd_restore(int argc, char **argv)
 	int match_cflags = REG_EXTENDED | REG_NOSUB | REG_NEWLINE;
 	regex_t match_reg, *mreg = NULL;
 	char reg_err[256];
+	int list_roots = 0;
 
-	while ((opt = getopt(argc, argv, "sviot:u:df:r:cm:")) != -1) {
+	while ((opt = getopt(argc, argv, "sviot:u:df:r:cm:l")) != -1) {
 		switch (opt) {
 			case 's':
 				get_snaps = 1;
@@ -943,12 +1013,17 @@ int cmd_restore(int argc, char **argv)
 			case 'm':
 				match_regstr = optarg;
 				break;
+			case 'l':
+				list_roots = 1;
+				break;
 			default:
 				usage(cmd_restore_usage);
 		}
 	}
 
-	if (optind + 1 >= argc)
+	if (!list_roots && optind + 1 >= argc)
+		usage(cmd_restore_usage);
+	else if (list_roots && optind >= argc)
 		usage(cmd_restore_usage);
 
 	if ((ret = check_mounted(argv[optind])) < 0) {
@@ -960,10 +1035,13 @@ int cmd_restore(int argc, char **argv)
 		return 1;
 	}
 
-	root = open_fs(argv[optind], tree_location, super_mirror);
+	root = open_fs(argv[optind], tree_location, super_mirror, list_roots);
 	if (root == NULL)
 		return 1;
 
+	if (list_roots)
+		goto out;
+
 	if (fs_location != 0) {
 		free_extent_buffer(root->node);
 		root->node = read_tree_block(root, fs_location, 4096, 0);
-- 
1.7.7.6

