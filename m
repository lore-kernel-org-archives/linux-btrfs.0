Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:43352 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbeEKUNv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 16:13:51 -0400
Received: by mail-pl0-f65.google.com with SMTP id a39-v6so3855806pla.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 13:13:51 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v4 01/12] Btrfs: update stale comments referencing vmtruncate()
Date: Fri, 11 May 2018 13:13:29 -0700
Message-Id: <24b50db94f8cb107d8a34d350407dbe682c54177.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Commit a41ad394a03b ("Btrfs: convert to the new truncate sequence")
changed btrfs_setsize() to call truncate_setsize() instead of
vmtruncate() but didn't update the comment above it. truncate_setsize()
never fails (the IS_SWAPFILE() check happens elsewhere), so remove the
comment.

Additionally, the comment above btrfs_page_mkwrite() references
vmtruncate(), but truncate_setsize() does the size write and page
locking now.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..0c644ad7e1cb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5106,7 +5106,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		if (ret)
 			return ret;
 
-		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
 
 		/* Disable nonlocked read DIO to avoid the end less truncate */
@@ -8868,8 +8867,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
  *
  * We are not allowed to take the i_mutex here so we have to play games to
  * protect against truncate races as the page could now be beyond EOF.  Because
- * vmtruncate() writes the inode size before removing pages, once we have the
- * page lock we can determine safely if the page is beyond EOF. If it is not
+ * truncate_setsize() writes the inode size before removing pages, once we have
+ * the page lock we can determine safely if the page is beyond EOF. If it is not
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
  */
-- 
2.17.0

