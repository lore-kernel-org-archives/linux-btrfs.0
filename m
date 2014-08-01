Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39933 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbaHAXMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:48 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/12] btrfs: consistently use fs_info in close_ctree()
Date: Fri,  1 Aug 2014 18:12:36 -0500
Message-Id: <1406934766-16974-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

close_ctree() has a local fs_info var for convienience;
use it consistently.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f6d7afd..e6746be 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3651,7 +3651,7 @@ int close_ctree(struct btrfs_root *root)
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_commit_super(root);
 		if (ret)
-			btrfs_err(root->fs_info, "commit super ret %d", ret);
+			btrfs_err(fs_info, "commit super ret %d", ret);
 	}
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
@@ -3663,10 +3663,10 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 2;
 	smp_mb();
 
-	btrfs_free_qgroup_config(root->fs_info);
+	btrfs_free_qgroup_config(fs_info);
 
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
-		btrfs_info(root->fs_info, "at unmount delalloc count %lld",
+		btrfs_info(fs_info, "at unmount delalloc count %lld",
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-- 
1.7.1

