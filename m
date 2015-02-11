Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64635 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753380AbbBKUJG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 15:09:06 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t1BK56kG002666
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2015 12:09:05 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1sgc180cvg-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2015 12:09:05 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: don't set and clear delalloc for O_DIRECT writes
Date: Wed, 11 Feb 2015 15:08:58 -0500
Message-ID: <1423685339-8278-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1423685339-8278-1-git-send-email-jbacik@fb.com>
References: <1423685339-8278-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We do this to get the space accounting, but this is just needless churn on the
io_tree, so just drop setting/clearing delalloc and just drop the reserved data
space when we have a successfull allocation.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e78a2fd..fb16fd3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7142,7 +7142,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	int ret = 0;
 
 	if (create)
-		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
+		unlock_bits |= EXTENT_DIRTY;
 	else
 		len = min_t(u64, len, root->sectorsize);
 
@@ -7278,11 +7278,7 @@ unlock:
 			BTRFS_I(inode)->outstanding_extents++;
 			spin_unlock(&BTRFS_I(inode)->lock);
 		}
-
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
-				     &cached_state, GFP_NOFS);
-		BUG_ON(ret);
+		btrfs_free_reserved_data_space(inode, len);
 	}
 
 	/*
-- 
1.8.3.1

