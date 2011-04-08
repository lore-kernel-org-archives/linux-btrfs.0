From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check for duplicate iov_base's when doing dio reads
Date: Fri,  8 Apr 2011 11:51:18 -0400
Message-ID: <1302277878-15975-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Apparently it is ok to submit a read to an IDE device with the same target page
for different offsets.  This is what Windows does under qemu.  The problem is
under DIO we expect them to be different buffers for checksumming reasons, and
so this sort of thing will result in checksum errors, when in reality the file
is fine.  So when reading, check to make sure that all iov bases are different,
and if they aren't fall back to buffered mode, since that will work out right.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 032e8fb..c4b914e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6205,6 +6205,7 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 			unsigned long nr_segs)
 {
 	int seg;
+	int i;
 	size_t size;
 	unsigned long addr;
 	unsigned blocksize_mask = root->sectorsize - 1;
@@ -6219,8 +6220,22 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask)) 
+		if ((addr & blocksize_mask) || (size & blocksize_mask))
 			goto out;
+
+		/* If this is a write we don't need to check anymore */
+		if (rw & WRITE)
+			continue;
+
+		/*
+		 * Check to make sure we don't have duplicate iov_base's in this
+		 * iovec, if so return EINVAL, otherwise we'll get csum errors
+		 * when reading back.
+		 */
+		for (i = seg + 1; i < nr_segs; i++) {
+			if (iov[seg].iov_base == iov[i].iov_base)
+				goto out;
+		}
 	}
 	retval = 0;
 out:
-- 
1.7.2.3

