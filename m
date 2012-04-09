From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: make btrfsck aware of free space inodes
Date: Mon,  9 Apr 2012 15:22:13 -0400
Message-ID: <1333999333-11529-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The new xfstests will run fsck against the volume to make sure we didn't
introduce any inconsistencies, which is nice except we will error out
immediately if we mount with inode_cache.  We need to make btrfsck skip the
special free space cache items and then just assume that we have a link for
the free space cache inode item.  This makes btrfsck pass with success on a
fs with inode cache items.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 btrfsck.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 7aac736..572dde0 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -274,6 +274,9 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		node->cache.size = 1;
 		node->data = rec;
 
+		if (ino == BTRFS_FREE_INO_OBJECTID)
+			rec->found_link = 1;
+
 		ret = insert_existing_cache_extent(inode_cache, &node->cache);
 		BUG_ON(ret);
 	}
@@ -1015,6 +1018,10 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
 		btrfs_item_key_to_cpu(eb, &key, i);
+
+		if (key.objectid == BTRFS_FREE_SPACE_OBJECTID)
+			continue;
+
 		if (active_node->current == NULL ||
 		    active_node->current->ino < key.objectid) {
 			if (active_node->current) {
-- 
1.7.5.2

