From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH -V2 3/3] btrfs: fix panic caused by direct IO
Date: Mon, 22 Nov 2010 11:04:43 +0800
Message-ID: <4CE9DDCB.7060706@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

V1->V2 Changes:
change the fix method. we split bios in btrfs_submit_direct() to fix this
problem now.

btrfs paniced when we write >64KB data by direct IO at one time.

Reproduce steps:
 # mkfs.btrfs /dev/sda5 /dev/sda6
 # mount /dev/sda5 /mnt
 # dd if=/dev/zero of=/mnt/tmpfile bs=100K count=1 oflag=direct

Then btrfs paniced:
mapping failed logical 1103155200 bio len 69632 len 12288
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3010!
[SNIP]
Pid: 1992, comm: btrfs-worker-0 Not tainted 2.6.37-rc1 #1 D2399/PRIMERGY
RIP: 0010:[<ffffffffa03d1462>]  [<ffffffffa03d1462>] btrfs_map_bio+0x202/0x210 [btrfs]
[SNIP]
Call Trace:
 [<ffffffffa03ab3eb>] __btrfs_submit_bio_done+0x1b/0x20 [btrfs]
 [<ffffffffa03a35ff>] run_one_async_done+0x9f/0xb0 [btrfs]
 [<ffffffffa03d3d20>] run_ordered_completions+0x80/0xc0 [btrfs]
 [<ffffffffa03d45a4>] worker_loop+0x154/0x5f0 [btrfs]
 [<ffffffffa03d4450>] ? worker_loop+0x0/0x5f0 [btrfs]
 [<ffffffffa03d4450>] ? worker_loop+0x0/0x5f0 [btrfs]
 [<ffffffff81083216>] kthread+0x96/0xa0
 [<ffffffff8100cec4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81083180>] ? kthread+0x0/0xa0
 [<ffffffff8100cec0>] ? kernel_thread_helper+0x0/0x10

We fix this problem by splitting bios when we submit bios.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |  205 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 184 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a5edc7..c91d0e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5535,13 +5535,21 @@ struct btrfs_dio_private {
 	u64 bytes;
 	u32 *csums;
 	void *private;
+
+	/* number of bios pending for this dio */
+	atomic_t pending_bios;
+
+	/* IO errors */
+	int errors;
+
+	struct bio *orig_bio;
 };
 
 static void btrfs_endio_direct_read(struct bio *bio, int err)
 {
+	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
-	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start;
@@ -5684,6 +5692,176 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 	return 0;
 }
 
+static void btrfs_end_dio_bio(struct bio *bio, int err)
+{
+	struct btrfs_dio_private *dip = bio->bi_private;
+
+	if (err) {
+		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
+		      "disk_bytenr %lu len %u err no %d\n",
+		      dip->inode->i_ino, bio->bi_rw, bio->bi_sector,
+		      bio->bi_size, err);
+		dip->errors = 1;
+
+		/*
+		 * before atomic variable goto zero, we must make sure
+		 * dip->errors is perceived to be set.
+		 */
+		smp_mb__before_atomic_dec();
+	}
+
+	/* if there are more bios still pending for this dio, just exit */
+	if (!atomic_dec_and_test(&dip->pending_bios))
+		goto out;
+
+	if (dip->errors)
+		bio_io_error(dip->orig_bio);
+	else {
+		set_bit(BIO_UPTODATE, &dip->orig_bio->bi_flags);
+		bio_endio(dip->orig_bio, 0);
+	}
+out:
+	bio_put(bio);
+}
+
+static struct bio *btrfs_dio_bio_alloc(struct block_device *bdev,
+				       u64 first_sector, gfp_t gfp_flags)
+{
+	int nr_vecs = bio_get_nr_vecs(bdev);
+	return btrfs_bio_alloc(bdev, first_sector, nr_vecs, gfp_flags);
+}
+
+static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
+					 int rw, u64 file_offset, int skip_sum,
+					 u32 *csums)
+{
+	int write = rw & REQ_WRITE;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	bio_get(bio);
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	if (ret)
+		goto err;
+
+	if (write && !skip_sum) {
+		ret = btrfs_wq_submit_bio(root->fs_info,
+				   inode, rw, bio, 0, 0,
+				   file_offset,
+				   __btrfs_submit_bio_start_direct_io,
+				   __btrfs_submit_bio_done);
+		goto err;
+	} else if (!skip_sum)
+		btrfs_lookup_bio_sums_dio(root, inode, bio,
+					  file_offset, csums);
+
+	ret = btrfs_map_bio(root, rw, bio, 0, 1);
+err:
+	bio_put(bio);
+	return ret;
+}
+
+static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
+				    int skip_sum)
+{
+	struct inode *inode = dip->inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	struct bio *bio;
+	struct bio *orig_bio = dip->orig_bio;
+	struct bio_vec *bvec = orig_bio->bi_io_vec;
+	u64 start_sector = orig_bio->bi_sector;
+	u64 file_offset = dip->logical_offset;
+	u64 submit_len = 0;
+	u64 map_length;
+	int nr_pages = 0;
+	u32 *csums = dip->csums;
+	int ret = 0;
+
+	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
+	if (!bio)
+		return -ENOMEM;
+	bio->bi_private = dip;
+	bio->bi_end_io = btrfs_end_dio_bio;
+	atomic_inc(&dip->pending_bios);
+
+	map_length = orig_bio->bi_size;
+	ret = btrfs_map_block(map_tree, READ, start_sector << 9,
+			      &map_length, NULL, 0);
+	if (ret) {
+		bio_put(bio);
+		return -EIO;
+	}
+
+	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
+		if (unlikely(map_length < submit_len + bvec->bv_len ||
+		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
+				 bvec->bv_offset) < bvec->bv_len)) {
+			/*
+			 * inc the count before we submit the bio so
+			 * we know the end IO handler won't happen before
+			 * we inc the count. Otherwise, the dip might get freed
+			 * before we're done setting it up
+			 */
+			atomic_inc(&dip->pending_bios);
+			ret = __btrfs_submit_dio_bio(bio, inode, rw,
+						     file_offset, skip_sum,
+						     csums);
+			if (ret) {
+				bio_put(bio);
+				atomic_dec(&dip->pending_bios);
+				goto out_err;
+			}
+
+			if (!skip_sum)
+				csums = csums + nr_pages;
+			start_sector += submit_len >> 9;
+			file_offset += submit_len;
+
+			submit_len = 0;
+			nr_pages = 0;
+
+			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
+						  start_sector, GFP_NOFS);
+			if (!bio)
+				goto out_err;
+			bio->bi_private = dip;
+			bio->bi_end_io = btrfs_end_dio_bio;
+
+			map_length = orig_bio->bi_size;
+			ret = btrfs_map_block(map_tree, READ, start_sector << 9,
+					      &map_length, NULL, 0);
+			if (ret) {
+				bio_put(bio);
+				goto out_err;
+			}
+		} else {
+			submit_len += bvec->bv_len;
+			nr_pages ++;
+			bvec++;
+		}
+	}
+
+	ret = __btrfs_submit_dio_bio(bio, inode, rw, file_offset, skip_sum,
+				     csums);
+	if (!ret)
+		return 0;
+
+	bio_put(bio);
+out_err:
+	dip->errors = 1;
+	/*
+	 * before atomic variable goto zero, we must
+	 * make sure dip->errors is perceived to be set.
+	 */
+	smp_mb__before_atomic_dec();
+	if (atomic_dec_and_test(&dip->pending_bios))
+		bio_io_error(dip->orig_bio);
+
+	/* bio_end_io() will handle error, so we needn't return it */
+	return 0;
+}
+
 static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 				loff_t file_offset)
 {
@@ -5723,33 +5901,18 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 
 	dip->disk_bytenr = (u64)bio->bi_sector << 9;
 	bio->bi_private = dip;
+	dip->errors = 0;
+	dip->orig_bio = bio;
+	atomic_set(&dip->pending_bios, 0);
 
 	if (write)
 		bio->bi_end_io = btrfs_endio_direct_write;
 	else
 		bio->bi_end_io = btrfs_endio_direct_read;
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
-	if (ret)
-		goto free_ordered;
-
-	if (write && !skip_sum) {
-		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-				   inode, rw, bio, 0, 0,
-				   dip->logical_offset,
-				   __btrfs_submit_bio_start_direct_io,
-				   __btrfs_submit_bio_done);
-		if (ret)
-			goto free_ordered;
+	ret = btrfs_submit_direct_hook(rw, dip, skip_sum);
+	if (!ret)
 		return;
-	} else if (!skip_sum)
-		btrfs_lookup_bio_sums_dio(root, inode, bio,
-					  dip->logical_offset, dip->csums);
-
-	ret = btrfs_map_bio(root, rw, bio, 0, 1);
-	if (ret)
-		goto free_ordered;
-	return;
 free_ordered:
 	/*
 	 * If this is a write, we need to clean up the reserved space and kill
-- 
1.7.0.1
