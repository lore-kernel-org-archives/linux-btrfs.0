Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14543 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754486AbbB0IYe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:24:34 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8NcdJ019766
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:23:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/7] btrfs: Don't allow subvolid >= (1 << BTRFS_QGROUP_LEVEL_SHIFT) to be created
Date: Fri, 27 Feb 2015 16:24:23 +0800
Message-ID: <1425025468-29749-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs will create qgroup on subvolume creation if quota is enabled, but
qgroup uses the high bits(currently 16 bits) as level, to build the
inheritance.

However it is fully possible a subvolume can be created with a
subvolumeid larger than 1 << BTRFS_QGROUP_LEVEL_SHIFT, so it will be
considered as level 1 and can't be assigned to other qgroup in level 1.

This patch will prevent such things so qgroup inheritance will not be
screwed up.
The downside is very clear, btrfs subvolume number limit will decrease
from (u64 max - 256(fisrt free objectid) - 256(last free objectid)) to
(u48 max -256(first free objectid)).
But we still have near u48(that's 15 digits in dec), so that should not
be a huge problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 3 ++-
 fs/btrfs/ioctl.c | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cbaf1a4..fb4b52b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4200,7 +4200,8 @@ int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 static inline int is_fstree(u64 rootid)
 {
 	if (rootid == BTRFS_FS_TREE_OBJECTID ||
-	    (s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID)
+	    ((s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID &&
+	      !btrfs_qgroup_level(rootid)))
 		return 1;
 	return 0;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d49fe8a..f93ca4b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -456,6 +456,13 @@ static noinline int create_subvol(struct inode *dir,
 	if (ret)
 		return ret;
 
+	/*
+	 * Don't create subvolume whose level is not zero. Or qgroup will be
+	 * screwed up since it assume subvolme qgroup's level to be 0.
+	 */
+	if (btrfs_qgroup_level(objectid))
+		return -ENOSPC;
+
 	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
 	/*
 	 * The same as the snapshot creation, please see the comment
-- 
2.3.0

