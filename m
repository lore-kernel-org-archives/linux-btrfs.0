From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: remove useless waiting and extra filemap work
Date: Mon, 23 Apr 2012 14:42:29 -0400
Message-ID: <1335206549-8670-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_wait_ordered_range we have been calling filemap_fdata_write() twice
because compression does strange things and then waiting.  Then we look up
ordered extents and if we find any we will always schedule_timeout(); once
and then loop back around and do it all again.  We will even check to see if
there is delalloc pages on this range and loop again.  So this patch gets
rid of the multipe fdata_write() calls and just does
filemap_write_and_wait().  In the case of compression we will still find the
ordered extents and start those individually if we need to so that is ok,
but in the normal buffered case we avoid all this weird overhead.

Then in the case of the schedule_timeout(1), we don't need it.  All callers
either 1) don't care, they just want to make sure what they just wrote maeks
it to disk or 2) are doing the lock()->lookup ordered->unlock->flush thing
in which case it will lock and check for ordered extents _anyway_ so get
back to them as quickly as possible.  The delaloc check is simply not
needed, this only catches the case where we write to the file again since
doing the filemap_write_and_wait() and if the caller truly cares about that
it will take care of everything itself.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ordered-data.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index acfb360..e587716 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -623,19 +623,11 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 		if (orig_end > INT_LIMIT(loff_t))
 			orig_end = INT_LIMIT(loff_t);
 	}
-again:
+
 	/* start IO across the range first to instantiate any delalloc
 	 * extents
 	 */
-	filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
-
-	/* The compression code will leave pages locked but return from
-	 * writepage without setting the page writeback.  Starting again
-	 * with WB_SYNC_ALL will end up waiting for the IO to actually start.
-	 */
-	filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
-
-	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
+	filemap_write_and_wait_range(inode->i_mapping, start, orig_end);
 
 	end = orig_end;
 	found = 0;
@@ -659,11 +651,6 @@ again:
 			break;
 		end--;
 	}
-	if (found || test_range_bit(&BTRFS_I(inode)->io_tree, start, orig_end,
-			   EXTENT_DELALLOC, 0, NULL)) {
-		schedule_timeout(1);
-		goto again;
-	}
 }
 
 /*
-- 
1.7.7.6

