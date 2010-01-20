From: Chris Mason <chris.mason@oracle.com>
Subject: Re: worse than expected compression ratios with -o compress
Date: Wed, 20 Jan 2010 11:30:11 -0500
Message-ID: <20100120163011.GE3001@think>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
 <20100118141240.GA10710@localhost.localdomain>
 <20100118212951.GC4065@think>
 <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 18, 2010 at 05:11:53PM -0500, Jim Faulkner wrote:
> 
> On Mon, 18 Jan 2010, Chris Mason wrote:
> 
> >>Currently the only compression algorithm we support is gzip, so try gzipp'ing
> >>your database to get a better comparison.  The plan is to eventually support
> >>other compression algorithms, but currently we do not.  Thanks,
> >
> >The compression code backs off compression pretty quickly if parts of
> >the file do not compress well.  This is another way of saying it favors
> >CPU time over the best possible compression.  If gzip ends up better
> >than what you're getting from btrfs, I can give you a patch to force
> >compression all the time.
> 
> Yes, gzip compresses much better than btrfs.  I'd greatly appreciate
> a patch to force compression all the time.
> 
> It would be nice if such an ability were merged in the mainline.
> Perhaps there could be a mount option or tunable parameter to force
> compression?

Lets start by making sure that this patch works for you.  Just apply it
(2.6.32 or 2.6.33-rc) and then mount -o compress-force.  Normally, mount
-o compress will set a flag on a file after it fails to get good
compression for that file.

With this patch, mount -o compress-force will still honor that flag.
But it will skip setting it during new writes.  This is a long way of
saying you'll have to copy your data file to a new files for the new
mount option to do anything.

Please let me know if this improves your ratios

-chris

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9f806dd..2aa8ec6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1161,6 +1161,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
+#define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b330e27..f46c572 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -483,7 +483,8 @@ again:
 		nr_pages_ret = 0;
 
 		/* flag the file so we don't compress in the future */
-		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
+		if (!btrfs_test_opt(root, FORCE_COMPRESS))
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
 	}
 	if (will_compress) {
 		*num_added += 1;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3f9b457..8a1ea6e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,7 +66,8 @@ enum {
 	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl,
-	Opt_compress, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
+	Opt_compress, Opt_compress_force, Opt_notreelog, Opt_ratio,
+	Opt_flushoncommit,
 	Opt_discard, Opt_err,
 };
 
@@ -82,6 +83,7 @@ static match_table_t tokens = {
 	{Opt_alloc_start, "alloc_start=%s"},
 	{Opt_thread_pool, "thread_pool=%d"},
 	{Opt_compress, "compress"},
+	{Opt_compress_force, "compress-force"},
 	{Opt_ssd, "ssd"},
 	{Opt_ssd_spread, "ssd_spread"},
 	{Opt_nossd, "nossd"},
@@ -173,6 +175,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: use compression\n");
 			btrfs_set_opt(info->mount_opt, COMPRESS);
 			break;
+		case Opt_compress_force:
+			printk(KERN_INFO "btrfs: forcing compression\n");
+			btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
+			btrfs_set_opt(info->mount_opt, COMPRESS);
+			break;
 		case Opt_ssd:
 			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
 			btrfs_set_opt(info->mount_opt, SSD);
