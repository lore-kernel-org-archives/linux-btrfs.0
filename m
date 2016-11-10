Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:43209 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbcKJJuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 04:50:01 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Subject: [PATCH] Fs: Btrfs - Improvement in code readability when
Date: Thu, 10 Nov 2016 15:17:41 +0530
Message-id: <1478771261-1020-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Shailendra Verma" <shailendra.v@samsung.com>

There is no need to call kfree() if memdup_user() fails, as no memory
was allocated and the error in the error-valued pointer should be returned.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 fs/btrfs/ioctl.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 18e1aa0f..fddbc04 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4567,11 +4567,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
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
@@ -5198,11 +5195,8 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 	int ret = 0;
 
 	args32 = memdup_user(arg, sizeof(*args32));
-	if (IS_ERR(args32)) {
-		ret = PTR_ERR(args32);
-		args32 = NULL;
-		goto out;
-	}
+	if (IS_ERR(args32))
+		return PTR_ERR(args32);
 
 	args64 = kmalloc(sizeof(*args64), GFP_KERNEL);
 	if (!args64) {
@@ -5250,11 +5244,8 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
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
1.7.9.5

