From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 64/66] btrfs: end_compressed_writeback should return void
Date: Mon, 24 Oct 2011 21:03:40 -0400
Message-ID: <20111025010857.906343914@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 end_compressed_writeback has no error conditions and should return
 void. Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 0c0e842..6c4d228 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -225,8 +225,8 @@ out:
  * Clear the writeback bits on all of the file
  * pages for a compressed write
  */
-static noinline int end_compressed_writeback(struct inode *inode, u64 start,
-					     unsigned long ram_size)
+static noinline void end_compressed_writeback(struct inode *inode, u64 start,
+					      unsigned long ram_size)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = (start + ram_size - 1) >> PAGE_CACHE_SHIFT;
@@ -252,7 +252,6 @@ static noinline int end_compressed_writeback(struct inode *inode, u64 start,
 		index += ret;
 	}
 	/* the inode may be gone now */
-	return 0;
 }
 
 /*



