From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Cross-subvolume reflink copy (BTRFS_IOC_CLONE over subvolume boundaries)
Date: Mon, 13 Feb 2012 21:47:00 -0500
Message-ID: <CALJXSJpHMDdomKfM8noVZEBpak1gvm3OhOd-8spYtKAd_6LABQ@mail.gmail.com>
References: <2704295.VfXjvSRAYV@bursa01>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2704295.VfXjvSRAYV@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2012 at 6:52 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> It's been nearly a year since the patches needed to implement a reflinked copy
> between subvolumes have been posted
> (http://permalink.gmane.org/gmane.comp.file-systems.btrfs/9865 ) and I still
> get "Invalid cross-device link" error with Linux 3.2.4 while I try to do a cp
> --reflink between subvolumes.

I am still keeping this patch up-to-date in my personal kernel repo.

Here is the diff from current for-linus

BTRFS-Allow-cross-subvolume-BTRFS_IOC_CLONE.patch

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b06a5c..05dc644 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2203,6 +2203,7 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
 {
        struct inode *inode = fdentry(file)->d_inode;
        struct btrfs_root *root = BTRFS_I(inode)->root;
+       struct btrfs_root *srcroot;
        struct file *src_file;
        struct inode *src;
        struct btrfs_trans_handle *trans;
@@ -2245,6 +2246,7 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
        }

        src = src_file->f_dentry->d_inode;
+       srcroot = BTRFS_I(src)->root;

        ret = -EINVAL;
        if (src == inode)
@@ -2264,11 +2266,11 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
                goto out_fput;

        ret = -EXDEV;
-       if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
+       if (src->i_sb != inode->i_sb)
                goto out_fput;

        ret = -ENOMEM;
-       buf = vmalloc(btrfs_level_size(root, 0));
+       buf = vmalloc(btrfs_level_size(srcroot, 0));
        if (!buf)
                goto out_fput;

@@ -2338,13 +2340,13 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
                 * note the key will change type as we walk through the
                 * tree.
                 */
-               ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+               ret = btrfs_search_slot(NULL, srcroot, &key, path, 0, 0);
                if (ret < 0)
                        goto out;

                nritems = btrfs_header_nritems(path->nodes[0]);
                if (path->slots[0] >= nritems) {
-                       ret = btrfs_next_leaf(root, path);
+                       ret = btrfs_next_leaf(srcroot, path);
                        if (ret < 0)
                                goto out;
                        if (ret > 0)
