Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43922 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3GGKDh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jul 2013 06:03:37 -0400
Received: by mail-pd0-f176.google.com with SMTP id t12so3160474pdi.35
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jul 2013 03:03:37 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([223.65.190.13])
        by mx.google.com with ESMTPSA id nr8sm5415547pbc.6.2013.07.07.03.03.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sun, 07 Jul 2013 03:03:36 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2] Btrfs-progs: fix compile warning in btrfs_free_block_groups()
Date: Sun,  7 Jul 2013 18:03:33 +0800
Message-Id: <1373191413-4581-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

extent-tree.c: In function 'btrfs_free_block_groups':
extent-tree.c:3189:12: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
V1->V2: use 'uintptr_t' instead of 'unsigned long'(Thanks Stefan)
---
 extent-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index f597e16..494cf21 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -18,6 +18,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -3180,7 +3181,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			break;
 		ret = get_state_private(&info->block_group_cache, start, &ptr);
 		if (!ret) {
-			cache = (struct btrfs_block_group_cache *)ptr;
+			cache = (struct btrfs_block_group_cache *)
+				(uintptr_t)ptr;
 			if (cache->free_space_ctl) {
 				btrfs_remove_free_space_cache(cache);
 				kfree(cache->free_space_ctl);
-- 
1.7.11.7

