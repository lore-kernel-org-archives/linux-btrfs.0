Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34344 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbcACTAO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 14:00:14 -0500
Received: by mail-pa0-f49.google.com with SMTP id uo6so165483618pac.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 11:00:13 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id fc6sm120726837pac.44.2016.01.03.11.00.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 11:00:12 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs-progs: use NULL instead of 0
Date: Mon,  4 Jan 2016 03:59:54 +0900
Message-Id: <1451847598-30666-3-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the code assigning 0 to pointer instead of NULL.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 cmds-fi-usage.c | 12 ++++++------
 props.c         |  2 +-
 qgroup.c        |  6 ++++--
 utils.c         |  4 ++--
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 72d80278e259..852e5651db8c 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -47,7 +47,7 @@ static int add_info_to_list(struct chunk_info **info_ptr,
 
 	for (j = 0 ; j < num_stripes ; j++) {
 		int i;
-		struct chunk_info *p = 0;
+		struct chunk_info *p = NULL;
 		struct btrfs_stripe *stripe;
 		u64    devid;
 
@@ -182,7 +182,7 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 
 			ret = add_info_to_list(info_ptr, info_count, item);
 			if (ret) {
-				*info_ptr = 0;
+				*info_ptr = NULL;
 				return 1;
 			}
 
@@ -228,7 +228,7 @@ static int cmp_btrfs_ioctl_space_info(const void *a, const void *b)
  */
 static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 {
-	struct btrfs_ioctl_space_args *sargs = 0, *sargs_orig = 0;
+	struct btrfs_ioctl_space_args *sargs = NULL, *sargs_orig = NULL;
 	int e, ret, count;
 
 	sargs_orig = sargs = calloc(1, sizeof(struct btrfs_ioctl_space_args));
@@ -312,7 +312,7 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		int chunkcount, struct device_info *devinfo, int devcount,
 		char *path, unsigned unit_mode)
 {
-	struct btrfs_ioctl_space_args *sargs = 0;
+	struct btrfs_ioctl_space_args *sargs = NULL;
 	int i;
 	int ret = 0;
 	int width = 10;		/* default 10 for human units */
@@ -510,7 +510,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 	struct device_info *info;
 
 	*device_info_count = 0;
-	*device_info_ptr = 0;
+	*device_info_ptr = NULL;
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
 	if (ret < 0) {
@@ -620,7 +620,7 @@ static void _cmd_filesystem_usage_tabular(unsigned unit_mode,
 {
 	int i;
 	u64 total_unused = 0;
-	struct string_table *matrix = 0;
+	struct string_table *matrix = NULL;
 	int  ncols, nrows;
 	int col;
 	int unallocated_col;
diff --git a/props.c b/props.c
index c9e2bd4108f8..5b7493240b09 100644
--- a/props.c
+++ b/props.c
@@ -194,5 +194,5 @@ const struct prop_handler prop_handlers[] = {
 	 prop_object_dev | prop_object_root, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, prop_compression},
-	{0, 0, 0, 0, 0}
+	{NULL, NULL, 0, 0, NULL}
 };
diff --git a/qgroup.c b/qgroup.c
index 1fbfcb97d659..f56f51a0e4aa 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1117,7 +1117,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				  btrfs_stack_qgroup_info_exclusive_compressed
 				  (info);
 				add_qgroup(qgroup_lookup, sh->offset, a1, a2,
-					   a3, a4, a5, 0, 0, 0, 0, 0, 0, 0);
+					   a3, a4, a5, 0, 0, 0, 0, 0,
+					   NULL, NULL);
 			} else if (sh->type == BTRFS_QGROUP_LIMIT_KEY) {
 				limit = (struct btrfs_qgroup_limit_item *)
 				    (args.buf + off);
@@ -1132,7 +1133,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				a5 = btrfs_stack_qgroup_limit_rsv_exclusive
 				     (limit);
 				add_qgroup(qgroup_lookup, sh->offset, 0, 0,
-					   0, 0, 0, a1, a2, a3, a4, a5, 0, 0);
+					   0, 0, 0, a1, a2, a3, a4, a5,
+					   NULL, NULL);
 			} else if (sh->type == BTRFS_QGROUP_RELATION_KEY) {
 				if (sh->offset < sh->objectid)
 					goto skip;
diff --git a/utils.c b/utils.c
index d5f60a420135..76a2bf4aa2a8 100644
--- a/utils.c
+++ b/utils.c
@@ -154,7 +154,7 @@ int test_uuid_unique(char *fs_uuid)
 	blkid_dev dev = NULL;
 	blkid_cache cache = NULL;
 
-	if (blkid_get_cache(&cache, 0) < 0) {
+	if (blkid_get_cache(&cache, NULL) < 0) {
 		printf("ERROR: lblkid cache get failed\n");
 		return 1;
 	}
@@ -2602,7 +2602,7 @@ int btrfs_scan_lblkid(void)
 	if (btrfs_scan_done)
 		return 0;
 
-	if (blkid_get_cache(&cache, 0) < 0) {
+	if (blkid_get_cache(&cache, NULL) < 0) {
 		printf("ERROR: lblkid cache get failed\n");
 		return 1;
 	}
-- 
2.6.4

