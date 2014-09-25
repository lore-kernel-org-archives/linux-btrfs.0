Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:61141 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbaIYVdg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 17:33:36 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] Btrfs: remove redundant btrfs_verify_qgroup_counts  declaration.
Date: Thu, 25 Sep 2014 23:33:06 +0200
Message-Id: <1411680786-24886-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do like disk-io function declared under CONFIG_BTRFS_FS_RUN_SANITY_TESTS
and keep prototype in qgroup.h only

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/ctree.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 089f6da..67ef9d1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4126,8 +4126,6 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
-int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
-			       u64 rfer, u64 excl);
 #endif
 
 #endif
-- 
1.9.3

