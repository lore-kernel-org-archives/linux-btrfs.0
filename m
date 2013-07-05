Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33846 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3GESMu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 14:12:50 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B8F179A0695
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:12:49 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id ySudPq5YfEzzMKnL (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 12:12:49 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix backref walking when we hit a compressed extent
Date: Fri, 5 Jul 2013 14:12:47 -0400
Message-ID: <1373047967-3749-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you do btrfs inspect-internal logical-resolve on a compressed extent that has
been partly overwritten it won't find anything.  This is because we try and
match the extent offset we've searched for based on the extent offset in the
data extent entry.  However this doesn't work for compressed extents because the
offsets are for the uncompressed size, not the compressed size.  So instead only
do this check if we are not compressed, that way we can get an actual entry for
the physical offset rather than nothing for compressed.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/backref.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index eaf1333..30dbe1c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -36,16 +36,23 @@ static int check_extent_in_eb(struct btrfs_key *key, struct extent_buffer *eb,
 				u64 extent_item_pos,
 				struct extent_inode_elem **eie)
 {
-	u64 data_offset;
-	u64 data_len;
+	u64 offset = 0;
 	struct extent_inode_elem *e;
 
-	data_offset = btrfs_file_extent_offset(eb, fi);
-	data_len = btrfs_file_extent_num_bytes(eb, fi);
+	if (!btrfs_file_extent_compression(eb, fi) &&
+	    !btrfs_file_extent_encryption(eb, fi) &&
+	    !btrfs_file_extent_other_encoding(eb, fi)) {
+		u64 data_offset;
+		u64 data_len;
 
-	if (extent_item_pos < data_offset ||
-	    extent_item_pos >= data_offset + data_len)
-		return 1;
+		data_offset = btrfs_file_extent_offset(eb, fi);
+		data_len = btrfs_file_extent_num_bytes(eb, fi);
+
+		if (extent_item_pos < data_offset ||
+		    extent_item_pos >= data_offset + data_len)
+			return 1;
+		offset = extent_item_pos - data_offset;
+	}
 
 	e = kmalloc(sizeof(*e), GFP_NOFS);
 	if (!e)
@@ -53,7 +60,7 @@ static int check_extent_in_eb(struct btrfs_key *key, struct extent_buffer *eb,
 
 	e->next = *eie;
 	e->inum = key->objectid;
-	e->offset = key->offset + (extent_item_pos - data_offset);
+	e->offset = key->offset + offset;
 	*eie = e;
 
 	return 0;
-- 
1.7.7.6

