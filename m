From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][TRIVIAL] btrfs: Remove a couple of redundant semi-colons
Date: Sun, 18 Dec 2011 00:06:28 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1112180003140.21784@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/free-space-cache.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f44b392..2a8038a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2699,7 +2699,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	 * one reference for us, and we leave it for the
 	 * caller
 	 */
-	device->flush_bio = NULL;;
+	device->flush_bio = NULL;
 	bio = bio_alloc(GFP_NOFS, 0);
 	if (!bio)
 		return -ENOMEM;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..9a897bf 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -423,7 +423,7 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	}
 
 	if (index == 0)
-		offset = sizeof(u32) * io_ctl->num_pages;;
+		offset = sizeof(u32) * io_ctl->num_pages;
 
 	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
 			      PAGE_CACHE_SIZE - offset);
-- 
1.7.8


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

