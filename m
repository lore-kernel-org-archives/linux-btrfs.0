Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:39600 "EHLO m50-133.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbcLCKz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Dec 2016 05:55:56 -0500
From: Pan Bian <bianpan2016@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] btrfs: fix improper return value
Date: Sat,  3 Dec 2016 18:55:16 +0800
Message-Id: <1480762516-5002-1-git-send-email-bianpan2016@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function btrfs_uuid_tree_iterate(), errno is assigned to variable
ret on errors. However, it directly returns 0. It may be better to
return ret.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188731

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/btrfs/uuid-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 7fc89e4..44bcc1f 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -353,5 +353,5 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 	btrfs_free_path(path);
 	if (ret)
 		btrfs_warn(fs_info, "btrfs_uuid_tree_iterate failed %d", ret);
-	return 0;
+	return ret;
 }
-- 
1.9.1


