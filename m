From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: Fix up 32/64-bit compatibility for new ioctls
Date: Mon, 14 Nov 2011 22:21:14 -0500
Message-ID: <4EC1DAAA.9020907@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Commit 740c3d22 (Btrfs: fix the new inspection ioctls for 32 bit compat)
 uses 64-bit values instead of pointers but the casting throws cast to
 integer of different size warnings when built on 32-bit machines.

 This patch casts to unsigned long before casting to a pointer and fixes
 the following warnings:
fs/btrfs/extent_io.c:2289:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
fs/btrfs/ioctl.c:2933:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
fs/btrfs/ioctl.c:2937:21: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
fs/btrfs/ioctl.c:3020:21: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
fs/btrfs/scrub.c:275:4: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
fs/btrfs/backref.c:686:27: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c   |    2 +-
 fs/btrfs/extent_io.c |    2 +-
 fs/btrfs/ioctl.c     |    9 ++++++---
 fs/btrfs/scrub.c     |    2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -683,7 +683,7 @@ static int inode_to_path(u64 inum, struc
 		return PTR_ERR(fspath);
 
 	if (fspath > fspath_min) {
-		ipath->fspath->val[i] = (u64)fspath;
+		ipath->fspath->val[i] = (u64)(unsigned long)fspath;
 		++ipath->fspath->elem_cnt;
 		ipath->fspath->bytes_left = fspath - fspath_min;
 	} else {
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2343,7 +2343,7 @@ static void end_bio_extent_readpage(stru
 		}
 		if (!uptodate) {
 			u64 failed_mirror;
-			failed_mirror = (u64)bio->bi_bdev;
+			failed_mirror = (unsigned long)bio->bi_bdev;
 			if (tree->ops && tree->ops->readpage_io_failed_hook)
 				ret = tree->ops->readpage_io_failed_hook(
 						bio, page, start, end,
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2954,11 +2954,13 @@ static long btrfs_ioctl_ino_to_path(stru
 		goto out;
 
 	for (i = 0; i < ipath->fspath->elem_cnt; ++i) {
-		rel_ptr = ipath->fspath->val[i] - (u64)ipath->fspath->val;
+		rel_ptr = ipath->fspath->val[i] -
+			  (u64)(unsigned long)ipath->fspath->val;
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
-	ret = copy_to_user((void *)ipa->fspath, (void *)ipath->fspath, size);
+	ret = copy_to_user((void *)(unsigned long)ipa->fspath,
+			   (void *)(unsigned long)ipath->fspath, size);
 	if (ret) {
 		ret = -EFAULT;
 		goto out;
@@ -3041,7 +3043,8 @@ static long btrfs_ioctl_logical_to_ino(s
 	if (ret < 0)
 		goto out;
 
-	ret = copy_to_user((void *)loi->inodes, (void *)inodes, size);
+	ret = copy_to_user((void *)(unsigned long)loi->inodes,
+			   (void *)(unsigned long)inodes, size);
 	if (ret)
 		ret = -EFAULT;
 
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -272,7 +272,7 @@ static int scrub_print_warning_inode(u64
 			swarn->logical, swarn->dev->name,
 			(unsigned long long)swarn->sector, root, inum, offset,
 			min(isize - offset, (u64)PAGE_SIZE), nlink,
-			(char *)ipath->fspath->val[i]);
+			(char *)(unsigned long)ipath->fspath->val[i]);
 
 	free_ipath(ipath);
 	return 0;
-- 
Jeff Mahoney
SUSE Labs
