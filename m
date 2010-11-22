From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH -V2 1/3] btrfs: fix free dip and dip->csums twice
Date: Mon, 22 Nov 2010 11:01:39 +0800
Message-ID: <4CE9DD13.3090205@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

bio_endio() will free dip and dip->csums, so dip and dip->csums twice will
be freed twice. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..5a5edc7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5731,7 +5731,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
 	if (ret)
-		goto out_err;
+		goto free_ordered;
 
 	if (write && !skip_sum) {
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
@@ -5740,7 +5740,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 				   __btrfs_submit_bio_start_direct_io,
 				   __btrfs_submit_bio_done);
 		if (ret)
-			goto out_err;
+			goto free_ordered;
 		return;
 	} else if (!skip_sum)
 		btrfs_lookup_bio_sums_dio(root, inode, bio,
@@ -5748,11 +5748,8 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 
 	ret = btrfs_map_bio(root, rw, bio, 0, 1);
 	if (ret)
-		goto out_err;
+		goto free_ordered;
 	return;
-out_err:
-	kfree(dip->csums);
-	kfree(dip);
 free_ordered:
 	/*
 	 * If this is a write, we need to clean up the reserved space and kill
-- 
1.7.0.1
