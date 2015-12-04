Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17559 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbLDA4T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 19:56:19 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: codebird@birds-are-nice.me
Subject: [PATCH] Btrfs: disable online scrub repair on ro cases
Date: Thu,  3 Dec 2015 16:55:58 -0800
Message-Id: <1449190558-11205-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This disables repair process on ro cases as it can cause system
to be unresponsive on the ASSERT() in repair_io_failure().

This can happen when scrub is running and a hardware error pops up,
we should fallback to ro mounts gracefully instead of being unresponsive.

Reported-by: Codebird <codebird@birds-are-nice.me>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2907a77..d6dd2f5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -682,6 +682,9 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 	struct btrfs_root *local_root;
 	int srcu_index;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-- 
2.5.0

