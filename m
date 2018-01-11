Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:21049 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753918AbeAKHbN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:13 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C0DAE48AEA0D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:08 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 08/17] btrfs-progs: lowmem check: exclude extents if init-extent-tree in lowmem
Date: Thu, 11 Jan 2018 15:35:02 +0800
Message-ID: <20180111073511.25288-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
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
 cmds-check.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 8ebd1a38a1b9..341f73829ec7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13793,6 +13793,11 @@ out:
 
 	/* if repair, update block accounting */
 	if (repair) {
+		/* Just do clean up, ignore return values here*/
+		end_avoid_extents_overwrite(fs_info);
+		modify_block_groups_cache(fs_info, BTRFS_BLOCK_GROUP_METADATA,
+					  0);
+
 		ret = btrfs_fix_block_accounting(trans, root);
 		if (ret)
 			err |= ret;
@@ -13804,7 +13809,6 @@ out:
 		btrfs_commit_transaction(trans, root->fs_info->extent_root);
 
 	btrfs_release_path(&path);
-
 	return err;
 }
 
@@ -14215,6 +14219,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 {
 	u64 start = 0;
 	int ret;
+	int pin_extents = check_mode == CHECK_MODE_ORIGINAL;
 
 	/*
 	 * The only reason we don't do this is because right now we're just
@@ -14236,10 +14241,21 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 	 * down the bytes that are in use so we don't overwrite any existing
 	 * metadata.
 	 */
-	ret = pin_metadata_blocks(fs_info);
-	if (ret) {
-		fprintf(stderr, "error pinning down used bytes\n");
-		return ret;
+again:
+	if (pin_extents) {
+		ret = pin_metadata_blocks(fs_info);
+		if (ret) {
+			fprintf(stderr, "error pinning down used bytes\n");
+			return ret;
+		}
+	} else {
+		ret = avoid_extents_overwrite(fs_info, EXTENTS_EXCLUDE);
+		if (ret) {
+			fprintf(stderr, "error excluding used bytes\n");
+			printf("try to pin down used bytes\n");
+			pin_extents = 1;
+			goto again;
+		}
 	}
 
 	/*
-- 
2.15.1



