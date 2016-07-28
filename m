Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42349 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163109AbcG1HJL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:11 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 77F3E42BA386
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:52 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 12/13] btrfs-progs: check: fix the return value bug of cmd_check()
Date: Thu, 28 Jul 2016 15:08:24 +0800
Message-ID: <1469689705-26836-13-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function cmd_check() is called by the main function of btrfs.c, its
return value will be returned by exit(). Resulting in the loss of
significant bits in some cases, for example this value is greater than
0377. If use a bool value "err" to store all of the return value, this
will solve the problem.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e43dce1..c52eebc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12227,6 +12227,7 @@ int cmd_check(int argc, char **argv)
 	u64 chunk_root_bytenr = 0;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
+	int err = 0;
 	u64 num;
 	int init_csum_tree = 0;
 	int readonly = 0;
@@ -12356,10 +12357,12 @@ int cmd_check(int argc, char **argv)
 
 	if((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
+		err |= !!ret;
 		goto err_out;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", argv[optind]);
 		ret = -EBUSY;
+		err |= !!ret;
 		goto err_out;
 	}
 
@@ -12372,6 +12375,7 @@ int cmd_check(int argc, char **argv)
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
 		ret = -EIO;
+		err |= !!ret;
 		goto err_out;
 	}
 
@@ -12386,9 +12390,11 @@ int cmd_check(int argc, char **argv)
 		ret = ask_user("repair mode will force to clear out log tree, Are you sure?");
 		if (!ret) {
 			ret = 1;
+			err |= !!ret;
 			goto close_out;
 		}
 		ret = zero_log_tree(root);
+		err |= !!ret;
 		if (ret) {
 			fprintf(stderr, "fail to zero log tree\n");
 			goto close_out;
@@ -12400,6 +12406,7 @@ int cmd_check(int argc, char **argv)
 		printf("Print quota groups for %s\nUUID: %s\n", argv[optind],
 		       uuidbuf);
 		ret = qgroup_verify_all(info);
+		err |= !!ret;
 		if (ret == 0)
 			report_qgroups(1);
 		goto close_out;
@@ -12408,6 +12415,7 @@ int cmd_check(int argc, char **argv)
 		printf("Print extent state for subvolume %llu on %s\nUUID: %s\n",
 		       subvolid, argv[optind], uuidbuf);
 		ret = print_extent_state(info, subvolid);
+		err |= !!ret;
 		goto close_out;
 	}
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
@@ -12417,6 +12425,7 @@ int cmd_check(int argc, char **argv)
 	    !extent_buffer_uptodate(info->chunk_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
 		ret = -EIO;
+		err |= !!ret;
 		goto close_out;
 	}
 
@@ -12427,12 +12436,14 @@ int cmd_check(int argc, char **argv)
 		if (IS_ERR(trans)) {
 			fprintf(stderr, "Error starting transaction\n");
 			ret = PTR_ERR(trans);
+			err |= !!ret;
 			goto close_out;
 		}
 
 		if (init_extent_tree) {
 			printf("Creating a new extent tree\n");
 			ret = reinit_extent_tree(trans, info);
+			err |= !!ret;
 			if (ret)
 				goto close_out;
 		}
@@ -12443,6 +12454,7 @@ int cmd_check(int argc, char **argv)
 			if (ret) {
 				fprintf(stderr, "crc root initialization failed\n");
 				ret = -EIO;
+				err |= !!ret;
 				goto close_out;
 			}
 
@@ -12458,17 +12470,20 @@ int cmd_check(int argc, char **argv)
 		 * extent entries for all of the items it finds.
 		 */
 		ret = btrfs_commit_transaction(trans, info->extent_root);
+		err |= !!ret;
 		if (ret)
 			goto close_out;
 	}
 	if (!extent_buffer_uptodate(info->extent_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
 		ret = -EIO;
+		err |= !!ret;
 		goto close_out;
 	}
 	if (!extent_buffer_uptodate(info->csum_root->node)) {
 		fprintf(stderr, "Checksum root corrupted, rerun with --init-csum-tree option\n");
 		ret = -EIO;
+		err |= !!ret;
 		goto close_out;
 	}
 
@@ -12478,15 +12493,18 @@ int cmd_check(int argc, char **argv)
 		ret = check_chunks_and_extents_v2(root);
 	else
 		ret = check_chunks_and_extents(root);
+	err |= !!ret;
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
 
 	ret = repair_root_items(info);
+	err |= !!ret;
 	if (ret < 0)
 		goto close_out;
 	if (repair) {
 		fprintf(stderr, "Fixed %d roots.\n", ret);
 		ret = 0;
+		err |= !!ret;
 	} else if (ret > 0) {
 		fprintf(stderr,
 		       "Found %d roots with an outdated root item.\n",
@@ -12494,6 +12512,7 @@ int cmd_check(int argc, char **argv)
 		fprintf(stderr,
 			"Please run a filesystem check with the option --repair to fix them.\n");
 		ret = 1;
+		err |= !!ret;
 		goto close_out;
 	}
 
@@ -12504,6 +12523,7 @@ int cmd_check(int argc, char **argv)
 			fprintf(stderr, "checking free space cache\n");
 	}
 	ret = check_space_cache(root);
+	err |= !!ret;
 	if (ret)
 		goto out;
 
@@ -12521,17 +12541,20 @@ int cmd_check(int argc, char **argv)
 		ret = check_fs_roots_v2(root->fs_info);
 	else
 		ret = check_fs_roots(root, &root_cache);
+	err |= !!ret;
 	if (ret)
 		goto out;
 
 	fprintf(stderr, "checking csums\n");
 	ret = check_csums(root);
+	err |= !!ret;
 	if (ret)
 		goto out;
 
 	fprintf(stderr, "checking root refs\n");
 	if (!low_memory) {
 		ret = check_root_refs(root, &root_cache);
+		err |= !!ret;
 		if (ret)
 			goto out;
 	}
@@ -12543,6 +12566,7 @@ int cmd_check(int argc, char **argv)
 				      struct extent_buffer, recow);
 		list_del_init(&eb->recow);
 		ret = recow_extent_buffer(root, eb);
+		err |= !!ret;
 		if (ret)
 			break;
 	}
@@ -12552,26 +12576,29 @@ int cmd_check(int argc, char **argv)
 
 		bad = list_first_entry(&delete_items, struct bad_item, list);
 		list_del_init(&bad->list);
-		if (repair)
+		if (repair) {
 			ret = delete_bad_item(root, bad);
+			err |= !!ret;
+		}
 		free(bad);
 	}
 
 	if (info->quota_enabled) {
-		int err;
+		int error;
 		fprintf(stderr, "checking quota groups\n");
-		err = qgroup_verify_all(info);
-		if (err)
+		error = qgroup_verify_all(info);
+		if (error)
 			goto out;
 		report_qgroups(0);
-		err = repair_qgroups(info, &qgroups_repaired);
-		if (err)
+		error = repair_qgroups(info, &qgroups_repaired);
+		if (error)
 			goto out;
 	}
 
 	if (!list_empty(&root->fs_info->recow_ebs)) {
 		fprintf(stderr, "Transid errors in file system\n");
 		ret = 1;
+		err |= !!ret;
 	}
 out:
 	/* Don't override original ret */
@@ -12588,6 +12615,7 @@ out:
 		       "\n * Please mount the FS in readonly mode, "
 		       "backup data and re-format the FS. *\n\n");
 		ret = 1;
+		err |= !!ret;
 	}
 	printf("found %llu bytes used err is %d\n",
 	       (unsigned long long)bytes_used, ret);
@@ -12612,5 +12640,5 @@ err_out:
 	if (ctx.progress_enabled)
 		task_deinit(ctx.info);
 
-	return ret;
+	return err;
 }
-- 
2.7.4



