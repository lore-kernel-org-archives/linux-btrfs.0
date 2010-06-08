From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] fs: make sure to invalidate pages if we fall back on buffered reads
Date: Tue,  8 Jun 2010 10:24:04 -0400
Message-ID: <1276007044-17715-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since BTRFS can fallback on buffered reads after having done some direct reads,
we need to make sure to invalidate any pages that we may have read by doing
buffered IO.  This shouldn't have shown up as a visible user problem, it's just
for correctness sake.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 mm/filemap.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 829ac9c..ca5aba9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1266,6 +1266,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	unsigned long seg = 0;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
+	bool invalidate = false;
 
 	count = 0;
 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
@@ -1291,7 +1292,8 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 							iov, pos, nr_segs);
 			}
 			if (retval > 0) {
-				*ppos = pos + retval;
+				pos += retval;
+				*ppos = pos;
 				count -= retval;
 			}
 
@@ -1307,6 +1309,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 				file_accessed(filp);
 				goto out;
 			}
+			invalidate = true;
 		}
 	}
 
@@ -1343,6 +1346,10 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		if (desc.count > 0)
 			break;
 	}
+	if (invalidate && retval > 0)
+		invalidate_mapping_pages(filp->f_mapping,
+					 pos >> PAGE_CACHE_SHIFT,
+					 (*ppos - 1) >> PAGE_CACHE_SHIFT);
 out:
 	return retval;
 }
-- 
1.6.6.1

