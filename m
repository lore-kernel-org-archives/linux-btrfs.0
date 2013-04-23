Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51773 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3DWPbm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 11:31:42 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4AC8D9A0425
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 09:31:42 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id kAU8Co7fAdw7NOgg (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 09:31:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add tree block level sanity check
Date: Tue, 23 Apr 2013 11:31:39 -0400
Message-ID: <1366731099-1940-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With a users corrupted fs I was getting weird behavior and panics and it turns
out it was because one of his tree blocks had a bogus header level.  So add this
to the sanity checks in the endio handler for tree blocks.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f4628c7..fb0e5c2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -651,6 +651,12 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 		goto err;
 	}
 	found_level = btrfs_header_level(eb);
+	if (found_level >= BTRFS_MAX_LEVEL) {
+		btrfs_info(root->fs_info, "bad tree block level %d\n",
+			   (int)btrfs_header_level(eb));
+		ret = -EIO;
+		goto err;
+	}
 
 	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
 				       eb, found_level);
-- 
1.7.7.6

