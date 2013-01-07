Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:38367 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab3AGWEV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 17:04:21 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id HgnjKXOvj9egQcHL (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2013 15:04:20 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make btrfsck aware of free space inodes
Date: Mon, 7 Jan 2013 17:10:56 -0500
Message-ID: <1357596656-11658-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

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
1.7.7.6

