Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36042 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdARHiI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 02:38:08 -0500
Received: by mail-pf0-f171.google.com with SMTP id 189so2319762pfu.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 23:38:08 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: kernel-team@fb.com
Subject: [PATCH] Btrfs: refactor btrfs_extent_same() slightly
Date: Tue, 17 Jan 2017 23:37:38 -0800
Message-Id: <0e35cf0b96176e03494585709f5170dff94e1e55.1484724993.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This was originally a prep patch for changing the behavior on len=0, but
we went another direction with that. This still makes the function
slightly easier to follow.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Qu thought this would still be a worthwhile cleanup. I'm fine either
way. Applies to Dave's for-next branch.

 fs/btrfs/ioctl.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bf7227d43b5d..3542dddde3d2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3127,26 +3127,27 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	int ret;
 	u64 len = olen;
 	struct cmp_pages cmp;
-	int same_inode = 0;
+	bool same_inode = (src == dst);
 	u64 same_lock_start = 0;
 	u64 same_lock_len = 0;
 
-	if (src == dst)
-		same_inode = 1;
-
 	if (len == 0)
 		return 0;
 
-	if (same_inode) {
+	if (same_inode)
 		inode_lock(src);
+	else
+		btrfs_double_inode_lock(src, dst);
 
-		ret = extent_same_check_offsets(src, loff, &len, olen);
-		if (ret)
-			goto out_unlock;
-		ret = extent_same_check_offsets(src, dst_loff, &len, olen);
-		if (ret)
-			goto out_unlock;
+	ret = extent_same_check_offsets(src, loff, &len, olen);
+	if (ret)
+		goto out_unlock;
 
+	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
+	if (ret)
+		goto out_unlock;
+
+	if (same_inode) {
 		/*
 		 * Single inode case wants the same checks, except we
 		 * don't want our length pushed out past i_size as
@@ -3174,16 +3175,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 		same_lock_start = min_t(u64, loff, dst_loff);
 		same_lock_len = max_t(u64, loff, dst_loff) + len - same_lock_start;
-	} else {
-		btrfs_double_inode_lock(src, dst);
-
-		ret = extent_same_check_offsets(src, loff, &len, olen);
-		if (ret)
-			goto out_unlock;
-
-		ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
-		if (ret)
-			goto out_unlock;
 	}
 
 	/* don't make the dst file partly checksummed */
-- 
2.11.0

