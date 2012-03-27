From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 03/10] Btrfs: fix race between direct io and autodefrag
Date: Tue, 27 Mar 2012 14:44:31 +0800
Message-ID: <1332830678-3992-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

The bug is from running xfstests 209 with autodefrag.

The race is as follows:
       t1                       t2(autodefrag)
   direct IO
     invalidate pagecache
     dio(old data)             add_inode_defrag
     invalidate pagecache
   endio

   direct IO
     invalidate pagecache
                                run_defrag
                                  readpage(old data)
                                  set page dirty (old data)
     dio(new data, rewrite)
     invalidate pagecache (*)
     endio

t2(autodefrag) will get old data into pagecache via readpage and set
pagecache dirty.  Meanwhile, invalidate pagecache(*) will fail due to
dirty flags in pages.  So the old data may be flushed into disk by
flush thread, which will lead to data loss.

And so does the case of user defragment progs.

The patch fixes this race by holding i_mutex when we readpage and set page dirty.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d8b5471..0acc828 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1123,12 +1123,16 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			ra_index += max_cluster;
 		}
 
+		mutex_lock(&inode->i_mutex);
 		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
-		if (ret < 0)
+		if (ret < 0) {
+			mutex_unlock(&inode->i_mutex);
 			goto out_ra;
+		}
 
 		defrag_count += ret;
 		balance_dirty_pages_ratelimited_nr(inode->i_mapping, ret);
+		mutex_unlock(&inode->i_mutex);
 
 		if (newer_than) {
 			if (newer_off == (u64)-1)
-- 
1.6.5.2

