Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58461 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725825AbeIEH2t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 03:28:49 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 674534B5CBE6
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 11:00:45 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: defrag: use btrfs_mod_outstanding_extents in cluster_pages_for_defrag
Date: Wed, 5 Sep 2018 11:07:33 +0800
Message-ID: <20180905030733.29720-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit 8b62f87bad9c ("Btrfs: rework outstanding_extents"),
manual operations of outstanding_extent in btrfs_inode are replaced by
btrfs_mod_outstanding_extents().
The one in cluster_pages_for_defrag seems to be lost, so replace it
of btrfs_mod_outstanding_extents().

Fixes: 8b62f87bad9c ("Btrfs: rework outstanding_extents")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63600dc2ac4c..c180ded27092 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1308,7 +1308,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
-		BTRFS_I(inode)->outstanding_extents++;
+		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
 				start_index << PAGE_SHIFT,
-- 
2.18.0
