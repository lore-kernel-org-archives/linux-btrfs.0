From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Thu, 03 Mar 2011 16:35:42 +0800
Message-ID: <4D6F52DE.5080508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


For datacow control, the corresponding inode flags are needed.
This is for the following patch.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/linux/fs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..bef47ff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -353,6 +353,8 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_NOCOW_FL			0x00800000 /* Do not cow file */
+#define FS_COW_FL			0x01000000 /* Cow file */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-- 
1.6.5.2
