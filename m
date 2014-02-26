Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaBZIWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 03:22:12 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1Q8M704025030
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 16:22:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Init root_item to avoid gcc 4.8.2 warning
Date: Wed, 26 Feb 2014 16:23:08 +0800
Message-Id: <1393402988-18675-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using gcc 4.8.2, -Wmaybe-uninitialized will report root_item may be
used uninitialized.
Since root_item_valid variant is used to determine the root_item valid,
it's a false alert and to avoid the warning, just init it on allocation.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 send-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/send-utils.c b/send-utils.c
index 8d4f46e..71b6ec1 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -538,7 +538,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 	struct btrfs_ioctl_search_key *sk = &args.key;
 	struct btrfs_ioctl_search_header *sh;
 	struct btrfs_root_item *root_item_ptr;
-	struct btrfs_root_item root_item;
+	struct btrfs_root_item root_item = {};
 	struct subvol_info *si = NULL;
 	int root_item_valid = 0;
 	unsigned long off = 0;
-- 
1.9.0

