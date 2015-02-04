Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34439 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631AbbBDHUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:20:09 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IJ5w020250
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/7] btrfs-progs: Introduce "--dangerous" option to reset all tree block csum.
Date: Wed, 4 Feb 2015 15:16:53 +0800
Message-ID: <1423034213-14018-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes minor bit error is repairable without much pain, like bit
error in tree root csum.
But in that case, if metadata profile is single it is unable to mount
nor btrfsck can repair it.

So add '--dangerous' option to reset all tree block csum.

NOTE: in most case, bit error can cause unpredictable error for btrfsck
or kernel. So this is *VERY VERY* dangerous, only designed for developer
or experienced btrfs user, or crazy guy who wants to mount a broken btrfs
at any cost.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 535a518..e5cb0ea 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -56,6 +56,7 @@ static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
 static int check_data_csum = 0;
+static int dangerous = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -9232,8 +9233,8 @@ static int reset_one_root_csum(struct btrfs_root *root)
 		while (1) {
 			u64 bytenr;
 
-			node = path->nodes[0];
-			slot = path->slots[0];
+			node = path->nodes[cur_level];
+			slot = path->slots[cur_level];
 			bytenr = btrfs_node_blockptr(node, slot);
 
 			if (bytenr != round_down(bytenr, sectorsize)) {
@@ -9326,7 +9327,7 @@ static int reset_roots_csum(struct btrfs_root *tree_root)
 		if (round_down(bytenr, sectorsize) != bytenr) {
 			bytenr = round_down(bytenr, sectorsize);
 			btrfs_set_disk_root_bytenr(node, ri, bytenr);
-			ret = write_tree_block(NULL, root, node);
+			ret = write_tree_block(NULL, tree_root, node);
 			if (ret < 0) {
 				fprintf(stderr,
 				"Fail to write extent at %llu\n",
@@ -9369,6 +9370,30 @@ out:
 	return ret;
 }
 
+static int do_dangerous_work(struct btrfs_fs_info *fs_info)
+{
+	int ret = 0;
+
+	/*
+	 * TODO: we can use sb bytenr to reset tree root without a valid tree
+	 * root. But open_ctree will use backup/search tree, so this is not so
+	 * important.
+	 */
+	if (!extent_buffer_uptodate(fs_info->tree_root->node)) {
+		fprintf(stderr,
+			"Tree root corrupted, unable to continue.\n");
+		return -EIO;
+	}
+
+	/* First reset tree root csum */
+	ret = reset_one_root_csum(fs_info->tree_root);
+	if (ret < 0)
+		return ret;
+
+	ret = reset_roots_csum(fs_info->tree_root);
+	return ret;
+}
+
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check an unmounted btrfs filesystem.",
@@ -9378,6 +9403,7 @@ const char * const cmd_check_usage[] = {
 	"--repair                    try to repair the filesystem",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
+	"--dangerous                 reset all tree block csum, very dangerous",
 	"--check-data-csum           verify checkums of data blocks",
 	"--qgroup-report             print a report on qgroup consistency",
 	"--subvol-extents <subvolid> print subvolume extents and sharing state",
@@ -9407,13 +9433,14 @@ int cmd_check(int argc, char **argv)
 		int c;
 		int option_index = 0;
 		enum { OPT_REPAIR = 257, OPT_INIT_CSUM, OPT_INIT_EXTENT,
-			OPT_CHECK_CSUM, OPT_READONLY };
+			OPT_CHECK_CSUM, OPT_READONLY, OPT_DANGEROUS };
 		static const struct option long_options[] = {
 			{ "super", 1, NULL, 's' },
 			{ "repair", 0, NULL, OPT_REPAIR },
 			{ "readonly", 0, NULL, OPT_READONLY },
 			{ "init-csum-tree", 0, NULL, OPT_INIT_CSUM },
 			{ "init-extent-tree", 0, NULL, OPT_INIT_EXTENT },
+			{ "dangerous", 0, NULL, OPT_DANGEROUS},
 			{ "check-data-csum", 0, NULL, OPT_CHECK_CSUM },
 			{ "backup", 0, NULL, 'b' },
 			{ "subvol-extents", 1, NULL, 'E' },
@@ -9478,6 +9505,13 @@ int cmd_check(int argc, char **argv)
 			case OPT_CHECK_CSUM:
 				check_data_csum = 1;
 				break;
+			case OPT_DANGEROUS:
+				dangerous = 1;
+				repair = 1;
+				ctree_flags |= (OPEN_CTREE_WRITES |
+						OPEN_CTREE_PARTIAL |
+						__RETURN_CHUNK_ROOT);
+				break;
 		}
 	}
 	argc = argc - optind;
@@ -9518,6 +9552,22 @@ again:
 
 	root = info->fs_root;
 
+	if (dangerous && !in_recheck) {
+		printf("Reset all csum of tree block may cause disaster!\n");
+		printf("Only do this if you have binary backup!\n");
+		ret = 1;
+		if (ask_user("Are you sure?")) {
+			in_recheck = 1;
+			dangerous = 0;
+			ret = do_dangerous_work(info);
+			close_ctree(root);
+			ctree_flags &= ~(__RETURN_CHUNK_ROOT |
+					 OPEN_CTREE_PARTIAL);
+			goto again;
+		} else
+			goto close_out;
+	}
+
 	/*
 	 * repair mode will force us to commit transaction which
 	 * will make us fail to load log tree when mounting.
-- 
2.2.2

