Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33731 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab3B1SSp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 13:18:45 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4075E7C040A
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 11:18:45 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id u007BGnNy84rA0P5 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 11:18:44 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: copy everything if we've created an inline extent
Date: Thu, 28 Feb 2013 13:25:52 -0500
Message-ID: <1362075952-1429-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed while looking into a tree logging bug that we aren't logging inline
extents properly.  Since this requires copying and it shouldn't happen too often
just force us to copy everything for the inode into the tree log when we have an
inline extent.  With this patch we have valid data after a crash when we write
an inline extent.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ef7a5b..ecd9c4c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -266,6 +266,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 		return 1;
 	}
 
+	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 	return 0;
-- 
1.7.7.6

