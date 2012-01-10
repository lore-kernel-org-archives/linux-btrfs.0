From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: release space on error in page_mkwrite
Date: Tue, 10 Jan 2012 14:20:18 -0500
Message-ID: <1326223218-5342-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If updating the inode gave us an ENOSPC we were just returning in page_mkwrite,
which is a problem since we make our reservation right before trying to update
the inode, so fix the out label so that we actually free our reservation.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b0d7777..90a32f1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6509,8 +6509,8 @@ out_unlock:
 	if (!ret)
 		return VM_FAULT_LOCKED;
 	unlock_page(page);
-	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 out:
+	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 	return ret;
 }
 
-- 
1.7.5.2

