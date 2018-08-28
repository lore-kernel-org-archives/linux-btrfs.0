Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38304 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbeH1Dw2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id x17-v6so331054pfh.5
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:33 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com
Subject: [RFC PATCH v2 4/6] fs: stop propagating bh->b_private for direct I/O
Date: Mon, 27 Aug 2018 17:03:17 -0700
Message-Id: <711728042a285870799943d3431cd3f3783b585c.1535414064.git.osandov@fb.com>
In-Reply-To: <cover.1535414064.git.osandov@fb.com>
References: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Currently, the direct I/O code saves the value of bh->b_private set
by the filesystem and passes it to the end_io callback. However, struct
kiocb already has a ->private member which can be used for this purpose,
with the added benefit of being available before get_block is called,
too. The only users of the bh->b_private functionality have been
converted to use iocb->private, so stop passing it around.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/direct-io.c     | 7 +------
 fs/ext4/inode.c    | 3 +--
 fs/ocfs2/aops.c    | 5 +----
 include/linux/fs.h | 3 +--
 4 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index f631aa98849b..80e488afe6c6 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -122,8 +122,6 @@ struct dio {
 	loff_t i_size;			/* i_size when submitted */
 	dio_iodone_t *end_io;		/* IO completion function */
 
-	void *private;			/* copy from map_bh.b_private */
-
 	/* BIO completion state */
 	spinlock_t bio_lock;		/* protects BIO fields below */
 	int page_errors;		/* errno from get_user_pages() */
@@ -288,7 +286,7 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, unsigned int flags)
 
 	if (dio->end_io) {
 		// XXX: ki_pos??
-		err = dio->end_io(dio->iocb, offset, ret, dio->private);
+		err = dio->end_io(dio->iocb, offset, ret);
 		if (err)
 			ret = err;
 	}
@@ -716,9 +714,6 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 		ret = (*sdio->get_block)(dio->iocb, dio->inode, fs_startblk,
 					 map_bh, create);
 
-		/* Store for completion */
-		dio->private = map_bh->b_private;
-
 		if (ret == 0 && buffer_defer_completion(map_bh))
 			ret = dio_set_defer_completion(dio);
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 841d79919cef..0f42793765bf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3612,8 +3612,7 @@ const struct iomap_ops ext4_iomap_ops = {
 	.iomap_end		= ext4_iomap_end,
 };
 
-static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
-			    ssize_t size, void *private)
+static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset, ssize_t size)
 {
         ext4_io_end_t *io_end = iocb->private;
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index fc4a18b6ad3c..c1232df20be5 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2404,10 +2404,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
  * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
  * to protect io on one node from truncation on another.
  */
-static int ocfs2_dio_end_io(struct kiocb *iocb,
-			    loff_t offset,
-			    ssize_t bytes,
-			    void *private)
+static int ocfs2_dio_end_io(struct kiocb *iocb, loff_t offset, ssize_t bytes)
 {
 	struct ocfs2_dio_write_ctxt *dwc;
 	struct inode *inode = file_inode(iocb->ki_filp);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 85db69835023..f1a235f0fa21 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -83,8 +83,7 @@ typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 typedef int (dio_get_block_t)(struct kiocb *iocb, struct inode *inode,
 			      sector_t iblock, struct buffer_head *bh_result,
 			      int create);
-typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
-			ssize_t bytes, void *private);
+typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset, ssize_t bytes);
 
 #define MAY_EXEC		0x00000001
 #define MAY_WRITE		0x00000002
-- 
2.18.0
