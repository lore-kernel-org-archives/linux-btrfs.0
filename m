From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't panic if we get an error while balancing
Date: Fri,  1 Jul 2011 16:21:45 -0400
Message-ID: <1309551705-16299-1-git-send-email-josef@redhat.com>
Cc: Anand.Jain@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported an error where if we try to balance an fs after a device has
been removed it will blow up.  This is because we get an EIO back and this is
where BUG_ON(ret) bites us in the ass.  To fix we just exit.  Thanks,

Reported-by: Anand Jain <Anand.Jain@oracle.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1efa56e..685bc0f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2098,7 +2098,8 @@ int btrfs_balance(struct btrfs_root *dev_root)
 					   chunk_root->root_key.objectid,
 					   found_key.objectid,
 					   found_key.offset);
-		BUG_ON(ret && ret != -ENOSPC);
+		if (ret != -ENOSPC)
+			goto error;
 		key.offset = found_key.offset - 1;
 	}
 	ret = 0;
-- 
1.7.5.2

