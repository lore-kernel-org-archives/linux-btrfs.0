From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/3] Btrfs: fix the file extent gap when doing direct IO
Date: Thu, 18 Aug 2011 16:13:30 +0800
Message-ID: <4E4CC9AA.6040402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we write some data to the place that is beyond the end of the file
in direct I/O mode, a data hole will be created. And Btrfs should insert
a file extent item that point to this hole into the fs tree. But unfortunately
Btrfs forgets doing it.

The following is a simple way to reproduce it:
 # mkfs.btrfs /dev/sdc2
 # mount /dev/sdc2 /test4
 # touch /test4/a
 # dd if=/dev/zero of=/test4/a seek=8 count=1 bs=4K oflag=direct conv=nocreat,notrunc
 # umount /test4
 # btrfsck /dev/sdc2
 root 5 inode 257 errors 100

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/file.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 010aec8..a9c4636 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1073,12 +1073,6 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 	start_pos = pos & ~((u64)root->sectorsize - 1);
 	last_pos = ((u64)index + num_pages) << PAGE_CACHE_SHIFT;
 
-	if (start_pos > inode->i_size) {
-		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);
-		if (err)
-			return err;
-	}
-
 again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = find_or_create_page(inode->i_mapping, index + i,
@@ -1336,6 +1330,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	loff_t *ppos = &iocb->ki_pos;
+	u64 start_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
 	size_t count, ocount;
@@ -1384,6 +1379,15 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	file_update_time(file);
 	BTRFS_I(inode)->sequence++;
 
+	start_pos = round_down(pos, root->sectorsize);
+	if (start_pos > i_size_read(inode)) {
+		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);
+		if (err) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+	}
+
 	if (unlikely(file->f_flags & O_DIRECT)) {
 		num_written = __btrfs_direct_write(iocb, iov, nr_segs,
 						   pos, ppos, count, ocount);
-- 
1.7.4
