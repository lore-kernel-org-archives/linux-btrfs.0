Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41558 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2IRO3u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 10:29:50 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: fengguang.wu@intel.com
Subject: [PATCH] Btrfs: fix a compiling warning
Date: Tue, 18 Sep 2012 22:27:45 +0800
Message-Id: <1347978465-20500-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NOTE:
This is against btrfs-next git repo.

fs/btrfs/inode.c: In function ‘relink_extent_backref’:
fs/btrfs/inode.c:2185:6: warning: passing argument 2 of
‘btrfs_drop_extents’ from incompatible pointer type [enabled by default]
fs/btrfs/ctree.h:3340:5: note: expected ‘struct btrfs_root *’ but argument is of type ‘struct inode *’
fs/btrfs/inode.c:2185:6: warning: passing argument 3 of ‘btrfs_drop_extents’ makes pointer from integer without a cast [enabled by default]
fs/btrfs/ctree.h:3340:5: note: expected ‘struct inode *’ but argument is of type ‘u64’
fs/btrfs/inode.c:2185:6: warning: passing argument 5 of ‘btrfs_drop_extents’ makes integer from pointer without a cast [enabled by default]
fs/btrfs/ctree.h:3340:5: note: expected ‘u64’ but argument is of type ‘u64 *’

We didn't update the related functions after someone changed the API.

This fixes it.

Reported-by: <fengguang.wu@intel.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2a6e9fb..1f85d37 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2095,7 +2095,6 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	struct inode *inode;
 	struct extent_state *cached = NULL;
 	int ret = 0;
-	u64 hint_byte;
 	u64 start;
 	u64 len;
 	bool merge = false;
@@ -2181,8 +2180,8 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 		  old->extent_offset + old->offset + old->len);
 	len -= max(backref->extent_offset, old->extent_offset + old->offset);
 
-	ret = btrfs_drop_extents(trans, inode, start,
-				 start + len, &hint_byte, 1);
+	ret = btrfs_drop_extents(trans, BTRFS_I(inode)->root, inode, start,
+				 start + len, 1);
 	if (ret)
 		goto out_free_path;
 again:
-- 
1.7.7.6

