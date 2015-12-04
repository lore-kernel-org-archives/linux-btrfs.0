Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbLDR6Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 12:58:25 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: codebird@birds-are-nice.me
Subject: [PATCH V2] Btrfs: disable online scrub repair on ro cases
Date: Fri,  4 Dec 2015 09:58:04 -0800
Message-Id: <1449251884-24135-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1449190558-11205-1-git-send-email-bo.li.liu@oracle.com>
References: <1449190558-11205-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This disables repair process on ro cases as it can cause system
to be unresponsive on the ASSERT() in repair_io_failure().

This can happen when scrub is running and a hardware error pops up,
we should fallback to ro mounts gracefully instead of being unresponsive.

Reported-by: Codebird <codebird@birds-are-nice.me>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Get @fs_info from a real pointer instead of a confusing-name u64 root.

 fs/btrfs/scrub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2907a77..cb8a4e0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -682,11 +682,14 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 	struct btrfs_root *local_root;
 	int srcu_index;
 
+	fs_info = fixup->root->fs_info;
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
 
-	fs_info = fixup->root->fs_info;
 	srcu_index = srcu_read_lock(&fs_info->subvol_srcu);
 
 	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
-- 
2.5.0

