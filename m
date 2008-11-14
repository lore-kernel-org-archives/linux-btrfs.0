From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix free space leak
Date: Fri, 14 Nov 2008 16:33:32 -0500
Message-ID: <20081114213332.GD19225@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

In my batch delete/update/insert patch I introduced a free space leak.  The
extent that we do the original search on in free_extents is never pinned, so we
always update the block saying that it has free space, but the free space never
actually gets added to the free space tree, since op->del will always be 0 and
it's never actually added to the pinned extents tree.  This patch fixes this
problem by making sure we call pin_down_bytes on the pending extent op and set
op->del to the return value of pin_down_bytes so update_block_group is called
with the right value.  This seems to fix the case where we were getting ENOSPC
when there was plenty of space available.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6eb56a0..93726ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -999,6 +999,14 @@ search:
 		path->slots[0] = extent_slot;
 		bytes_freed = op->num_bytes;
 
+		mutex_lock(&info->pinned_mutex);
+		ret = pin_down_bytes(trans, extent_root, op->bytenr,
+				     op->num_bytes, op->level >=
+				     BTRFS_FIRST_FREE_OBJECTID);
+		mutex_unlock(&info->pinned_mutex);
+		BUG_ON(ret < 0);
+		op->del = ret;
+
 		/*
 		 * we need to see if we can delete multiple things at once, so
 		 * start looping through the list of extents we are wanting to
