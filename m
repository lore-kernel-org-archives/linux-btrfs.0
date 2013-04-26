Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612Ab3DZCmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 22:42:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH v2] btrfs-progs: mkfs seg fault for wrong free
Date: Fri, 26 Apr 2013 10:44:45 +0800
Message-Id: <1366944285-30289-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366892142-21920-1-git-send-email-anand.jain@oracle.com>
References: <1366892142-21920-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With commit
        87c09f7 Btrfs-progs: fix memory leaks on cleanup

mkfs on multiple dev is ending with segfault at
close_all_devices() during kfree(device->name)

because mkfs calls btrfs_add_to_fsid, which does not initialize
name when dev is added to the list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 412de80..7b4cd74 100644
--- a/utils.c
+++ b/utils.c
@@ -482,7 +482,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	u64 num_devs;
 	int ret;
 
-	device = kmalloc(sizeof(*device), GFP_NOFS);
+	device = kzalloc(sizeof(*device), GFP_NOFS);
 	if (!device)
 		return -ENOMEM;
 	buf = kmalloc(sectorsize, GFP_NOFS);
-- 
1.8.1.227.g44fe835

