Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19700 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752555AbbAMCE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 21:04:57 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D24Hcx025915
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 10:04:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] btrfs-progs: Automatically rebuild csum/extent tree if no other tree has corrupted/missing extent.
Date: Tue, 13 Jan 2015 10:04:46 +0800
Message-ID: <1421114687-6084-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we find other tree has no corrupted/missing extent, we should be
safely to rebuild csum/extent tree.

This patch will automatically do it using the report_root_corrtuped()
result.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index b275b39..7d8d9d1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9030,6 +9030,8 @@ int cmd_check(int argc, char **argv)
 	int init_csum_tree = 0;
 	int qgroup_report = 0;
 	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
+	u16 root_corrupted = 0;
+	int in_recheck = 0;
 
 	while(1) {
 		int c;
@@ -9075,12 +9077,14 @@ int cmd_check(int argc, char **argv)
 			printf("Creating a new CRC tree\n");
 			init_csum_tree = 1;
 			repair = 1;
+			in_recheck = 1;
 			ctree_flags |= OPEN_CTREE_WRITES;
 		} else if (option_index == 3) {
 			init_extent_tree = 1;
 			ctree_flags |= (OPEN_CTREE_WRITES |
 					OPEN_CTREE_NO_BLOCK_GROUPS);
 			repair = 1;
+			in_recheck = 1;
 		} else if (option_index == 4) {
 			check_data_csum = 1;
 		}
@@ -9106,6 +9110,7 @@ int cmd_check(int argc, char **argv)
 	if (repair)
 		ctree_flags |= OPEN_CTREE_PARTIAL;
 
+again:
 	info = open_ctree_fs_info(argv[optind], bytenr, tree_root_bytenr,
 				  ctree_flags);
 	if (!info) {
@@ -9218,7 +9223,21 @@ int cmd_check(int argc, char **argv)
 	 * chunk and extent tree check has iterates all the extents,
 	 * so know we have a brief view on which trees are damaged.
 	 */
-	report_root_corrupted(info, "\t");
+	root_corrupted = report_root_corrupted(info, "\t");
+	if (repair && !in_recheck && (root_corrupted == CORRUPTED_CSUM ||
+	    root_corrupted == CORRUPTED_EXTENT)) {
+		in_recheck = 1;
+		if (root_corrupted == CORRUPTED_CSUM) {
+			init_csum_tree = 1;
+			printf("Only csum tree is corrupted, rebuild it\n");
+		}
+		if (root_corrupted == CORRUPTED_EXTENT) {
+			init_extent_tree = 1;
+			printf("Only extent tree is corrupted, rebuild it\n");
+		}
+		close_ctree(root);
+		goto again;
+	}
 	ret = repair_root_items(info);
 	if (ret < 0)
 		goto close_out;
-- 
2.2.1

