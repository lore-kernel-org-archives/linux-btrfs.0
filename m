Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47655 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbbETONP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 10:13:15 -0400
Date: Wed, 20 May 2015 10:13:11 -0400
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <holger.hoffstaette@googlemail.com>
Subject: [PATCH] Btrfs: fix regression in raid level conversion
Message-ID: <20150520141301.GA16249@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e changed
btrfs_set_block_group_ro to avoid trying to allocate new chunks with the
new raid profile during conversion.  This fixed failures when there was
no space on the drive to allocate a new chunk, but the metadata
reserves were sufficient to continue the conversion.

But this ended up causing a regression when the drive had plenty of
space to allocate new chunks, mostly because reduce_alloc_profile isn't
using the new raid profile.

Fixing btrfs_reduce_alloc_profile is a bigger patch.  For now, do a
partial revert of 2f0810880, and don't error out if we hit ENOSPC.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/extent-tree.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 45e3f08..a115599 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8829,6 +8829,26 @@ again:
 		goto again;
 	}
 
+	/*
+	 * if we are changing raid levels, try to allocate a corresponding
+	 * block group with the new raid level.
+	 */
+	if (!(cache->flags & BTRFS_BLOCK_GROUP_SYSTEM)) {
+		alloc_flags = update_block_group_flags(root, cache->flags);
+		if (alloc_flags != cache->flags) {
+			ret = do_chunk_alloc(trans, root, alloc_flags,
+					     CHUNK_ALLOC_FORCE);
+			/*
+			 * ENOSPC is allowed here, we may have enough space
+			 * already allocated at the new raid level to
+			 * carry on
+			 */
+			if (ret == -ENOSPC)
+				ret = 0;
+			if (ret < 0)
+				goto out;
+		}
+	}
 
 	ret = set_block_group_ro(cache, 0);
 	if (!ret)
-- 
2.4.0

