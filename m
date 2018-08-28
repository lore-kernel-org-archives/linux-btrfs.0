Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44105 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbeH1Dw1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id k21-v6so316635pff.11
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:32 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Subject: [RFC PATCH v2 3/6] ocfs2: use iocb->private instead of bh->b_private
Date: Mon, 27 Aug 2018 17:03:16 -0700
Message-Id: <3140f34d27f1ad45a75073284ee36347b2da9cd9.1535414064.git.osandov@fb.com>
In-Reply-To: <cover.1535414064.git.osandov@fb.com>
References: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

As part of simplifying all of the private data passed around for direct
I/O, bh->b_private will no longer be passed to dio_iodone_t. Instead,
filesystems should use iocb->private. ocfs2 already uses iocb->private
for storing a couple of flag bits, but we can use it as a tagged pointer
and hide all of the messiness in helpers.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/ocfs2/aops.c | 19 ++++++++-------
 fs/ocfs2/aops.h | 64 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 54 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 93ca23c56b07..fc4a18b6ad3c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2104,12 +2104,13 @@ struct ocfs2_dio_write_ctxt {
 };
 
 static struct ocfs2_dio_write_ctxt *
-ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
+ocfs2_dio_alloc_write_ctx(struct kiocb *iocb, int *alloc)
 {
-	struct ocfs2_dio_write_ctxt *dwc = NULL;
+	struct ocfs2_dio_write_ctxt *dwc;
 
-	if (bh->b_private)
-		return bh->b_private;
+	dwc = ocfs2_iocb_private(iocb);
+	if (dwc)
+		return dwc;
 
 	dwc = kmalloc(sizeof(struct ocfs2_dio_write_ctxt), GFP_NOFS);
 	if (dwc == NULL)
@@ -2118,7 +2119,7 @@ ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
 	dwc->dw_zero_count = 0;
 	dwc->dw_orphaned = 0;
 	dwc->dw_writer_pid = task_pid_nr(current);
-	bh->b_private = dwc;
+	ocfs2_iocb_set_private(iocb, dwc);
 	*alloc = 1;
 
 	return dwc;
@@ -2184,7 +2185,7 @@ static int ocfs2_dio_wr_get_block(struct kiocb *iocb, struct inode *inode,
 		bh_result->b_state = 0;
 	}
 
-	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
+	dwc = ocfs2_dio_alloc_write_ctx(iocb, &first_get_block);
 	if (unlikely(dwc == NULL)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -2408,6 +2409,7 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 			    ssize_t bytes,
 			    void *private)
 {
+	struct ocfs2_dio_write_ctxt *dwc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int level;
 	int ret = 0;
@@ -2415,8 +2417,9 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
-	if (bytes > 0 && private)
-		ret = ocfs2_dio_end_io_write(inode, private, offset, bytes);
+	dwc = ocfs2_iocb_private(iocb);
+	if (bytes > 0 && dwc)
+		ret = ocfs2_dio_end_io_write(inode, dwc, offset, bytes);
 
 	ocfs2_iocb_clear_rw_locked(iocb);
 
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 3494a62ed749..2c3219e0c010 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -63,32 +63,54 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create);
-/* all ocfs2_dio_end_io()'s fault */
-#define ocfs2_iocb_is_rw_locked(iocb) \
-	test_bit(0, (unsigned long *)&iocb->private)
+
+/*
+ * Direct I/O uses iocb->private as a tagged pointer. The bottom two bits
+ * defined below are used for communication between ocfs2_dio_end_io() and
+ * ocfs2_file_write/read_iter().
+ */
+#define OCFS2_IOCB_RW_LOCK 1
+#define OCFS2_IOCB_RW_LOCK_LEVEL 2
+
+static inline void *ocfs2_iocb_private(struct kiocb *iocb)
+{
+	return (void *)((unsigned long)iocb->private & ~3);
+}
+
+static inline void ocfs2_iocb_set_private(struct kiocb *iocb, void *private)
+{
+	iocb->private = (void *)(((unsigned long)iocb->private & 3) |
+				 ((unsigned long)private & ~3));
+}
+
+static inline bool ocfs2_iocb_is_rw_locked(struct kiocb *iocb)
+{
+	return (unsigned long)iocb->private & OCFS2_IOCB_RW_LOCK;
+}
+
 static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
 {
-	set_bit(0, (unsigned long *)&iocb->private);
+	unsigned long private = (unsigned long)iocb->private;
+
+	private |= OCFS2_IOCB_RW_LOCK;
 	if (level)
-		set_bit(1, (unsigned long *)&iocb->private);
+		private |= OCFS2_IOCB_RW_LOCK_LEVEL;
 	else
-		clear_bit(1, (unsigned long *)&iocb->private);
+		private &= ~OCFS2_IOCB_RW_LOCK_LEVEL;
+	iocb->private = (void *)private;
 }
 
-/*
- * Using a named enum representing lock types in terms of #N bit stored in
- * iocb->private, which is going to be used for communication between
- * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
- */
-enum ocfs2_iocb_lock_bits {
-	OCFS2_IOCB_RW_LOCK = 0,
-	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_NUM_LOCKS
-};
-
-#define ocfs2_iocb_clear_rw_locked(iocb) \
-	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_rw_locked_level(iocb) \
-	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
+static inline void ocfs2_iocb_clear_rw_locked(struct kiocb *iocb)
+{
+	unsigned long private = (unsigned long)iocb->private;
+
+	private &= ~OCFS2_IOCB_RW_LOCK;
+	iocb->private = (void *)private;
+}
+
+static inline bool ocfs2_iocb_rw_locked_level(struct kiocb *iocb)
+{
+	return (unsigned long)iocb->private & OCFS2_IOCB_RW_LOCK_LEVEL;
+}
 
 #endif /* OCFS2_FILE_H */
-- 
2.18.0
