From: Yuri D'Elia <wavexx@users.sf.net>
Subject: Re: Building btrfs as a dkms module on Debian
Date: Wed, 16 Feb 2011 18:44:58 +0100
Message-ID: <20110216184458.fa5cbeae.wavexx@users.sf.net>
References: <20110215163519.d9c7f40f.wavexx@users.sf.net>
	<4D5B3BBF.6020702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__16_Feb_2011_18_44_58_+0100_ATWDE6wF+Rz2DpRl"
Cc: linux-btrfs@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5B3BBF.6020702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Wed__16_Feb_2011_18_44_58_+0100_ATWDE6wF+Rz2DpRl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Feb 2011 10:51:43 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

> > I assume BLKDEV_IFL_WAIT/BARRIER was added in later kernels?
> > Is there a way to make it build btrfs for 2.6.37?
> 
> in commit fbd9b09a177a481eda256447c881f014f29034fe:
> include/linux/blkdev.h:
> 
> #define BLKDEV_IFL_WAIT         (1 << BLKDEV_WAIT)
> #define BLKDEV_IFL_BARRIER      (1 << BLKDEV_BARRIER)
> #define BLKDEV_IFL_SECURE       (1 << BLKDEV_SECURE)
> 
> Maybe this is helpful.:)

I've worked more on this today. There was a lot of restructuring of blkdev in 2.6.38, but in stock 2.6.37 only BLKDEV_SECURE has any effect.

Just in case, I'm posting here the changes required to backport current btrfs to 2.6.37 (just a few minor changes).

--Multipart=_Wed__16_Feb_2011_18_44_58_+0100_ATWDE6wF+Rz2DpRl
Content-Type: text/x-diff;
 name="backport-2.6.37.patch"
Content-Disposition: attachment;
 filename="backport-2.6.37.patch"
Content-Transfer-Encoding: 7bit

commit db77ab6c70a5c148ff4ab6d354603609c0eb73aa
Author: Yuri D'Elia <yuri.delia@eurac.edu>
Date:   Wed Feb 16 18:27:54 2011 +0100

    Backport changes for compilation under 2.6.37

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e1ea3e..7022ac8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2131,7 +2131,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!buffer_eopnotsupp(bh) && printk_ratelimit()) {
+		if (printk_ratelimit()) {
 			printk(KERN_WARNING "lost page write due to "
 					"I/O error on %s\n",
 				       bdevname(bh->b_bdev, b));
@@ -2269,7 +2269,7 @@ static int write_dev_supers(struct btrfs_device *device,
 		}
 
 		if (i == last_barrier && do_barriers && device->barriers) {
-			ret = submit_bh(WRITE_BARRIER, bh);
+			ret = submit_bh(WRITE_FLUSH_FUA, bh);
 			if (ret == -EOPNOTSUPP) {
 				printk("btrfs: disabling barriers on dev %s\n",
 				       device->name);
diff --git a/fs/btrfs/dkms.conf b/fs/btrfs/dkms.conf
new file mode 100644
index 0000000..10b8fb9
--- /dev/null
+++ b/fs/btrfs/dkms.conf
@@ -0,0 +1,6 @@
+PACKAGE_NAME="btrfs"
+PACKAGE_VERSION="20110214"
+BUILT_MODULE_NAME[0]="btrfs"
+DEST_MODULE_LOCATION[0]="/kernel/fs/btrfs/"
+AUTOINSTALL="yes"
+REMAKE_INITRD="yes"
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a7aaa10..f3c96fc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1743,8 +1743,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
-	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e7aeba2..06fd0d0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -16,6 +16,10 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 
+#define INIT_RCU_HEAD(ptr) do { \
+       (ptr)->next = NULL; (ptr)->func = NULL; \
+} while (0)
+
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
 
diff --git a/fs/btrfs/version.h b/fs/btrfs/version.h
index 9bf3946..d7c55c6 100644
--- a/fs/btrfs/version.h
+++ b/fs/btrfs/version.h
@@ -1,4 +1,4 @@
-#ifndef __BTRFS_VERSION_H
-#define __BTRFS_VERSION_H
-#define BTRFS_BUILD_VERSION "Btrfs"
+#ifndef __BUILD_VERSION
+#define __BUILD_VERSION
+#define BTRFS_BUILD_VERSION "Btrfs 2011-02-14_16:21:37_-0500_c26a920-dirty"
 #endif
diff --git a/fs/btrfs/version.sh b/fs/btrfs/version.sh
index 1ca1952..2c1d0b5 100644
--- a/fs/btrfs/version.sh
+++ b/fs/btrfs/version.sh
@@ -12,10 +12,7 @@ which git &> /dev/null
 if [ $? == 0 ]; then
     git branch >& /dev/null
     if [ $? == 0 ]; then
-	    if head=`git rev-parse --verify HEAD 2>/dev/null`; then
-		if tag=`git describe --tags 2>/dev/null`; then
-		    v="$tag"
-		fi
+		v="`git show --format='%ci_%h'|head -n 1|sed -e 's/[^a-z0-9_:-]/_/ig'`"
 
 		# Are there uncommitted changes?
 		git update-index --refresh --unmerged > /dev/null
@@ -24,7 +21,6 @@ if [ $? == 0 ]; then
 		    | read dummy; then
 		    v="$v"-dirty
 		fi
-	    fi
     fi
 fi
  

--Multipart=_Wed__16_Feb_2011_18_44_58_+0100_ATWDE6wF+Rz2DpRl--

