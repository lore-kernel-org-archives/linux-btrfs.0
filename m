Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12298 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751466AbdBUIe7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:34:59 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: [PATCH v3 02/12] btrfs-progs: check: Output verbose error when fsck found a bug in any tree
Date: Tue, 21 Feb 2017 16:34:28 +0800
Message-ID: <20170221083438.25719-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
References: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we output error like "errors found in extent allocation tree or
chunk allocation", but we lacks such output for other trees, but leaving
the final "found error is %d" to catch the last return value(and
sometime it's cleared)

This patch adds extra error message for top level error path, and modify
the last "found error is %d" to "error(s) found" or "no error found".

Cc: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 699753fb..107359f8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12933,8 +12933,10 @@ int cmd_check(int argc, char **argv)
 
 	ret = repair_root_items(info);
 	err |= !!ret;
-	if (ret < 0)
+	if (ret < 0) {
+		error("failed to repair root items: %s", strerror(-ret));
 		goto close_out;
+	}
 	if (repair) {
 		fprintf(stderr, "Fixed %d roots.\n", ret);
 		ret = 0;
@@ -12957,8 +12959,13 @@ int cmd_check(int argc, char **argv)
 	}
 	ret = check_space_cache(root);
 	err |= !!ret;
-	if (ret)
+	if (ret) {
+		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
+			error("errors found in free space tree");
+		else
+			error("errors found in free space cache");
 		goto out;
+	}
 
 	/*
 	 * We used to have to have these hole extents in between our real
@@ -12974,22 +12981,28 @@ int cmd_check(int argc, char **argv)
 	else
 		ret = check_fs_roots(root, &root_cache);
 	err |= !!ret;
-	if (ret)
+	if (ret) {
+		error("errors found in fs roots");
 		goto out;
+	}
 
 	fprintf(stderr, "checking csums\n");
 	ret = check_csums(root);
 	err |= !!ret;
-	if (ret)
+	if (ret) {
+		error("errors found in csum tree");
 		goto out;
+	}
 
 	fprintf(stderr, "checking root refs\n");
 	/* For low memory mode, check_fs_roots_v2 handles root refs */
 	if (check_mode != CHECK_MODE_LOWMEM) {
 		ret = check_root_refs(root, &root_cache);
 		err |= !!ret;
-		if (ret)
+		if (ret) {
+			error("errors found in root refs");
 			goto out;
+		}
 	}
 
 	while (repair && !list_empty(&root->fs_info->recow_ebs)) {
@@ -13000,8 +13013,10 @@ int cmd_check(int argc, char **argv)
 		list_del_init(&eb->recow);
 		ret = recow_extent_buffer(root, eb);
 		err |= !!ret;
-		if (ret)
+		if (ret) {
+			error("fails to fix transid errors");
 			break;
+		}
 	}
 
 	while (!list_empty(&delete_items)) {
@@ -13020,13 +13035,17 @@ int cmd_check(int argc, char **argv)
 		fprintf(stderr, "checking quota groups\n");
 		ret = qgroup_verify_all(info);
 		err |= !!ret;
-		if (ret)
+		if (ret) {
+			error("failed to check quota groups");
 			goto out;
+		}
 		report_qgroups(0);
 		ret = repair_qgroups(info, &qgroups_repaired);
 		err |= !!ret;
-		if (err)
+		if (err) {
+			error("failed to repair quota groups");
 			goto out;
+		}
 		ret = 0;
 	}
 
@@ -13047,8 +13066,12 @@ out:
 		       "backup data and re-format the FS. *\n\n");
 		err |= 1;
 	}
-	printf("found %llu bytes used err is %d\n",
-	       (unsigned long long)bytes_used, ret);
+	printf("found %llu bytes used, ",
+	       (unsigned long long)bytes_used);
+	if (err)
+		printf("error(s) found\n");
+	else
+		printf("no error found\n");
 	printf("total csum bytes: %llu\n",(unsigned long long)total_csum_bytes);
 	printf("total tree bytes: %llu\n",
 	       (unsigned long long)total_btree_bytes);
-- 
2.11.1



