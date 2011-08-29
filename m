From: Jeff Liu <jeff.liu@oracle.com>
Subject: Fix btrfs_file_llseek() to return -EINVAL directly
Date: Mon, 29 Aug 2011 02:48:05 -0700 (PDT)
Message-ID: <4E5B6055.1080807@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

In btrfs_file_llseek(), if the offset < 0 or offset > 
inode->i_sb->s_maxbytes, we should return -EINVAL rather than offset.
Also,  if the offset >= inode->i_size for SEEK_DATA or SEEK_HOLE, return 
-ENXIO is ok IMHO.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..2c126d0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1813,6 +1813,11 @@ static loff_t btrfs_file_llseek(struct file 
*file, loff_t offset, int origin)
          goto out;
      case SEEK_DATA:
      case SEEK_HOLE:
+        if (offset >= inode->i_size) {
+            mutex_unlock(&inode->i_mutex);
+            return -ENXIO;
+        }
+
          ret = find_desired_extent(inode, &offset, origin);
          if (ret) {
              mutex_unlock(&inode->i_mutex);
@@ -1820,14 +1825,11 @@ static loff_t btrfs_file_llseek(struct file 
*file, loff_t offset, int origin)
          }
      }

-    if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-        ret = -EINVAL;
-        goto out;
-    }
-    if (offset > inode->i_sb->s_maxbytes) {
-        ret = -EINVAL;
-        goto out;
-    }
+    if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
+        return -EINVAL;
+
+    if (offset > inode->i_sb->s_maxbytes)
+        return -EINVAL;

      /* Special lock needed here? */
      if (offset != file->f_pos) {

