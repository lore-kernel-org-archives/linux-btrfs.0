From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Tue, 06 Dec 2011 13:35:47 +0800
Message-ID: <4EDDA9B3.60508@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The reason the deadlock is that:
  Task					Btrfs-cleaner
  umount()
    down_write(&s->s_umount)
    close_ctree()
      wait for the end of
      btrfs-cleaner
					start_transaction
					  reserve space
					    shrink_delalloc()
					      writeback_inodes_sb_nr_if_idle()
						down_read(&sb->s_umount)
So, the deadlock has happened.

We fix it by trying to lock >s_umount, if _trylock_ fails, it means the fs
is on remounting or umounting. At this time, we will use the sync function of
btrfs to sync all the delalloc file. It may waste lots of time, but as a
corner case, we needn't care.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 813c6bb..86c295d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3372,6 +3372,27 @@ out:
 	return ret;
 }
 
+void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
+				  unsigned long nr_pages)
+{
+	struct super_block *sb = root->fs_info->sb;
+
+	if (writeback_in_progress(sb->s_bdi))
+		return;
+
+	/*
+	 * If we can not get s_umount, it means the fs is on remounting or
+	 * umounting. At this time, we just sync all the delalloc file.
+	 */
+	if (down_read_trylock(&sb->s_umount)) {
+		writeback_inodes_sb_nr(sb, nr_pages);
+		up_read(&sb->s_umount);
+	} else {
+		btrfs_start_delalloc_inodes(root, 0);
+		btrfs_wait_ordered_extents(root, 0, 0);
+	}
+}
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3416,7 +3437,7 @@ static int shrink_delalloc(struct btrfs_root *root, u64 to_reclaim,
 		smp_mb();
 		nr_pages = min_t(unsigned long, nr_pages,
 		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
-		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
+		btrfs_writeback_inodes_sb_nr(root, nr_pages);
 
 		spin_lock(&space_info->lock);
 		if (reserved > space_info->bytes_may_use)
-- 
1.7.6.4
