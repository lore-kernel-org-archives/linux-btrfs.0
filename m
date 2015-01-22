Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64234 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754060AbbAVFtt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 00:49:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0M5mt0r009233
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 13:48:55 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: qgroup: destroy related qgroup when removing subvolume if needed.
Date: Thu, 22 Jan 2015 13:46:22 +0800
Message-ID: <1421905582-4539-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1421905582-4539-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1421905582-4539-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When removing a subvol, if the related qgroup has no child qgroup, we should destroy
it at the same time. Also remove the TODO entry in qgroup.c.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c  | 4 ++++
 fs/btrfs/qgroup.c | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0..31de211 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -59,6 +59,7 @@
 #include "backref.h"
 #include "hash.h"
 #include "props.h"
+#include "qgroup.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -4029,6 +4030,9 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode_fallback(trans, root, dir);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
+	ret = btrfs_remove_qgroup(trans, root->fs_info, objectid);
+	if (ret == -EBUSY)
+		ret = 0;
 out:
 	btrfs_free_path(path);
 	return ret;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c3b1e4f..303c078 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -35,7 +35,6 @@
 #include "qgroup.h"
 
 /* TODO XXX FIXME
- *  - subvol delete -> delete when ref goes to 0? delete limits also?
  *  - reorganize keys
  *  - compressed
  *  - sync
-- 
1.8.4.2

