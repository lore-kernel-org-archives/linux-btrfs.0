Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54959 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3JONiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 09:38:17 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 152F09A03ED
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 07:38:17 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id ql6biqEGtCseIKkl (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 07:38:16 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add an assert to btrfs_lookup_csums_range for alignment
Date: Tue, 15 Oct 2013 09:38:14 -0400
Message-ID: <1381844294-6866-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was hitting weird issues when trying to remove hole extents and it turned out
it was because I was sending non-aligned offsets down to
btrfs_lookup_csums_range.  So add an assert for this in case somebody trips over
this in the future.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file-item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4f53159..ae8a513 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -329,6 +329,9 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	u64 csum_end;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
+	ASSERT(start == ALIGN(start, root->sectorsize) &&
+	       (end + 1) == ALIGN(end + 1, root->sectorsize));
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.8.3.1

