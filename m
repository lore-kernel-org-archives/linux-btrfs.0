Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34784 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbDGFJa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 01:09:30 -0400
Received: by pdbqa5 with SMTP id qa5so9789335pdb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 22:09:29 -0700 (PDT)
From: Davide Italiano <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] Btrfs: Improve FL_KEEP_SIZE handling in fallocate.
Date: Mon,  6 Apr 2015 22:09:15 -0700
Message-Id: <1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
In-Reply-To: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
References: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- We call inode_size_ok() only if FL_KEEP_SIZE isn't specified.
- As an optimisation we can skip the call if (off + len)
  isn't greater than the current size of the file. This operation
  is called under the lock so the less work we do, the better.
- If we call inode_size_ok() pass to it the correct value rather
  than a more conservative estimation.

Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
---
 fs/btrfs/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 30982bb..f649bfc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2586,9 +2586,13 @@ static long btrfs_fallocate(struct file *file, int mode,
 	}
 
 	mutex_lock(&inode->i_mutex);
-	ret = inode_newsize_ok(inode, alloc_end);
-	if (ret)
-		goto out;
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + len > inode->i_size) {
+		ret = inode_newsize_ok(inode, offset + len);
+		if (ret)
+			goto out;
+	}
 
 	if (alloc_start > inode->i_size) {
 		ret = btrfs_cont_expand(inode, i_size_read(inode),
-- 
2.3.4

