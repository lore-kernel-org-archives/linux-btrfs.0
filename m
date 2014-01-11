Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37659 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaAKVbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 16:31:38 -0500
Received: by mail-wg0-f44.google.com with SMTP id l18so4334814wgh.11
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 13:31:37 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: unlock inodes in correct order in clone ioctl
Date: Sat, 11 Jan 2014 21:31:25 +0000
Message-Id: <1389475885-19409-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the clone ioctl, when the source and target inodes are different,
we can acquire their mutexes in 2 possible different orders. After
we're done cloning, we were releasing the mutexes always in the same
order - the most correct way of doing it is to release them by the
reverse order they were acquired.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cced205..98cb3e8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3266,9 +3266,17 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 	unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
 out_unlock:
-	mutex_unlock(&src->i_mutex);
-	if (!same_inode)
-		mutex_unlock(&inode->i_mutex);
+	if (!same_inode) {
+		if (inode < src) {
+			mutex_unlock(&src->i_mutex);
+			mutex_unlock(&inode->i_mutex);
+		} else {
+			mutex_unlock(&inode->i_mutex);
+			mutex_unlock(&src->i_mutex);
+		}
+	} else {
+		mutex_unlock(&src->i_mutex);
+	}
 out_fput:
 	fdput(src_file);
 out_drop_write:
-- 
1.7.9.5

