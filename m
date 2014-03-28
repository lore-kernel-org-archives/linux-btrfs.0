Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63461 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbaC1VHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 17:07:33 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2SL15Ta004774
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 14:07:32 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1jwg6803sy-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 14:07:32 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't clear uptodate if the eb is under IO
Date: Fri, 28 Mar 2014 17:07:27 -0400
Message-ID: <1396040847-6026-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I have an awful exercise script that will run snapshot, balance and
send/receive in parallel.  This sometimes would crash spectacularly and when it
came back up the fs would be completely hosed.  Turns out this is because of a
bad interaction of balance and send/receive.  Send will hold onto its entire
path for the whole send, but its blocks could get relocated out from underneath
it, and because it doesn't old tree locks theres nothing to keep this from
happening.  So it will go to read in a slot with an old transid, and we could
have re-allocated this block for something else and it could have a completely
different transid.  But because we think it is invalid we clear uptodate and
re-read in the block.  If we do this before we actually write out the new block
we could write back stale data to the fs, and boom we're screwed.

Now we definitely need to fix this disconnect between send and balance, but we
really really need to not allow ourselves to accidently read in stale data over
new data.  So make sure we check if the extent buffer is not under io before
clearing uptodate, this will kick back EIO to the caller instead of reading in
stale data and keep us from corrupting the fs.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/disk-io.c     | 20 +++++++++++++++++++-
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/send.c        |  2 ++
 fs/btrfs/transaction.h |  2 ++
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02ae4d1..716aa18 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -330,6 +330,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 {
 	struct extent_state *cached_state = NULL;
 	int ret;
+	bool need_lock = (current->journal_info ==
+			  (void *)BTRFS_SEND_TRANS_STUB);
 
 	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
 		return 0;
@@ -337,6 +339,11 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 	if (atomic)
 		return -EAGAIN;
 
+	if (need_lock) {
+		btrfs_tree_read_lock(eb);
+		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+	}
+
 	lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
 			 0, &cached_state);
 	if (extent_buffer_uptodate(eb) &&
@@ -348,10 +355,21 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		       "found %llu\n",
 		       eb->start, parent_transid, btrfs_header_generation(eb));
 	ret = 1;
-	clear_extent_buffer_uptodate(eb);
+
+	/*
+	 * Things reading via commit roots that don't have normal protection,
+	 * like send, can have a really old block in cache that may point at a
+	 * block that has been free'd and re-allocated.  So don't clear uptodate
+	 * if we find an eb that is under IO (dirty/writeback) because we could
+	 * end up reading in the stale data and then writing it back out and
+	 * making everybody very sad.
+	 */
+	if (!extent_buffer_under_io(eb))
+		clear_extent_buffer_uptodate(eb);
 out:
 	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
 			     &cached_state, GFP_NOFS);
+	btrfs_tree_read_unlock_blocking(eb);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fd78c84..d35a3ca 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4315,7 +4315,7 @@ static void __free_extent_buffer(struct extent_buffer *eb)
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
-static int extent_buffer_under_io(struct extent_buffer *eb)
+int extent_buffer_under_io(struct extent_buffer *eb)
 {
 	return (atomic_read(&eb->io_pages) ||
 		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 58b27e5..c488b45 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -320,6 +320,7 @@ int set_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_buffer *eb);
 int clear_extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_uptodate(struct extent_buffer *eb);
+int extent_buffer_under_io(struct extent_buffer *eb);
 int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long min_len, char **map,
 		      unsigned long *map_start,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0148999..6f035ee 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5609,7 +5609,9 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			NULL);
 	sort_clone_roots = 1;
 
+	current->journal_info = (void *)BTRFS_SEND_TRANS_STUB;
 	ret = send_subvol(sctx);
+	current->journal_info = NULL;
 	if (ret < 0)
 		goto out;
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index aa014fe..b57b924 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -79,6 +79,8 @@ struct btrfs_transaction {
 #define TRANS_EXTWRITERS	(__TRANS_USERSPACE | __TRANS_START |	\
 				 __TRANS_ATTACH)
 
+#define BTRFS_SEND_TRANS_STUB	1
+
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
-- 
1.8.3.1

