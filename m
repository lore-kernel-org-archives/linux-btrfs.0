From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] cloning file data
Date: Mon, 5 May 2008 08:57:28 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0805050855250.15314@cobra.newdream.net>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
 <Pine.LNX.4.64.0805022255370.15314@cobra.newdream.net>
 <3d0408630805030025s2c9006c1qad3c29011caf3013@mail.gmail.com>
 <200805050627.46919.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yan Zheng <yanzheng@21cn.com>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805050627.46919.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

> > In my previous mail, I said items of different types should be
> > differentiated. Actually, there is no need to do that. Please consider
> > changing the big loop in btrfs_ioctl_clone to something like:
> 
> Oh, nice catch Yan, thanks.  I've pushed out a new version to the unstable 
> tree.  Sage, could you please give this a try too?

Looks good to me.  Here's a small cleanup to remove the now unnecessary 
pos.

sage


diff -r d94a17e354a8 inode.c
--- a/inode.c   Mon May 05 06:26:21 2008 -0400
+++ b/inode.c   Mon May 05 09:02:55 2008 -0700
@@ -3135,7 +3135,6 @@ long btrfs_ioctl_clone(struct file *file
        struct inode *src;
        struct btrfs_trans_handle *trans;
        int ret;
-       u64 pos;
        struct btrfs_path *path;
        struct btrfs_key key;
        struct extent_buffer *leaf;
@@ -3183,7 +3182,6 @@ long btrfs_ioctl_clone(struct file *file
        key.offset = 0;
        key.type = BTRFS_EXTENT_DATA_KEY;
        key.objectid = src->i_ino;
-       pos = 0;
        path->reada = 2;
 
        while (1) {
@@ -3214,7 +3212,6 @@ long btrfs_ioctl_clone(struct file *file
                if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
                        struct btrfs_file_extent_item *extent;
                        int found_type;
-                       pos = key.offset;
                        extent = btrfs_item_ptr(leaf, slot,
                                                struct btrfs_file_extent_item);
                        found_type = btrfs_file_extent_type(leaf, extent);
@@ -3228,25 +3225,22 @@ long btrfs_ioctl_clone(struct file *file
                                u64 off = btrfs_file_extent_offset(leaf,
                                                                   extent);
                                btrfs_insert_file_extent(trans, root,
-                                                        inode->i_ino, pos,
+                                                        inode->i_ino, 
+                                                        key.offset,
                                                         ds, dl, len, off);
                                /* ds == 0 means there's a hole */
-                               if (ds != 0) {
+                               if (ds != 0)
                                        btrfs_inc_extent_ref(trans, root,
                                                     ds, dl,
                                                     root->root_key.objectid,
                                                     trans->transid,
-                                                    inode->i_ino, pos);
-                               }
-                               pos = key.offset + len;
+                                                    inode->i_ino, key.offset);
                        } else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
                                ret = dup_item_to_inode(trans, root, path,
                                                        leaf, slot, &key,
                                                        inode->i_ino);
                                if (ret)
                                        goto out;
-                               pos = key.offset + btrfs_item_size_nr(leaf,
-                                                                     slot);
                        }
                } else if (btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
                        ret = dup_item_to_inode(trans, root, path, leaf,
