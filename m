Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49364 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750904AbdALOz7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:55:59 -0500
From: Milan Stephan <milan.stephan@fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Milan Stephan <milan.stephan+linux@fau.de>,
        Thomas Preisner <thomas.preisner+linux@fau.de>
Subject: [PATCH] btrfs: uuid-tree: btrfs_uuid_tree_iterate: fix improper return value
Date: Thu, 12 Jan 2017 15:55:45 +0100
Message-Id: <1484232945-45624-1-git-send-email-milan.stephan@fau.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Milan Stephan <milan.stephan+linux@fau.de>

Fixes return value of btrfs_uuid_tree_iterate to catch and return errors
when calling btrfs_alloc_path.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188731

Reported-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Milan Stephan <milan.stephan+linux@fau.de>
Signed-off-by: Thomas Preisner <thomas.preisner+linux@fau.de>
---
 fs/btrfs/uuid-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 161342b..12f873d 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -354,5 +354,5 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 	btrfs_free_path(path);
 	if (ret)
 		btrfs_warn(fs_info, "btrfs_uuid_tree_iterate failed %d", ret);
-	return 0;
+	return ret;
 }
-- 
2.7.4

