From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 21 Apr 2011 15:42:33 -0400
Message-ID: <1303414954-3315-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org
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

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/read_write.c    |    3 +++
 include/linux/fs.h |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5520f8a..5446d61 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -64,6 +64,9 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 			return file->f_pos;
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		return -EINVAL;
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
