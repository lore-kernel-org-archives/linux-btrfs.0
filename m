Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29055 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752175AbeBHDXM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:12 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id B02A648AE767
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:08 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 08/18] btrfs-progs: lowmem check: exclude extents if init-extent-tree in lowmem
Date: Thu, 8 Feb 2018 11:27:27 +0800
Message-ID: <20180208032737.31561-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If options '--init-extent-tree' and '--mode=lowmem' are both
input, all metadata blocks will be traversed twice.
First one is done by pin_metadata_blocks() in reinit_extent_tree().
Second one is in check_chunks_and_extents_v2().

Excluding instead of pining metadata blocks before reinit extent tree
in lowmem can save some time.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-common.c | 27 ++++++++++++++++++++-------
 check/mode-common.h |  2 +-
 check/mode-lowmem.c |  8 +++++++-
 cmds-check.c        |  3 ++-
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index acceb24b9597..afe5f04d1deb 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -706,7 +706,7 @@ out:
  * Using fs and other trees to rebuild extent tree.
  */
 int reinit_extent_tree(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info)
+		       struct btrfs_fs_info *fs_info, bool pin)
 {
 	u64 start = 0;
 	int ret;
@@ -728,13 +728,26 @@ int reinit_extent_tree(struct btrfs_trans_handle *trans,
 
 	/*
 	 * first we need to walk all of the trees except the extent tree and pin
-	 * down the bytes that are in use so we don't overwrite any existing
-	 * metadata.
+	 * down/exclude the bytes that are in use so we don't overwrite any
+	 * existing metadata.
+	 * If pin, unpin will be done in end of transaction.
+	 * If exclude, cleanup will be done in check_chunks_and_extents_lowmem.
 	 */
-	ret = pin_metadata_blocks(fs_info);
-	if (ret) {
-		fprintf(stderr, "error pinning down used bytes\n");
-		return ret;
+again:
+	if (pin) {
+		ret = pin_metadata_blocks(fs_info);
+		if (ret) {
+			fprintf(stderr, "error pinning down used bytes\n");
+			return ret;
+		}
+	} else {
+		ret = exclude_metadata_blocks(fs_info);
+		if (ret) {
+			fprintf(stderr, "error excluding used bytes\n");
+			printf("try to pin down used bytes\n");
+			pin = true;
+			goto again;
+		}
 	}
 
 	/*
diff --git a/check/mode-common.h b/check/mode-common.h
index e2a824a318c1..8af7dd3066ff 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -122,7 +122,7 @@ int check_child_node(struct extent_buffer *parent, int slot,
 void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
 int zero_log_tree(struct btrfs_root *root);
 int reinit_extent_tree(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info);
+		       struct btrfs_fs_info *fs_info, bool pin);
 int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite);
 int fill_csum_tree(struct btrfs_trans_handle *trans,
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index ea4019c32a3f..1e0545e6249d 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4860,8 +4860,14 @@ next:
 	}
 out:
 
-	/* if repair, update block accounting */
 	if (repair) {
+		ret = end_avoid_extents_overwrite(fs_info);
+		if (ret < 0)
+			ret = FATAL_ERROR;
+		err |= ret;
+
+		reset_cached_block_groups(fs_info);
+		/* update block accounting */
 		ret = btrfs_fix_block_accounting(trans, root);
 		if (ret)
 			err |= ret;
diff --git a/cmds-check.c b/cmds-check.c
index 28746712fac1..ed81fd3c22b4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -453,7 +453,8 @@ int cmd_check(int argc, char **argv)
 
 		if (init_extent_tree) {
 			printf("Creating a new extent tree\n");
-			ret = reinit_extent_tree(trans, info);
+			ret = reinit_extent_tree(trans, info,
+					 check_mode == CHECK_MODE_ORIGINAL);
 			err |= !!ret;
 			if (ret)
 				goto close_out;
-- 
2.16.1



