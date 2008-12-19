From: "Yehuda Sadeh Weinraub" <yehudasa@gmail.com>
Subject: [PATCH 1/1] ioctl to fetch csums of file extents
Date: Fri, 19 Dec 2008 13:14:40 -0800
Message-ID: <a37615150812191314q30f7405agf40f4e6b352b123b@mail.gmail.com>
References: <a37615150812191310y682c746bt4bd669c0fe5eb4ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a37615150812191310y682c746bt4bd669c0fe5eb4ea@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This adds a new ioctl that requests for the csums of file's extent.
The csums of contiguous extents can also be requested. The call will
not return anything for extents that don't have csum information for
their data, or that the csum list is not available.
Presumably, the user calls fiemap first in order to get the list of
extents. The max number of requested csum items is specified in the
request and is updated according to the actual number of returned
items.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/btrfs/ioctl.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    9 +++++
 2 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab429fe..18a57c1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -990,6 +990,105 @@ out_drop_write:
       return ret;
 }

+static long btrfs_ioctl_getcsum(struct file *file,
+               void __user *arg)
+{
+       struct inode *inode = fdentry(file)->d_inode;
+       struct btrfs_root *root = BTRFS_I(inode)->root;
+       struct btrfs_ioctl_get_csum_args *req;
+       struct btrfs_ioctl_get_csum_args __user *ureq = arg;
+       int ret;
+       u64 off, max;
+       struct extent_map *em = NULL;
+       u32 count = 0;
+       size_t end;
+       unsigned long flags;
+
+       req = kmalloc(sizeof(*req), GFP_NOFS);
+       if (!req)
+               return -ENOMEM;
+       if (copy_from_user(req, arg, sizeof(*req))) {
+               kfree(req);
+               return -EFAULT;
+       }
+
+       off = req->off;
+       max = off + req->len;
+       end = (off + req->len + root->sectorsize - 1) & ~(root->sectorsize - 1);
+
+       ret = 0;
+       lock_extent(&BTRFS_I(inode)->io_tree, req->off, max,
+               GFP_NOFS);
+       while (off < max) {
+               struct list_head list;
+               size_t len = 0;
+               size_t offset;
+               struct btrfs_ordered_sum *sums;
+               struct btrfs_sector_sum *sector_sum;
+
+               em = btrfs_get_extent(inode, NULL, 0, off, max - off, 0);
+
+               if (!em)
+                       goto out;
+               if (IS_ERR(em)) {
+                       ret = PTR_ERR(em);
+                       goto out;
+               }
+
+               if (em->block_start > EXTENT_MAP_LAST_BYTE)
+                       goto out_free;
+
+               INIT_LIST_HEAD(&list);
+               len = 0;
+
+               offset = (off - em->start) & ~(root->sectorsize - 1);
+
+               ret = btrfs_lookup_csums_range(root, em->block_start + offset,
+                               em->block_start + em->block_len - 1, &list);
+               if (ret < 0)
+                       goto out_free;
+
+               len = 0;
+               while (!list_empty(&list)) {
+                       sums = list_entry(list.next,
+                                         struct btrfs_ordered_sum, list);
+                       list_del_init(&sums->list);
+
+                       sector_sum = sums->sums;
+
+                       while ((len < sums->len) &&
+                               (offset + len < end) &&
+                               (count < req->size)) {
+                               put_user((u32)sector_sum->sum,
+                                        &ureq->csum[count++]);
+                               sector_sum++;
+                               len += root->sectorsize;
+                       }
+                       kfree(sums);
+               }
+
+               flags = em->flags;
+               off = em->start + em->len;
+
+               free_extent_map(em);
+
+               if (test_bit(EXTENT_FLAG_VACANCY, &flags))
+                       break;
+
+               if (count == req->size)
+                       break;
+       }
+out:
+       unlock_extent(&BTRFS_I(inode)->io_tree, req->off, max,
+                       GFP_NOFS);
+
+       put_user((u32)count, &ureq->size);
+       return ret;
+out_free:
+       free_extent_map(em);
+       goto out;
+}
+
 static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
 {
       struct btrfs_ioctl_clone_range_args args;
@@ -1102,6 +1201,8 @@ long btrfs_ioctl(struct file *file, unsigned int
       case BTRFS_IOC_SYNC:
               btrfs_sync_fs(file->f_dentry->d_sb, 1);
               return 0;
+       case BTRFS_IOC_GETCSUM:
+               return btrfs_ioctl_getcsum(file, argp);
       }

       return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 78049ea..9962579 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -64,4 +64,13 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
                                  struct btrfs_ioctl_vol_args)

+struct btrfs_ioctl_get_csum_args {
+       __u64 off;
+       __u64 len;
+       __u32 size; /* in/out */
+       __u32 csum[0];
+};
+
+#define BTRFS_IOC_GETCSUM      _IO(BTRFS_IOCTL_MAGIC, 15)
+
 #endif
--
1.5.6.5
