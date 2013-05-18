Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40661 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3ERQzG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 May 2013 12:55:06 -0400
Received: by mail-pb0-f53.google.com with SMTP id un1so4153179pbc.40
        for <linux-btrfs@vger.kernel.org>; Sat, 18 May 2013 09:55:04 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([112.22.172.46])
        by mx.google.com with ESMTPSA id uq10sm16307738pbc.5.2013.05.18.09.55.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 18 May 2013 09:55:04 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2] Btrfs-progs: fix compile warning in btrfs_free_block_groups()
Date: Sun, 19 May 2013 00:54:37 +0800
Message-Id: <1368896077-2129-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

extent-tree.c: In function 'btrfs_free_block_groups':
extent-tree.c:3190:12: warning: cast to pointer from integer of
 different size [-Wint-to-pointer-cast]

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
v1->v2: fix encoding error in changelog
---
 extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 381572d..153d14b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3187,7 +3187,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			break;
 		ret = get_state_private(&info->block_group_cache, start, &ptr);
 		if (!ret) {
-			cache = (struct btrfs_block_group_cache *)ptr;
+			cache = (struct btrfs_block_group_cache *)
+							(unsigned long)ptr;
 			if (cache->free_space_ctl) {
 				btrfs_remove_free_space_cache(cache);
 				kfree(cache->free_space_ctl);
-- 
1.7.11.7

