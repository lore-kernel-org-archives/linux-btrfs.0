Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33733 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755197AbaFLCaW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 22:30:22 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5C2U8Dq024478
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 10:30:08 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: fix missing parity stripe for raid6 in chunk-recover
Date: Thu, 12 Jun 2014 10:24:59 +0800
Message-ID: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When deal with the p & q stripes for data profile raid6, chunk-recover
forgets to insert them into the chunk record. Just insert them back
freely.
Also wrap the inert procedure into a new function, fill_chunk_up.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index dfa7ff6..9b46b0b 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1785,6 +1785,23 @@ static inline int count_devext_records(struct list_head *record_list)
 	return num_of_records;
 }
 
+static int fill_chunk_up(struct chunk_record *chunk, struct list_head *devexts,
+			 struct recover_control *rc)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < chunk->num_stripes; i++) {
+		if (!chunk->stripes[i].devid) {
+			ret = insert_stripe(devexts, rc, chunk, i);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
 #define EQUAL_STRIPE (1 << 0)
 
 static int rebuild_raid_data_chunk_stripes(struct recover_control *rc,
@@ -1919,9 +1936,9 @@ next_csum:
 		num_unordered = count_devext_records(&unordered);
 		if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6
 					&& num_unordered == 2) {
-			list_splice_init(&unordered, &chunk->dextents);
 			btrfs_release_path(&path);
-			return 0;
+			ret = fill_chunk_up(chunk, &unordered, rc);
+			return ret;
 		}
 
 		goto next_stripe;
@@ -1966,14 +1983,7 @@ out:
 			& BTRFS_BLOCK_GROUP_RAID5)
 		 || (num_unordered == 3 && chunk->type_flags
 			& BTRFS_BLOCK_GROUP_RAID6)) {
-			for (i = 0; i < chunk->num_stripes; i++) {
-				if (!chunk->stripes[i].devid) {
-					ret = insert_stripe(&unordered, rc,
-							chunk, i);
-					if (ret)
-						break;
-				}
-			}
+			ret = fill_chunk_up(chunk, &unordered, rc);
 		}
 	}
 fail_out:
-- 
1.8.1.4

