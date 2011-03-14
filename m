From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2] fs: add super operation contains_bdev
Date: Mon, 14 Mar 2011 11:37:39 -0400
Message-ID: <1300117060-13613-2-git-send-email-josef@redhat.com>
References: <1300117060-13613-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@infradead.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300117060-13613-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Using get_active_super will not work properly if the fs (like btrfs) does not
save it's s_bdev with the device it is on.  Also it doesn't provide the entire
picture, since an fs can be contained on multiple disks (again like btrfs).  So
add a super operation that will check to see if the given block device is
contained within the given super.  This will mean that if we try to something
like a snapshot of a lv with btrfs on the lv the fs will actually get properly
frozen.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 Documentation/filesystems/vfs.txt |    6 ++++++
 fs/super.c                        |   16 ++++++++++++++--
 include/linux/fs.h                |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 94cf97b..ce22988 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -221,6 +221,7 @@ struct super_operations {
 
         ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
         ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+        int (*contains_bdev)(struct super_block *, struct block_device *);
 };
 
 All methods are called without any locks being held, unless otherwise
@@ -293,6 +294,11 @@ or bottom half).
 
   quota_write: called by the VFS to write to filesystem quota file.
 
+  contains_bdev: called by the VFS to see if the filesystem contains the given
+	block_device.  Return 1 if it does or 0 if it does not.  Only intended
+	for filesystems that can have several underlying block devices.
+	Optional.
+
 Whoever sets up the inode is responsible for filling in the "i_op" field. This
 is a pointer to a "struct inode_operations" which describes the methods that
 can be performed on individual inodes.
diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..43185fa 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -497,7 +497,7 @@ EXPORT_SYMBOL(get_super);
  */
 struct super_block *get_active_super(struct block_device *bdev)
 {
-	struct super_block *sb;
+	struct super_block *sb, *p = NULL;
 
 	if (!bdev)
 		return NULL;
@@ -507,13 +507,25 @@ restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (list_empty(&sb->s_instances))
 			continue;
-		if (sb->s_bdev == bdev) {
+
+		if (sb->s_op->contains_bdev) {
+			if (!grab_super(sb))
+				goto restart;
+			if (sb->s_op->contains_bdev(sb, bdev))
+				return sb;
+			spin_lock(&sb_lock);
+			if (p)
+				__put_super(p);
+			p = sb;
+		} else if (sb->s_bdev == bdev) {
 			if (grab_super(sb)) /* drops sb_lock */
 				return sb;
 			else
 				goto restart;
 		}
 	}
+	if (p)
+		__put_super(p);
 	spin_unlock(&sb_lock);
 	return NULL;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e38b50a..fe12b7b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1627,6 +1627,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*contains_bdev)(struct super_block *, struct block_device *);
 };
 
 /*
-- 
1.7.2.3

