Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57521 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3I0Uht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 16:37:49 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3ACC47C0427
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 14:37:49 -0600 (MDT)
Received: from CAS1.int.fusionio.com ([10.101.1.40]) by mx1.fusionio.com with ESMTP id kOQY4Nlh2hxVv3W2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 14:37:48 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't delete ordered roots from list during cleanup
Date: Fri, 27 Sep 2013 16:37:46 -0400
Message-ID: <1380314266-28871-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During transaction cleanup after an abort we are just removing roots from the
ordered roots list which is incorrect.  We have a BUG_ON() to make sure that the
root is still part of the ordered roots list when we put our ordered extent
which we were tripping in this case.  So do like we do everywhere else and just
move it to the tail of the ordered roots list and allow the normal cleanup to
take care of stuff.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f38211f..872b4ce 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3835,7 +3835,8 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 	while (!list_empty(&splice)) {
 		root = list_first_entry(&splice, struct btrfs_root,
 					ordered_root);
-		list_del_init(&root->ordered_root);
+		list_move_tail(&root->ordered_root,
+			       &fs_info->ordered_roots);
 
 		btrfs_destroy_ordered_extents(root);
 
-- 
1.8.3.1

