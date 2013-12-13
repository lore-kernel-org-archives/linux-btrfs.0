Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:61955 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3LMTjm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 14:39:42 -0500
Received: by mail-we0-f173.google.com with SMTP id u57so2388276wes.32
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 11:39:41 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix use of uninitialized err variable
Date: Fri, 13 Dec 2013 19:39:34 +0000
Message-Id: <1386963574-14467-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the compiler:

fs/btrfs/file.c: In function ‘prepare_pages.isra.18’:
fs/btrfs/file.c:1265:6: warning: ‘err’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 740ae8c..35bf838 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1244,7 +1244,7 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 	int i;
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
-	int err;
+	int err = 0;
 	int faili;
 
 	for (i = 0; i < num_pages; i++) {
-- 
1.7.9.5

