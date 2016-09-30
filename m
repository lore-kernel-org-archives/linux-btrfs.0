Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14911 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S935602AbcI3FFV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 01:05:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 4/4] btrfs-progs: volumes: Use new raid5_gen_result to calculate raid5 parity
Date: Fri, 30 Sep 2016 13:04:57 +0800
Message-Id: <20160930050457.22584-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
References: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use thew raid5_gen_result() function to calculate raid5 parity.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Patch split
---
 volumes.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/volumes.c b/volumes.c
index 93ce934..e78d157 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2112,7 +2112,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 {
 	struct extent_buffer **ebs, *p_eb = NULL, *q_eb = NULL;
 	int i;
-	int j;
 	int ret;
 	int alloc_size = eb->len;
 	void **pointers;
@@ -2167,18 +2166,12 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
 	} else {
 		ebs[multi->num_stripes - 1] = p_eb;
-		memcpy(p_eb->data, ebs[0]->data, stripe_len);
-		for (j = 1; j < multi->num_stripes - 1; j++) {
-			for (i = 0; i < stripe_len; i += sizeof(u64)) {
-				u64 p_eb_data;
-				u64 ebs_data;
-
-				p_eb_data = get_unaligned_64(p_eb->data + i);
-				ebs_data = get_unaligned_64(ebs[j]->data + i);
-				p_eb_data ^= ebs_data;
-				put_unaligned_64(p_eb_data, p_eb->data + i);
-			}
-		}
+		for (i = 0; i < multi->num_stripes; i++)
+			pointers[i] = ebs[i]->data;
+		ret = raid5_gen_result(multi->num_stripes, stripe_len,
+				       multi->num_stripes - 1, pointers);
+		if (ret < 0)
+			goto out_free_split;
 	}
 
 	for (i = 0; i < multi->num_stripes; i++) {
-- 
2.10.0



