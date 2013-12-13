Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10630 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab3LMPoB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 10:44:01 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBDFfCOH014068
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 07:43:57 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0a-00082601.pphosted.com with ESMTP id 1gqkgg2n88-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 07:43:57 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use a bit to track if we're in the radix tree
Date: Fri, 13 Dec 2013 10:43:54 -0500
Message-ID: <1386949434-4488-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For creating a dummy in-memory btree I need to be able to use the radix tree to
keep track of the buffers like normal extent buffers.  With dummy buffers we
skip the radix tree step, and we still want to do that for the tree mod log
dummy buffers but for my test buffers we need to be able to remove them from the
radix tree like normal.  This will give me a way to do that.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 7 ++++---
 fs/btrfs/extent_io.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2779255..dc392d9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4627,6 +4627,7 @@ again:
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
+	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
 
 	/*
 	 * there is a race where release page may have
@@ -4670,9 +4671,7 @@ static int release_extent_buffer(struct extent_buffer *eb)
 {
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
-		if (test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags)) {
-			spin_unlock(&eb->refs_lock);
-		} else {
+		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
 			struct extent_io_tree *tree = eb->tree;
 
 			spin_unlock(&eb->refs_lock);
@@ -4681,6 +4680,8 @@ static int release_extent_buffer(struct extent_buffer *eb)
 			radix_tree_delete(&tree->buffer,
 					  eb->start >> PAGE_CACHE_SHIFT);
 			spin_unlock(&tree->buffer_lock);
+		} else {
+			spin_unlock(&eb->refs_lock);
 		}
 
 		/* Should be safe to release our pages at this point */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 19620c5..92e4347 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -43,6 +43,7 @@
 #define EXTENT_BUFFER_WRITEBACK 7
 #define EXTENT_BUFFER_IOERR 8
 #define EXTENT_BUFFER_DUMMY 9
+#define EXTENT_BUFFER_IN_TREE 10
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define PAGE_UNLOCK		(1 << 0)
-- 
1.8.3.1

