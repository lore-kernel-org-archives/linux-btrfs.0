Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21762 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751451AbaDXDW3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 23:22:29 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3O3MEq6005664
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 11:22:14 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs-progs: fsck: clear out log tree in repair mode
Date: Thu, 24 Apr 2014 11:19:16 +0800
Message-ID: <1398309558-29509-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Repair mode will commit transaction which will make us
fail to load log tree anymore.

Give a warning to common users, if they really want to
coninue, we will clear out log tree.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 93f9ae6..15806a4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6615,6 +6615,22 @@ out:
 	return ret;
 }
 
+static int zero_log_tree(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		return ret;
+	}
+	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
+	ret = btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -6719,6 +6735,23 @@ int cmd_check(int argc, char **argv)
 	}
 
 	root = info->fs_root;
+	/*
+	 * repair mode will force us to commit transaction which
+	 * will make us fail to load log tree when mounting.
+	 */
+	if (repair && btrfs_super_log_root(info->super_copy)) {
+		ret = ask_user("repair mode will force to clear out log tree, Are you sure?");
+		if (!ret) {
+			ret = 1;
+			goto close_out;
+		}
+		ret = zero_log_tree(root);
+		if (ret) {
+			fprintf(stderr, "fail to zero log tree\n");
+			goto close_out;
+		}
+	}
+
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
-- 
1.9.0

