Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45864 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3GCQY5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 12:24:57 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so282667pbc.7
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 09:24:57 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com
Subject: [PATCH RESEND] Btrfs-progs: fix compile warning in btrfs_free_block_groups()
Date: Thu,  4 Jul 2013 00:24:45 +0800
Message-Id: <1372868685-4973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

extent-tree.c: In function 'btrfs_free_block_groups':
extent-tree.c:3189:12: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index b0cfe0a..7561bbb 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3186,7 +3186,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			break;
 		ret = get_state_private(&info->block_group_cache, start, &ptr);
 		if (!ret) {
-			cache = (struct btrfs_block_group_cache *)ptr;
+			cache = (struct btrfs_block_group_cache *)
+				(unsigned long)ptr;
 			if (cache->free_space_ctl) {
 				btrfs_remove_free_space_cache(cache);
 				kfree(cache->free_space_ctl);
-- 
1.7.11.7

