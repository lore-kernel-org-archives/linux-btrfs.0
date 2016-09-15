Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753259AbcIOS6C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 14:58:02 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8FItDv9013316
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 11:58:01 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 25g12t05sc-20
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 11:58:01 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: handle quota reserve failure properly
Date: Thu, 15 Sep 2016 14:57:48 -0400
Message-ID: <1473965868-9675-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs/022 was spitting a warning for the case that we exceed the quota.  If we
fail to make our quota reservation we need to clean up our data space
reservation.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 03da2f6..d72eaae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4286,13 +4286,10 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
-	 *
-	 * TODO: Find a good method to avoid reserve data space for NOCOW
-	 * range, but don't impact performance on quota disable case.
-	 */
+	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
 	ret = btrfs_qgroup_reserve_data(inode, start, len);
+	if (ret)
+		btrfs_free_reserved_data_space_noquota(inode, start, len);
 	return ret;
 }
 
-- 
2.7.4

