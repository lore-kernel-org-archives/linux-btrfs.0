Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19414 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752304AbbAMMgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 07:36:07 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 06/15] Btrfs: Remove noneed force_write in scrub_write_block_to_dev_replace
Date: Tue, 13 Jan 2015 20:34:39 +0800
Message-ID: <1421152488-30548-7-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421152488-30548-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421152488-30548-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It is always 1 in this place, because !1 case was already jumped
out in previous code.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f45399a..8ea5ce7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -250,8 +250,7 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 					 const u8 *csum, u64 generation,
 					 u16 csum_size);
 static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
-					     struct scrub_block *sblock_good,
-					     int force_write);
+					     struct scrub_block *sblock_good);
 static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 					    struct scrub_block *sblock_good,
 					    int page_num, int force_write);
@@ -1090,15 +1089,13 @@ nodatasum_case:
 		    sblock_other->no_io_error_seen) {
 			if (sctx->is_dev_replace) {
 				scrub_write_block_to_dev_replace(sblock_other);
+				goto corrected_error;
 			} else {
-				int force_write = is_metadata || have_csum;
-
 				ret = scrub_repair_block_from_good_copy(
-						sblock_bad, sblock_other,
-						force_write);
+						sblock_bad, sblock_other);
+				if (!ret)
+					goto corrected_error;
 			}
-			if (0 == ret)
-				goto corrected_error;
 		}
 	}
 
@@ -1611,8 +1608,7 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 }
 
 static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
-					     struct scrub_block *sblock_good,
-					     int force_write)
+					     struct scrub_block *sblock_good)
 {
 	int page_num;
 	int ret = 0;
@@ -1622,8 +1618,7 @@ static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
 
 		ret_sub = scrub_repair_page_from_good_copy(sblock_bad,
 							   sblock_good,
-							   page_num,
-							   force_write);
+							   page_num, 1);
 		if (ret_sub)
 			ret = ret_sub;
 	}
-- 
1.8.5.1

