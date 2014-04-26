Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50255 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaDYXfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 19:35:42 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so4284504wes.29
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 16:35:41 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: read inode size after acquiring the mutex when punching a hole
Date: Sat, 26 Apr 2014 01:35:31 +0100
Message-Id: <1398472531-27343-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In a previous change, commit 12870f1c9b2de7d475d22e73fd7db1b418599725,
I accidentally moved the roundup of inode->i_size to outside of the
critical section delimited by the inode mutex, which is not atomic and
not correct since the size can be changed by other task before we acquire
the mutex. Therefore fix it.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 23f6a9d..efaad37 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2192,13 +2192,14 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
 			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
-	u64 ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
+	u64 ino_size;
 
 	ret = btrfs_wait_ordered_range(inode, offset, len);
 	if (ret)
 		return ret;
 
 	mutex_lock(&inode->i_mutex);
+	ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
 	/*
 	 * We needn't truncate any page which is beyond the end of the file
 	 * because we are sure there is no data there.
-- 
1.9.1

