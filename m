Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34337 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeFBU0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jun 2018 16:26:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id q4-v6so10369534wmq.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jun 2018 13:26:20 -0700 (PDT)
From: Yevgeny Popovych <yevgenyp@pointgrab.com>
To: linux-btrfs@vger.kernel.org
Cc: Yevgeny Popovych <yevgenyp@pointgrab.com>
Subject: [PATCH] btrfs-progs: mkfs: Fix traverse_directory() silently failing on some dirs
Date: Sat,  2 Jun 2018 23:26:11 +0300
Message-Id: <1527971171-49824-1-git-send-email-yevgenyp@pointgrab.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When traverse_directory() encounters an inode item that already exists
and has a normal amount of hardlinks - it just continues with a next one,
w/o clearing the ret value (set to -EEXIST).

But, if the last file traverse_directory() processes already has an
inode item - traverse_directory() will silently exit with a
bad return code, causing the prints like the following:

    unable to traverse directory initial-directory: 1
    error wihle filling filesystem: 1

Fix this by clearing ret value before continuing with a next file.

Signed-off-by: Yevgeny Popovych <yevgenyp@pointgrab.com>
---
 mkfs/rootdir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index ff00bb0..834aacc 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -553,6 +553,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 						(unsigned long)st.st_nlink);
 					goto fail;
 				}
+				ret = 0;
 				continue;
 			}
 			if (ret) {
-- 
2.7.4

