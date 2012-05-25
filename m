Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2EYOKb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 10:10:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4PEAURS013448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:10:31 -0400
Received: from localhost.localdomain.com (vpn-8-136.rdu.redhat.com [10.11.8.136])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4PEAUcR001705
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:10:30 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fall back to non-inline if we don't have enough space
Date: Fri, 25 May 2012 10:10:30 -0400
Message-Id: <1337955030-3508-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If cow_file_range_inline fails with ENOSPC we abort the transaction which
isn't very nice.  This really shouldn't be happening anyways but there's no
sense in making it a horrible error when we can easily just go allocate
normal data space for this stuff.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cd51968..46d8732 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -257,10 +257,13 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 	ret = insert_inline_extent(trans, root, inode, start,
 				   inline_len, compressed_size,
 				   compress_type, compressed_pages);
-	if (ret) {
+	if (ret && ret != -ENOSPC) {
 		btrfs_abort_transaction(trans, root, ret);
 		return ret;
+	} else if (ret == -ENOSPC) {
+		return 1;
 	}
+
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 	return 0;
-- 
1.7.7.6

