Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6847 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbbFSSyP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 14:54:15 -0400
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        wangyf <wangyf-fnst@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>, Omar Sandoval <osandov@fb.com>
Subject: [PATCH v2 2/5] Btrfs: count devices correctly in readahead during RAID 5/6 replace
Date: Fri, 19 Jun 2015 11:52:49 -0700
Message-ID: <fbccfbe0bbde4621b45ffd41f8276cfbcbd6d825.1434739053.git.osandov@fb.com>
In-Reply-To: <cover.1434739053.git.osandov@fb.com>
References: <cover.1434739053.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5fbc7c59fd22 ("Btrfs: fix unfinished readahead thread for raid5/6
degraded mounting") fixed a problem where we would skip a missing device
when we shouldn't have because there are no other mirrors to read from
in RAID 5/6. After commit 2c8cdd6ee4e7 ("Btrfs, replace: write dirty
pages into the replace target device"), the fix doesn't work when we're
doing a missing device replace on RAID 5/6 because the replace device is
counted as a mirror so we're tricked into thinking we can safely skip
the missing device. The fix is to count only the real stripes and decide
based on that.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/reada.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 0e7beea92b4c..4645cd16d5ba 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -328,6 +328,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	struct btrfs_device *prev_dev;
 	u32 blocksize;
 	u64 length;
+	int real_stripes;
 	int nzones = 0;
 	int i;
 	unsigned long index = logical >> PAGE_CACHE_SHIFT;
@@ -369,7 +370,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		goto error;
 	}
 
-	for (nzones = 0; nzones < bbio->num_stripes; ++nzones) {
+	real_stripes = bbio->num_stripes - bbio->num_tgtdevs;
+	for (nzones = 0; nzones < real_stripes; ++nzones) {
 		struct reada_zone *zone;
 
 		dev = bbio->stripes[nzones].dev;
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
