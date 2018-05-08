Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2328 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933111AbeEHIYa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:30 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 06/16] btrfs-progs: lowmem: exclude extents if init-extent-tree in lowmem
Date: Tue, 8 May 2018 16:30:02 +0800
Message-ID: <20180508083012.12090-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
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
 check/main.c        | 30 ++++++++++++++++++++++--------
 check/mode-lowmem.c |  8 +++++++-
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/check/main.c b/check/main.c
index 4944e72e6eb9..7fd39601e274 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8541,7 +8541,7 @@ out:
 }
 
 static int reinit_extent_tree(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info)
+		       struct btrfs_fs_info *fs_info, bool pin)
 {
 	u64 start = 0;
 	int ret;
@@ -8563,13 +8563,26 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 
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
@@ -9663,7 +9676,8 @@ int cmd_check(int argc, char **argv)
 
 		if (init_extent_tree) {
 			printf("Creating a new extent tree\n");
-			ret = reinit_extent_tree(trans, info);
+			ret = reinit_extent_tree(trans, info,
+					 check_mode == CHECK_MODE_ORIGINAL);
 			err |= !!ret;
 			if (ret)
 				goto close_out;
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 9ca533bd2a0e..c4e76113fa8a 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4921,8 +4921,14 @@ next:
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
-- 
2.17.0



