Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48002 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3JYJ36 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 05:29:58 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r9P9TsHv011791
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:29:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: don't output baffling message when checking a fresh fs
Date: Fri, 25 Oct 2013 17:30:45 +0800
Message-Id: <1382693445-16800-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we know,  a new fs doesn't have space cache, so we set the cache generation
of the super block to be -1ULL, it is not equal to the fs generation. But the
check program didn't consider this case, and output the following message

  cache and super generation don't match, space cache will be invalidated

directly, it would be baffling the users. So we should avoid outputing such
message. This patch fixes this problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 8015288..918e577 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3210,7 +3210,8 @@ static int check_space_cache(struct btrfs_root *root)
 	int ret;
 	int error = 0;
 
-	if (btrfs_super_generation(root->fs_info->super_copy) !=
+	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
+	    btrfs_super_generation(root->fs_info->super_copy) !=
 	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
 		printf("cache and super generation don't match, space cache "
 		       "will be invalidated\n");
-- 
1.8.1.4

