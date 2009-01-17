From: Gabor MICSKO <gabor.micsko@gmail.com>
Subject: Re: btrfs progs v0.18 (required for 2.6.29-rc2)
Date: Sat, 17 Jan 2009 15:57:55 +0100
Message-ID: <1232204275.15761.47.camel@localhost.localdomain>
References: <1232194721.28343.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232194721.28343.0.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-01-17 at 07:18 -0500, Chris Mason wrote:

> Hello everyone,

hi,

> As mentioned in the ioctl update email, I've released btrfs v0.18.  This
> only includes the ioctl change and none of the patches that I've been
> queuing up for testing.

With the following patches everything looks good on 2.6.27.

diff --git a/compat.h b/compat.h
index 7c4503e..74d2e32 100644
--- a/compat.h
+++ b/compat.h
@@ -4,4 +4,28 @@
 #define btrfs_drop_nlink(inode) drop_nlink(inode)
 #define btrfs_inc_nlink(inode)	inc_nlink(inode)
 
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 27)
+static inline struct dentry *d_obtain_alias(struct inode *inode)
+{
+       struct dentry *d;
+
+       if (!inode)
+               return NULL;
+       if (IS_ERR(inode))
+               return ERR_CAST(inode);
+
+       d = d_alloc_anon(inode);
+       if (!d)
+               iput(inode);
+       return d;
+}
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
+# define  __pagevec_lru_add_file __pagevec_lru_add
+# define open_bdev_exclusive open_bdev_excl
+# define close_bdev_exclusive(bdev, mode) close_bdev_excl(bdev)
+typedef unsigned __bitwise__ fmode_t;
+#endif
+
 #endif /* _COMPAT_H_ */
diff --git a/extent-tree.c b/extent-tree.c
index 293da65..41fc059 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -869,7 +869,11 @@ static noinline int remove_extent_backref(struct
btrfs_trans_handle *trans,
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
-	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 28)
+       blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
+#else
+       blkdev_issue_discard(bdev, start >> 9, len >> 9);
+#endif
 }
 #endif
 


