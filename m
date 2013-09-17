Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3IQWn5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 18:43:57 -0400
Date: Tue, 17 Sep 2013 15:43:54 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Zach Brown <zab@redhat.com>
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
Message-ID: <20130917224354.GP31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20130913133314.GA20461@roeck-us.net> <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com> <20130913163535.GA5681@roeck-us.net> <20130913170022.18785.82013@localhost.localdomain> <20130913175801.GL31381@wotan.suse.de> <20130913193334.18785.8623@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130913193334.18785.8623@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 03:33:34PM -0400, Chris Mason wrote:
> Mark, could you please send a patch for the whole-struct option until
> the unaligned put is upstreamed?
> 
> -chris

Here you go. It's been lightly tested and needs review.

Thanks,
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.de>

[PATCH] btrfs: change extent-same to copy entire argument struct

btrfs_ioctl_file_extent_same() uses __put_user_unaligned() to copy some data
back to it's argument struct. Unfortunately, not all architectures provide
__put_user_unaligned(), so compiles break on them if btrfs is selected.

Instead, just copy the whole struct in / out at the start and end of
operations, respectively.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c | 76 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1a5b946..25d6920 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2696,9 +2696,9 @@ out_unlock:
 static long btrfs_ioctl_file_extent_same(struct file *file,
 					 void __user *argp)
 {
-	struct btrfs_ioctl_same_args *args = argp;
-	struct btrfs_ioctl_same_args same;
-	struct btrfs_ioctl_same_extent_info info;
+	struct btrfs_ioctl_same_args tmp;
+	struct btrfs_ioctl_same_args *same;
+	struct btrfs_ioctl_same_extent_info *info;
 	struct inode *src = file->f_dentry->d_inode;
 	struct file *dst_file = NULL;
 	struct inode *dst;
@@ -2706,6 +2706,7 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	u64 len;
 	int i;
 	int ret;
+	unsigned long size;
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	bool is_admin = capable(CAP_SYS_ADMIN);
 
@@ -2716,15 +2717,30 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	if (ret)
 		return ret;
 
-	if (copy_from_user(&same,
+	if (copy_from_user(&tmp,
 			   (struct btrfs_ioctl_same_args __user *)argp,
-			   sizeof(same))) {
+			   sizeof(tmp))) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	off = same.logical_offset;
-	len = same.length;
+	size = sizeof(tmp) +
+		tmp.dest_count * sizeof(struct btrfs_ioctl_same_extent_info);
+
+	same = kmalloc(size, GFP_NOFS);
+	if (!same) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (copy_from_user(same,
+			   (struct btrfs_ioctl_same_args __user *)argp, size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	off = same->logical_offset;
+	len = same->length;
 
 	/*
 	 * Limit the total length we will dedupe for each operation.
@@ -2752,27 +2768,28 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	if (!S_ISREG(src->i_mode))
 		goto out;
 
-	ret = 0;
-	for (i = 0; i < same.dest_count; i++) {
-		if (copy_from_user(&info, &args->info[i], sizeof(info))) {
-			ret = -EFAULT;
-			goto out;
-		}
+	/* pre-format output fields to sane values */
+	for (i = 0; i < same->dest_count; i++) {
+		same->info[i].bytes_deduped = 0ULL;
+		same->info[i].status = 0;
+	}
 
-		info.bytes_deduped = 0;
+	ret = 0;
+	for (i = 0; i < same->dest_count; i++) {
+		info = &same->info[i];
 
-		dst_file = fget(info.fd);
+		dst_file = fget(info->fd);
 		if (!dst_file) {
-			info.status = -EBADF;
+			info->status = -EBADF;
 			goto next;
 		}
 
 		if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
-			info.status = -EINVAL;
+			info->status = -EINVAL;
 			goto next;
 		}
 
-		info.status = -EXDEV;
+		info->status = -EXDEV;
 		if (file->f_path.mnt != dst_file->f_path.mnt)
 			goto next;
 
@@ -2781,32 +2798,29 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 			goto next;
 
 		if (S_ISDIR(dst->i_mode)) {
-			info.status = -EISDIR;
+			info->status = -EISDIR;
 			goto next;
 		}
 
 		if (!S_ISREG(dst->i_mode)) {
-			info.status = -EACCES;
+			info->status = -EACCES;
 			goto next;
 		}
 
-		info.status = btrfs_extent_same(src, off, len, dst,
-						info.logical_offset);
-		if (info.status == 0)
-			info.bytes_deduped += len;
+		info->status = btrfs_extent_same(src, off, len, dst,
+						info->logical_offset);
+		if (info->status == 0)
+			info->bytes_deduped += len;
 
 next:
 		if (dst_file)
 			fput(dst_file);
-
-		if (__put_user_unaligned(info.status, &args->info[i].status) ||
-		    __put_user_unaligned(info.bytes_deduped,
-					 &args->info[i].bytes_deduped)) {
-			ret = -EFAULT;
-			goto out;
-		}                                                               
 	}
 
+	ret = copy_to_user(argp, same, size);
+	if (ret)
+		ret = -EFAULT;
+
 out:
 	mnt_drop_write_file(file);
 	return ret;
-- 
1.8.1.4

