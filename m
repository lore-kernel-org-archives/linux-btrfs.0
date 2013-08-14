Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933312Ab3HNXRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHLo8015149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSn017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/15] btrfs-progs: fix shadow symbols
Date: Wed, 14 Aug 2013 16:16:34 -0700
Message-Id: <1376522205-16992-5-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes all the instances of warnings that symbols declared in blocks
shadow symbols with the same name in surrounding scopes:

 cmds-device.c:341:22: warning: symbol 'path' shadows an earlier one
 cmds-device.c:285:14: originally declared here

I just renamed or removed the risky shadow symbols instead of pulling
their blocks out into functions.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-check.c   |  7 +++----
 cmds-device.c  | 10 +++++-----
 cmds-restore.c |  8 ++++----
 ctree.c        |  2 --
 volumes.c      |  2 +-
 5 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4e5f997..2318aed 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3477,6 +3477,7 @@ static int run_next_block(struct btrfs_root *root,
 	u64 parent;
 	u64 owner;
 	u64 flags;
+	u64 ptr;
 	int ret;
 	int i;
 	int nritems;
@@ -3665,8 +3666,8 @@ static int run_next_block(struct btrfs_root *root,
 			btrfs_item_key_to_cpu(buf, &first_key, 0);
 		level = btrfs_header_level(buf);
 		for (i = 0; i < nritems; i++) {
-			u64 ptr = btrfs_node_blockptr(buf, i);
-			u32 size = btrfs_level_size(root, level - 1);
+			ptr = btrfs_node_blockptr(buf, i);
+			size = btrfs_level_size(root, level - 1);
 			btrfs_node_key_to_cpu(buf, &key, i);
 			ret = add_extent_rec(extent_cache, &key,
 					     ptr, size, 0, 0, 1, 0, 1, 0,
@@ -5317,8 +5318,6 @@ again:
 		ret = err;
 
 	if (trans) {
-		int err;
-
 		err = btrfs_commit_transaction(trans, root);
 		if (!ret)
 			ret = err;
diff --git a/cmds-device.c b/cmds-device.c
index 48ac526..06df864 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -282,7 +282,7 @@ static const char * const cmd_dev_stats_usage[] = {
 
 static int cmd_dev_stats(int argc, char **argv)
 {
-	char *path;
+	char *dev_path;
 	struct btrfs_ioctl_fs_info_args fi_args;
 	struct btrfs_ioctl_dev_info_args *di_args = NULL;
 	int ret;
@@ -314,16 +314,16 @@ static int cmd_dev_stats(int argc, char **argv)
 		return 1;
 	}
 
-	path = argv[optind];
+	dev_path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(path, &dirstream);
+	fdmnt = open_path_or_dev_mnt(dev_path, &dirstream);
 
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		fprintf(stderr, "ERROR: can't access '%s'\n", dev_path);
 		return 12;
 	}
 
-	ret = get_fs_info(path, &fi_args, &di_args);
+	ret = get_fs_info(dev_path, &fi_args, &di_args);
 	if (ret) {
 		fprintf(stderr, "ERROR: getting dev info for devstats failed: "
 				"%s\n", strerror(-ret));
diff --git a/cmds-restore.c b/cmds-restore.c
index 478c0b5..1e965a6 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -658,7 +658,7 @@ set_size:
 }
 
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
-		      const char *output_rootdir, const char *dir,
+		      const char *output_rootdir, const char *in_dir,
 		      const regex_t *mreg)
 {
 	struct btrfs_path *path;
@@ -716,7 +716,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		if (loops++ >= 1024) {
 			printf("We have looped trying to restore files in %s "
 			       "too many times to be making progress, "
-			       "stopping\n", dir);
+			       "stopping\n", in_dir);
 			break;
 		}
 
@@ -764,7 +764,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		btrfs_dir_item_key_to_cpu(leaf, dir_item, &location);
 
 		/* full path from root of btrfs being restored */
-		snprintf(fs_name, 4096, "%s/%s", dir, filename);
+		snprintf(fs_name, 4096, "%s/%s", in_dir, filename);
 
 		if (mreg && REG_NOMATCH == regexec(mreg, fs_name, 0, NULL, 0))
 			goto next;
@@ -896,7 +896,7 @@ next:
 	}
 
 	if (verbose)
-		printf("Done searching %s\n", dir);
+		printf("Done searching %s\n", in_dir);
 	btrfs_free_path(path);
 	return 0;
 }
diff --git a/ctree.c b/ctree.c
index a79ed13..1b093f6 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2401,7 +2401,6 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	BUG_ON(slot < 0);
 
 	if (slot != nritems) {
-		int i;
 		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
 
 		if (old_data < data_end) {
@@ -2580,7 +2579,6 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	nritems = btrfs_header_nritems(leaf);
 
 	if (slot + nr != nritems) {
-		int i;
 		int data_end = leaf_data_end(root, leaf);
 
 		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
diff --git a/volumes.c b/volumes.c
index 1f172b5..e460bce 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1281,7 +1281,7 @@ again:
 				BTRFS_BLOCK_GROUP_RAID6)) {
 
 		if (raid_map) {
-			int i, rot;
+			int rot;
 			u64 tmp;
 			u64 raid56_full_stripe_start;
 			u64 full_stripe_len = nr_data_stripes(map) * map->stripe_len;
-- 
1.7.11.7

