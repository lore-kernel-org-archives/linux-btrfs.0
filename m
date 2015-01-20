Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7142 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbbATHNM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 02:13:12 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 10/15] Btrfs: Separate finding-right-mirror and writing-to-target's process in scrub_handle_errored_block()
Date: Tue, 20 Jan 2015 15:11:40 +0800
Message-ID: <1421737905-1693-11-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421737905-1693-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421737905-1693-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

In corrent code, code of finding-right-mirror and writing-to-target
are mixed in logic, if we find a right mirror but failed in writing
to target, it will treat as "hadn't found right block", and fill the
target with sblock_bad.

Actually, "failed in writing to target" does not mean "source
block is wrong", this patch separate above two condition in logic,
and do some cleanup to make code clean.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9afc6dd..26d5dbf 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1106,35 +1106,21 @@ nodatasum_case:
 		success = 1;
 		for (page_num = 0; page_num < sblock_bad->page_count;
 		     page_num++) {
-			int sub_success;
+			struct scrub_block *sblock_other = NULL;
 
-			sub_success = 0;
 			for (mirror_index = 0;
 			     mirror_index < BTRFS_MAX_MIRRORS &&
 			     sblocks_for_recheck[mirror_index].page_count > 0;
 			     mirror_index++) {
-				struct scrub_block *sblock_other =
-					sblocks_for_recheck + mirror_index;
-				struct scrub_page *page_other =
-					sblock_other->pagev[page_num];
-
-				if (!page_other->io_error) {
-					ret = scrub_write_page_to_dev_replace(
-							sblock_other, page_num);
-					if (ret == 0) {
-						/* succeeded for this page */
-						sub_success = 1;
-						break;
-					} else {
-						btrfs_dev_replace_stats_inc(
-							&sctx->dev_root->
-							fs_info->dev_replace.
-							num_write_errors);
-					}
+				if (!sblocks_for_recheck[mirror_index].
+				    pagev[page_num]->io_error) {
+					sblock_other = sblocks_for_recheck +
+						       mirror_index;
+					break;
 				}
 			}
 
-			if (!sub_success) {
+			if (!sblock_other) {
 				/*
 				 * did not find a mirror to fetch the page
 				 * from. scrub_write_page_to_dev_replace()
@@ -1142,13 +1128,17 @@ nodatasum_case:
 				 * filling the block with zeros before
 				 * submitting the write request
 				 */
+				sblock_other = sblock_bad;
+				success = 0;
+			}
+
+			if (scrub_write_page_to_dev_replace(sblock_other,
+							    page_num) != 0) {
+				btrfs_dev_replace_stats_inc(
+					&sctx->dev_root->
+					fs_info->dev_replace.
+					num_write_errors);
 				success = 0;
-				ret = scrub_write_page_to_dev_replace(
-						sblock_bad, page_num);
-				if (ret)
-					btrfs_dev_replace_stats_inc(
-						&sctx->dev_root->fs_info->
-						dev_replace.num_write_errors);
 			}
 		}
 
-- 
1.8.5.1

