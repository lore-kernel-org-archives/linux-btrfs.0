Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:32791 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbcITGsv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 02:48:51 -0400
From: Shailendra Verma <shailendra.v@samsung.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Ravikant Sharma <ravikant.s2@samsung.com>
Cc: linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Subject: Fs: Btrfs - Fix possible ERR_PTR() dereferencing.
Date: Tue, 20 Sep 2016 12:18:27 +0530
Message-id: <1474354107-18774-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is of course wrong to call kfree() if memdup_user() fails,
no memory was allocated and the error in the error-valued pointer
should be returned.

Reviewed-by: Ravikant Sharma <ravikant.s2@samsung.com>
Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 fs/btrfs/ioctl.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da94138..58a40f8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4512,11 +4512,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 		return -EPERM;
 
 	loi = memdup_user(arg, sizeof(*loi));
-	if (IS_ERR(loi)) {
-		ret = PTR_ERR(loi);
-		loi = NULL;
-		goto out;
-	}
+	if (IS_ERR(loi))
+		return PTR_ERR(loi);
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -5143,11 +5140,8 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 	int ret = 0;
 
 	args32 = memdup_user(arg, sizeof(*args32));
-	if (IS_ERR(args32)) {
-		ret = PTR_ERR(args32);
-		args32 = NULL;
-		goto out;
-	}
+	if (IS_ERR(args32))
+		return PTR_ERR(args32);
 
 	args64 = kmalloc(sizeof(*args64), GFP_NOFS);
 	if (!args64) {
@@ -5195,11 +5189,8 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 	int ret = 0;
 
 	sa = memdup_user(arg, sizeof(*sa));
-	if (IS_ERR(sa)) {
-		ret = PTR_ERR(sa);
-		sa = NULL;
-		goto out;
-	}
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
 
 	ret = _btrfs_ioctl_set_received_subvol(file, sa);
 
-- 
1.9.1

