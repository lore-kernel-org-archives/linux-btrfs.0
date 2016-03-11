Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbcCKWyR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 17:54:17 -0500
From: Ashish Samant <ashish.samant@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V3] btrfs: Print Warning only if ENOSPC_DEBUG is enabled
Date: Fri, 11 Mar 2016 14:54:05 -0800
Message-Id: <1457736845-27783-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dont print warning for ENOSPC error unless ENOSPC_DEBUG is enabled. Use 
btrfs_debug if it is enabled.

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>

V3:
 - Use btrfs_debug() instead of WARN() per David Sterba's comment.
V2:
 - Add a commit message.
---
 fs/btrfs/delayed-inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b57daa8..b7e44cc 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -651,9 +651,12 @@ static int btrfs_delayed_inode_reserve_metadata(
 			goto out;
 
 		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-		if (!WARN_ON(ret))
+		if (!ret)
 			goto out;
 
+		if (btrfs_test_opt(root, ENOSPC_DEBUG))
+			btrfs_debug(root->fs_info,
+				    "block rsv migrate returned %d\n", ret);
 		/*
 		 * Ok this is a problem, let's just steal from the global rsv
 		 * since this really shouldn't happen that often.
-- 
1.9.1

