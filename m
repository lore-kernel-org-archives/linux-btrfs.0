Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42261 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324AbcE0RDQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 13:03:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4RH2PUW009189
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:03:15 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 236s3wrgqf-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:03:15 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: don't BUG_ON() in btrfs_orphan_add
Date: Fri, 27 May 2016 13:03:04 -0400
Message-ID: <1464368584-3531-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just a screwup for developers, so change it to an ASSERT() so developers
notice when things go wrong and deal with the error appropriately if ASSERT()
isn't enabled.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6dd4cc..3c367a8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3256,7 +3256,16 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	/* grab metadata reservation from transaction handle */
 	if (reserve) {
 		ret = btrfs_orphan_reserve_metadata(trans, inode);
-		BUG_ON(ret); /* -ENOSPC in reservation; Logic error? JDM */
+		ASSERT(!ret);
+		if (ret) {
+			atomic_dec(&root->orphan_inodes);
+			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+				  &BTRFS_I(inode)->runtime_flags);
+			if (insert)
+				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+					  &BTRFS_I(inode)->runtime_flags);
+			return ret;
+		}
 	}
 
 	/* insert an orphan item to track this unlinked/truncated file */
-- 
1.8.3.1

