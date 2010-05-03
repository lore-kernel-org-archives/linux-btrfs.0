From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/3] fs: allow short direct-io reads to be completed via
	buffered IO
Date: Mon, 3 May 2010 13:27:02 -0400
Message-ID: <20100503172702.GB3961@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is similar to what already happens in the write case.  If we have a short
read while doing O_DIRECT, instead of just returning, fallthrough and try to
read the rest via buffered IO.  BTRFS needs this because if we encounter a
compressed or inline extent during DIO, we need to fallback on buffered.  If the
extent is compressed we need to read the entire thing into memory and
de-compress it into the users pages.  I have tested this with fsx and everything
works great.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 mm/filemap.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 140ebda..423b439 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1263,7 +1263,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct file *filp = iocb->ki_filp;
 	ssize_t retval;
-	unsigned long seg;
+	unsigned long seg = 0;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
 
@@ -1290,21 +1290,34 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
 			}
-			if (retval > 0)
+			if (retval > 0) {
 				*ppos = pos + retval;
-			if (retval) {
+				count -= retval;
+			}
+			if (retval < 0 || !count) {
 				file_accessed(filp);
 				goto out;
 			}
 		}
 	}
 
+	count = retval;
 	for (seg = 0; seg < nr_segs; seg++) {
 		read_descriptor_t desc;
+		loff_t offset = 0;
+
+		if (count) {
+			if (count > iov[seg].iov_len) {
+				count -= iov[seg].iov_len;
+				continue;
+			}
+			offset = count;
+			count = 0;
+		}
 
 		desc.written = 0;
-		desc.arg.buf = iov[seg].iov_base;
-		desc.count = iov[seg].iov_len;
+		desc.arg.buf = iov[seg].iov_base + offset;
+		desc.count = iov[seg].iov_len - offset;
 		if (desc.count == 0)
 			continue;
 		desc.error = 0;
-- 
1.6.6.1

