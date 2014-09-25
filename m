Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37666 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaIYUKw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 16:10:52 -0400
Received: from pps.filterd (m0004346 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8PK9F6v011662
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 13:10:52 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pmshxg11s-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 13:10:51 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: don't assert when we have an invalid mapping
Date: Thu, 25 Sep 2014 16:10:48 -0400
Message-ID: <1411675848-4437-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Asserting is no fun, we may be able to recover from this error in certain cases
(like btrfs-image and btrfsck).  Just do what the kernel does and spit out an
error and return that there is only 1 copy.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 volumes.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index 388c94e..009ce78 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1136,8 +1136,20 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	int ret;
 
 	ce = search_cache_extent(&map_tree->cache_tree, logical);
-	BUG_ON(!ce);
-	BUG_ON(ce->start > logical || ce->start + ce->size < logical);
+	if (!ce) {
+		fprintf(stderr, "No mapping for %llu-%llu\n",
+			(unsigned long long)logical,
+			(unsigned long long)logical+len);
+		return 1;
+	}
+	if (ce->start > logical || ce->start + ce->size < logical) {
+		fprintf(stderr, "Invalid mapping for %llu-%llu, got "
+			"%llu-%llu\n", (unsigned long long)logical,
+			(unsigned long long)logical+len,
+			(unsigned long long)ce->start,
+			(unsigned long long)ce->start + ce->size);
+		return 1;
+	}
 	map = container_of(ce, struct map_lookup, ce);
 
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
-- 
1.9.3

