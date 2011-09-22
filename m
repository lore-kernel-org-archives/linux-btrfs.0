From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [RFC][PATCH] Btrfs: Fix the write error into tiny space
Date: Thu, 22 Sep 2011 15:35:15 +0800
Message-ID: <4E7AE533.1020700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

reproduce:
dd if=/dev/zero of=tmpfile bs=4K count=1
dd if=/dev/zero of=tmpfile1 bs=1M
dd if=/dev/zero of=tmpfile2 bs=4K
rm -f tmpfile
sync
dd if=/dev/zero of=tmpfile bs=8K count=1

We try to create a 8K file when there is only 4K space left, btrfs will write no
data into a file, but under EXT4 it will still write the first 4K data. Also the 
POSIX hopes we writting as much as possible.

quote the POSIX:
If a write() requests that more bytes be written than there is room for(for example, 
[XSI] [Option Start]  the process' file size limit or [Option End] the physical end 
of a medium), only as many bytes as there is room for shall be written. For example,
suppose there is space for 20 bytes more in a file before reaching a limit. A write 
of 512 bytes will return 20. The next write of a non-zero number of bytes would give
a failure return (except as noted below).

Signed-off-by: Wu Bo <wu.bo@cn.fujitsu.com>
---
 fs/btrfs/file.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15e5a1c..b364f05 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1179,11 +1179,14 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
-		size_t num_pages = (write_bytes + offset +
-				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		size_t num_pages;
 		size_t dirty_pages;
 		size_t copied;
 
+again:
+		num_pages = (write_bytes + offset +
+			     PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
 		WARN_ON(num_pages > nrptrs);
 
 		/*
@@ -1197,6 +1200,17 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		ret = btrfs_delalloc_reserve_space(inode,
 					num_pages << PAGE_CACHE_SHIFT);
+
+		/* try to reserve smaller space for write */
+		if (ret == -ENOSPC) {
+			if (num_pages > 1) {
+				write_bytes >>= 1;
+				goto again;
+			} else {
+				break;
+			}
+		}
+
 		if (ret)
 			break;
 
-- 
1.7.3.1
