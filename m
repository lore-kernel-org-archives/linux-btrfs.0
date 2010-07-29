From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 6/7] btrfs: check the return value of btrfs_start_workers()
 in open_ctree()
Date: Thu, 29 Jul 2010 16:31:34 +0800
Message-ID: <4C513C66.8010109@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_start_workers() failed, we must stop mounting the btrfs, otherwise
the btrfs can't run well because there is no kthread to deal with the request
submited by it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 280de15..4dd6bf0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1775,15 +1775,30 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->endio_write_workers.idle_thresh = 2;
 	fs_info->endio_meta_write_workers.idle_thresh = 2;
 
-	btrfs_start_workers(&fs_info->workers, 1);
-	btrfs_start_workers(&fs_info->generic_worker, 1);
-	btrfs_start_workers(&fs_info->submit_workers, 1);
-	btrfs_start_workers(&fs_info->delalloc_workers, 1);
-	btrfs_start_workers(&fs_info->fixup_workers, 1);
-	btrfs_start_workers(&fs_info->endio_workers, 1);
-	btrfs_start_workers(&fs_info->endio_meta_workers, 1);
-	btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
-	btrfs_start_workers(&fs_info->endio_write_workers, 1);
+	/*
+	 * We must start generic_worker first because it is used to create
+	 * other workers.
+	 */
+	ret = btrfs_start_workers(&fs_info->generic_worker, 1);
+	if (ret) {
+		printk(KERN_INFO "btrfs: start generic workers failed on %s\n",
+		       sb->s_id);
+		goto fail_iput;
+	}
+
+	ret |= btrfs_start_workers(&fs_info->workers, 1);
+	ret |= btrfs_start_workers(&fs_info->submit_workers, 1);
+	ret |= btrfs_start_workers(&fs_info->delalloc_workers, 1);
+	ret |= btrfs_start_workers(&fs_info->fixup_workers, 1);
+	ret |= btrfs_start_workers(&fs_info->endio_workers, 1);
+	ret |= btrfs_start_workers(&fs_info->endio_meta_workers, 1);
+	ret |= btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
+	ret |= btrfs_start_workers(&fs_info->endio_write_workers, 1);
+	if (ret) {
+		printk(KERN_INFO "btrfs: start other workers failed on %s\n",
+		       sb->s_id);
+		goto fail_sb_buffer;
+	}
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
-- 
1.7.0.1
