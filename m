Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37656 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbcCYR03 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:29 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHKUgn021304
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:28 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 21vva6jmxs-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:28 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 12/14] Btrfs: fix release reserved extents trace points
Date: Fri, 25 Mar 2016 13:25:58 -0400
Message-ID: <1458926760-17563-13-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were doing trace_btrfs_release_reserved_extent() in pin_down_extent which
isn't quite right because we will go through and free that extent later when we
unpin, so it messes up apps that are accounting for the reservation space.  We
were also unconditionally doing it in __btrfs_free_reserved_extent(), when we
only actually free the reservation instead of pinning the extent.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ecceea..273e18d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6253,8 +6253,6 @@ static int pin_down_extent(struct btrfs_root *root,
 				      cache->space_info->flags, num_bytes, 1);
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
-	if (reserved)
-		trace_btrfs_reserved_extent_free(root, bytenr, num_bytes);
 	return 0;
 }
 
@@ -7877,12 +7875,10 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 			ret = btrfs_discard_extent(root, start, len, NULL);
 		btrfs_add_free_space(cache, start, len);
 		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE, delalloc);
+		trace_btrfs_reserved_extent_free(root, start, len);
 	}
 
 	btrfs_put_block_group(cache);
-
-	trace_btrfs_reserved_extent_free(root, start, len);
-
 	return ret;
 }
 
-- 
2.5.0

