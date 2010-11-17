From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: fix panic caused by direct IO
Date: Wed, 17 Nov 2010 12:23:35 +0800
Message-ID: <4CE358C7.3040902@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

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

We fix this problem by adding a function to check the end of the bio span
the chunks/stripes or not when we want to add a page into the bios.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32b68fa..341d080 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5689,6 +5689,20 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 	return 0;
 }
 
+/*
+ * This function is used to check the chunk tree when doing direct IO because
+ * btrfs can't create bios that span stripes or chunks.
+ */
+static int btrfs_can_merge_page_dio(size_t size, struct inode *inode,
+				    struct bio *bio)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_mapping_tree *map_tree;
+
+	map_tree = &root->fs_info->mapping_tree;
+	return __btrfs_can_merge_page_to_bio(map_tree, size, bio);
+}
+
 static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 				loff_t file_offset)
 {
@@ -5873,7 +5887,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, NULL, 0);
+		   btrfs_submit_direct, btrfs_can_merge_page_dio, 0);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-- 
1.7.0.1
