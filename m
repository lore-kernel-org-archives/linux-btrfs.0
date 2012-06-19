Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23856 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab2FSMlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 08:41:10 -0400
Message-ID: <4FE07313.2040104@cn.fujitsu.com>
Date: Tue, 19 Jun 2012 20:39:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH] Btrfs: fix old data problem caused by aio vs dio
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 209th case of xfstests failed because of the race between aio and dio. The
detail reason is following:
	Task1		Task2			Btrfs-worker
			invalidate pages
	read pages
			do direct io
			invalidate pages*
						finish ordered io
	read data from
	pages

* This step failed because the kernel found the ordered extent object that
covered the pages and thought the pages were still under busy. And then Task1
read the old data from those pages.

And beside that, I think all the operations including metadata update and
bit cleanup of extent state should complete before the dio ends.

This patch fixes the above problem by changing the end io method of dio back
to the old one.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
We have other method to fix this problem, such as making the dio task wait until
the worker completes end io operation. But the way of this patch is the simplest
one. Josef, what do you think?
---
 fs/btrfs/inode.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f2c8cb..3ff862f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5988,7 +5988,6 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered = NULL;
 	u64 ordered_offset = dip->logical_offset;
 	u64 ordered_bytes = dip->bytes;
@@ -6003,10 +6002,7 @@ again:
 	if (!ret)
 		goto out_test;
 
-	ordered->work.func = finish_ordered_fn;
-	ordered->work.flags = 0;
-	btrfs_queue_worker(&root->fs_info->endio_write_workers,
-			   &ordered->work);
+	btrfs_finish_ordered_io(ordered);
 out_test:
 	/*
 	 * our bio might span multiple ordered extents.  If we haven't
@@ -6089,11 +6085,9 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 
 	bio_get(bio);
 
-	if (!write) {
-		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
-		if (ret)
-			goto err;
-	}
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	if (ret)
+		goto err;
 
 	if (skip_sum)
 		goto map;
-- 
1.7.6.5
