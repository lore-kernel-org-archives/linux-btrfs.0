Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22836 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3KMIK7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 03:10:59 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: make it static if function isn't called outside
Date: Wed, 13 Nov 2013 16:19:39 +0800
Message-Id: <1384330779-16647-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-dedup.c |    2 +-
 disk-io.c    |    2 +-
 qgroup.c     |    6 +++---
 utils.c      |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/cmds-dedup.c b/cmds-dedup.c
index beaadb3..67aa6ee 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -31,7 +31,7 @@ static const char * const dedup_cmd_group_usage[] = {
 	NULL
 };
 
-int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
+static int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
 {
 	int ret = 0;
 	int fd;
diff --git a/disk-io.c b/disk-io.c
index 3d855d2..6a24772 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -344,7 +344,7 @@ int write_and_map_eb(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int write_tree_block(struct btrfs_trans_handle *trans,
+static int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
diff --git a/qgroup.c b/qgroup.c
index 1c68046..94d1feb 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -76,7 +76,7 @@ struct btrfs_qgroup_list {
 /*
  * qgroupid,rfer,excl default to set
  */
-struct {
+static struct {
 	char *name;
 	char *column_name;
 	int need_print;
@@ -652,7 +652,7 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	return ret;
 }
 
-void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
+static void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
 {
 	struct btrfs_qgroup_list *list;
 	while (!list_empty(&bq->qgroups)) {
@@ -674,7 +674,7 @@ void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
 	free(bq);
 }
 
-void __free_all_qgroups(struct qgroup_lookup *root_tree)
+static void __free_all_qgroups(struct qgroup_lookup *root_tree)
 {
 	struct btrfs_qgroup *entry;
 	struct rb_node *n;
diff --git a/utils.c b/utils.c
index 97859d9..2345f40 100644
--- a/utils.c
+++ b/utils.c
@@ -1939,7 +1939,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-int test_skip_this_disk(char *path)
+static int test_skip_this_disk(char *path)
 {
 	int fd;
 
-- 
1.7.1

