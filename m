Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27453 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756059AbcDLQyq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 12:54:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3CGqQeC021773
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 09:54:45 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 22932sgk3p-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 09:54:45 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: remove BUG_ON()'s in btrfs_map_block
Date: Tue, 12 Apr 2016 12:54:40 -0400
Message-ID: <1460480080-27063-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_map_block can go horribly wrong in the face of fs corruption, lets agree
to not be assholes and panic at any possible chance things are all fucked up.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e2b54d5..ba8216b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5278,7 +5278,18 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	stripe_nr = div64_u64(stripe_nr, stripe_len);
 
 	stripe_offset = stripe_nr * stripe_len;
-	BUG_ON(offset < stripe_offset);
+	if (offset < stripe_offset) {
+		btrfs_crit(fs_info, "stripe math has gone wrong, "
+			   "stripe_offset=%llu, offset=%llu, start=%llu, "
+			   "logical=%llu, stripe_len=%llu\n",
+			   (unsigned long long)stripe_offset,
+			   (unsigned long long)offset,
+			   (unsigned long long)em->start,
+			   (unsigned long long)logical,
+			   (unsigned long long)stripe_len);
+		free_extent_map(em);
+		return -EINVAL;
+	}
 
 	/* stripe_offset is the offset of this block in its stripe*/
 	stripe_offset = offset - stripe_offset;
@@ -5519,7 +5530,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				&stripe_index);
 		mirror_num = stripe_index + 1;
 	}
-	BUG_ON(stripe_index >= map->num_stripes);
+	if (stripe_index >= map->num_stripes) {
+		btrfs_crit(fs_info, "stripe index math went horribly wrong, "
+			   "got stripe_index=%lu, num_stripes=%lu\n",
+			   (unsigned long)stripe_index,
+			   (unsigned long)map->num_stripes);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	num_alloc_stripes = num_stripes;
 	if (dev_replace_is_ongoing) {
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
