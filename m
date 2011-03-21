From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/2 v2] Btrfs: add datacow flag in inode flag
Date: Mon, 21 Mar 2011 16:54:27 +0800
Message-ID: <4D871243.2060001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@lst.de>, tytso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


For datacow control, the corresponding inode flags are needed.
This is for btrfs use.

v1->v2:
Change FS_COW_FL to another bit due to conflict with the upstream e2fsprogs

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/linux/fs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..dbcb47e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -353,6 +353,8 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_NOCOW_FL			0x00800000 /* Do not cow file */
+#define FS_COW_FL			0x02000000 /* Cow file */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-- 
1.6.5.2
