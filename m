Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36257 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759722AbcBYI5v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 03:57:51 -0500
Received: by mail-oi0-f65.google.com with SMTP id w71so2169890oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 00:57:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453326567-20454-3-git-send-email-mfasheh@suse.de>
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
	<1453326567-20454-3-git-send-email-mfasheh@suse.de>
Date: Thu, 25 Feb 2016 03:57:51 -0500
Message-ID: <CALJXSJoatg4G8YnJxk=oRJzS2vJXyJoWceNFeEZqoK_7vfdbPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs-progs: add 'du' command
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 4:49 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> 'btrfs du' differs from regular du in that it will work to resolve which
> blocks are shared between files in its list. This gives the user a more
> accurate bytecount from which they can make decisions regarding management
> of their file space.


Would it be a good idea for this new du to show the compressed file size too?

It was not made by me but I know I had this patch lying around, it
also does not compile right now but I could give it an update. The
wiki says this patch was "not merged yet" but I have no idea why it
was not since it was working correctly 2 years ago on my machine.

---
 fs/btrfs/ioctl.c           | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  2 ++
 2 files changed, 79 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da94138..1c6285b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4499,6 +4499,81 @@ static int build_ino_list(u64 inum, u64 offset,
u64 root, void *ctx)
     return 0;
 }

+/*
+ * Returns the compressed size of an inode in 512 byte blocks.
+ * Count the on-disk space used by extents starting in range [start, end),
+ * inline data are rounded up to sector, ie. 512.
+ *
+ * The range is start inclusive and end exclusive so it can be used to
+ * determine compressed size of a given extent by its start and start of the
+ * next extent easily, without counting length.
+ * Whole file is specified as start = 0, end = (u64)-1
+ */
+static long btrfs_ioctl_compr_size(struct file *file, void __user *argp)
+{
+    struct inode *inode = fdentry(file)->d_inode;
+    struct btrfs_ioctl_compr_size_args compr_args;
+    u64 len;
+    u64 compressed_size = 0;
+    u64 offset = 0;
+
+    if (S_ISDIR(inode->i_mode))
+        return -EISDIR;
+
+    if (copy_from_user(&compr_args, argp,
+                sizeof(struct btrfs_ioctl_compr_size_args)))
+        return -EFAULT;
+
+    if (compr_args.start > compr_args.end)
+        return -EINVAL;
+
+    mutex_lock(&inode->i_mutex);
+
+    offset = compr_args.start;
+    if (inode->i_size > compr_args.end)
+        len = compr_args.end;
+    else
+        len = inode->i_size;
+
+    /*
+     * do any pending delalloc/csum calc on inode, one way or
+     * another, and lock file content
+     */
+    btrfs_wait_ordered_range(inode, compr_args.start, len);
+
+    while (offset < len) {
+        struct extent_map *em;
+
+        em = btrfs_get_extent(inode, NULL, 0, offset, 1, 0);
+        if (IS_ERR_OR_NULL(em))
+            goto error;
+        if (em->block_len != (u64)-1)
+            compressed_size += em->block_len;
+        else if (em->block_start == EXTENT_MAP_INLINE) {
+            compressed_size += ALIGN(em->len, 512);
+        }
+        offset += em->len;
+        free_extent_map(em);
+    }
+    mutex_unlock(&inode->i_mutex);
+
+    unlock_extent(&BTRFS_I(inode)->io_tree, compr_args.start, len);
+
+    compr_args.size = compressed_size >> 9;
+
+    if (copy_to_user(argp, &compr_args, sizeof(struct
+                    btrfs_ioctl_compr_size_args)))
+        return -EFAULT;
+
+    return 0;
+
+error:
+    mutex_unlock(&inode->i_mutex);
+    unlock_extent(&BTRFS_I(inode)->io_tree, compr_args.start, len);
+
+    return -EIO;
+}
+
 static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
                     void __user *arg)
 {
@@ -5532,6 +5607,8 @@ long btrfs_ioctl(struct file *file, unsigned int
         return btrfs_ioctl_scrub_progress(root, argp);
     case BTRFS_IOC_BALANCE_V2:
         return btrfs_ioctl_balance(file, argp);
+    case BTRFS_IOC_COMPR_SIZE:
+        return btrfs_ioctl_compr_size(file, argp);
     case BTRFS_IOC_BALANCE_CTL:
         return btrfs_ioctl_balance_ctl(root, arg);
     case BTRFS_IOC_BALANCE_PROGRESS:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index dea8931..cd52cda 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -647,6 +647,8 @@ static inline char *btrfs_err_str(enum
btrfs_err_code err_code)
                    char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
                    char[BTRFS_LABEL_SIZE])
+#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 51, \
+                struct btrfs_ioctl_compr_size_args)
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
                       struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
-- 
2.7.0
