Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37045 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbcCYR0M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:12 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHLxAK016799
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:11 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 21vv98j8wb-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:11 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/14] Btrfs: change delayed reservation fallback behavior
Date: Fri, 25 Mar 2016 13:25:50 -0400
Message-ID: <1458926760-17563-5-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We reserve space for the inode update when we first reserve space for writing to
a file.  However there are lots of ways that we can use this reservation and not
have it for subsequent ordered extents.  Previously we'd fall through and try to
reserve metadata bytes for this, then we'd just steal the full reservation from
the delalloc_block_rsv, and if that didn't have enough space we'd steal the full
reservation from the global reserve.  The problem with this is we can easily
just return ENOSPC and fallback to updating the inode item directly.  In the
worst case (assuming 4k nodesize) we'd steal 64kib from the global reserve if we
fall all the way through, however if we just fallback and update the inode
directly we'd only steal 4k * BTRFS_PATH_MAX in the worst case which is 32kib.

We would have also just added the extent item for the inode so we likely will
have already cow'ed down most of the way to the leaf containing the inode item,
so we are more often than not only need one or two nodesize's worth of
reservations.  Given the reservation for the extent itself is also a worst case
we will likely already have space to cover the inode update.

This change will make us behave better in the theoretical worst case, and much
better in the case that we don't have our reservation and cannot reserve more
metadata.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-inode.c | 64 +++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index d3cda0f..1c77103 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -598,6 +598,29 @@ static int btrfs_delayed_inode_reserve_metadata(
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
 
 	/*
+	 * If our block_rsv is the delalloc block reserve then check and see if
+	 * we have our extra reservation for updating the inode.  If not fall
+	 * through and try to reserve space quickly.
+	 *
+	 * We used to try and steal from the delalloc block rsv or the global
+	 * reserve, but we'd steal a full reservation, which isn't kind.  We are
+	 * here through delalloc which means we've likely just cowed down close
+	 * to the leaf that contains the inode, so we would steal less just
+	 * doing the fallback inode update, so if we do end up having to steal
+	 * from the global block rsv we hopefully only steal one or two blocks
+	 * worth which is less likely to hurt us.
+	 */
+	if (src_rsv && src_rsv->type == BTRFS_BLOCK_RSV_DELALLOC) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		if (test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
+				       &BTRFS_I(inode)->runtime_flags))
+			release = true;
+		else
+			src_rsv = NULL;
+		spin_unlock(&BTRFS_I(inode)->lock);
+	}
+
+	/*
 	 * btrfs_dirty_inode will update the inode under btrfs_join_transaction
 	 * which doesn't reserve space for speed.  This is a problem since we
 	 * still need to reserve space for this update, so try to reserve the
@@ -626,51 +649,10 @@ static int btrfs_delayed_inode_reserve_metadata(
 						      num_bytes, 1);
 		}
 		return ret;
-	} else if (src_rsv->type == BTRFS_BLOCK_RSV_DELALLOC) {
-		spin_lock(&BTRFS_I(inode)->lock);
-		if (test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-				       &BTRFS_I(inode)->runtime_flags)) {
-			spin_unlock(&BTRFS_I(inode)->lock);
-			release = true;
-			goto migrate;
-		}
-		spin_unlock(&BTRFS_I(inode)->lock);
-
-		/* Ok we didn't have space pre-reserved.  This shouldn't happen
-		 * too often but it can happen if we do delalloc to an existing
-		 * inode which gets dirtied because of the time update, and then
-		 * isn't touched again until after the transaction commits and
-		 * then we try to write out the data.  First try to be nice and
-		 * reserve something strictly for us.  If not be a pain and try
-		 * to steal from the delalloc block rsv.
-		 */
-		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
-					  BTRFS_RESERVE_NO_FLUSH);
-		if (!ret)
-			goto out;
-
-		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
-		if (!ret)
-			goto out;
-
-		if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
-			btrfs_debug(root->fs_info,
-				    "block rsv migrate returned %d", ret);
-			WARN_ON(1);
-		}
-		/*
-		 * Ok this is a problem, let's just steal from the global rsv
-		 * since this really shouldn't happen that often.
-		 */
-		ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
-					      dst_rsv, num_bytes, 1);
-		goto out;
 	}
 
-migrate:
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 
-out:
 	/*
 	 * Migrate only takes a reservation, it doesn't touch the size of the
 	 * block_rsv.  This is to simplify people who don't normally have things
-- 
2.5.0

