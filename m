From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] btrfs/direct-IO: fix a bug of btrfs_dio_read
Date: Thu, 06 May 2010 10:12:10 +0800
Message-ID: <4BE2257A.7030005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, jim owens <owens6336@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As I mentioned in the bug-report, when the file size is 
not n * BUFFERSIZE, this file cannot be read correctly 
and the system will crash or hang up.

After investigation, I fount that data_len should be 
checked before lock_extent, in order to prevent the 
situation that when it comes to the file end, 
diocb->lockstart changes to lockend+1, then lock_extent
 will cause system's crash or hang.

So move the data_len's check ahead.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index c930ff5..7178a25 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -517,11 +517,6 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 	lockend = ALIGN(end, blocksize) - 1;
 
 getlock:
-	/* writeout everything we read for checksum or compressed extents */
-	filemap_write_and_wait_range(diocb->inode->i_mapping,
-				diocb->lockstart, lockend);
-	lock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
-
 	data_len = min_t(u64, end, i_size_read(diocb->inode));
 	if (data_len <= diocb->start) {
 		/* whatever we finished (or 0) is returned past EOF */
@@ -529,6 +524,11 @@ getlock:
 	}
 	data_len -= diocb->start;
 
+	/* writeout everything we read for checksum or compressed extents */
+	filemap_write_and_wait_range(diocb->inode->i_mapping,
+				diocb->lockstart, lockend);
+	lock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
+
 	safe_to_read = 0;
 	while (data_len && !diocb->error) { /* error in reaper stops submit */
 		struct extent_map *em;
-- 
1.6.2.5


