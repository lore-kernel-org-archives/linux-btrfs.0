From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed,  4 May 2011 13:58:39 -0400
Message-ID: <1304531920-2890-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
using fiemap in things like cp cause more problems than it solves, so lets try
and give userspace an interface that doesn't suck.  So we have

-SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
given position.  If the given position is a hole then pos won't move.  A "hole"
is defined by whatever the fs feels like defining it to be.  In simple things
like ext2/3 it will simplly mean an unallocated space in the file.  For more
complex things where you have preallocated space then that is left up to the
filesystem.  Since preallocated space is supposed to return all 0's it is
perfectly legitimate to have SEEK_HOLE dump you out at the start of a
preallocated extent, but then again if this is not something you can do and be
sure the extent isn't in the middle of being converted to a real extent then it
is also perfectly legitimate to skip preallocated extents and only park f_pos at
a truly unallocated section.

-SEEK_DATA: this is obviously a little more self-explanatory.  Again the only
ambiguity comes in with preallocated extents.  If you have an fs that can't
reliably tell that the preallocated extent is in the process of turning into a
real extent, it is correct for SEEK_DATA to park you at a preallocated extent.

In the generic case we will just assume the entire file is data and there is a
virtual hole at i_size, so SEEK_DATA will return -ENXIO unless you provide an
offset of 0 and the file size is larger than 0, and SEEK_HOLE will put you at
i_size unless pos is i_size or larger, and i_size is larger than 0.

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
v1->v2: Make the generic case assume that the entire file is data and there is a
virtual hole at the end of the file.
 fs/read_write.c    |   22 ++++++++++++++++++++++
 include/linux/fs.h |    4 +++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5520f8a..6ee63a4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -64,6 +64,28 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 			return file->f_pos;
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		/*
+		 * In the generic case the entire file is data, so data only
+		 * starts at position 0 provided the file has an i_size,
+		 * otherwise it's an empty file and will always be ENXIO.
+		 */
+		if (offset != 0 || i_size_read(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+		break;
+	case SEEK_HOLE:
+		/*
+		 * There is a virtual hole at the end of the file, so as long as
+		 * offset isn't i_size or larger, return i_size.
+		 */
+		if (offset >= i_size_read(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+		offset = i_size_read(inode);
+		break;
 	}
 
 	if (offset < 0 && !unsigned_offsets(file))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dbd860a..1b72e0c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -31,7 +31,9 @@
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-#define SEEK_MAX	SEEK_END
+#define SEEK_HOLE	3	/* seek to the closest hole */
+#define SEEK_DATA	4	/* seek to the closest data */
+#define SEEK_MAX	SEEK_DATA
 
 struct fstrim_range {
 	__u64 start;
-- 
1.7.2.3
