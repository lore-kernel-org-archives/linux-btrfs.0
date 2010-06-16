From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH btrfs-unstable#master] Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Wed, 16 Jun 2010 14:00:53 +0530
Message-ID: <201006161400.53879.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris

I am resending this based on the btrfs-unstable tree. Please apply/reply.

Thanks
Nikanth

Prevent creation of files larger than RLIMIT_FSIZE using fallocate.

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a larger file than the limit. Add a check for that.


Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Amit K. Arora <aarora@linux.vnet.ibm.com>

---

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..7870f4f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6842,6 +6842,11 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
 
 	mutex_lock(&inode->i_mutex);
+
+	ret = inode_newsize_ok(inode, (offset + len));
+	if (ret)
+		goto out;
+
 	if (alloc_start > inode->i_size) {
 		ret = btrfs_cont_expand(inode, alloc_start);
 		if (ret)
