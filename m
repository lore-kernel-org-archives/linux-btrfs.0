Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33269 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932779AbdC2BeK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 21:34:10 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH v3 5/5] btrfs: Prevent scrub recheck from racing with dev replace
Date: Wed, 29 Mar 2017 09:33:22 +0800
Message-ID: <20170329013322.1323-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

scrub_setup_recheck_block() calls btrfs_map_sblock() and then access
bbio without protection of bio_counter.

This can leads to use-after-free if racing with dev replace cancel.

Fix it by increasing bio_counter before calling btrfs_map_sblock() and
decrease the bio_counter when corresponding recover is finished.

Cc: Liu Bo <bo.li.liu@oracle.com>
Reported-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b8c49074d1b3..84b077c993c0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1072,9 +1072,11 @@ static inline void scrub_get_recover(struct scrub_recover *recover)
 	atomic_inc(&recover->refs);
 }
 
-static inline void scrub_put_recover(struct scrub_recover *recover)
+static inline void scrub_put_recover(struct btrfs_fs_info *fs_info,
+				     struct scrub_recover *recover)
 {
 	if (atomic_dec_and_test(&recover->refs)) {
+		btrfs_bio_counter_dec(fs_info);
 		btrfs_put_bbio(recover->bbio);
 		kfree(recover);
 	}
@@ -1464,7 +1466,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				sblock->pagev[page_index]->sblock = NULL;
 				recover = sblock->pagev[page_index]->recover;
 				if (recover) {
-					scrub_put_recover(recover);
+					scrub_put_recover(fs_info, recover);
 					sblock->pagev[page_index]->recover =
 									NULL;
 				}
@@ -1556,16 +1558,19 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 		 * with a length of PAGE_SIZE, each returned stripe
 		 * represents one mirror
 		 */
+		btrfs_bio_counter_inc_blocked(fs_info);
 		ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
 				logical, &mapped_length, &bbio, 0, 1);
 		if (ret || !bbio || mapped_length < sublen) {
 			btrfs_put_bbio(bbio);
+			btrfs_bio_counter_dec(fs_info);
 			return -EIO;
 		}
 
 		recover = kzalloc(sizeof(struct scrub_recover), GFP_NOFS);
 		if (!recover) {
 			btrfs_put_bbio(bbio);
+			btrfs_bio_counter_dec(fs_info);
 			return -ENOMEM;
 		}
 
@@ -1591,7 +1596,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 				spin_lock(&sctx->stat_lock);
 				sctx->stat.malloc_errors++;
 				spin_unlock(&sctx->stat_lock);
-				scrub_put_recover(recover);
+				scrub_put_recover(fs_info, recover);
 				return -ENOMEM;
 			}
 			scrub_page_get(page);
@@ -1633,7 +1638,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 			scrub_get_recover(recover);
 			page->recover = recover;
 		}
-		scrub_put_recover(recover);
+		scrub_put_recover(fs_info, recover);
 		length -= sublen;
 		logical += sublen;
 		page_index++;
-- 
2.12.1



