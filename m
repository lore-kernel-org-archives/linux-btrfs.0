Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58471 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbaJHAXq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 20:23:46 -0400
Received: from localhost.localdomain ([93.96.201.217]) by mail.gmx.com
 (mrgmx103) with ESMTPSA (Nemesis) id 0LlDx4-1YAAa62nBe-00b0G0 for
 <linux-btrfs@vger.kernel.org>; Wed, 08 Oct 2014 02:23:44 +0200
Date: Wed, 8 Oct 2014 01:23:41 +0100
From: Marios Titas <redneb@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: move struct btrfs_ioctl_defrag_range_args from
 ctree.h to linux/btrfs.h
Message-ID: <20141008002341.GA28669@zeno.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

include/uapi/linux/btrfs.h is a more logical place to put the struct
btrfs_ioctl_defrag_range_args as it is being used by the
BTRFS_IOC_DEFRAG_RANGE IOCTL which is defined in that file.
Additionally, this is where the btrfs-progs defines that struct. Thus
this patches reduces the gap between the btrfs-progs headers and the
kernel headers.

Signed-off-by: Marios Titas <redneb@gmx.com>
---
  fs/btrfs/ctree.h           | 31 -------------------------------
  include/uapi/linux/btrfs.h | 31 +++++++++++++++++++++++++++++++
  2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e29b61..5e633cc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1891,37 +1891,6 @@ struct btrfs_root {
  	atomic_t will_be_snapshoted;
  };
  
-struct btrfs_ioctl_defrag_range_args {
-	/* start of the defrag operation */
-	__u64 start;
-
-	/* number of bytes to defrag, use (u64)-1 to say all */
-	__u64 len;
-
-	/*
-	 * flags for the operation, which can include turning
-	 * on compression for this one defrag
-	 */
-	__u64 flags;
-
-	/*
-	 * any extent bigger than this will be considered
-	 * already defragged.  Use 0 to take the kernel default
-	 * Use 1 to say every single extent must be rewritten
-	 */
-	__u32 extent_thresh;
-
-	/*
-	 * which compression method to use if turning on compression
-	 * for this defrag operation.  If unspecified, zlib will
-	 * be used
-	 */
-	__u32 compress_type;
-
-	/* spare for later */
-	__u32 unused[4];
-};
-
  
  /*
   * inode items have the data typically returned from stat and store other
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 2f47824..d0e5757 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -350,6 +350,37 @@ struct btrfs_ioctl_same_args {
  	struct btrfs_ioctl_same_extent_info info[0];
  };
  
+struct btrfs_ioctl_defrag_range_args {
+	/* start of the defrag operation */
+	__u64 start;
+
+	/* number of bytes to defrag, use (u64)-1 to say all */
+	__u64 len;
+
+	/*
+	 * flags for the operation, which can include turning
+	 * on compression for this one defrag
+	 */
+	__u64 flags;
+
+	/*
+	 * any extent bigger than this will be considered
+	 * already defragged.  Use 0 to take the kernel default
+	 * Use 1 to say every single extent must be rewritten
+	 */
+	__u32 extent_thresh;
+
+	/*
+	 * which compression method to use if turning on compression
+	 * for this defrag operation.  If unspecified, zlib will
+	 * be used
+	 */
+	__u32 compress_type;
+
+	/* spare for later */
+	__u32 unused[4];
+};
+
  struct btrfs_ioctl_space_info {
  	__u64 flags;
  	__u64 total_bytes;
-- 
2.0.4

