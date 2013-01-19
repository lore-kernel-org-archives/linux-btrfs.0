Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:50982 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3ASSGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 13:06:32 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119180631.YWCS21186.eastrmfepo203.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 13:06:31 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 1/6] Fedora 18 - btrfs-init-dev-list.patch
Date: Sat, 19 Jan 2013 13:06:16 -0500
Message-Id: <1358618781-26629-2-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-1-git-send-email-gene@czarc.net>
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 938f9a5..51b78d5 100644
--- a/utils.c
+++ b/utils.c
@@ -477,7 +477,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	u64 num_devs;
 	int ret;
 
-	device = kmalloc(sizeof(*device), GFP_NOFS);
+	device = kzalloc(sizeof(*device), GFP_NOFS);
 	if (!device)
 		return -ENOMEM;
 	buf = kmalloc(sectorsize, GFP_NOFS);
@@ -503,6 +503,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->bytes_used = 0;
 	device->total_ios = 0;
 	device->dev_root = root->fs_info->dev_root;
+	INIT_LIST_HEAD(&device->dev_list);
 
 	ret = btrfs_add_device(trans, root, device);
 	BUG_ON(ret);
-- 
1.8.1

