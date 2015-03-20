Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbbCTSCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 14:02:13 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C2906AB07
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 18:02:11 +0000 (UTC)
Message-ID: <550C60A1.9000708@suse.com>
Date: Fri, 20 Mar 2015 14:02:09 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: cleanup orphans while looking up default subvolume
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Orphans in the fs tree are cleaned up via open_ctree and subvolume
orphans are cleaned via btrfs_lookup_dentry -- except when a default
subvolume is in use.  The name for the default subvolume uses a manual
lookup that doesn't trigger orphan cleanup and needs to trigger it
manually as well. This doesn't apply to the remount case since the
subvolumes are cleaned up by walking the root radix tree.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef19..e477ed6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -901,6 +901,15 @@ find_root:
 	if (IS_ERR(new_root))
 		return ERR_CAST(new_root);
 
+	if (!(sb->s_flags & MS_RDONLY)) {
+		int ret;
+		down_read(&fs_info->cleanup_work_sem);
+		ret = btrfs_orphan_cleanup(new_root);
+		up_read(&fs_info->cleanup_work_sem);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
 	dir_id = btrfs_root_dirid(&new_root->root_item);
 setup_root:
 	location.objectid = dir_id;
-- 
1.8.5.6


-- 
Jeff Mahoney
SUSE Labs
