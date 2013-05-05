Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40961 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3EEFM5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 01:12:57 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so1509636pde.9
        for <linux-btrfs@vger.kernel.org>; Sat, 04 May 2013 22:12:57 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs: use arg gfp_t to decide how to allocate tree mod
Date: Sun,  5 May 2013 13:12:28 +0800
Message-Id: <1367730748-7827-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We have passed arg gfp_t to tree_mod_alloc(), so
just use it rather than always use GFP_ATOMIC.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index de6de8e..0e3514f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -553,7 +553,7 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
 	 * once we switch from spin locks to something different, we should
 	 * honor the flags parameter here.
 	 */
-	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
+	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
 	if (!tm)
 		return -ENOMEM;
 
-- 
1.7.11.7

