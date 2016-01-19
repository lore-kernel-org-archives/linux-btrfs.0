Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985AbcASKoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 05:44:00 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] Btrfs: clean up an error code in btrfs_init_space_info()
Date: Tue, 19 Jan 2016 11:43:54 +0100
Message-Id: <0dc924c5f2a3c4d999e12feaccee5f970cea1315.1453199864.git.dsterba@suse.com>
In-Reply-To: <cover.1453199864.git.dsterba@suse.com>
References: <cover.1453199864.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

If we return 1 here, then the caller treats it as an error and returns
-EINVAL.  It causes a static checker warning to treat positive returns
as an error.

Fixes: 1aba86d67f34 ('Btrfs: fix easily get into ENOSPC in mixed case')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8c912894a5bd..9d70330c6ebf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10509,7 +10509,7 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 
 	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
-		return 1;
+		return -EINVAL;
 
 	features = btrfs_super_incompat_flags(disk_super);
 	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
-- 
2.6.3

