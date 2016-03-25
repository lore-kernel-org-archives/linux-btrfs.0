Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34911 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbcCYR00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:26 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHKUUe021302
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:24 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 21vva6jmxj-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:24 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/14] Btrfs: fix delalloc reservation amount tracepoint
Date: Fri, 25 Mar 2016 13:25:55 -0400
Message-ID: <1458926760-17563-10-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can sometimes drop the reservation we had for our inode, so we need to remove
that amount from to_reserve so that our tracepoint reports a valid amount of
space.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 26f7a9d..1221c07 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5922,8 +5922,10 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	if (test_and_set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-			     &BTRFS_I(inode)->runtime_flags))
+			     &BTRFS_I(inode)->runtime_flags)) {
+		to_reserve -= btrfs_calc_trans_metadata_size(root, 1);
 		release_extra = true;
+	}
 	BTRFS_I(inode)->reserved_extents += nr_extents;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
-- 
2.5.0

