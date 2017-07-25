Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10747 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751802AbdGYB6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 21:58:23 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2D21046B5DF4
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 09:58:16 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Move check of mixed block early.
Date: Tue, 25 Jul 2017 09:57:44 +0800
Message-ID: <20170725015744.12907-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make the check of mixed block groups early.
Reason:
We do not support re-initing extent tree for mixed block groups.
So it will return -EINVAL in function reinit_extent_tree.
In this situation, we do not need to start transaction.
We do not have a btrfs_abort_transaction like kernel now,
so we should prevent starting transaction not necessary.

Output message when run test 003 in fuzz-test:
/home/gujx/btrfs/btrfs-progs/btrfs check --init-extent-tree /home/gujx/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-154961-heap-overflow-chunk-items.raw.restored
We don't support re-initing the extent tree for mixed block groups yet, please notify a btrfs developer you want to do this so they can add this functionality.
transaction.h:42: btrfs_start_transaction: BUG_ON fs_info->running_transaction triggered, value 11477904
/home/gujx/btrfs/btrfs-progs/btrfs[0x411adf]
/home/gujx/btrfs/btrfs-progs/btrfs(close_ctree_fs_info+0x312)[0x413c93]
/home/gujx/btrfs/btrfs-progs/btrfs(cmd_check+0x5b1)[0x45d46a]
/home/gujx/btrfs/btrfs-progs/btrfs(main+0x85)[0x40acd9]
/lib64/libc.so.6(__libc_start_main+0xf1)[0x7f0d957d3401]
/home/gujx/btrfs/btrfs-progs/btrfs(_start+0x2a)[0x40a88a]
Checking filesystem on /home/gujx/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-154961-heap-overflow-chunk-items.raw.restored
UUID: e0d334b9-d48f-49f3-9c6b-45fc8e0ec0c7
Creating a new extent tree
failed (ignored, ret=134): /home/gujx/btrfs/btrfs-progs/btrfs check --init-extent-tree /home/gujx/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-154961-heap-overflow-chunk-items.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c5faa2b..357623e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11914,21 +11914,6 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 	int ret;
 
 	/*
-	 * The only reason we don't do this is because right now we're just
-	 * walking the trees we find and pinning down their bytes, we don't look
-	 * at any of the leaves.  In order to do mixed groups we'd have to check
-	 * the leaves of any fs roots and pin down the bytes for any file
-	 * extents we find.  Not hard but why do it if we don't have to?
-	 */
-	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS)) {
-		fprintf(stderr, "We don't support re-initing the extent tree "
-			"for mixed block groups yet, please notify a btrfs "
-			"developer you want to do this so they can add this "
-			"functionality.\n");
-		return -EINVAL;
-	}
-
-	/*
 	 * first we need to walk all of the trees except the extent tree and pin
 	 * down the bytes that are in use so we don't overwrite any existing
 	 * metadata.
@@ -12963,6 +12948,23 @@ int cmd_check(int argc, char **argv)
 	if (init_extent_tree || init_csum_tree) {
 		struct btrfs_trans_handle *trans;
 
+		/*
+		 * The only reason we don't do this is because right now we're
+		 * just walking the trees we find and pinning down their bytes,
+		 * we don't look at any of the leaves. In order to do mixed
+		 * groups we'd have to check the leaves of any fs roots and
+		 * pin down the bytes for any file extents we find.
+		 * Not hard but why do it if we don't have to?
+		 */
+		if (init_extent_tree && btrfs_fs_incompat(info, MIXED_GROUPS)) {
+			fprintf(stderr, "We don't support re-initing the extent tree "
+					"for mixed block groups yet, please notify a btrfs "
+					"developer you want to do this so they can add this "
+					"functionality.\n");
+			goto close_out;
+
+		}
+
 		trans = btrfs_start_transaction(info->extent_root, 0);
 		if (IS_ERR(trans)) {
 			error("error starting transaction");
-- 
2.9.4



