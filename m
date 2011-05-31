From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't save the inode cache if we are deleting this root
Date: Tue, 31 May 2011 15:33:33 -0400
Message-ID: <1306870413-3490-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com,
	chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With xfstest 254 I can panic the box every time with the inode number caching
stuff on.  This is because we clean the inodes out when we delete the subvolume,
but then we write out the inode cache which adds an inode to the subvolume inode
tree, and then when it gets evicted again the root gets added back on the dead
roots list and is deleted again, so we have a double free.  To stop this from
happening just return 0 if refs is 0 (and we're not the tree root since tree
root always has refs of 0).  With this fix 254 no longer panics.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode-map.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 3262cd1..2835375 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -388,6 +388,11 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	int prealloc;
 	bool retry = false;
 
+	/* Don't save inode cache if we are deleting this root */
+	if (btrfs_root_refs(&root->root_item) == 0 &&
+	    root != root->fs_info->tree_root)
+		return 0;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.7.2.3

