From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check the return value of filemap_write_and_wait in the space cache
Date: Wed,  5 Oct 2011 16:33:33 -0400
Message-ID: <1317846813-19115-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We need to check the return value of filemap_write_and_wait in the space cache
writeout code.  Also don't set the inode's generation until we're sure nothing
else is going to fail.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 35bfc13..abc924c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -852,9 +852,10 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	if (ret)
 		goto out;
 
-	BTRFS_I(inode)->generation = trans->transid;
 
-	filemap_write_and_wait(inode->i_mapping);
+	ret = filemap_write_and_wait(inode->i_mapping);
+	if (ret)
+		goto out;
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
 	key.offset = offset;
@@ -884,6 +885,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			goto out;
 		}
 	}
+
+	BTRFS_I(inode)->generation = trans->transid;
 	header = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_free_space_header);
 	btrfs_set_free_space_entries(leaf, header, entries);
-- 
1.7.5.2

