Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17266 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754385AbdLTExq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:46 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 08/17] btrfs-progs: lowmem check: exclude extents if init-extent-tree in lowmem
Date: Wed, 20 Dec 2017 12:57:22 +0800
Message-ID: <20171220045731.19343-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
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
index 9042bab93785..bc405d0f3fc0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13699,6 +13699,11 @@ out:
 
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
@@ -13710,7 +13715,6 @@ out:
 		btrfs_commit_transaction(trans, root->fs_info->extent_root);
 
 	btrfs_release_path(&path);
-
 	return err;
 }
 
@@ -14121,6 +14125,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 {
 	u64 start = 0;
 	int ret;
+	int pin_extents = check_mode == CHECK_MODE_ORIGINAL;
 
 	/*
 	 * The only reason we don't do this is because right now we're just
@@ -14142,10 +14147,21 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
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



