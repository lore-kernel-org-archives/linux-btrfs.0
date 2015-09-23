Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7447 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbbIWVNs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 17:13:48 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t8NKR34n000327
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 14:13:48 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1x417p102y-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 14:13:48 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: fix prealloc under heavy fragmentation conditions
Date: Wed, 23 Sep 2015 17:13:43 -0400
Message-ID: <1443042823-4895-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we are heavily fragmented we will continually try to prealloc the largest
extent size we can every time we call btrfs_reserve_extent.  This can be very
expensive when we are heavily fragmented, burning lots of CPU cycles and loops
through the allocator.  So instead notice when we get a smaller chunk from the
allocator than what we specified and use this as the new maximum size we try to
allocate.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 79d568f..424dab7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9599,6 +9599,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	u64 cur_offset = start;
 	u64 i_size;
 	u64 cur_bytes;
+	u64 last_alloc = (u64)-1;
 	int ret = 0;
 	bool own_trans = true;
 
@@ -9615,6 +9616,13 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		cur_bytes = min(num_bytes, 256ULL * 1024 * 1024);
 		cur_bytes = max(cur_bytes, min_size);
+		/*
+		 * If we are severely fragmented we could end up with really
+		 * small allocations, so if the allocator is returning small
+		 * chunks lets make its job easier by only searching for those
+		 * sized chunks.
+		 */
+		cur_bytes = min(cur_bytes, last_alloc);
 		ret = btrfs_reserve_extent(root, cur_bytes, min_size, 0,
 					   *alloc_hint, &ins, 1, 0);
 		if (ret) {
@@ -9623,6 +9631,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			break;
 		}
 
+		last_alloc = ins.offset;
 		ret = insert_reserved_file_extent(trans, inode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
-- 
1.8.3.1

