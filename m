Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47058 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbcGULCz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 07:02:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u6LAwaKQ010344
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 04:02:54 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
	by m0001303.ppops.net with ESMTP id 24a8ghy6my-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 04:02:54 -0700
Received: from facebook.com (2401:db00:2040:5012:face:0:1:0)	by
 mx-out.facebook.com (10.212.232.63) with ESMTP	id
 ac07fc364f3211e69dd20002c992ebde-d67f8af0 for <linux-btrfs@vger.kernel.org>;
	Thu, 21 Jul 2016 04:02:53 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH] Btrfs: avoid deadlocks during reservations in btrfs_truncate_block
Date: Thu, 21 Jul 2016 04:02:33 -0700
Message-ID: <1469098953-2500150-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

The new enospc code makes it possible to deadlock if we don't use
FLUSH_LIMIT during reservations inside a transaction.  This enforces
the correct flush type to avoid both deadlocks and assertions

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3a129c4..9fcb8c9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5939,10 +5939,15 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	 * the middle of a transaction commit.  We also don't need the delalloc
 	 * mutex since we won't race with anybody.  We need this mostly to make
 	 * lockdep shut its filthy mouth.
+	 *
+	 * If we have a transaction open (can happen if we call truncate_block
+	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
 	 */
 	if (btrfs_is_free_space_inode(inode)) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 		delalloc_lock = false;
+	} else if (current->journal_info) {
+		flush = BTRFS_RESERVE_FLUSH_LIMIT;
 	}
 
 	if (flush != BTRFS_RESERVE_NO_FLUSH &&
-- 
2.8.0.rc2

