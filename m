Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43603 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2IHCDn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2012 22:03:43 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, dave@jikos.cz
Subject: [PATCH v2 6/6] Btrfs: use larger limit for translation of logical to inode
Date: Sat,  8 Sep 2012 10:01:30 +0800
Message-Id: <1347069690-30223-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
References: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the change of the kernel side.

Translation of logical to inode used to have an upper limit 4k on
inode container's size, but the limit is not large enough for a data
with a great many of refs, so when resolving logical address,
we can end up with
"ioctl ret=0, bytes_left=0, bytes_missing=19944, cnt=510, missed=2493"

This changes to regard 64k as the upper limit and use vmalloc instead of
kmalloc to get memory more easily.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c |    2 +-
 fs/btrfs/ioctl.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 4e80ba3..fb72931 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1583,7 +1583,7 @@ struct btrfs_data_container *init_data_container(u32 total_bytes)
 	size_t alloc_bytes;
 
 	alloc_bytes = max_t(size_t, total_bytes, sizeof(*data));
-	data = kmalloc(alloc_bytes, GFP_NOFS);
+	data = vmalloc(alloc_bytes);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7bf3984..2503e37 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3238,7 +3238,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 		goto out;
 	}
 
-	size = min_t(u32, loi->size, 4096);
+	size = min_t(u32, loi->size, 64 * 1024);
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
@@ -3260,7 +3260,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 
 out:
 	btrfs_free_path(path);
-	kfree(inodes);
+	vfree(inodes);
 	kfree(loi);
 
 	return ret;
-- 
1.7.7.6

