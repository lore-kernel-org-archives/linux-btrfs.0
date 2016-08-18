Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3663 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754065AbcHSAt6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Aug 2016 20:49:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.17/8.16.0.17) with SMTP id u7IJ4INR001888
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Aug 2016 12:30:11 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0089730.ppops.net with ESMTP id 24w7vww70g-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Aug 2016 12:30:11 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix em leak in find_first_block_group
Date: Thu, 18 Aug 2016 15:30:06 -0400
Message-ID: <1471548606-1433-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to call free_extent_map() on the em we look up.Btrfs: fix em leak in
find_first_block_group

We need to call free_extent_map() on the em we look up.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61b494e..20f9fa6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9906,6 +9906,7 @@ static int find_first_block_group(struct btrfs_root *root,
 			} else {
 				ret = 0;
 			}
+			free_extent_map(em);
 			goto out;
 		}
 		path->slots[0]++;
-- 
1.8.3.1

