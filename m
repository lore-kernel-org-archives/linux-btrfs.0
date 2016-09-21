Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48883 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753395AbcIUDQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:35 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 12/14] btrfs-progs: check: fix the return value bug of cmd_check()
Date: Wed, 21 Sep 2016 11:16:02 +0800
Message-Id: <20160921031604.23334-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The function cmd_check() is called by the main function of btrfs.c, its
return value will be returned by exit(). Resulting in the loss of
significant bits in some cases, for example this value is greater than
0377. If use a bool value "err" to store all of the return value, this
will solve the problem.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 934a3dd..701fff5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12337,6 +12337,7 @@ int cmd_check(int argc, char **argv)
 	u64 chunk_root_bytenr = 0;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
+	int err = 0;
 	u64 num;
 	int init_csum_tree = 0;
 	int readonly = 0;
@@ -12470,10 +12471,12 @@ int cmd_check(int argc, char **argv)
 
 	if((ret = check_mounted(argv[optind])) < 0) {
 		error("could not check mount status: %s", strerror(-ret));
+		err |= !!ret;
 		goto err_out;
 	} else if(ret) {
 		error("%s is currently mounted, aborting", argv[optind]);
 		ret = -EBUSY;
+		err |= !!ret;
 		goto err_out;
 	}
 
@@ -12486,6 +12489,7 @@ int cmd_check(int argc, char **argv)
 	if (!info) {
 		error("cannot open file system");
 		ret = -EIO;
+		err |= !!ret;
 		goto err_out;
 	}
 
@@ -12500,9 +12504,11 @@ int cmd_check(int argc, char **argv)
 		ret = ask_user("repair mode will force to clear out log tree, are you sure?");
 		if (!ret) {
 			ret = 1;
+			err |= !!ret;
 			goto close_out;
 		}
 		ret = zero_log_tree(root);
+		err |= !!ret;
 		if (ret) {
 			error("failed to zero log tree: %d", ret);
 			goto close_out;
@@ -12514,6 +12520,7 @@ int cmd_check(int argc, char **argv)
 		printf("Print quota groups for %s\nUUID: %s\n", argv[optind],
 		       uuidbuf);
 		ret = qgroup_verify_all(info);
+		err |= !!ret;
 		if (ret == 0)
 			report_qgroups(1);
 		goto close_out;
@@ -12522,6 +12529,7 @@ int cmd_check(int argc, char **argv)
 		printf("Print extent state for subvolume %llu on %s\nUUID: %s\n",
 		       subvolid, argv[optind], uuidbuf);
 		ret = print_extent_state(info, subvolid);
+		err |= !!ret;
 		goto close_out;
 	}
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
@@ -12530,6 +12538,7 @@ int cmd_check(int argc, char **argv)
 	    !extent_buffer_uptodate(info->dev_root->node) ||
 	    !extent_buffer_uptodate(info->chunk_root->node)) {
 		error("critical roots corrupted, unable to check the filesystem");
+		err |= !!ret;
 		ret = -EIO;
 		goto close_out;
 	}
@@ -12541,12 +12550,14 @@ int cmd_check(int argc, char **argv)
 		if (IS_ERR(trans)) {
 			error("error starting transaction");
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
@@ -12558,11 +12569,13 @@ int cmd_check(int argc, char **argv)
 				error("checksum tree initialization failed: %d",
 						ret);
 				ret = -EIO;
+				err |= !!ret;
 				goto close_out;
 			}
 
 			ret = fill_csum_tree(trans, info->csum_root,
 					     init_extent_tree);
+			err |= !!ret;
 			if (ret) {
 				error("checksum tree refilling failed: %d", ret);
 				return -EIO;
@@ -12573,17 +12586,20 @@ int cmd_check(int argc, char **argv)
 		 * extent entries for all of the items it finds.
 		 */
 		ret = btrfs_commit_transaction(trans, info->extent_root);
+		err |= !!ret;
 		if (ret)
 			goto close_out;
 	}
 	if (!extent_buffer_uptodate(info->extent_root->node)) {
 		error("critical: extent_root, unable to check the filesystem");
 		ret = -EIO;
+		err |= !!ret;
 		goto close_out;
 	}
 	if (!extent_buffer_uptodate(info->csum_root->node)) {
 		error("critical: csum_root, unable to check the filesystem");
 		ret = -EIO;
+		err |= !!ret;
 		goto close_out;
 	}
 
@@ -12593,10 +12609,12 @@ int cmd_check(int argc, char **argv)
 		ret = check_chunks_and_extents_v2(root);
 	else
 		ret = check_chunks_and_extents(root);
+	err |= !!ret;
 	if (ret)
 		printf("Errors found in extent allocation tree or chunk allocation");
 
 	ret = repair_root_items(info);
+	err |= !!ret;
 	if (ret < 0)
 		goto close_out;
 	if (repair) {
@@ -12609,6 +12627,7 @@ int cmd_check(int argc, char **argv)
 		fprintf(stderr,
 			"Please run a filesystem check with the option --repair to fix them.\n");
 		ret = 1;
+		err |= !!ret;
 		goto close_out;
 	}
 
@@ -12619,6 +12638,7 @@ int cmd_check(int argc, char **argv)
 			fprintf(stderr, "checking free space cache\n");
 	}
 	ret = check_space_cache(root);
+	err |= !!ret;
 	if (ret)
 		goto out;
 
@@ -12636,11 +12656,13 @@ int cmd_check(int argc, char **argv)
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
 
@@ -12648,6 +12670,7 @@ int cmd_check(int argc, char **argv)
 	/* For low memory mode, check_fs_roots_v2 handles root refs */
 	if (check_mode != CHECK_MODE_LOWMEM) {
 		ret = check_root_refs(root, &root_cache);
+		err |= !!ret;
 		if (ret)
 			goto out;
 	}
@@ -12659,6 +12682,7 @@ int cmd_check(int argc, char **argv)
 				      struct extent_buffer, recow);
 		list_del_init(&eb->recow);
 		ret = recow_extent_buffer(root, eb);
+		err |= !!ret;
 		if (ret)
 			break;
 	}
@@ -12668,32 +12692,33 @@ int cmd_check(int argc, char **argv)
 
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
 		fprintf(stderr, "checking quota groups\n");
-		err = qgroup_verify_all(info);
-		if (err)
+		ret = qgroup_verify_all(info);
+		err |= !!ret;
+		if (ret)
 			goto out;
 		report_qgroups(0);
-		err = repair_qgroups(info, &qgroups_repaired);
+		ret = repair_qgroups(info, &qgroups_repaired);
+		err |= !!ret;
 		if (err)
 			goto out;
+		ret = 0;
 	}
 
 	if (!list_empty(&root->fs_info->recow_ebs)) {
 		error("transid errors in file system");
 		ret = 1;
+		err |= !!ret;
 	}
 out:
-	/* Don't override original ret */
-	if (!ret && qgroups_repaired)
-		ret = qgroups_repaired;
-
 	if (found_old_backref) { /*
 		 * there was a disk format change when mixed
 		 * backref was in testing tree. The old format
@@ -12703,7 +12728,7 @@ out:
 		       "The old format is not supported! *"
 		       "\n * Please mount the FS in readonly mode, "
 		       "backup data and re-format the FS. *\n\n");
-		ret = 1;
+		err |= 1;
 	}
 	printf("found %llu bytes used err is %d\n",
 	       (unsigned long long)bytes_used, ret);
@@ -12728,5 +12753,5 @@ err_out:
 	if (ctx.progress_enabled)
 		task_deinit(ctx.info);
 
-	return ret;
+	return err;
 }
-- 
2.10.0



