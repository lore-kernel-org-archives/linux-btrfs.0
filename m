Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38581 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466AbaE1Kyc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 06:54:32 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4SAsSVx028119
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 18:54:28 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: fix uninitialized number count in chunk-recover
Date: Wed, 28 May 2014 18:49:37 +0800
Message-ID: <1401274178-4523-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When count the number of unordered device extents in chunk-recover,
the counter should be reinitialized to be used.
Also, introduce a new function for the counting job.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 84fd8b7..924b2f6 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1795,6 +1795,17 @@ static int insert_stripe(struct list_head *devexts,
 	return 0;
 }
 
+static inline int count_devext_records(struct list_head *record_list)
+{
+	int num_of_records = 0;
+	struct device_extent_record *devext;
+
+	list_for_each_entry(devext, record_list, chunk_list)
+		num_of_records++;
+
+	return num_of_records;
+}
+
 #define EQUAL_STRIPE (1 << 0)
 
 static int rebuild_raid_data_chunk_stripes(struct recover_control *rc,
@@ -1898,8 +1909,7 @@ next_csum:
 		fprintf(stderr, "Fetch csum failed\n");
 		goto fail_out;
 	} else if (ret == 1) {
-		list_for_each_entry(devext, &unordered, chunk_list)
-			num_unordered++;
+		num_unordered = count_devext_records(&unordered);
 		if (!(*flags & EQUAL_STRIPE))
 			*flags |= EQUAL_STRIPE;
 		goto out;
@@ -1927,8 +1937,7 @@ next_csum:
 	}
 
 	if (list_empty(&candidates)) {
-		list_for_each_entry(devext, &unordered, chunk_list)
-			num_unordered++;
+		num_unordered = count_devext_records(&unordered);
 		if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6
 					&& num_unordered == 2) {
 			list_splice_init(&unordered, &chunk->dextents);
@@ -1963,8 +1972,7 @@ next_stripe:
 out:
 	ret = 0;
 	list_splice_init(&candidates, &unordered);
-	list_for_each_entry(devext, &unordered, chunk_list)
-		num_unordered++;
+	num_unordered = count_devext_records(&unordered);
 	if (num_unordered == 1) {
 		for (i = 0; i < chunk->num_stripes; i++) {
 			if (!chunk->stripes[i].devid) {
-- 
1.8.1.4

